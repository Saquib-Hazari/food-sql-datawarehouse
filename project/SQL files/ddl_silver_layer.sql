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