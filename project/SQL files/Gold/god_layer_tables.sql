CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.dim_customers;

CREATE TABLE gold.dim_customers (
  customer_sk SERIAL PRIMARY KEY NOT NULL,
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

DROP TABLE IF EXISTS gold.fact_sales;

CREATE TABLE gold.fact_sales (
  sales_sk SERIAL PRIMARY KEY,             -- surrogate key
  order_item_id INTEGER,
  order_id INTEGER,
  food_id INTEGER,
  customer_id INTEGER,
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

DROP TABLE IF EXISTS gold.dim_products;

CREATE TABLE gold.dim_products (
  product_sk SERIAL PRIMARY KEY,        -- surrogate key
  food_id INTEGER,
  product_name TEXT,
  category TEXT,
  price NUMERIC(10,2)
);