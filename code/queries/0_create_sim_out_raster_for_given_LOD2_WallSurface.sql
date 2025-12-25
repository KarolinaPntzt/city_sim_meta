/*
--Compute total number of points per WallSurface geometry
SELECT cityObjectIdentifier, surfaceGeometryID, count(*) as num_of_points
FROM sim_meta.Geom_AIrr
WHERE simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251023_v1'
GROUP BY cityObjectIdentifier, surfaceGeometryID
ORDER BY num_of_points;
*/


--Get 3DBox for WallSurface geometry containing AIrr points
/*
SELECT ST_3DExtent(GEOMETRY) As b3extent
FROM SURFACE_GEOMETRY 
WHERE SURFACE_GEOMETRY.ID = 174360
--WHERE CITYOBJECT.GMLID = 'WSLod2a66227c6-2e87-4695-b08e-3eafd0c6d6fd'
*/


--Compute WallSurface dimensions (i.e., height and width)
--height (Python script) --
--BOX3D(117270.647 6161967.6521 11.972728999999998,117319.4931 6162055.37 29.938394)
--29.938394-11.972728999999998


--Create the raster (colorscale?)

--Save it as a .png or blob in the TEX_IMAGE table



/*
SELECT 'data:image/png;base64,' || encode(ST_AsPNG(raster), 'base64')
FROM (

	SELECT ST_AsRaster(ST_Union(Geom_AIrr.geom), 
	490, 88, ARRAY['8BUI', '8BUI', '8BUI'], 
	ARRAY[255,0,0], ARRAY[0,0,0]) as raster
	FROM sim_meta.Geom_AIrr
	WHERE Geom_AIrr.surfaceGeometryID = 174360
	);

*/



/*
--Get dimension information of LOD2 WallSurfce
--to create an empty raster:
WITH bounds AS (
	SELECT ST_Extent(GEOMETRY) AS geom_extent, ST_SRID(GEOMETRY) AS srid
	FROM SURFACE_GEOMETRY
	WHERE SURFACE_GEOMETRY.ID = 174360
	GROUP BY SURFACE_GEOMETRY.ID,SURFACE_GEOMETRY)

--Create an empty raster:
SELECT ST_MakeEmptyRaster(
	502, 90, --raster-cols, raster-rows
	117270.647, 6162055.37, --upper left x-coord & y-coord
	0.2, 0.2, --pixel size x, pixel size y
	0, 0, --skew x and y
	3008 -- SRID
	) AS empty_rast;
--FROM bounds;
*/

SET postgis.gdal.enabled_drivers = 'ENABLE_ALL';


DROP TABLE IF EXISTS point_raster;

--Create raster with AIrr sim output for a given 
--LOD2 WallSurface:
CREATE TABLE point_raster AS

WITH projected_points AS(
	SELECT ST_SetSRID(ST_MakePoint(ST_Y(geom), ST_Z(geom)),
	ST_SRID(geom)) AS geom_2d, value AS AIrr_value
	FROM sim_meta.Geom_AIrr
	WHERE surfaceGeometryID = 174360
),

extent AS(
	SELECT ST_Extent(geom_2d) AS bbox
	FROM projected_points	
),

raster_params AS (
	SELECT e.bbox, ST_SRID(e.bbox) AS consistent_srid
	FROM extent e
),


ref_raster AS (
	SELECT 
		ST_AddBand(
			ST_MakeEmptyRaster(
			round((ST_XMax(rp.bbox) - ST_XMin(rp.bbox)) / 0.2::float)::int, --raster-cols
			round((ST_YMax(rp.bbox) - ST_YMin(rp.bbox)) / 0.2::float)::int, --raster-rows
			ST_XMin(rp.bbox), --upper left x-coord
			ST_YMax(rp.bbox), --upper left y-coord
			
			0.2, -0.2, --pixel size x, pixel size y
			0, 0, --skew x and y
			rp.consistent_srid--ST_SRID(bbox) -- SRID
			),
			'32BF'::text, --Pixel type (e.g., 32-bit float)
			-9999 --NoData value
			) AS initial_rast 
	FROM raster_params rp 
),



point_values_agg AS(
	SELECT ARRAY_AGG((
		ST_SetSRID(pp.geom_2d, rp.consistent_srid), pp.AIrr_value)::geomval) AS gv_array
	FROM projected_points pp
	CROSS JOIN raster_params rp
)

SELECT ST_SetValues(
	r.initial_rast,
	1,
	g.gv_array
) AS facade_raster
FROM ref_raster r
CROSS JOIN point_values_agg g;



--Delete table storing AIrr output in RGB-color (if it exists)
DROP TABLE IF EXISTS AIrr_raster;

--Create table to store raster with AIrr output in RGB-color
CREATE TABLE AIrr_raster AS
	--Convert 1-band raster containing AIrr sim out values to a 3-band RGB raster
	WITH reclassed_raster AS(
		SELECT ST_Reclass(
			facade_raster,
			1, --input raster band
			--Reclassification expression [min-max] = new_value
			'[0-200): 1,
			 [200-300): 2,
			 [300-400): 3,
			 [400-500): 4,
			 [500-infinity): 5,',
			'8BUI'	
		) AS rast1
		FROM point_raster 
	)

	--Add a RGB-color to every group representing a range of AIrr values
	SELECT ST_Colormap(
		rast1,
		1,
		'1 245 245 0
		 2 245 184 0
		 3 245 122 0
		 4 245 61 0
		 5 168 0 0',
		 'EXACT'	
	) AS rgb_rast
	FROM reclassed_raster;	

--Add column to raster table to store raster ID:
ALTER TABLE AIrr_raster ADD COLUMN rid numeric;
UPDATE AIrr_raster SET rid = 1;


--SELECT *
--FROM AIrr_raster









--select (ST_PixelAsPoints(facade_raster)).*
--from point_raster







--Export raster to see in URL:
--SELECT 'data:image/png;base64,' || encode(ST_AsPNG(facade_raster), 'base64')
--FROM point_raster;








--select (ST_PixelAsPoints(rast)).* from raster_table

