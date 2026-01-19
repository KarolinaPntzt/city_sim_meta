-- STEP 1 --
--Create Wind (Lawson LDDC comfort criteria) table:
/*
CREATE TABLE sim_meta.Geom_Wind
(
	Geom_ID character varying(255),
	coord_x double precision,
	coord_y double precision,
	coord_z double precision,
	Value numeric,
	cityObjectIdentifier character varying(255),
	cityObjectGMLID character varying(255),
	surfaceGeometryID bigint,
	simulationID character varying(255),
	geom geometry(PointZ, 3008)
);
*/



-- STEP 2 --
--Import csv-file with Flood sim output to newly created table



-- STEP 3 --
-- Add simulation ID to table
/*
UPDATE sim_meta.Geom_Wind
SET simulationID = 'Wind_malmo_bellevue_DpXXXXX_20250321_v1'
WHERE simulationID IS NULL AND
geom_id LIKE 'Wind_malmo_bellevue_DpXXXXX_20250321_v1_%';
*/


-- STEP 4 --
-- Compute point geometry from the imported x-, y-, and z-coordinates:
/*
UPDATE sim_meta.Geom_Wind
SET geom = ST_SetSRID(ST_MakePoint(coord_x, coord_y, coord_z), 3008)
WHERE simulationID = 'Wind_malmo_bellevue_DpXXXXX_20250321_v1';
*/


-- STEP 5 --
--Add spatial index 2D:
--CREATE INDEX idx_geom_wind_2d
--ON sim_meta.Geom_Wind
--USING GIST (geom);

--Add spatial index 3D:
--CREATE INDEX idx_geom_wind_3d
--ON sim_meta.Geom_Wind
--USING GIST (geom gist_geometry_ops_nd);


--VACUUM ANALYZE sim_meta.Geom_Wind;

/*
-- STEP 6 --
-- Store details of the closest TIN triangle to every sim output point:
WITH TIN_triangle_geom AS (
	SELECT	SURFACE_GEOMETRY.ID AS sg_id, 
			SURFACE_GEOMETRY.GMLID AS sg_gmlid, 
			SURFACE_GEOMETRY.GEOMETRY AS sg_geom,
			CITYOBJECT.ID AS co_id, 
			CITYOBJECT.GMLID AS co_gmlid
	FROM SURFACE_GEOMETRY INNER JOIN CITYOBJECT
	ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
	WHERE SURFACE_GEOMETRY.GMLID LIKE 'TIN_TRI_%'
)


SELECT	t.sg_gmlid, t.co_gmlid,
		ST_3DDistance(t.sg_geom, ST_Force3DZ('POINT(10 20 0)'::geometry)) AS dist_3D 
FROM	TIN_triangle_geom t
CROSS JOIN LATERAL (SELECT 'POINT(10 20)'::geometry AS p2d) p
ORDER BY 
	ST_Intersects(ST_Force2D(t.geom), p.p2d) DESC,
	ST_3DDistance(t.geom, ST_Force3DZ(p.p2d)) ASC
LIMIT 1;

*/

--SELECT indexname, indexdef
--FROM pg_indexes
--WHERE tablename = 'citydb.SURFACE_GEOMETRY'




