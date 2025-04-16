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
  ROW_NUMBER() OVER() AS customer_sk,
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



INSERT INTO gold.fact_sales(
  sales_sk,
  order_item_id,
  order_id,
  food_id,
  customer_id,
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
  ROW_NUMBER() OVER() AS sales_sk,
  i.order_item_id,
  i.food_id,
  o.order_id,
  o.customer_id,
  p.payment_id,
  i.item_name,
  o.order_date,
  i.quantity,
  fp.price,
  fp.price * i.quantity AS total_sales,
  p.payment_date,
  p.amount AS payment_amount,
  p.payment_method
FROM silver.erp_order_items i 
JOIN silver.erp_orders o ON o.order_id = i.order_id
JOIN silver.food_products fp ON fp.food_id = i.food_id
LEFT JOIN silver.erp_payments p ON p.order_id = o.order_id



INSERT INTO gold.dim_products(
  product_sk,
  food_id,
  product_name,
  category,
  price
)

SELECT 
  ROW_NUMBER() OVER() AS product_sk,
  food_id,
  name AS product_name,
  category,
  price
FROM silver.food_products

