-- STEP 1 --
--Create DSH table:
/*
CREATE TABLE sim_meta.Geom_DSH
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
--Import csv-file with DSH sim output to newly created table



-- STEP 3 --
-- Add simulation ID to table
/*
UPDATE sim_meta.Geom_DSH
SET simulationID = 'DSH_malmo_bellevue_DpXXXXX_20230401_v1';
*/



-- STEP 4 --
-- Compute point geometry from the imported x-, y-, and z-coordinates:
/*
UPDATE sim_meta.Geom_DSH
SET geom = ST_SetSRID(ST_MakePoint(coord_x, coord_y, coord_z), 3008)
WHERE simulationID = 'DSH_malmo_bellevue_DpXXXXX_20230401_v1'
*/



/*
SELECT *
FROM sim_meta.Geom_DSH;

*/