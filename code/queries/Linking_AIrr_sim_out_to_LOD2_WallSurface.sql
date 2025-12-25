/*

This SQL-script is dedicated to linking AIrr simulation output 
(consisting of point-geometries of a regular point grid) to the
corresponding WallSurface geometry in the CityGML model they 
belong to.

Since every CITYOBJECT may consist of more than one geometries
(i.e., every CITYOBJECT ID corresponding to a single WallSurface
may consist of more than one geometries in the SURFACE_GEOMETRY
table), each of which have a unique ID. 

In order to be able to uniquely identify every WallSurface geometry
for obtaining its dimensions (height, width) and creater a raster
corresponding to its size, it is necessary to add its corresponding
SURFACE_GEOMETRY ID to the Geom_AIrr table. This is also needed from
a FAIR perspective.

*/

--Link AIrr simulation output to 3D city model geometry (WallSurface LOD2):
WITH temp_update_AIrr_table(geom_id) AS(

SELECT t1.geom_id, t1.value, t1.geom, t2.GMLID, t2.ID,
	ST_3DDistance(t1.geom, t2.GEOMETRY) AS distance
	FROM sim_meta.geom_AIrr AS t1
	--WHERE t1.simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251024_v2'

	CROSS JOIN LATERAL (
		SELECT CITYOBJECT.GMLID, SURFACE_GEOMETRY.ID, SURFACE_GEOMETRY.GEOMETRY
		FROM THEMATIC_SURFACE INNER JOIN SURFACE_GEOMETRY
		ON THEMATIC_SURFACE.LOD2_MULTI_SURFACE_ID = SURFACE_GEOMETRY.ROOT_ID
		INNER JOIN CITYOBJECT 
		ON SURFACE_GEOMETRY.CITYOBJECT_ID = CITYOBJECT.ID
		WHERE CITYOBJECT.OBJECTCLASS_ID = 34
		AND SURFACE_GEOMETRY.GEOMETRY IS NOT NULL
		AND ST_3DDwithin(geometry, t1.geom, 1)
		ORDER BY t1.geom <-> geometry
		LIMIT 1
	) AS t2
)

UPDATE sim_meta.Geom_AIrr
SET cityObjectIdentifier = temp_update_AIrr_table.gmlid,
surfaceGeometryID = temp_update_AIrr_table.ID
FROM temp_update_AIrr_table
WHERE sim_meta.Geom_AIrr.simulationID = 'AIrr_malmo_bellevue_DpXXXXX_20251024_v2'
AND sim_meta.Geom_AIrr.geom_id = temp_update_AIrr_table.geom_id


