-- Writing Queries.

SELECT *
FROM food_payments
LIMIT 100

SHOW search_path;

ALTER ROLE saquibhazari SET search_path TO bronze;

ALTER SCHEMA bronze_layer RENAME TO bronze;

SELECT *
FROM food_products
LIMIT 100