-- Creating the gold layer view

CREATE VIEW gold.dim_customers AS 
SELECT 
 customer_sk,
  customer_id,
  campaign_id,
  feedback_id,
  customer_name,
  city,
  state,
  country,
  signup_date,
  rating,
  comments,
  submitted_at,
  channel,
  engaged,
  sent_date
FROM gold.dim_customers



CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
  fs.sales_sk,
  fs.order_item_id,
  fs.order_id,
  p.product_sk,
  p.customer_sk,
  fs.payment_id,
  fs.item_name,
  fs.order_date,
  fs.quantity,
  fs.price,
  fs.total_sales,
  fs.payment_date,
  fs.payment_amount,
  fs.payment_method
FROM gold.fact_sales fs
JOIN gold.dim_products p ON p.food_id = fs.food_id
JOIN gold.dim_customers c ON c.customer_id = fs.customer_id


CREATE OR REPLACE VIEW gold.dim_product AS
SELECT 
  product_sk,
  food_id,
  product_name,
  category,
  price
FROM gold.dim_products