-- Writing Queries.

SELECT *
FROM food_payments
LIMIT 100

SHOW search_path;

ALTER ROLE saquibhazari SET search_path TO food_star;

ALTER SCHEMA food_star RENAME TO bronze_layer;