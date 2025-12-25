--Populate TEXTUREPARAM table with values
/*
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
WHERE CITYOBJECT.OBJECTCLASS_ID = 38
AND SURFACE_GEOMETRY.GEOMETRY IS NULL;

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;

INSERT INTO citydb.TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;

*/
/*

--Populate TEXTUREPARAM table with values for
--building roof-surfaces:
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
WHERE CITYOBJECT.OBJECTCLASS_ID = 33
AND SURFACE_GEOMETRY.GEOMETRY IS NULL;

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;

INSERT INTO citydb.TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;



--Populate TEXTUREPARAM table with values for
--building wall-surfaces:
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
WHERE CITYOBJECT.OBJECTCLASS_ID = 34
AND SURFACE_GEOMETRY.GEOMETRY IS NULL;

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;

INSERT INTO citydb.TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;



--Populate TEXTUREPARAM table with values for
--building ground-surfaces:
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
WHERE CITYOBJECT.OBJECTCLASS_ID = 35
AND SURFACE_GEOMETRY.GEOMETRY IS NULL;

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;

INSERT INTO citydb.TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;





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


/*
--Planned building roofs:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 9
WHERE surface_geometry_id IN(

--Get RoofSurfaces (33) of planned buildings (2027)
	SELECT citydb.SURFACE_GEOMETRY.ID
	FROM citydb.BUILDING INNER JOIN citydb.SURFACE_GEOMETRY
	ON citydb.BUILDING.ID = citydb.SURFACE_GEOMETRY.PARENT_ID
	INNER JOIN citydb.CITYOBJECT 
	ON citydb.SURFACE_GEOMETRY.CITYOBJECT_ID = citydb.CITYOBJECT.ID
	WHERE year_of_construction = '2027-01-01'
	AND citydb.CITYOBJECT.OBJECTCLASS_ID = 33
);




--Planned building wall surfaces:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 10
WHERE surface_geometry_id IN(

--Get RoofSurfaces (34) of planned buildings (2027)
	SELECT citydb.SURFACE_GEOMETRY.ID
	FROM citydb.BUILDING INNER JOIN citydb.SURFACE_GEOMETRY
	ON citydb.BUILDING.ID = citydb.SURFACE_GEOMETRY.PARENT_ID
	INNER JOIN citydb.CITYOBJECT 
	ON citydb.SURFACE_GEOMETRY.CITYOBJECT_ID = citydb.CITYOBJECT.ID
	WHERE year_of_construction = '2027-01-01'
	AND citydb.CITYOBJECT.OBJECTCLASS_ID = 34
);




--Planned building ground surfaces:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 11
WHERE surface_geometry_id IN(

--Get RoofSurfaces (35) of planned buildings (2027)
	SELECT citydb.SURFACE_GEOMETRY.ID
	FROM citydb.BUILDING INNER JOIN citydb.SURFACE_GEOMETRY
	ON citydb.BUILDING.ID = citydb.SURFACE_GEOMETRY.PARENT_ID
	INNER JOIN citydb.CITYOBJECT 
	ON citydb.SURFACE_GEOMETRY.CITYOBJECT_ID = citydb.CITYOBJECT.ID
	WHERE year_of_construction = '2027-01-01'
	AND citydb.CITYOBJECT.OBJECTCLASS_ID = 35
);

*/





/*
--Match the SURFACE_DATA color to the SURFACE_GEOMETRY window
--based on the OA sim output value (BD scenario)

--Windows whose OA is NULL:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 0
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL AND sim_meta.geom_oa.Value IS NULL
);

--Windows whose OA is < 5:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 1
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL AND sim_meta.geom_oa.Value < 5
);

--Windows whose sim output is: 5>= OA <10:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 2
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_oa.Value >= 5
	AND sim_meta.geom_oa.Value < 10
);


--Windows whose sim output is: 10>= OA <20:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 3
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_oa.Value >= 10
	AND sim_meta.geom_oa.Value < 20
);


--Windows whose sim output is: 20>= OA <30:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 4
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_oa.Value >= 20
	AND sim_meta.geom_oa.Value < 30
);


--Windows whose sim output is: OA >=30:
UPDATE citydb.TEXTUREPARAM
SET surface_data_id = 5
WHERE surface_geometry_id IN(

	SELECT surface_geometry.id
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	INNER JOIN sim_meta.geom_oa
	ON CITYOBJECT.GMLID = sim_meta.geom_oa.cityObjectIdentifier
	WHERE CITYOBJECT.OBJECTCLASS_ID = 38
	AND SURFACE_GEOMETRY.GEOMETRY IS NULL 
	AND sim_meta.geom_oa.Value >= 30
);*/


/*
--AIrr add texture for one facade (f4)
INSERT INTO citydb.TEXTUREPARAM(
	surface_geometry_id,
	is_texture_parametrization,
	world_to_texture,
	texture_coordinates,
	surface_data_id
)
--VALUES(174360, 1, NULL, ST_GeomFromText('POLYGON((0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0, 0.0 1.0))'), 18);
VALUES(174360, 1, NULL, ST_GeomFromText('POLYGON((0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0, 0.0 1.0))'), 19);

*/




/*
UPDATE TEXTUREPARAM
SET TEXTURE_COORDINATES =
ST_GeomFromText('POLYGON((0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0, 0.0 1.0))')
WHERE TEXTURE_COORDINATES  IN
(
	SELECT TEXTURE_COORDINATES
	FROM TEXTUREPARAM 
	WHERE SURFACE_GEOMETRY_ID = 174360 AND
	SURFACE_DATA_ID = 18 
)
*/





/*

--Noise add texture for one facade (fx)
INSERT INTO citydb.TEXTUREPARAM(
	surface_geometry_id,
	is_texture_parametrization,
	world_to_texture,
	texture_coordinates,
	surface_data_id
)
VALUES(256661, 1, NULL, ST_GeomFromText('POLYGON((0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0, 0.0 1.0))'), 20);
*/


UPDATE TEXTUREPARAM
SET TEXTURE_COORDINATES =
ST_GeomFromText('POLYGON((0.0 0.0, 0.0 1.0, 1.0 1.0, 1.0 0.0, 0.0 0.0))')
WHERE TEXTURE_COORDINATES  IN
(
	SELECT TEXTURE_COORDINATES
	FROM TEXTUREPARAM 
	WHERE SURFACE_GEOMETRY_ID = 256661 AND
	SURFACE_DATA_ID = 20
);




--DELETE FROM TEXTUREPARAM
--WHERE TEXTUREPARAM.SURFACE_GEOMETRY_ID = 256661
--AND TEXTUREPARAM.SURFACE_DATA_ID != 20;



--SELECT *
--FROM TEXTUREPARAM
--WHERE TEXTUREPARAM.SURFACE_GEOMETRY_ID = 256661;

