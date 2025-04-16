/*
===============================================================================
🏆 Script: Gold Layer – Star Schema Population (Dimension & Fact Tables)
📊 Purpose : Transforms and loads cleaned Silver Layer data into analytical 
             Gold Layer tables using a dimensional model (star schema).

🧱 Tables Populated:
    1. gold.dim_customers – Enriched customer dimension combining CRM + feedback + marketing
    2. gold.fact_sales     – Central fact table capturing sales and payment events
    3. gold.dim_products   – Product dimension derived from food catalog

🔍 Key Transformations:
    - Surrogate keys (`*_sk`) generated via ROW_NUMBER for dimensional modeling
    - Denormalization of CRM and ERP sources for optimized dashboard querying
    - Left joins used to preserve referential integrity where applicable

⚠️ Assumes Silver Layer tables are already cleaned and deduplicated.

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
===============================================================================
*/
-- Creating the gold layer ddl 
INSERT INTO gold.dim_customers(
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
)
SELECT 
  ROW_NUMBER() OVER(ORDER BY c.customer_id) AS customer_sk,
  c.customer_id,
  m.campaign_id,
  f.feedback_id,
  c.customer_name,
  c.city,
  c.state,
  c.country,
  c.signup_date,
  f.rating,
  f.comments,
  f.submitted_at,
  m.channel,
  m.engaged,
  m.sent_date
FROM silver.crm_customers c 
LEFT JOIN silver.crm_feedback f ON f.customer_id = c.customer_id
LEFT JOIN silver.crm_marketing m ON m.customer_id = f.customer_id



-- Assuming sales_sk is SERIAL PRIMARY KEY
INSERT INTO gold.fact_sales (
  order_item_id,
  order_id,
  product_sk,
  customer_sk,
  payment_id,
  item_name,
  order_date,
  quantity,
  price,
  total_sales,
  payment_date,
  payment_amount,
  payment_method
)
SELECT 
  i.order_item_id,
  o.order_id,
  pr.product_sk,
  c.customer_sk,
  p.payment_id,
  i.item_name,
  o.order_date,
  i.quantity,
  pr.price,
  pr.price * i.quantity AS total_sales,
  p.payment_date,
  p.amount AS payment_amount,
  p.payment_method
FROM silver.erp_order_items i 
JOIN silver.erp_orders o ON o.order_id = i.order_id
JOIN silver.erp_payments p ON p.order_id = o.order_id
JOIN gold.dim_customers c ON c.customer_id = o.customer_id
JOIN gold.dim_products pr ON pr.food_id = i.food_id
LIMIT 10000


INSERT INTO gold.dim_products(
  product_sk,
  food_id,
  product_name,
  category,
  price
)

SELECT 
  ROW_NUMBER() OVER(ORDER BY food_id) AS product_sk,
  food_id,
  name AS product_name,
  category,
  price
FROM silver.food_products


SELECT *
FROM gold.fact_sales
LIMIT 100