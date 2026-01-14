-- STEP 1 --
--Create DEM point table:
/*
CREATE TABLE sim_meta.DEM_point
(
	pointid character varying(255),
	coord_x double precision,
	coord_y double precision,
	coord_z double precision,
	geom geometry(PointZ, 3008)
);
*/



-- STEP 2 --
--Import csv-file with DEM points to newly created table



-- STEP 3 --
-- Compute point geometry from the imported x-, y-, and z-coordinates:
/*
UPDATE sim_meta.DEM_point
SET geom = ST_SetSRID(ST_MakePoint(coord_x, coord_y, coord_z), 3008);
*/


-- STEP 4 --
--Create TIN from DEM points and store it in 3DCityDB


--Filter the DEM points to study area
WITH FilteredPoints AS (
	SELECT ST_Collect(ST_Force3D(geom)) AS collected_points
	FROM DEM_point
	WHERE ST_Within(geom, ST_MakeEnvelope(116874.00, 117165.00, 6162053.00, 6162360.00, 3008))-- Xmin, Xmax, Ymin, Ymax 
),


--Generate TIN triangles from the DEM points
tin_data AS (
	SELECT ST_DelaunayTriangles(collected_points, 0, 0) AS geom
	FROM FilteredPoints
),


--Dump the collection of Delaunay triangles to individual polygons
--ST_Dump() correctly handles both Collections and PolyhedralSurfaces
--by extracting their faces
dumped_data AS (
	SELECT (ST_Dump(ST_CollectionExtract(geom, 3))).geom AS raw_geom
	FROM tin_data
),

--Filter out the Delaunay triangles that are not polygons
--This makes it possible to calculate the aggregate envelope
geometry_dump AS (
	SELECT ST_SetSRID(ST_Force3D(raw_geom), (SELECT srid FROM citydb.database_srs))::geometry AS tri_geom
	FROM dumped_data
	WHERE ST_GeometryType(raw_geom) = 'ST_Polygon'
),

--Calculate the 3D Envelope before inserting into CITYOBJECT
envelope_calc AS (
	SELECT ST_SetSRID(citydb.box2envelope(ST_3DExtent(tri_geom)), 3008) as box
	FROM geometry_dump
),

--Create an entry in CITYOBJECT for the ReliefFeature
relief_cityobj AS (
	INSERT INTO citydb.CITYOBJECT (ID, OBJECTCLASS_ID, GMLID, NAME, DESCRIPTION, ENVELOPE, CREATION_DATE, LAST_MODIFICATION_DATE, UPDATING_PERSON)
	SELECT
		nextval('citydb.cityobject_seq'),
		14,
		'RELIEF_FEAT_' || gen_random_uuid(),
		'DTM_of_Bellevue',
		'TIN-based DTM of Bellevue district Malmo',
		box,
		NOW(),
		NOW(),
		'postgres'
	FROM envelope_calc
	RETURNING ID
),

-- Add an entry to the ReliefFeature table:
relief_feat AS (
	INSERT INTO citydb.relief_feature (ID, OBJECTCLASS_ID, LOD)
	SELECT ID, 14, 2 FROM relief_cityobj
	RETURNING ID
),

--Prepare all IDs for every TIN-triangle in one pass
--Generate 1 CITYOBJECT.ID and 2 SurfaceGeometry.IDs per TIN-triangle
prep_TINs AS ( --ALIAS prepared_data
	SELECT 
		tri_geom,
		nextval('citydb.cityobject_seq') AS new_co_id,
		nextval('citydb.surface_geometry_seq') AS parent_sg_id,
		nextval('citydb.surface_geometry_seq') AS child_sg_id		
	FROM geometry_dump
),

--Add an entry in the CITYOBJECT table for the TINRelief component (one for every TIN-triangle):
comp_cityobj AS (
	INSERT INTO citydb.CITYOBJECT (ID, OBJECTCLASS_ID, GMLID, NAME, DESCRIPTION, ENVELOPE, CREATION_DATE, LAST_MODIFICATION_DATE, UPDATING_PERSON)
	SELECT
		new_co_id, --ID
		16, --OBJECTCLASS_ID
		'TIN_RELIEF_' || gen_random_uuid(), --GMLID
		'DTM_of_Bellevue', --NAME
		'TIN-triangle of Bellevue DTM', --DESCRIPTION
		ST_SetSRID(citydb.box2envelope(Box3D(tri_geom)), 3008), --ENVELOPE
		NOW(), --CREATION_DATE
		NOW(), --LAST_MODIFICATION_DATE
		'postgres' --UPDATING_PERSON
	FROM prep_TINs
	RETURNING ID
),

--Enter two rows for every TIN-triangle in the SURFACE_GEOMETRY table: 
--(1st row) corresponds to the parent/container (geometry is NULL)
--(2nd row) corresponds to the child (incl. TIN-triangle geometry)
root_geom AS (
	INSERT INTO citydb.SURFACE_GEOMETRY(
		ID, GMLID, PARENT_ID, ROOT_ID,
		IS_COMPOSITE, IS_SOLID, 
		IS_TRIANGULATED, IS_REVERSE, IS_XLINK,
		GEOMETRY, CITYOBJECT_ID
	)
	--1st row:
	SELECT 
		prep_TINs.parent_sg_id, --ID
		'TIN_ROOT_' || gen_random_uuid(), --Generate unique GMLID for parent
		NULL, --PARENT_ID
		prep_TINs.parent_sg_id, --ROOT_ID same as ID
		0, 0, 1, 0, 0, -- IS_TRIANGULATED = 1, other flags = 0
		NULL, --Geometry
		prep_TINs.new_co_id --CITYOBJECT_ID (FK to CITYOBJECT)
	FROM prep_TINs

	UNION ALL

	--2nd row:
	SELECT
		prep_TINs.child_sg_id, -- ID
		'TIN_TRI_' || gen_random_uuid(), --Generate unique GMLID for child
		prep_TINs.parent_sg_id, --PARENT_ID
		prep_TINs.parent_sg_id, --ROOT_ID
		0, 0, 0, 0, 0, --All flags = 0
		prep_TINs.tri_geom, --Geometry
		prep_TINs.new_co_id --Same CITYOBJECT_ID value as for 1st row
	FROM prep_TINs
	RETURNING ID
),

--Create an entry for every TIN-triangle in ReliefComponent 
--The ID is a FK to the CITYOBJECT.ID of the corresponding TIN-triangle. 
relief_comp AS (
	INSERT INTO citydb.relief_component (ID, OBJECTCLASS_ID, LOD)
	SELECT new_co_id, 16, 2 FROM prep_TINs
	RETURNING ID
),

--Link the ReliefComponents to the ReliefFeature in the
--RELIEF_FEAT_TO_REL_COMP table
feat_to_comp AS (
	INSERT INTO citydb.RELIEF_FEAT_TO_REL_COMP (RELIEF_FEATURE_ID, RELIEF_COMPONENT_ID)
	SELECT rf.ID, rc.ID 
	FROM relief_feat rf CROSS JOIN relief_comp rc
	RETURNING RELIEF_FEATURE_ID
)

--Connect the TINRelief table to the geometry root
INSERT INTO citydb.TIN_RELIEF (ID, OBJECTCLASS_ID, SURFACE_GEOMETRY_ID)
SELECT 
	sg.cityobject_id, 
	16, 
	sg.id
	
FROM SURFACE_GEOMETRY sg

WHERE sg.parent_id IS NULL 
AND sg.is_triangulated = 1 
AND sg.geometry IS NULL

ORDER BY CITYOBJECT_ID ASC;








--SELECT *
--FROM citydb.SURFACE_GEOMETRY
--ORDER BY creation_date DESC
--LIMIT 1



