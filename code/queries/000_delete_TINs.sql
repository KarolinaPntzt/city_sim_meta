--Delete the entries from last SQL-snippet to first

-- 1 entry
--DELETE FROM CITYOBJECT
--WHERE GMLID LIKE 'RELIEF_FEAT_%'
--AND ID = 4283706;



-- 1 entry
--DELETE FROM RELIEF_FEATURE
--WHERE ID = 4283706;



--1359481 entries
--The following query deletes TIN-triangle related entries
--from the CITYOBJECT, SURFACE_GEOMETRY (GMLID LIKE 'TIN_ROOT_%'),
--TIN_RELIEF, and RELIEF_COMPONENT 

--UPDATE citydb.surface_geometry
--SET cityobject_id = NULL
--WHERE cityobject_id IN (
--	SELECT ID FROM citydb.cityobject
--	WHERE gmlid LIKE '%TIN%');

/*
WITH to_delete AS (
	SELECT ID FROM CITYOBJECT  
	WHERE GMLID LIKE '%TIN%' 
	AND ID >= 5003707 AND ID < 5043707 -- Delete in chunks of 40,000 rows for the load to be manageable
)

SELECT citydb.del_cityobject(ID) 
FROM to_delete;
*/


--SELECT *
--FROM CITYOBJECT 
--WHERE GMLID LIKE '%TIN%';

-- 1359481 entries
--SELECT * FROM TIN_RELIEF 
--DELETE FROM TIN_RELIEF 
--WHERE ID >= 4323707 AND ID < 4323707; -- Delete in chunks of 40,000 rows for the load to be manageable




-- 1359481 entries
--SELECT * FROM RELIEF_COMPONENT 
--DELETE FROM RELIEF_COMPONENT 
--WHERE ID >= 4323707 AND ID < 4323707; -- Delete in chunks of 40,000 rows for the load to be manageable


-- 1359481 entries
--SELECT * FROM SURFACE_GEOMETRY 
--DELETE FROM SURFACE_GEOMETRY 
--WHERE GMLID LIKE 'TIN_TRI_%' 
--AND ID >= 15938110 AND ID < 16018110; -- Delete in chunks of 40,000 rows for the load to be manageable


-- 1359481 entries
--SELECT * FROM RELIEF_FEAT_TO_REL_COMP 
--DELETE FROM RELIEF_FEAT_TO_REL_COMP 
--WHERE RELIEF_COMPONENT_ID >= 4363707; -- Delete in chunks of 40,000 rows for the load to be manageable


--VACUUM ANALYZE
--https://www.postgresql.org/docs/current/sql-vacuum.html
-- Apply this to following tables: 
--cityobject, surface_geometry, tin_relief, relief_component, relief_feat_to_rel_comp
--VACUUM (FULL) SURFACE_GEOMETRY;
--VACUUM ANALYZE citydb.cityobject;
--VACUUM (FULL) citydb.cityobject;
--VACUUM (FULL) citydb.TIN_RELIEF;
--VACUUM (FULL) citydb.RELIEF_COMPONENT;
--VACUUM (FULL) citydb.RELIEF_FEAT_TO_REL_COMP;