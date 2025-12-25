--Add UUID as ID for every SURFACE_DATA table entry

--OA (sunlight simulation)
--UPDATE citydb.SURFACE_DATA
--SET gmlid = CONCAT('surfacedata', uuid_generate_v4());



--AIrr (daylight simulation)
-- Add entries for textures representing vertical point grid of AIrr sim output
INSERT INTO citydb.SURFACE_DATA
VALUES(18, NULL, NULL, 'WS_LOD2_AIrr_BD_f4', NULL, 'Texture for LOD2 WallSurface with AIrr output for BD scenario',
1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'none', NULL, NULL, NULL, NULL);

--Add GMLID:
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE SURFACE_DATA.ID = 18;