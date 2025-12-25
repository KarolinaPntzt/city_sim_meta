-- Adding a texture with sim output results to citydb

/*
--Step 1--
--Add PNG-file with simulation ouput to TEX_IMAGE table:

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
	(SELECT MAX(TEX_IMAGE.ID)+1 FROM TEX_IMAGE) AS id,
	'WS_LOD2_Noise_AD_Fx'|| (SELECT MAX(TEX_IMAGE.ID)+1 FROM TEX_IMAGE)::TEXT ||'.png' AS tex_image_uri,
	ST_AsPNG(r.rgb_rast) AS tex_image_data,
	'image/png' AS tex_mime_type

FROM Noise_raster r
WHERE r.rid = 1;

*/



--UPDATE TEX_IMAGE
--SET tex_image_data = (SELECT ST_AsPNG(r.rgb_rast) 
--FROM Noise_raster r WHERE r.rid = 1)
--WHERE TEX_IMAGE.ID = 67 --(SELECT MAX(ID) FROM TEX_IMAGE);




--Delete the temporary help tables:
--DROP TABLE Noise_raster, Point_raster;
-- --------------------------------------------------------------------


/*

--STEP 2--
--Update the SURFACE_DATA table
INSERT INTO citydb.SURFACE_DATA
VALUES((SELECT MAX(SURFACE_DATA.ID)+1 FROM SURFACE_DATA), 
CONCAT('surfacedata', uuid_generate_v4()), NULL, 
'WS_LOD2_Noise_AD_f'|| (SELECT MAX(SURFACE_DATA.ID)+1 FROM SURFACE_DATA)::TEXT, 
NULL, 'Texture for LOD2 WallSurface with Noise output for AD scenario',
1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
(SELECT MAX(TEX_IMAGE.ID) FROM TEX_IMAGE)::INT, NULL, 'none', NULL, NULL, NULL, NULL);



-- --------------------------------------------------------------------





--STEP 3--
--Update APPEAR_TO_SURFACE_DATA table to link the texture to a theme:

--Noise textures (APPEARANCE ID for Noise sim output - 4=BD, 5=AD):
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES ((SELECT MAX(SURFACE_DATA.ID) FROM SURFACE_DATA)::INT, 5); --SURFACE_DATA.ID (TEXTURE ID), APPEARANCE.ID (THEME ID for Noise BD)

-- --------------------------------------------------------------------






--STEP 4--
--Update TEXTUREPARAM table to link the texture to the citydb geometry:
INSERT INTO citydb.TEXTUREPARAM(
	surface_geometry_id,
	is_texture_parametrization,
	world_to_texture,
	texture_coordinates,
	surface_data_id
)
VALUES(82482, 1, NULL, 
ST_GeomFromText('POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'), 
--(SELECT TEXTURE_COORDINATES FROM TEXTUREPARAM 
--WHERE SURFACE_GEOMETRY_ID = 82482 AND SURFACE_DATA_ID = 61),
(SELECT MAX(SURFACE_DATA.ID) FROM SURFACE_DATA)::INT);

*/







--In case you need to adjust the orientation of the texture
--as it is attached on the citydb geometry:


--UPDATE TEXTUREPARAM
--SET TEXTURE_COORDINATES =
--ST_GeomFromText('POLYGON((0.0 0.0, 0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0))')
--WHERE SURFACE_GEOMETRY_ID = 82482 AND
--SURFACE_DATA_ID = 15




--SELECT*
--FROM TEXTUREPARAM
--WHERE SURFACE_GEOMETRY_ID = 82482 


--SELECT *
--FROM SURFACE_DATA 
--WHERE ID = 90



