--Creating the views from gold layer.
--Which customers are most engaged and provide feedback?
SELECT 
  c.customer_id,
  c.customer_name,
  c.city,
  c.state,
  c.engaged,
  COUNT(fs.order_id) AS total_order,
  ROUND(AVG(fs.total_sales),2) AS avg_sales,
  c.rating,
  c.comments
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales fs ON fs.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.state, c.engaged, c.rating, c.comments, c.city
LIMIT 1000

-- What are total sales per month and by category?
SELECT 
  EXTRACT('month' FROM fs.order_date) AS months,
  p.category,
  SUM(fs.total_sales) AS total_sales,
  COUNT(fs.order_id) AS total_order_id
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products p ON p.food_id = fs.food_id
GROUP BY p.category, months
ORDER BY  months

-- Which products generate the most revenue?
SELECT
  p.product_name,
  p.category,
  SUM(fs.total_sales) AS revenue,
  SUM(fs.quantity) AS total_quantity
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products p ON p.food_id = fs.food_id
GROUP BY p.product_name, p.category


-- How effective are marketing campaigns in driving engagement and sales?

SELECT
  c.campaign_id,
  c.customer_name,
  c.channel,
  c.engaged,
  SUM(fs.total_sales) AS total_sales,
  COUNT(c.customer_id) AS engaged_customer
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales fs ON fs.customer_id = c.customer_id
GROUP BY c.campaign_id, c.channel, c.engaged, c.customer_name
LIMIT 100

-- What is the distribution of payment methods and success rate?

SELECT
  fs.payment_method,
  COUNT(fs.payment_id) AS payments,
  SUM(fs.payment_amount) AS total_amount
FROM gold.fact_sales fs
GROUP BY payment_method
ORDER BY total_amount DESC