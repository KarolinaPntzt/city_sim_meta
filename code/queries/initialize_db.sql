--Preparing DB
/*
--Create extensions:
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_sfcgal;
CREATE EXTENSION postgis_raster;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
*/

--Check search path:
--SHOW search_path;


--Update path info:
--ALTER DATABASE tcim_malmo_xl SET search_path TO citydb, sim_meta, citydb_pkg, public;
--ALTER DATABASE tcim_malmo_xl 
--SET search_path TO citydb, sim_meta, citydb_pkg, public, postgis, "$user";v


--Create new schema to store simulation output







--Delete all rows from the DB:
--SELECT cleanup_schema();