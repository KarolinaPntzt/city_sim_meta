--Populate APPEARANCE table with values
/*
--Building roof-, wall-, and ground-surface colors (plain)
INSERT INTO citydb.APPEARANCE
VALUES (0, NULL, NULL, NULL, NULL, NULL,
'buildings_plain', NULL, NULL);*/

--OA simulation output (windows)
--INSERT INTO citydb.APPEARANCE
--VALUES (1, NULL, NULL, NULL, NULL, NULL,
--'OA_windows_LOD3', NULL, NULL);


--AIrr simulation output (LOD2 WallSurface)
INSERT INTO citydb.APPEARANCE
VALUES (3, NULL, NULL, NULL, NULL, NULL,
'AIrr_wallsurface_LOD2', NULL, NULL);

-- ---------------------------------------------------------------


--Set a unique ID (UUID) as the GMLID-value for every row

/*
UPDATE citydb.APPEARANCE
SET gmlid = CONCAT('Building_plain_theme_', uuid_generate_v4())
WHERE citydb.APPEARANCE.ID = 0;
*/

-- Set UUID for OA-theme:
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('OA_LOD3_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 1;


-- Set UUID for AIrr-theme:
UPDATE citydb.APPEARANCE
SET gmlid = CONCAT('AIrr_LOD2_theme_', uuid_generate_v4())
WHERE citydb.APPEARANCE.ID = 3;

