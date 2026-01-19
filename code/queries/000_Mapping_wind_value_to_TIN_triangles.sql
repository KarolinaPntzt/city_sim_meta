/*

	Link WIND (LAWSON LDDC comfort critiria) simulation output to TIN triangles

*/

--UPDATE the TEXTUREPARAM table
UPDATE citydb.TEXTUREPARAM tp
SET surface_data_id = mapping.target_surface_data_id
FROM (

	--Find the closest wind point to every TIN triangle 
	-- and assign the Surface Data ID based on the intervals
	SELECT
		sg.id AS sg_id,
		CASE 
			WHEN f.wind_val IS NULL THEN 96
			WHEN f.wind_val >=0.0 AND f.wind_val < 2.5 THEN 97
			WHEN f.wind_val >=2.5 AND f.wind_val < 4.0 THEN 98
			WHEN f.wind_val >=4.0 AND f.wind_val < 6.0 THEN 99
			WHEN f.wind_val >=6.0 AND f.wind_val < 8.0 THEN 100
			WHEN f.wind_val >=8.0 AND f.wind_val < 15.0 THEN 101
			WHEN f.wind_val >=15.0 THEN 102
		END AS target_surface_data_id
	
	FROM citydb.SURFACE_GEOMETRY sg
	
	CROSS JOIN LATERAL (
		SELECT w.Value AS wind_val
		FROM sim_meta.Geom_Wind w
		ORDER BY w.geom <-> ST_Centroid(sg.geometry)
		LIMIT 1
	) f
	
	WHERE sg.GMLID LIKE 'TIN_TRI_%' AND
		sg.PARENT_ID IS NOT NULL AND
		sg.GEOMETRY IS NOT NULL
) AS mapping

WHERE tp.surface_geometry_id = mapping.sg_id;



