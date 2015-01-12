------ This file is sql code to import DABASE (Modul SIA405Abwasser) in German to QGEP in Englisch on QQIS
------ For questions etc. please contact Stefan Burckhardt stefan.burckhardt@sjib.ch
------ version 07.06.2014 22:00:52

-- 1. ergaenzen tabelle mit oid spalte
ALTER TABLE qgep.od_wastewater_structure DROP COLUMN IF EXISTS old_obj_id;
ALTER TABLE qgep.od_wastewater_structure ADD COLUMN old_obj_id text;

-------
-- 2. loeschen vorhandener daten
DELETE FROM qgep.od_wastewater_structure;

-- 3. einsetzen der daten von siedlungsentwaesserung in qgep.
INSERT INTO qgep.od_wastewater_structure
(obj_id, accessibility, contract_section, detail_geometry_geometry, 
-- detail_geometry_3d_geometry, 
-- financing,
gross_costs, identifier, inspection_interval, location_name, 
-- records, 
remark, renovation_necessity, 
-- replacement_value, 
-- rv_base_year, 
-- rv_construction_type, 
status, structure_condition, subsidies, year_of_construction, year_of_replacement, last_modification, dataowner, fk_owner) 
SELECT a_abwasserbauwerk.obj_id,
CASE WHEN zugaenglichkeit = 0 THEN 3444 --- covered
WHEN zugaenglichkeit = 1 THEN 3447 --- unknown
WHEN zugaenglichkeit = 2 THEN 3446 --- inaccessible
WHEN zugaenglichkeit = 3 THEN 3445 --- accessible
END,
baulos,
the_geom,
-- the_geom3D, 
-- CASE WHEN finanzierung = 0 THEN 5510 --- public
-- WHEN finanzierung = 1 THEN 5511 --- private
-- WHEN finanzierung = 2 THEN 5512 --- unknown
-- END,
bruttokosten, 
bezeichnung, 
inspektionsintervall, 
standortname, 
-- akten, 
bemerkung,
CASE WHEN sanierungsbedarf = 0 THEN 5370 --- urgent
WHEN sanierungsbedarf = 1 THEN 5368 --- none
WHEN sanierungsbedarf = 2 THEN 2 --- short_term
WHEN sanierungsbedarf = 3 THEN 4 --- long_term
WHEN sanierungsbedarf = 4 THEN 3 --- medium_term
WHEN sanierungsbedarf = 5 THEN 5369 --- unknown
END,
-- CASE WHEN wiederbeschaffungswert = 0 THEN 4602 --- other
-- WHEN wiederbeschaffungswert = 1 THEN 4603 --- field
-- WHEN wiederbeschaffungswert = 2 THEN 4606 --- renovation_conduction_excavator
-- WHEN wiederbeschaffungswert = 3 THEN 4605 --- renovation_conduction_ditch_cutter
-- WHEN wiederbeschaffungswert = 4 THEN 4604 --- road
-- WHEN wiederbeschaffungswert = 5 THEN 4601 --- unknown
-- END,
-- wbw_basisjahr, 
-- wbw_bauart, 
CASE WHEN status = 0 THEN 7 --- suspeded not filled
WHEN status = 1 THEN 3325 --- suspended unkonwn
WHEN status = 2 THEN 3633 --- inoperative
WHEN status = 3 THEN 2763 --- calculation alternative
WHEN status = 4 THEN 2764 --- planned
WHEN status = 5 THEN 3634 --- operational
WHEN status = 6 THEN 3653 --- project
WHEN status = 7 THEN 10 --- tentative
WHEN status = 8 THEN 3027 --- unknown
WHEN status = 9 THEN 8 --- filled
WHEN status = 10 THEN 2683 --- will be suspended
END,
CASE WHEN baulicherzustand = 0 THEN 3037 --- unknown
WHEN baulicherzustand  = 1 THEN 3363 --- Z0
WHEN baulicherzustand  = 2 THEN 3359 --- Z1
WHEN baulicherzustand  = 3 THEN 3360 --- Z2
WHEN baulicherzustand  = 4 THEN 3361 --- Z3
WHEN baulicherzustand  = 5 THEN 3362 --- Z4
END,
subventionen,
baujahr,
ersatzjahr,
to_timestamp (LETZTE_AENDERUNG, 'DD MMM YYYY'),
MD_DATENHERR,
q_organisation.obj_id
FROM abwasser.siedlungsentwaesserung__Abwasserbauwerk a_abwasserbauwerk
LEFT JOIN
qgep.od_organisation q_organisation ON (q_organisation.old_obj_id = a_abwasserbauwerk.obj_id)
;


-- 4. update der oid spalten
UPDATE qgep.od_wastewater_structure SET old_obj_id=obj_id;


