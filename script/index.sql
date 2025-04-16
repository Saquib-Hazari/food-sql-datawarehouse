/*
===============================================================================
📁 Script: Gold Layer Indexing & Ownership Assignment
🎯 Purpose:
    - Enhance query performance through strategic indexing on key analytical 
      and join attributes in dimension and fact tables.
    - Set proper ownership for governance and access control.

🗂️ Target Schema: gold

🔍 Indexes Created:
    📌 dim_customers:
        - customer_id         → Speeds up joins with fact tables
        - campaign_id         → Enables efficient filtering by campaign
        - feedback_id         → Optimizes feedback-related queries

    📌 fact_sales:
        - order_id            → Accelerates joins with orders
        - customer_id         → Supports customer-level aggregations
        - order_date          → Improves time-based analysis
        - payment_date        → Enables payment timeline tracking

    📌 dim_products:
        - food_id             → Facilitates fast joins with sales items

🔐 Table Ownership:
    Ownership for base (bronze) tables reassigned to user `saquibhazari`
    to ensure controlled access and auditing capabilities.

📅 Maintained by: [Your Name]
🕒 Last Updated: [Insert Date]
===============================================================================
*/
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


-- Altering the table owner to saquibhazari
ALTER TABLE crm_customers OWNER TO saquibhazari;
ALTER TABLE crm_feedback OWNER TO saquibhazari;
ALTER TABLE crm_marketing OWNER TO saquibhazari;

ALTER TABLE erp_orders OWNER TO saquibhazari;
ALTER TABLE erp_order_items OWNER TO saquibhazari;
ALTER TABLE erp_payments OWNER TO saquibhazari;
ALTER TABLE food_products OWNER TO saquibhazari;