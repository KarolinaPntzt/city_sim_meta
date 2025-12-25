--SQL-script adding textures (raster png-files)
--depicting simulation output to TEX_IMAGE table

/*
--AIrr (WallSurface LOD2)
INSERT INTO citydb.TEX_IMAGE(
	id,
	tex_image_uri,
	tex_image_data,
	tex_mime_type
)

SELECT 
	--You need a unique ID. If you have a sequence, use nextval()
	--Example using a sequence (adjust 'tex_image_seq' if needed)
	--nextval('citydb.tex_image_seq'::regclass) AS id,
	2 AS id,
	'WS_LOD2_AIrr_AD_F4.png' AS tex_image_uri,
	ST_AsPNG(r.rgb_rast) AS tex_image_data,
	'image/png' AS tex_mime_type

FROM AIrr_raster r
WHERE r.rid = 1;

*/

--SELECT * FROM SURFACE_DATA


--SELECT * FROM citydb.TEX_IMAGE

--UPDATE citydb.TEX_IMAGE
--SET TEX_IMAGE_DATA = (SELECT ST_AsPNG(r.rgb_rast) 
--FROM AIrr_raster r WHERE r.rid = 1)
--WHERE TEX_IMAGE.ID = 2;


--DROP TABLE Airr_raster, point_raster;












/*

--Noise (WallSurface LOD2)
INSERT INTO citydb.TEX_IMAGE(
	id,
	tex_image_uri,
	tex_image_data,
	tex_mime_type
)

SELECT 
	--You need a unique ID. If you have a sequence, use nextval()
	--Example using a sequence (adjust 'tex_image_seq' if needed)
	--nextval('citydb.tex_image_seq'::regclass) AS id,
	4 AS id,
	'WS_LOD2_Noise_BD_Fx1.png' AS tex_image_uri,
	ST_AsPNG(r.rgb_rast) AS tex_image_data,
	'image/png' AS tex_mime_type

FROM Noise_raster r
WHERE r.rid = 1;

*/




--UPDATE citydb.TEX_IMAGE
--SET TEX_IMAGE_DATA = (SELECT ST_AsPNG(r.rgb_rast) 
--FROM Noise_raster r WHERE r.rid = 1)
--WHERE TEX_IMAGE.ID = 3;

--SELECT * FROM citydb.TEX_IMAGE;

--DROP TABLE Noise_raster, point_raster;

