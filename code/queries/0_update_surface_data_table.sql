--Add colormap with value intervals for OA sim output

--Colors for windows with and without OA sim output:
--INSERT INTO citydb.SURFACE_DATA
--VALUES (0, NULL, NULL, 'w_OA_null', NULL, 'RGB-color for windows with no OA value (value=NULL)',
--1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (1, NULL, NULL, 'w_OA_interval_1', NULL, 'RGB-color for windows whose OA value is: OA < 5 degrees',
--1, 53, NULL, NULL, NULL, NULL, '0.0 0.5 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (2, NULL, NULL, 'w_OA_interval_2', NULL, 'RGB-color for windows whose OA value is: 5<= OA <10 degrees',
--1, 53, NULL, NULL, NULL, NULL, '0.5 0.7 0.1', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (3, NULL, NULL, 'w_OA_interval_3', NULL, 'RGB-color for windows whose OA value is: 10<= OA <20 degrees',
--1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (4, NULL, NULL, 'w_OA_interval_4', NULL, 'RGB-color for windows whose OA value is: 20<= OA <30 degrees',
--1, 53, NULL, NULL, NULL, NULL, '1.0 0.7 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (5, NULL, NULL, 'w_OA_interval_5', NULL, 'RGB-color for windows whose OA value is: OA >=30 degrees',
--1, 53, NULL, NULL, NULL, NULL, '1.0 0.2 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);




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
--INSERT INTO citydb.SURFACE_DATA
--VALUES(20, NULL, NULL, 'WS_LOD2_Noise_BD_fx', NULL, 'Texture for LOD2 WallSurface with Noise output for BD scenario',
--1, 54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, NULL, 'none', NULL, NULL, NULL, NULL);

--Add GMLID:
--UPDATE citydb.SURFACE_DATA
--SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
--WHERE SURFACE_DATA.ID = 20;


----------------------------------------------------------------------
----------------------------------------------------------------------
--Add colormap with value intervals for Flood sim output (water depth)

--Colors for TIN triangles without flood sim output:
--INSERT INTO citydb.SURFACE_DATA
--VALUES (90, NULL, NULL, 'water_depth_null', NULL, 'RGB-color for TIN triangle with no water depth value (value=NULL)',
--1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with flood sim output:
--INSERT INTO citydb.SURFACE_DATA
--VALUES (91, NULL, NULL, 'water_depth_interval_1', NULL, 'RGB-color for TIN triangles whose water depth value is: WD < 0.1 m',
--1, 53, NULL, NULL, NULL, NULL, '0.0 0.2 0.5', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (92, NULL, NULL, 'water_depth_interval_2', NULL, 'RGB-color for TIN triangles whose water depth value is: 0.1 m >= WD < 0.3 m',
--1, 53, NULL, NULL, NULL, NULL, '0.0 0.3 0.7', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (93, NULL, NULL, 'water_depth_interval_3', NULL, 'RGB-color for TIN triangles whose water depth value is: 0.3 m >= WD < 0.6 m',
--1, 53, NULL, NULL, NULL, NULL, '0.0 0.4 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (94, NULL, NULL, 'water_depth_interval_4', NULL, 'RGB-color for TIN triangles whose water depth value is: 0.6 m >= WD < 1.2 m',
--1, 53, NULL, NULL, NULL, NULL, '0.4 0.7 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--INSERT INTO citydb.SURFACE_DATA
--VALUES (95, NULL, NULL, 'water_depth_interval_5', NULL, 'RGB-color for TIN triangles whose water depth value is: WD >= 1.2 m',
--1, 53, NULL, NULL, NULL, NULL, '0.8 0.9 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--UPDATE citydb.SURFACE_DATA
--SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
--WHERE ID > 89 AND ID < 96;


----------------------------------------------------------------------
----------------------------------------------------------------------
--Add colormap with value intervals for Wind sim output (Lawson LDDC)
/*
--Colors for TIN triangles without Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (96, NULL, NULL, 'wind_Lawson_BD_LDDC_null', NULL, 
'RGB-color for TIN triangle with no wind sim output value (value=NULL)',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 1.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (97, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_1', NULL, 
'RGB-color for TIN triangles whose wind value is: 0 m >= W < 2.5 m',
1, 53, NULL, NULL, NULL, NULL, '0.0 0.0 1.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (98, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_2', NULL, 
'RGB-color for TIN triangles whose wind value is: 2.5 m >= W < 4.0 m',
1, 53, NULL, NULL, NULL, NULL, '0.0 0.7 1.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (99, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_3', NULL, 
'RGB-color for TIN triangles whose wind value is:  4.0 m >= W < 6.0 m',
1, 53, NULL, NULL, NULL, NULL, '0.0 1.0 1.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (100, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_4', NULL, 
'RGB-color for TIN triangles whose wind value is: 6.0 m >= W < 8.0 m',
1, 53, NULL, NULL, NULL, NULL, '0.0 1.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (101, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_5', NULL, 
'RGB-color for TIN triangles whose wind value is: 8.0 m >= W < 15.0 m',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.7 0.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (102, NULL, NULL, 'wind_Lawson_BD_LDDC_interval_6', NULL, 
'RGB-color for TIN triangles whose wind value is: W >= 15.0 m',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.0 0.0', NULL, 0, 
NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Colors for TIN triangles with Wind sim output:
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE ID > 95 AND ID < 103;
*/

SELECT *
FROM citydb.SURFACE_DATA
ORDER BY ID;