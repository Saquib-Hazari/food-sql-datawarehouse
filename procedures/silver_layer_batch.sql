/*
===========================================================================
🧼 Script: Silver Layer Load – CRM and ERP Data Transformation
🏗️ Purpose : Cleanse and standardize raw Bronze Layer data and load it into the Silver Layer
📁 Target  : silver.crm_customers, silver.crm_feedback, silver.crm_marketing,
             silver.erp_order_items, silver.erp_orders, silver.erp_payments,
             silver.food_products

🔍 Overview:
    - Performs deduplication, type casting, null handling, and data enrichment.
    - Applies simple business logic (e.g., default values, formatting names/countries).
    - Uses `ROW_NUMBER()` for latest customer records by signup_date.
    - Converts date/time and numeric fields to consistent types.
    - Handles missing values for comments and engagement fields.

🧾 Breakdown by Table:
    • `crm_customers`: Combines names, standardizes country names, deduplicates.
    • `crm_feedback`: Defaults missing ratings and comments.
    • `crm_marketing`: Fills in missing engaged status.
    • `erp_order_items`, `erp_orders`, `erp_payments`: Ensures type consistency.
    • `food_products`: Converts price field to NUMERIC(10,2).

📦 Output:
    - The Silver Layer contains cleansed and ready-to-transform datasets
      suitable for further enrichment or loading into Gold/semantic layers.

⚠️ Assumptions:
    - Bronze Layer tables exist and have been preloaded correctly.
    - Data types in the Silver Layer are consistent with the transformations.
    - No duplicate primary keys in target tables.

✅ Recommended Execution: After Bronze Layer has been refreshed via ETL pipeline.

🧪 Example Use:
    -- Run after bronze.import_bronze_layer()
    -- Useful in dbt, Airflow DAGs, or scheduled ETL tasks

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
===========================================================================
*/
INSERT INTO silver.crm_customers(
  customer_id,
  customer_name,
  city,
  state,
  country,
  signup_date,
  dwh_created_date,
  dwh_updated_date
)
SELECT 
  customer_id::INTEGER,
  CONCAT(INITCAP(TRIM(first_name)), ' ', INITCAP(TRIM(last_name))) AS customer_name,
  INITCAP(TRIM(city)) AS city,
  state,
  CASE 
    WHEN LOWER(TRIM(country)) = 'usa' THEN 'United States'
    ELSE INITCAP(TRIM(country))
  END AS country,
  signup_date::DATE,
  dwh_created_date,
  dwh_updated_date
FROM (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY signup_date) AS flag_last
  FROM crm_customers
) t 
WHERE flag_last = 1;

INSERT INTO silver.crm_feedback(
  feedback_id,
  customer_id,
  rating,
  comments,
  submitted_at
)
SELECT feedback_id::INTEGER,
  customer_id::INTEGER,
  COALESCE(rating::INTEGER, 0) AS rating,
  CASE 
    WHEN TRIM(comments) IS NULL OR TRIM(comments) = '' THEN 'n/a'  
    ELSE  comments
  END AS comments,
  submitted_at::DATE
FROM crm_feedback


INSERT INTO silver.crm_marketing(
  campaign_id,
  customer_id,
  channel,
  engaged,
  sent_date
)
SELECT
  campaign_id::INTEGER,
  customer_id::INTEGER,
  channel,
  CASE 
    WHEN engaged IS NULL OR TRIM(engaged) = '' THEN 'n/a' 
    ELSE  engaged 
  END AS engaged,
  sent_date::DATE
FROM crm_marketing

INSERT INTO silver.erp_order_items(
  order_item_id,
  order_id,
  food_id,
  quantity,
  item_name
)
SELECT order_item_id::INTEGER,
  order_id::INTEGER,
  food_id::INTEGER,
  quantity::INTEGER,
  item_name
FROM erp_order_items

INSERT INTO silver.erp_orders(
  order_id,
  customer_id,
  order_date,
  status,
  order_type,
  delivery_address,
  delivery_item
)
SELECT order_id::INTEGER,
customer_id::INTEGER,
order_date::DATE,
status,
order_type,
delivery_address,
delivery_item::DATE
FROM erp_orders

INSERT INTO silver.erp_payments(
  payment_id,
  order_id,
  payment_date,
  amount,
  payment_method
)

SELECT payment_id::INTEGER,
  order_id::INTEGER,
  payment_date::DATE,
  amount::NUMERIC,
  payment_method
FROM erp_payments

INSERT INTO silver.food_products(
  food_id,
  name,
  category,
  price
)
SELECT food_id::INTEGER,
name,
category,
price::NUMERIC(10,2)
FROM food_products
