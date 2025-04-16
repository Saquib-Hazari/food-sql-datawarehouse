/*
=======================================================================
🛠️ Procedure: bronze.import_bronze_layer()
📦 Purpose : Loads raw CSV files into the Bronze Layer of the data warehouse.
📁 Scope   : CRM and ERP datasets including customers, feedback, orders, and products.

🔄 Functionality:
    - Logs start and end timestamps for the load process.
    - Truncates existing Bronze tables to ensure clean reloads.
    - Imports data from structured CSV files into their corresponding Bronze tables.
    - Captures load durations and prints meaningful status messages for each step.
    - Handles and logs any errors that occur during truncation or loading.

⚠️ Assumptions:
    - The CSV file paths are correct and accessible to the PostgreSQL server.
    - The Bronze schema and all referenced tables already exist.
    - CSV files are well-formed with headers.

✅ Use this procedure during ETL batch runs to refresh the Bronze Layer.

🧪 Example:
    CALL bronze.import_bronze_layer();

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
=======================================================================
*/
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