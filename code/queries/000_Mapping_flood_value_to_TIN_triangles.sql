/*

	Link FLOOD simulation output to TIN triangles

*/


-- STEP 1 --
-- Create temp table storing all TIN triangles to be
--linked with a flood simulation value and force them
--to 2D

WITH target_triangles AS (
	SELECT 
		sg.ID as sg_id,
		ST_Centroid(ST_Force2D(sg.GEOMETRY)) AS centroid_2D,
		ST_Z(ST_Centroid(sg.GEOMETRY)) AS original_z
	FROM citydb.SURFACE_GEOMETRY sg
	WHERE sg.GMLID LIKE 'TIN_TRI_%' AND 
	sg.PARENT_ID IS NOT NULL AND sg.GEOMETRY IS NOT NULL
),


-- STEP 2 --
-- Find the closest 2D flood point to every TIN triangle 
-- and assign the Surface Data ID based on the intervals

triangle_flood_mapping AS (
	SELECT
		t.sg_id,
		CASE 
			WHEN f.flood_val IS NULL THEN 90
			WHEN f.flood_val <= 0.1 THEN 91
			WHEN f.flood_val >0.1 AND f.flood_val <= 0.3 THEN 92
			WHEN f.flood_val >0.3 AND f.flood_val <= 0.6 THEN 93
			WHEN f.flood_val >0.6 AND f.flood_val <= 1.2 THEN 94
			WHEN f.flood_val >1.2 THEN 95
		END AS target_surface_data_id
	FROM target_triangles t

	CROSS JOIN LATERAL (
		SELECT gf.value AS flood_val
		FROM sim_meta.geom_flood gf
		ORDER BY gf.geom <-> t.centroid_2D
		LIMIT 1
	) f
)


-- STEP 3 --
-- Update TEXTUREPARAM with values
INSERT INTO citydb.TEXTUREPARAM (
	surface_geometry_id,
	surface_data_id,
	is_texture_parametrization
)
SELECT
	sg_id,
	target_surface_data_id,
	0 -- Boolean logic - no texture coordinates included

FROM triangle_flood_mapping
WHERE target_surface_data_id IS NOT NULL;