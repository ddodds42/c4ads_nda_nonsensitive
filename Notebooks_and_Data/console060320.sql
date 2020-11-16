-- --MANUAL ENTITY RESOLUTION: FINDING HIDDEN ROWS
SELECT * FROM ofac
-- where index IN (16464, 41888, 48973);
-- WHERE index IN (16464, 48973);
WHERE LOWER(last_name) LIKE '%ibrahim%'
AND index NOT IN (16464, 41888, 48973);
-- AND (LOWER(last_name) LIKE '%abbas_adil%'
--     OR LOWER(first_name) LIKE '%abbas_adil%'
--     OR LOWER(entity_name) LIKE '%abbas_adil%'
--     OR LOWER(aka) LIKE '%abbas_adil%'
--     OR LOWER(fka) LIKE '%abbas_adil%'
--     OR LOWER(nka) LIKE '%abbas_adil%'
--     );

-- where dob = to_timestamp('1968-07-30 00:00:00.000000', 'YYYY-MM-DD HH24:MI:SS.FF')

-- --FINDS COLUMNS THAT CONTAIN NATIONALITY INFORMATION FOR EACH ENTITY TYPE.
-- SELECT entity_type, nationality, passport, national_identification_number, tax_identification_number, citizen,
--        former_citizenship_country, nationality_of_registration, identification_number_country,
--        "identification_number_country.1", voter_identification_number_country, aircraft_operator
-- FROM ofac
-- WHERE entity_type = 'aircraft' AND
--       nationality IS NOT NULL;
--        passport IS NOT NULL;
--        national_identification_number IS NOT NULL;
--        tax_identification_number IS NOT NULL;
--        citizen IS NOT NULL;
--        former_citizenship_country IS NOT NULL;
--        nationality_of_registration IS NOT NULL;
--        identification_number_country IS NOT NULL;
--         aircraft_operator IS NOT NULL;
--        "identification_number_country.1" IS NOT NULL;
--        voter_identification_number_country IS NOT NULL;

-- --SORTS ENTITY BY NATIONHOOD FOR RANDOM SELECTION
-- SELECT INDEX, address FROM ofac
-- where entity_type='individual'
--   AND address NOT LIKE '%Iran%'
--   AND address NOT LIKE '%Mexico%'
--   AND address NOT LIKE '%Iraq%'
--   AND address NOT LIKE '%Korea, N%'
--   AND address NOT LIKE '%Syria%';

-- --COUNTS THE NATIONHOOD FREQUENCIES OF AN ENTITY TYPE.
-- SELECT aircraft_operator, count(ofac.aircraft_operator)
-- AS number_of_aircraft FROM ofac
-- WHERE entity_type = 'aircraft'
-- GROUP BY ofac.aircraft_operator
-- ORDER BY number_of_aircraft DESC;

-- -- COUNTS THE DISTRIBUTION OF ENTITIES
-- SELECT entity_type, count(ofac.entity_type) as number_of_entities FROM ofac
-- GROUP BY ofac.entity_type;

-- --SHOWS THE DATA TYPE OF EACH COLUMN
-- SELECT column_name, data_type, ordinal_position
-- FROM information_schema.columns
-- WHERE table_name = 'ofac'
-- ORDER BY 3;