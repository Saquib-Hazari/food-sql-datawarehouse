-- Creating index for dim_customers
CREATE INDEX idx_dim_customer_customer_id ON gold.dim_customers(customer_id);
CREATE INDEX idx_dim_customer_campaign_id ON gold.dim_customers(campaign_id);
CREATE INDEX idx_dim_customer_feedback_id ON gold.dim_customers(feedback_id);

-- Creating index for fact_sales
CREATE INDEX idx_dim_sales_order_id ON gold.fact_sales(order_id);
CREATE INDEX idx_dim_sales_customer_id ON gold.fact_sales(customer_id);
CREATE INDEX idx_dim_sales_order_date ON gold.fact_sales(order_date);
CREATE INDEX idx_dim_sales_payment_date ON gold.fact_sales(payment_date);

-- Creating index for dim_products
CREATE INDEX idx_dim_product_food_id ON gold.dim_products(food_id);