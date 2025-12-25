/*
-- Step 1 --
--Delete any previous entries in TEXTUREPARAM 
--that correspond to WallSurfaces of planned buildings
DELETE FROM TEXTUREPARAM 
WHERE SURFACE_GEOMETRY_ID IN (
SELECT SURFACE_GEOMETRY_ID
FROM CITYOBJECT INNER JOIN SURFACE_GEOMETRY
ON CITYOBJECT.ID = SURFACE_GEOMETRY.CITYOBJECT_ID 
INNER JOIN TEXTUREPARAM 
ON SURFACE_GEOMETRY.ID = TEXTUREPARAM.SURFACE_GEOMETRY_ID
WHERE CITYOBJECT.OBJECTCLASS_iD = 34)
*/



/*
-- Step 2.a --
--Add WallSurface geometries of existing buildings in TEXTUREPARAM
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM CITYOBJECT INNER JOIN SURFACE_GEOMETRY
ON CITYOBJECT.ID = SURFACE_GEOMETRY.CITYOBJECT_ID 
WHERE CITYOBJECT.OBJECTCLASS_ID = 34 AND
CITYOBJECT.GMLID NOT LIKE 'pb-ws%';

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;


INSERT INTO citydb. TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;
*/







/*
-- Step 2.b --
--Add WallSurface geometries of planned buildings in TEXTUREPARAM
CREATE TEMPORARY TABLE textureparam_temp
(surface_geometry_id BIGINT,
is_texture_parametrization INT,
world_to_texture VARCHAR(1000),
texture_coordinates GEOMETRY,
surface_data_id BIGINT);

INSERT INTO textureparam_temp (surface_geometry_id)
SELECT SURFACE_GEOMETRY.ID
FROM CITYOBJECT INNER JOIN SURFACE_GEOMETRY
ON CITYOBJECT.ID = SURFACE_GEOMETRY.CITYOBJECT_ID 
WHERE CITYOBJECT.OBJECTCLASS_ID = 34 AND
CITYOBJECT.GMLID LIKE 'pb-ws%';

UPDATE textureparam_temp
SET surface_data_id = 0;

UPDATE textureparam_temp
SET is_texture_parametrization = 0;


INSERT INTO citydb. TEXTUREPARAM (surface_geometry_id,
is_texture_parametrization, surface_data_id)
SELECT surface_geometry_id, is_texture_parametrization,
surface_data_id
FROM textureparam_temp;

DROP TABLE textureparam_temp;
*/






/*
-- Step 3.a --
--Set the color of the WallSurface of existing buildings:
UPDATE citydb.TEXTUREPARAM
SET SURFACE_DATA_ID = 7
WHERE SURFACE_GEOMETRY_ID IN (
	SELECT SURFACE_GEOMETRY_ID
	FROM CITYOBJECT INNER JOIN SURFACE_GEOMETRY
	ON CITYOBJECT.ID = SURFACE_GEOMETRY.CITYOBJECT_ID 
	INNER JOIN TEXTUREPARAM 
	ON SURFACE_GEOMETRY.ID = TEXTUREPARAM.SURFACE_GEOMETRY_ID
	WHERE CITYOBJECT.OBJECTCLASS_ID = 34
	AND CITYOBJECT.GMLID NOT LIKE 'pb-ws%');
*/






-- Step 3.b --
--Set the color of the WallSurface of planned buildings:
UPDATE citydb.TEXTUREPARAM
SET SURFACE_DATA_ID = 10
WHERE SURFACE_GEOMETRY_ID IN (
	SELECT SURFACE_GEOMETRY_ID
	FROM CITYOBJECT INNER JOIN SURFACE_GEOMETRY
	ON CITYOBJECT.ID = SURFACE_GEOMETRY.CITYOBJECT_ID 
	INNER JOIN TEXTUREPARAM 
	ON SURFACE_GEOMETRY.ID = TEXTUREPARAM.SURFACE_GEOMETRY_ID
	WHERE CITYOBJECT.OBJECTCLASS_ID = 34
	AND CITYOBJECT.GMLID LIKE 'pb-ws%');

