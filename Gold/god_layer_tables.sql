-- ===============================================================
-- Creating the Gold Layer Schema and Dimensional Tables
-- ===============================================================

-- Schema: gold
-- Purpose: This schema represents the curated, analytical layer of the data warehouse.
-- It contains clean, joined, and conformed dimensional and fact tables 
-- designed for reporting, dashboarding, and advanced analytics.

-- Tables:
-- 1. dim_customers: Customer dimension including feedback and campaign details.
-- 2. fact_sales: Central fact table capturing transactional sales metrics.
-- 3. dim_products: Product dimension containing descriptive attributes of food items.

-- Notes:
-- - Surrogate keys are generated using SERIAL for primary keys.
-- - All monetary values use NUMERIC for precision control.
-- - Dates are stored using DATE type for temporal analysis.
-- ===============================================================
CREATE SCHEMA IF NOT EXISTS gold;
DROP SCHEMA IF EXISTS gold CASCADE;

DROP TABLE IF EXISTS gold.dim_customers CASCADE;

CREATE TABLE gold.dim_customers (
  customer_sk  INTEGER,
  customer_id INTEGER,
  campaign_id INTEGER,
  feedback_id INTEGER,
  customer_name TEXT,
  city TEXT,
  state TEXT,
  country TEXT,
  signup_date DATE,
  rating NUMERIC,  -- adjust scale/precision as needed
  comments TEXT,
  submitted_at DATE,
  channel TEXT,
  engaged TEXT,
  sent_date DATE
);

DROP TABLE IF EXISTS gold.fact_sales CASCADE;

CREATE TABLE gold.fact_sales (
  sales_sk  INTEGER,             -- surrogate key
  order_item_id INTEGER,
  order_id INTEGER,
  product_sk INTEGER,
  customer_sk INTEGER,
  payment_id INTEGER,
  item_name TEXT,
  order_date DATE,
  quantity INTEGER,
  price NUMERIC(10,2),
  total_sales NUMERIC(12,2),
  payment_date DATE,
  payment_amount NUMERIC(12,2),
  payment_method TEXT
);

DROP TABLE IF EXISTS gold.dim_products CASCADE;

CREATE TABLE gold.dim_products (
  product_sk  INTEGER,        -- surrogate key
  food_id INTEGER,
  product_name TEXT,
  category TEXT,
  price NUMERIC(10,2)
);
