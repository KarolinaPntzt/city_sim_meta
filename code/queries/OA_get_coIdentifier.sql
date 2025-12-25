--Link OA simulation output to 3D city model geometry (windows):
WITH temp_update_OA_table(geom_id) AS(

SELECT t1.geom_id, t1.value, t1.geom, t2.gmlid,
	ST_3DDistance(t1.geom, t2.geometry) AS distance
	FROM sim_meta.geom_oa AS t1

	CROSS JOIN LATERAL (
		SELECT citydb.cityobject.gmlid, citydb.surface_geometry.geometry
		FROM citydb.cityobject INNER JOIN citydb.surface_geometry
		ON citydb.cityobject.id = citydb.surface_geometry.cityobject_id
		WHERE citydb.cityobject.objectclass_id = 38 AND
		citydb.surface_geometry.geometry IS NOT NULL
		AND ST_3DDwithin(geometry, t1.geom, 1)
		ORDER BY t1.geom <-> geometry
		LIMIT 1
	) AS t2
)

UPDATE sim_meta.geom_oa
SET cityObjectIdentifier = temp_update_OA_table.gmlid
FROM temp_update_OA_table
WHERE sim_meta.geom_oa.geom_id = temp_update_OA_table.geom_id