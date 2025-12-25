
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



