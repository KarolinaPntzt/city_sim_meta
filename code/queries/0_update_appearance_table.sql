--Populate APPEARANCE table with values

--Building roof-, wall-, and ground-surface colors (plain)
--INSERT INTO citydb.APPEARANCE
--VALUES (0, NULL, NULL, NULL, NULL, NULL,
--'DSH_windows_LOD3', NULL, NULL);

--OA simulation output (windows)
--INSERT INTO citydb.APPEARANCE
--VALUES (1, NULL, NULL, NULL, NULL, NULL,
--'OA_windows_LOD3', NULL, NULL);


--AIrr simulation output (LOD2 WallSurface) BD
--INSERT INTO citydb.APPEARANCE
--VALUES (2, NULL, NULL, NULL, NULL, NULL,
--'AIrr_wallsurface_LOD2_BD', NULL, NULL);

--AIrr simulation output (LOD2 WallSurface) AD
--INSERT INTO citydb.APPEARANCE
--VALUES (3, NULL, NULL, NULL, NULL, NULL,
--'AIrr_wallsurface_LOD2', NULL, NULL);


--Noise simulation output (LOD2 WallSurface) BD
--INSERT INTO citydb.APPEARANCE
--VALUES (4, NULL, NULL, NULL, NULL, NULL,
--'Noise_wallsurface_LOD2_BD', NULL, NULL);

--Noise simulation output (LOD2 WallSurface) AD
--INSERT INTO citydb.APPEARANCE
--VALUES (5, NULL, NULL, NULL, NULL, NULL,
--'Noise_wallsurface_LOD2_AD', NULL, NULL);


--Flood simulation output (Terrain) BD
--INSERT INTO citydb.APPEARANCE
--VALUES (6, NULL, NULL, NULL, NULL, NULL,
--'Flood_LOD2_BD', NULL, NULL);

--Flood simulation output (Terrain) AD
--INSERT INTO citydb.APPEARANCE
--VALUES (7, NULL, NULL, NULL, NULL, NULL,
--'Flood_LOD2_AD', NULL, NULL);


--Wind simulation output (Terrain) BD
--INSERT INTO citydb.APPEARANCE
--VALUES (6, NULL, NULL, NULL, NULL, NULL,
--'Wind_LOD2_BD', NULL, NULL);

--Wind simulation output (Terrain) AD
--INSERT INTO citydb.APPEARANCE
--VALUES (7, NULL, NULL, NULL, NULL, NULL,
--'Wind_LOD2_AD', NULL, NULL);
-- ---------------------------------------------------------------





--Set a unique ID (UUID) as the GMLID-value for every row

-- Set UUID for DSH-theme:
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('DSH_LOD3_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 0;


-- Set UUID for OA-theme:
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('OA_LOD3_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 1;

-- Set UUID for AIrr-theme:
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('AIrr_LOD2_BD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 2;

-- Set UUID for AIrr-theme:
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('AIrr_LOD2_AD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 3;

-- Set UUID for Noise-theme (BD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Noise_LOD2_BD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 4;

-- Set UUID for Noise-theme (AD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Noise_LOD2_AD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 5;

-- Set UUID for Flood-theme (BD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Flood_LOD2_BD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 6;

-- Set UUID for Flood-theme (AD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Flood_LOD2_AD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 7;

-- Set UUID for Wind-theme (BD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Wind_LOD2_BD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 8;

-- Set UUID for Wind-theme (AD scenario):
--UPDATE citydb.APPEARANCE
--SET gmlid = CONCAT('Wind_LOD2_AD_theme_', uuid_generate_v4())
--WHERE citydb.APPEARANCE.ID = 9;


SELECT *
FROM APPEARANCE
ORDER BY ID;

