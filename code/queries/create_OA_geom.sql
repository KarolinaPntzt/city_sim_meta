
--Calculate geometry from imported x-y-z- coords:
--UPDATE sim_meta.geom_oa
--SET geom = ST_SetSRID(ST_MakePoint(coord_x, coord_y, coord_z), 3008)


--Write simulation ID:
--UPDATE sim_meta.geom_oa
--SET simulationID = 'OA_malmo_bellevue_DpXXXXX_20230401_v1';

SELECT *
FROM sim_meta.Geom_OA