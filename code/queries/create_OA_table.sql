--Create OA table:

CREATE TABLE sim_meta.Geom_OA
(
	Geom_ID character varying(255),
	coord_x double precision,
	coord_y double precision,
	coord_z double precision,
	Value numeric,
	cityObjectIdentifier character varying(255),
	cityObjectGMLID character varying(255),
	simulationID character varying(255),
	geom geometry(PointZ, 3008)
);