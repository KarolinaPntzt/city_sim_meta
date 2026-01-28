/*
					*** DSH SQL QUERY ***

This SQL-query links every DSH simulation output to its corresponding
window geometry and assigns an appearance X3D color to it depending
on the value interval the simulation output value corresponds to.
*/



-- STEP 1 --
--Create an APPEARANCE for the DSH simulation type
/*
INSERT INTO citydb.APPEARANCE
VALUES (0, NULL, NULL, NULL, NULL, NULL,
'DSH_windows_LOD3', NULL, NULL);

-- Set UUID for "problematic buildings"-theme:
UPDATE citydb.APPEARANCE
SET gmlid = CONCAT('DSH_LOD3_theme_', uuid_generate_v4())
WHERE citydb.APPEARANCE.ID = 0;
*/

-------------------------------------------------------------------
-------------------------------------------------------------------



-- STEP 2 --
--Add entries to the SURFACE_DATA table corresponding to different 
--X3D colors for every DSH simulation output value interval.
/*
--Colors for windows with and without DSH sim output:
INSERT INTO citydb.SURFACE_DATA
VALUES (106, NULL, NULL, 'w_DSH_null', NULL, 'RGB-color for windows with no DSH value (value=NULL)',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 1.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (107, NULL, NULL, 'w_DSH_interval_1', NULL, 'RGB-color for windows whose DSH value is: DSH < 1.5 hours',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.2 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (108, NULL, NULL, 'w_DSH_interval_2', NULL, 'RGB-color for windows whose DSH value is: 1.5<= OA <4.0 hours',
1, 53, NULL, NULL, NULL, NULL, '1.0 0.7 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (109, NULL, NULL, 'w_DSH_interval_3', NULL, 'RGB-color for windows whose DSH value is: 4.0<= OA <7.0 hours',
1, 53, NULL, NULL, NULL, NULL, '1.0 1.0 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (110, NULL, NULL, 'w_DSH_interval_4', NULL, 'RGB-color for windows whose DSH value is: 7.0<= OA <10.0 hours',
1, 53, NULL, NULL, NULL, NULL, '0.5 0.7 0.1', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO citydb.SURFACE_DATA
VALUES (111, NULL, NULL, 'w_DSH_interval_5', NULL, 'RGB-color for windows whose DSH value is: OA >=10.0 hours',
1, 53, NULL, NULL, NULL, NULL, '0.0 0.5 0.0', NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--Add UUID as ID for every SURFACE_DATA table entry
--DSH (sunlight simulation)
UPDATE citydb.SURFACE_DATA
SET gmlid = CONCAT('surfacedata', uuid_generate_v4())
WHERE SURFACE_DATA.ID > 105 AND SURFACE_DATA.ID < 112;
*/

-------------------------------------------------------------------
-------------------------------------------------------------------





-- STEP 3 --
--Update the APPEAR_TO_SURFACE_DATA table to map the newly created
--SURFACE_DATA table entries to the "DSH" theme (ID: 10) in the APPEARANCE table. 

/*
--Entry for DSH NULL values:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (106, 0);

--Entry for DSH 1st value interval:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (107, 0);

--Entry for DSH 2nd value interval:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (108, 0);

--Entry for DSH 3rd value interval:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (109, 0);

--Entry for DSH 4th value interval:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (110, 0);

--Entry for DSH 5th value interval:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (111, 0);

--WallSurface of existing buildings:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (6, 0);

--RoofSurface of existing buildings:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (7, 0);

--GroundSurface of existing buildings:
INSERT INTO citydb.APPEAR_TO_SURFACE_DATA
VALUES (8, 0);

*/
-------------------------------------------------------------------
-------------------------------------------------------------------




-- STEP 4 --
--Link DSH simulation output to 3D city model geometry (windows):
/*
WITH temp_update_DSH_table(geom_id) AS(

SELECT t1.geom_id, t1.value, t1.geom, t2.gmlid,
	ST_3DDistance(t1.geom, t2.geometry) AS distance
	FROM sim_meta.geom_dsh AS t1

	CROSS JOIN LATERAL (
		SELECT citydb.cityobject.gmlid, citydb.surface_geometry.geometry
		FROM citydb.cityobject INNER JOIN citydb.surface_geometry
		ON citydb.cityobject.id = citydb.surface_geometry.cityobject_id
		WHERE citydb.cityobject.objectclass_id = 38 AND
		citydb.surface_geometry.geometry IS NOT NULL
		AND ST_3DDwithin(geometry, t1.geom, 1)
		ORDER BY t1.geom <-> geometry
		LIMIT 1
	) AS t2
)

UPDATE sim_meta.geom_dsh
SET cityObjectIdentifier = temp_update_DSH_table.gmlid
FROM temp_update_DSH_table
WHERE sim_meta.geom_dsh.geom_id = temp_update_DSH_table.geom_id;
*/
-------------------------------------------------------------------
-------------------------------------------------------------------




-- STEP 5 --
--Populate TEXTUREPARAM table with values for DSH.
--Match the SURFACE_DATA color to the SURFACE_GEOMETRY window
--based on the DSH sim output value (BD scenario)
/*
--Windows whose DSH is NULL:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 106
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	LEFT JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value IS NULL
);


--Windows whose DSH is < 1.5 hours:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 107
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value >= 0.0
	AND sim_meta.geom_dsh.Value < 1.5
);

--Windows whose sim output is: 1.5>= DSH <4.0:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 108
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value >= 1.5
	AND sim_meta.geom_dsh.Value < 4.0
);


--Windows whose sim output is: 4.0>= DSH <7.0:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 109
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value >= 4.0
	AND sim_meta.geom_dsh.Value < 7.0
);


--Windows whose sim output is: 7.0>= DSH <10.0:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 110
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value >= 7.0
	AND sim_meta.geom_dsh.Value < 10.0
);


--Windows whose sim output is: DSH >=10.0:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 111
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_dsh
	ON CITYOBJECT.GMLID = sim_meta.geom_dsh.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_dsh.Value >= 10.0
);





--Building roofs:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 6
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	WHERE CITYOBJECT.OBJECTCLASS_ID = 33
	
);


--Building wall surfaces:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 7
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	WHERE CITYOBJECT.OBJECTCLASS_ID = 34


);


--Building ground surfaces:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 8
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	WHERE CITYOBJECT.OBJECTCLASS_ID = 35
	


);
*/
