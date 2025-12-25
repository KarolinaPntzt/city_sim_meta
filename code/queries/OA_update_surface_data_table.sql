--Add colormap with value intervals for OA sim output

--Colors for windows with and without OA sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (0, NULL, NULL, 'w_OA_null', NULL, 'RGB-color for windows with no OA value (value=NULL)',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (1, NULL, NULL, 'w_OA_interval_1', NULL, 'RGB-color for windows whose OA value is: OA < 5 degrees',
1, 53, NULL, NULL, NULL, NULL, '0.0 0.5 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (2, NULL, NULL, 'w_OA_interval_2', NULL, 'RGB-color for windows whose OA value is: 5<= OA <10 degrees',
1, 53, NULL, NULL, NULL, NULL, '0.5 0.7 0.1', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (3, NULL, NULL, 'w_OA_interval_3', NULL, 'RGB-color for windows whose OA value is: 10<= OA <20 degrees',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (4, NULL, NULL, 'w_OA_interval_4', NULL, 'RGB-color for windows whose OA value is: 20<= OA <30 degrees',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.7 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (5, NULL, NULL, 'w_OA_interval_5', NULL, 'RGB-color for windows whose OA value is: OA >=30 degrees',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.2 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


