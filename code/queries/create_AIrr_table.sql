-- STEP 1 --
--Create AIrr table:
/*
CREATE TABLE sim_meta.Geom_AIrr
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
--Import csv-file with AIrr sim output to newly created table



-- STEP 3 --
-- Add simulation ID to table
/*
UPDATE sim_meta.Geom_AIrr
SET simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251023_v1';
*/


-- STEP 4 --
-- Compute point geometry from the imported x-, y-, and z-coordinates:
/*
UPDATE sim_meta.Geom_AIrr
SET geom = ST_SetSRID(ST_MakePoint(coord_x, coord_y, coord_z), 3008)
WHERE simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251024_v2'
*/

/*
SELECT *
FROM Geom_AIrr

*/