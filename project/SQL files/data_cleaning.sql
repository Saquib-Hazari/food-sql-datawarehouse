-- SELECT table_schema, table_name
-- FROM information_schema.tables
-- WHERE table_schema = 'silver'
--   AND table_type = 'BASE TABLE'
-- ORDER BY table_name


-- SELECT column_name, data_type, is_nullable, character_maximum_length
-- FROM information_schema.columns
-- WHERE table_schema = 'silver'
--   AND table_name = 'crm_customers';