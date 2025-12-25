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
	SELECT 
		ST_Force2D(
			ST_Affine(
			geom,
			-0.48627953189092443, -- a Affine transformation parameter 
			-0.8732615162867798, -- b Affine transformation parameter 
			-0.030765907047534315, -- c Affine transformation parameter 
			-0.014967916427927283, -- d Affine transformation parameter 
			-0.026879406880809444, -- e Affine transformation parameter 
			0.9995266174362454, -- f Affine transformation parameter 
			-0.8736750988449595, -- g Affine transformation parameter 
			0.4865098371649332, -- h Affine transformation parameter 
			0.00000000000000012837, -- i Affine transformation parameter 
			5438076.261364502, -- x-offset Affine transformation parameter 
			167367.41859724806, -- y-offset Affine transformation parameter 
			-2895401.4349294193 -- z-offset Affine transformation parameter 			
			)
		) AS geom_2d, 
		value AS AIrr_value
	FROM sim_meta.Geom_AIrr
	WHERE surfaceGeometryID = 174360 AND 
	simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251024_v2'
),

--Get the vertex pointes from the vertical WallSurface 
wallsurface_dumped_points AS(
	SELECT 
		(ST_DumpPoints(GEOMETRY)).geom AS p_geom,
		ST_SRID(GEOMETRY) AS srid
	FROM SURFACE_GEOMETRY
	WHERE SURFACE_GEOMETRY.ID = 174360
),

--Transform the vertical WallSurface to 2D
wallsurface_2d AS(
	SELECT 
		ST_Force2D(
			ST_Affine(
			p_geom,
			-0.48627953189092443, -- a Affine transformation parameter 
			-0.8732615162867798, -- b Affine transformation parameter 
			-0.030765907047534315, -- c Affine transformation parameter 
			-0.014967916427927283, -- d Affine transformation parameter 
			-0.026879406880809444, -- e Affine transformation parameter 
			0.9995266174362454, -- f Affine transformation parameter 
			-0.8736750988449595, -- g Affine transformation parameter 
			0.4865098371649332, -- h Affine transformation parameter 
			0.00000000000000012837, -- i Affine transformation parameter 
			5438076.261364502, -- x-offset Affine transformation parameter 
			167367.41859724806, -- y-offset Affine transformation parameter 
			-2895401.4349294193 -- z-offset Affine transformation parameter 			
			)
		) AS polygon_2d_yz_plane
	FROM wallsurface_dumped_points
),

extent AS(
	SELECT ST_Extent(polygon_2d_yz_plane) AS bbox
	FROM wallsurface_2d	
	
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
			'[-9999-0): 0,
			 [0-400): 1,
			 [400-500): 2,
			 [500-600): 3,
			 [600-700): 4,
			 [700-infinity): 5,',
			'8BUI'	
		) AS rast1
		FROM point_raster 
	)

	--Add a RGB-color to every group representing a range of AIrr values
	SELECT ST_Colormap(
		rast1,
		1,
		'0 255 255 255 255
		 1 245 245 0 255
		 2 245 184 0 255
		 3 245 122 0 255
		 4 245 61 0 255
		 5 168 0 0 255',
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
SELECT 'data:image/png;base64,' || encode(ST_AsPNG(rgb_rast), 'base64')
FROM AIrr_raster
WHERE rid=1;





--DROP TABLE WALLSURFACE_RASTER, POINT_RASTER, AIRR_RASTER;






--select (ST_PixelAsPoints(rast)).* from raster_table

