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

--Drop table if it already exists:
DROP TABLE IF EXISTS projected_points;

--Reproject sim output points to 2D using Affine transformation
CREATE TABLE projected_points AS
(
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
);




--Add index to temp_table:
CREATE INDEX projected_points_gix ON projected_points USING gist (geom_2d);


DROP TABLE IF EXISTS point_raster;

--Create raster with Noise sim output for a given 
--LOD2 WallSurface:
CREATE TABLE point_raster AS

--Get the vertex pointes from the vertical WallSurface 
WITH wallsurface_dumped_points AS(
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
	SELECT 
		e.bbox, ST_SRID(e.bbox) AS consistent_srid,
		3.0 AS pixel_size_x,
		-3.0 AS pixel_size_y,
		-9999 AS no_data_val
		
	FROM extent e
),


ref_raster AS (
	SELECT 
		ST_AddBand(
			ST_MakeEmptyRaster(
			CEIL((ST_XMax(rp.bbox) - ST_XMin(rp.bbox)) / ABS(rp.pixel_size_x))::int, --raster-cols
			CEIL((ST_YMax(rp.bbox) - ST_YMin(rp.bbox)) / ABS(rp.pixel_size_y))::int, --raster-rows
			ST_XMin(rp.bbox), --upper left x-coord
			ST_YMax(rp.bbox), --upper left y-coord
			
			rp.pixel_size_x, rp.pixel_size_y, --pixel size x, pixel size y
			0, 0, --skew x and y
			rp.consistent_srid--ST_SRID(bbox) -- SRID
			),
			'32BF'::text, --Pixel type (e.g., 32-bit float)
			rp.no_data_val--NoData value
			) AS initial_rast
	FROM raster_params rp 
),


point_values_agg AS(
	SELECT ARRAY_AGG((
		ST_SetSRID(pp.geom_2d, rp.consistent_srid), pp.Noise_value)::geomval) AS gv_array
	FROM projected_points pp
	CROSS JOIN raster_params rp
	GROUP BY rp.consistent_srid
),


original_raster_with_gaps AS(
	SELECT
		ST_SetValues(
			r.initial_rast,
			1,
			g.gv_array
	) AS rast
	FROM ref_raster r
	CROSS JOIN point_values_agg g
),


--Interpolate a full raster surface
--using IDW with a radius 
interpolated_surface AS (
	SELECT 
		ST_InterpolateRaster( --https://postgis.net/docs/RT_ST_InterpolateRaster.html	
			(SELECT 
				ST_UNION(ST_MakePoint(ST_X(geom_2d), ST_Y(geom_2d), Noise_value)) 
			FROM projected_points),			
			'invdist:power=4.0:radius=10.0'::text,
			(SELECT initial_rast FROM ref_raster LIMIT 1)
		) AS full_idw_rast
	LIMIT 1
),


merged_raster AS (
	SELECT 
		ST_MapAlgebra( --https://postgis.net/docs/RT_ST_MapAlgebra_expr.html
			og.rast, --rast1: original_raster_with_gaps
			idw.full_idw_rast, --rast2: interpolated_surface
			'[rast1.val]', --expression: default to rast1 values
			'32BF'::text,  --pixeltype: explicit output pixel type
			'FIRST', --extenttype: use extent of rast1
			'[rast2.val]', --nodata1expression: If rast1 pixel is NoData, use the value from pixel in rast2
			'[rast1.val]', --nodata2expression: If rast2 pixel is NoData, use the value from pixel in rast1
			--nodatanodataval: If both the pixel in rast1 & the pixel in rast2 are NoData, return -9999:
			(SELECT no_data_val FROM raster_params LIMIT 1)::double precision
		) AS final_rast
	FROM original_raster_with_gaps og
	CROSS JOIN interpolated_surface idw
)

--Select the final merged raster:
SELECT final_rast AS facade_raster
FROM merged_raster;




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
			 [0-30): 1,
			 [30-35): 2,
			 [35-40): 3,
			 [40-45): 4,
			 [45-50): 5,
			 [50-55): 6,
			 [55-60): 7,
			 [60-65): 8,
			 [65-70): 9,
			 [70-75): 10,
			 [75-80): 11,
			 [80-infinity): 12',
			'8BUI'	
		) AS rast1
		FROM point_raster 
	)

	--Add a RGB-color to every group representing a range of Noise values
	SELECT ST_Colormap(
		rast1,
		1,
		'0 255 255 255 255
		 1 255 255 255 255
		 
		 2 130 166 173 255
		 3 160 186 191 255
		 4 184 214 209 255
		 5 206 228 204 255
		 6 226 242 191 255
		 7 243 198 131 255
		 8 232 126 77 255
		 9 205 70 62 255
		 10 161 26 77 255
		 11 117 8 92 255
		 12 67 10 74 255',
		 'EXACT'	
	) AS rgb_rast
	FROM reclassed_raster;	

--Add column to raster table to store raster ID:
ALTER TABLE Noise_raster ADD COLUMN rid numeric;
UPDATE Noise_raster SET rid = 1;




DROP TABLE IF EXISTS projected_points;






















--Export raster to see in URL:
SELECT 'data:image/png;base64,' || encode(ST_AsPNG(rgb_rast), 'base64')
FROM Noise_raster
WHERE rid=1;

