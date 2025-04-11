-- Complex analysis
-- Track loyalty, inform re-engagement campaigns, and improve churn models.
CREATE OR REPLACE VIEW gold.customer_repeat_behavior AS
WITH customer_orders AS (
  SELECT 
    customer_id,
    order_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
  FROM gold.fact_sales
),
order_diffs AS (
  SELECT 
    customer_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
  FROM customer_orders
),
repeat_customers AS (
  SELECT 
    customer_id,
    COUNT(*) AS total_orders,
    MAX(order_date) - MIN(order_date) AS days_between_orders,
    ROUND(AVG(order_date - prev_order_date),2) AS avg_days_between
  FROM order_diffs
  WHERE prev_order_date IS NOT NULL
  GROUP BY customer_id
  HAVING COUNT(*) > 1
)
SELECT * FROM repeat_customers;

--Optimize marketing spend and focus on effective channels/campaigns.


CREATE OR REPLACE VIEW gold.campaign_conversion_performance AS
WITH campaign_customers AS (
  SELECT 
    campaign_id,
    customer_id
  FROM gold.dim_customers
  WHERE engaged = 'Yes'
),
campaign_sales AS (
  SELECT 
    cc.campaign_id,
    fs.customer_id,
    COUNT(DISTINCT fs.order_id) AS order_count,
    SUM(fs.total_sales) AS total_sales
  FROM campaign_customers cc
  JOIN gold.fact_sales fs ON fs.customer_id = cc.customer_id
  GROUP BY cc.campaign_id, fs.customer_id
)
SELECT 
  campaign_id,
  COUNT(DISTINCT customer_id) AS paying_customers,
  SUM(order_count) AS total_orders,
  SUM(total_sales) AS total_revenue,
  ROUND(AVG(total_sales), 2) AS avg_order_value
FROM campaign_sales
GROUP BY campaign_id;



CREATE OR REPLACE VIEW gold.category_monthly_sales_trend AS
WITH monthly_sales AS (
  SELECT 
    dp.category,
    DATE_TRUNC('month', fs.order_date) AS sales_month,
    SUM(fs.total_sales) AS monthly_revenue
  FROM gold.fact_sales fs
  JOIN gold.dim_products dp ON dp.food_id = fs.food_id
  GROUP BY category, sales_month
),
ranked_categories AS (
  SELECT 
    *,
    RANK() OVER (PARTITION BY sales_month ORDER BY monthly_revenue DESC) AS revenue_rank
  FROM monthly_sales
)
SELECT * 
FROM ranked_categories
WHERE revenue_rank <= 3;