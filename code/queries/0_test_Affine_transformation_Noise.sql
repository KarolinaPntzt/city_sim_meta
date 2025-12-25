/*
--Compute total number of points per WallSurface geometry
SELECT cityObjectIdentifier, surfaceGeometryID, count(*) as num_of_points
FROM sim_meta.Geom_Noise
WHERE simulationID = 'Noise_malmo_bellevue_DpXXXXX_20251023_v1'
GROUP BY cityObjectIdentifier, surfaceGeometryID
ORDER BY num_of_points;
*/
 



--Get 3DBox for WallSurface geometry containing Noise points
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

	SELECT ST_AsRaster(ST_Union(Geom_Noise.geom), 
	490, 88, ARRAY['8BUI', '8BUI', '8BUI'], 
	ARRAY[255,0,0], ARRAY[0,0,0]) as raster
	FROM sim_meta.Geom_Noise
	WHERE Geom_Noise.surfaceGeometryID = 174360
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

--Create raster with Noise sim output for a given 
--LOD2 WallSurface:
CREATE TABLE point_raster AS


WITH projected_points AS(
	SELECT 
		ST_Force2D(
			ST_Affine(
			geom,
			-0.487384235590107128821557580522, -- a Affine transformation parameter 
			-0.873182865273323560728613301762, -- b Affine transformation parameter 
			0.002879356059270048520670748360, -- c Affine transformation parameter 
			0.000455023204146112216200020795, -- d Affine transformation parameter 
			0.003043544936971907203387965879, -- e Affine transformation parameter 
			0.999995264882839407505343842786, -- f Affine transformation parameter 
			-0.873187494099709637929151995195, -- g Affine transformation parameter 
			0.487383237942469516035259857745, -- h Affine transformation parameter 
			-0.001086057357428043407265860765, -- i Affine transformation parameter 
			5437805.022592917, -- x-offset Affine transformation parameter 
			-18822.416814524833, -- y-offset Affine transformation parameter 
			-2900956.853885781-- z-offset Affine transformation parameter 			
			)
		) AS geom_2d, 
		value AS Noise_value
	FROM sim_meta.Geom_Noise
	WHERE surfaceGeometryID = 256661 AND 
	simulationID = 'Noise_malmo_bellevue_DpXXXXX_20240707_v1'
),

--Get the vertex pointes from the vertical WallSurface 
wallsurface_dumped_points AS(
	SELECT 
		(ST_DumpPoints(GEOMETRY)).geom AS p_geom,
		ST_SRID(GEOMETRY) AS srid
	FROM SURFACE_GEOMETRY
	WHERE SURFACE_GEOMETRY.ID = 256661
),

--Transform the vertical WallSurface to 2D
wallsurface_2d AS(
	SELECT 
		ST_MakePolygon(
			ST_MakeLine(
				ST_Force2D(
					ST_Affine(
						p_geom,
						-0.487384235590107128821557580522, -- a Affine transformation parameter 
						-0.873182865273323560728613301762, -- b Affine transformation parameter 
						0.002879356059270048520670748360, -- c Affine transformation parameter 
						0.000455023204146112216200020795, -- d Affine transformation parameter 
						0.003043544936971907203387965879, -- e Affine transformation parameter 
						0.999995264882839407505343842786, -- f Affine transformation parameter 
						-0.873187494099709637929151995195, -- g Affine transformation parameter 
						0.487383237942469516035259857745, -- h Affine transformation parameter 
						-0.001086057357428043407265860765, -- i Affine transformation parameter 
						5437805.022592917, -- x-offset Affine transformation parameter 
						-18822.416814524833, -- y-offset Affine transformation parameter 
						-2900956.853885781-- z-offset Affine transformation parameter 			
					)
				)
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
			round((ST_XMax(rp.bbox) - ST_XMin(rp.bbox)) / 3.0::float)::int, --raster-cols
			round((ST_YMax(rp.bbox) - ST_YMin(rp.bbox)) / 3.0::float)::int, --raster-rows
			ST_XMin(rp.bbox), --upper left x-coord
			ST_YMax(rp.bbox), --upper left y-coord
			
			3.0, -3.0, --pixel size x, pixel size y
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
		ST_SetSRID(pp.geom_2d, rp.consistent_srid), pp.Noise_value)::geomval) AS gv_array
	FROM projected_points pp
	CROSS JOIN raster_params rp
	GROUP BY rp.consistent_srid
)

SELECT ST_SetValues(
	r.initial_rast,
	1,
	g.gv_array
) AS facade_raster
FROM ref_raster r
CROSS JOIN point_values_agg g;



--Delete table storing Noise output in RGB-color (if it exists)
DROP TABLE IF EXISTS Noise_raster;

--Create table to store raster with Noise output in RGB-color
CREATE TABLE Noise_raster AS
	--Convert 1-band raster containing Noise sim out values to a 3-band RGB raster
	WITH reclassed_raster AS(
		SELECT ST_Reclass(
			facade_raster,
			1, --input raster band
			--Reclassification expression [min-max] = new_value
			'[-9999-0): 0,
			 [0-40): 1,
			 [40-50): 2,
			 [50-60): 3,
			 [60-70): 4,
			 [70-infinity): 5,',
			'8BUI'	
		) AS rast1
		FROM point_raster 
	)

	--Add a RGB-color to every group representing a range of Noise values
	SELECT ST_Colormap(
		rast1,
		1,
		'0 255 255 255 255
		 1 0 114 6 255
		 2 125 184 16 255
		 3 242 254 30 255
		 4 255 172 18 255
		 5 252 59 9 255',
		 'EXACT'	
	) AS rgb_rast
	FROM reclassed_raster;	

--Add column to raster table to store raster ID:
ALTER TABLE Noise_raster ADD COLUMN rid numeric;
UPDATE Noise_raster SET rid = 1;
























--SELECT *
--FROM Noise_raster









--select (ST_PixelAsPoints(facade_raster)).*
--from point_raster







--Export raster to see in URL:
SELECT 'data:image/png;base64,' || encode(ST_AsPNG(rgb_rast), 'base64')
FROM Noise_raster
WHERE rid=1;





--DROP TABLE WALLSURFACE_RASTER, POINT_RASTER, Noise_RASTER;






--select (ST_PixelAsPoints(rast)).* from raster_table

