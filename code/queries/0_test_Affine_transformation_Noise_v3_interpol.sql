


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
			, -- a Affine transformation parameter 
			, -- b Affine transformation parameter 
			, -- c Affine transformation parameter 
			, -- d Affine transformation parameter 
			, -- e Affine transformation parameter 
			, -- f Affine transformation parameter 
			, -- g Affine transformation parameter 
			, -- h Affine transformation parameter 
			, -- i Affine transformation parameter 
			, -- x-offset Affine transformation parameter 
			, -- y-offset Affine transformation parameter 
			-- z-offset Affine transformation parameter 			
			)
		) AS geom_2d, 
		value AS Noise_value
	FROM sim_meta.Geom_Noise
	WHERE surfaceGeometryID = 267209 AND 
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
	WHERE SURFACE_GEOMETRY.ID = 267209
),

--Transform the vertical WallSurface to 2D
wallsurface_2d AS(
	SELECT 
		ST_MakePolygon(
			ST_MakeLine(
				ST_Force2D(
					ST_Affine(
						p_geom,
						-0.0494613265885192401882797241796652087942, -- a Affine transformation parameter 
			-0.0892596365161568150448090364079689607024, -- b Affine transformation parameter 
			0.9947795205275926644361561557161621749401, -- c Affine transformation parameter 
			0.4821586356273411255735084068874130025506, -- d Affine transformation parameter 
			0.8701203046424599296670976400491781532764, -- e Affine transformation parameter 
			0.1020475650806651479740594368195161223412, -- f Affine transformation parameter 
			0.8746865880200085374696072904043830931187, -- g Affine transformation parameter 
			-0.4846889443116226825480907791643403470516, -- h Affine transformation parameter 
			-0.0000000000000000277555756156289135105908, -- i Affine transformation parameter 
			555797.4144257822772487998008728027343750000000, -- x-offset Affine transformation parameter 
			-5418206.4064311040565371513366699218750000000000, -- y-offset Affine transformation parameter 
			2884336.1295101945288479328155517578125000000000-- z-offset Affine transformation parameter 			
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
		ST_InterpolateRaster(			
			(SELECT 
				ST_UNION(ST_MakePoint(ST_X(geom_2d), ST_Y(geom_2d), Noise_value)) 
			FROM projected_points),			
			'invdist:power=4.0:radius=6.0'::text,
			(SELECT initial_rast FROM ref_raster LIMIT 1)
		) AS full_idw_rast
	LIMIT 1
)
--Select the final merged raster:
SELECT full_idw_rast AS facade_raster
FROM interpolated_surface;




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

