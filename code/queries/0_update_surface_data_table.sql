--Add UUID as ID for every SURFACE_DATA table entry

--OA (sunlight simulation)
--UPDATE citydb.SURFACE_DATA
--SET gmlid = CONCAT('surfacedata', uuid_generate_v4());

/*
--Colors for building roof, wall, and ground surfaces with no simulation output:
INSERT INTO citydb.SURFACE_DATA
VALUES (6, NULL, NULL, 'RoofSurface_darkgray', NULL, 'RGB-color for roof surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.2 0.2 0.2', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (7, NULL, NULL, 'WallSurface_lightgray', NULL, 'RGB-color for wall surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.7 0.7 0.7', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (8, NULL, NULL, 'GroundSurface_beige', NULL, 'RGB-color for ground surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.9 0.7 0.4', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



--Planned buildings: RoofSurface
INSERT INTO citydb.SURFACE_DATA
VALUES (9, NULL, NULL, 'RoofSurface_PB', NULL, 'RGB-color for roof surface of planned buildings',
1, 53, NULL, NULL, NULL, NULL, '0.6 0.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Planned buildings: WallSurface
INSERT INTO citydb.SURFACE_DATA
VALUES (10, NULL, NULL, 'WallSurface_PB', NULL, 'RGB-color for wall surface of planned buildings',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--Planned buildings: GroundSurface
INSERT INTO citydb.SURFACE_DATA
VALUES (11, NULL, NULL, 'WallSurface_PB', NULL, 'RGB-color for ground surface of planned buildings',
1, 53, NULL, NULL, NULL, NULL, '0.1 0.1 0.1', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);




--Existing buildings (white)
--Colors for building roof, wall, and ground surfaces with no simulation output:
INSERT INTO citydb.SURFACE_DATA
VALUES (12, NULL, NULL, 'RoofSurface_lightgray', NULL, 'RGB-color for roof surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.6 0.6 0.6', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (13, NULL, NULL, 'WallSurface_white', NULL, 'RGB-color for wall surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.9 0.9 0.9', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--Planned buildings (blue)
--Colors for building roof, wall, and ground surfaces with no simulation output:
INSERT INTO citydb.SURFACE_DATA
VALUES (14, NULL, NULL, 'RoofSurface_lightblue', NULL, 'RGB-color for roof surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.0 0.1 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (15, NULL, NULL, 'WallSurface_blue', NULL, 'RGB-color for wall surfaces',
1, 53, NULL, NULL, NULL, NULL, '0.8 0.8 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--Planned buildings (yellow)
--Colors for building roof, wall, and ground surfaces with no simulation output:
INSERT INTO citydb.SURFACE_DATA
VALUES (16, NULL, NULL, 'RoofSurface_lightyellow', NULL, 'RGB-color for roof surfaces',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.9 0.1', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (17, NULL, NULL, 'WallSurface_yellow', NULL, 'RGB-color for wall surfaces',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 0.8', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

*/

--Add GMLID for building wall- and roof-surfaces:
--UPDATE citydb.SURFACE_DATA
--SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
--WHERE (SURFACE_DATA.ID < 18) AND (SURFACE_DATA.ID > 11);


/*

--AIrr (daylight simulation) - Before densification (BD) scenario
-- Add entries for textures representing vertical point grid of AIrr sim output
INSERT INTO citydb.SURFACE_DATA
VALUES(18, NULL, NULL, 'WS_LOD2_AIrr_BD_f4', NULL, 'Texture for LOD2 WallSurface with AIrr output for BD scenario',
1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'none', NULL, NULL, NULL, NULL);

--Add GMLID:
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE SURFACE_DATA.ID = 18;
*/


/*
--AIrr (daylight simulation) - After densification (AD) scenario
-- Add entries for textures representing vertical point grid of AIrr sim output
INSERT INTO citydb.SURFACE_DATA
VALUES(19, NULL, NULL, 'WS_LOD2_AIrr_AD_f4', NULL, 'Texture for LOD2 WallSurface with AIrr output for AD scenario',
1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, 'none', NULL, NULL, NULL, NULL);

--Add GMLID:
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE SURFACE_DATA.ID = 19;
*/


-- Noise (noise simulation) - Before densification (BD) scenario
-- Add entries for textures representing vertical point grid of Noise sim output
INSERT INTO citydb.SURFACE_DATA
VALUES(20, NULL, NULL, 'WS_LOD2_Noise_BD_fx', NULL, 'Texture for LOD2 WallSurface with Noise output for BD scenario',
1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, 'none', NULL, NULL, NULL, NULL);

--Add GMLID:
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE SURFACE_DATA.ID = 20;


SELECT *
FROM citydb.SURFACE_DATA
ORDER BY ID;