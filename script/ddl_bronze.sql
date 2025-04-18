/*
===========================================================================
📦 Script: Bronze Layer – Raw Table Creation
🏗️ Purpose : Creates the foundational Bronze Layer tables to store raw, unprocessed
             CRM and ERP data ingested from CSV files.

📁 Tables Created:
    - CRM: crm_customers, crm_feedback, crm_marketing
    - ERP: erp_orders, erp_order_items, erp_payments
    - Product: food_products

🔧 Key Details:
    - All fields are typed as TEXT or INTEGER to mirror the raw data formats.
    - Designed to support initial ingestion prior to data cleaning/transformation.
    - Uses `DROP TABLE IF EXISTS` to ensure clean recreation.
    - Explicit ownership is assigned to user `saquibhazari`.

✅ Run this script once during setup or when a full schema reset is needed.

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
===========================================================================
*/
-- Creating the food star tables.
CREATE SCHEMA IF NOT EXISTS bronze;
DROP TABLE IF EXISTS crm_customers;
CREATE TABLE crm_customers(
  -- customer_id,first_name,last_name,email,phone,city,state,country,signup_date
  customer_id INTEGER,
  first_name TEXT,
  last_name TEXT,
  email TEXT,
  phone TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  signup_date TEXT
);

DROP TABLE IF EXISTS crm_feedback;
CREATE TABLE crm_feedback(
  -- feedback_id,customer_id,rating,comments,submitted_at
  feedback_id INTEGER,
  customer_id INTEGER,
  rating TEXT,
  comments TEXT,
  submitted_at TEXT
);

DROP TABLE IF EXISTS crm_marketing;
CREATE TABLE crm_marketing(
  -- campaign_id,customer_id,channel,engaged,sent_date
  campaign_id INTEGER,
  customer_id INTEGER,
  channel TEXT,
  engaged TEXT,
  sent_date TEXT
);

DROP TABLE IF EXISTS erp_order_items;
CREATE TABLE erp_order_items(
-- order_item_id,order_id,food_id,quantity,item_name
  order_item_id INTEGER,
  order_id INTEGER,
  food_id INTEGER,
  quantity TEXT,
  item_name TEXT
);

DROP TABLE IF EXISTS erp_orders;
CREATE TABLE erp_orders(
  -- order_id,customer_id,order_date,status,order_type,delivery_address,delivery_time
  order_id INTEGER,
  customer_id INTEGER,
  order_date TEXT,
  status TEXT,
  order_type TEXT,
  delivery_address TEXT,
  delivery_item TEXT
);

DROP TABLE IF EXISTS erp_payments;
CREATE TABLE erp_payments(
  -- payment_id,order_id,payment_date,amount,payment_method
  payment_id INTEGER,
  order_id INTEGER,
  payment_date TEXT,
  amount TEXT,
  payment_method TEXT
);

DROP TABLE IF EXISTS food_products;
CREATE TABLE food_products(
  -- food_id,name,category,price
  food_id INTEGER,
  name TEXT,
  category TEXT,
  price TEXT
);



