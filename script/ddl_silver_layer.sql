/*
===============================================================================
📁 Script: Silver Layer – Cleaned Data Tables Creation
🎯 Purpose : Defines the structure for cleaned and transformed data ingested 
             from Bronze Layer sources, ready for analytical modeling in Gold Layer.

🗂️ Schema: silver

📋 Tables Created:
    - crm_customers     : Cleansed customer profiles with standardized fields
    - crm_feedback      : Structured customer feedback with quality checks
    - crm_marketing     : Marketing interaction history by campaign & channel
    - erp_order_items   : Item-level transaction details from ERP
    - erp_orders        : Order metadata and fulfillment status
    - erp_payments      : Payment facts including method and amount
    - food_products     : Master product catalog with pricing info

🧼 Key Features:
    - Typed fields (DATE, INTEGER, NUMERIC) for downstream querying
    - `dwh_created_date` and `dwh_updated_date` timestamps for lineage tracking
    - `DROP TABLE IF EXISTS` for idempotency during iterative development

⚠️ Assumes Bronze Layer tables are loaded and transformed into valid formats.

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
===============================================================================
*/
CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.crm_customers;
CREATE TABLE silver.crm_customers(
  customer_id INTEGER,
  customer_name TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  signup_date DATE,
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.crm_feedback;
CREATE TABLE silver.crm_feedback(
  feedback_id INTEGER,
  customer_id INTEGER,
  rating INTEGER,
  comments VARCHAR(50),
  submitted_at DATE,
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.crm_marketing;

CREATE TABLE silver.crm_marketing(
  campaign_id INTEGER,
  customer_id INTEGER,
  channel TEXT,
  engaged TEXT,
  sent_date DATE,
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.erp_order_items;

CREATE TABLE silver.erp_order_items(
  order_item_id INTEGER,
  order_id INTEGER,
  food_id INTEGER,
  quantity INTEGER,
  item_name TEXT,
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.erp_orders;

CREATE TABLE silver.erp_orders(
  order_id INTEGER,
  customer_id INTEGER,
  order_date DATE,
  status VARCHAR(50),
  order_type VARCHAR(50),
  delivery_address TEXT,
  delivery_item DATE,
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.erp_payments;
CREATE TABLE silver.erp_payments(
  payment_id INTEGER,
  order_id INTEGER,
  payment_date DATE,
  amount NUMERIC,
  payment_method VARCHAR(50),
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)

DROP TABLE IF EXISTS silver.food_products;

CREATE TABLE silver.food_products(
  food_id INTEGER,
  name TEXT,
  category TEXT,
  price NUMERIC(10,2),
  dwh_created_date TIMESTAMP DEFAULT NOW(),
  dwh_updated_date TIMESTAMP DEFAULT NOW()
)