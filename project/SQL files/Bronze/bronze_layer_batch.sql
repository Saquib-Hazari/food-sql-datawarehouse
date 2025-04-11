CREATE OR REPLACE PROCEDURE bronze.import_bronze_layer()
LANGUAGE plpgsql AS $$
DECLARE
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
    total_duration INTERVAL;
BEGIN
    -- Log batch start time
    batch_start_time := clock_timestamp();
    RAISE NOTICE '-- Start bronze layer time: %', batch_start_time;

    -- Truncate the tables before loading
    BEGIN
        RAISE NOTICE '-- Truncating the tables before loading...';
        TRUNCATE TABLE 
            bronze.crm_customers,
            bronze.crm_feedback,
            bronze.crm_marketing,
            bronze.erp_order_items,
            bronze.erp_orders,
            bronze.erp_payments,
            bronze.food_products;
        RAISE NOTICE '-- Truncate completed.';
    EXCEPTION
        WHEN OTHERS THEN
            RAISE WARNING '❌ Failed to truncate the tables: %', SQLERRM;
    END;

    -- Load the datasets from CSVs
    BEGIN
        RAISE NOTICE '-- Importing the CSVs...';

        COPY bronze.crm_customers
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/crm_customers.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded crm_customers table';

        COPY bronze.crm_feedback
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/crm_feedback.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded crm_feedback table';

        COPY bronze.crm_marketing
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/crm_marketing.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded crm_marketing table';

        COPY bronze.erp_order_items
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/erp_order_items.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded erp_order_items table';

        COPY bronze.erp_orders
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/erp_orders.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded erp_orders table';

        COPY bronze.erp_payments
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/erp_payments.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded erp_payments table';

        COPY bronze.food_products
        FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/food_DB/food_products.csv'
        WITH (FORMAT csv, HEADER true, DELIMITER ',');

        RAISE NOTICE '✅ Loaded food_products table';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE WARNING '❌ Cannot load the CSV files: %', SQLERRM;
    END;

    -- Log batch end time
    batch_end_time := clock_timestamp();
    total_duration := batch_end_time - batch_start_time;

    RAISE NOTICE '-- Bronze layer load complete at %', batch_end_time;
    RAISE NOTICE 'Total batch duration in seconds: %', EXTRACT(EPOCH FROM total_duration);
END;
$$;

CALL import_bronze_layer();