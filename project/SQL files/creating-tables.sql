-- 1. Creating the tables
DROP TABLE IF EXISTS food_customers;
CREATE TABLE food_customers (
  customer_id INTEGER,
  name TEXT,
  email TEXT,
  phone TEXT,
  state TEXT,
  city TEXT
);

DROP TABLE IF EXISTS food_order_items;
CREATE TABLE food_order_items (
  order_item_id INTEGER,
  order_id INTEGER,
  food_id INTEGER,
  quantity INTEGER
);

DROP TABLE IF EXISTS food_orders;
CREATE TABLE food_orders (
  order_id INTEGER,
  customer_id INTEGER,
  order_date TEXT,
  status TEXT,
  order_type TEXT
);

DROP TABLE IF EXISTS food_payments;
CREATE TABLE food_payments (
  payment_id INTEGER,
  order_id INTEGER,
  payment_date TEXT,
  amount TEXT,
  payment_method TEXT
);

-- 2. Set the owner
ALTER TABLE food_customers OWNER TO saquibhazari;
ALTER TABLE food_order_items OWNER TO saquibhazari;
ALTER TABLE food_orders OWNER TO saquibhazari;
ALTER TABLE food_payments OWNER TO saquibhazari;

-- 3. Creating indexes (✅ with unique names and correct columns)
CREATE INDEX idx_customers_customer_id ON food_customers (customer_id);
CREATE INDEX idx_order_items_order_item_id ON food_order_items (order_item_id);
CREATE INDEX idx_orders_order_id ON food_orders (order_id);
CREATE INDEX idx_payments_payment_id ON food_payments (payment_id);

-- Copying the CSV files.
COPY food_customers
FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/Fooddb/food_customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY food_order_items
FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/Fooddb/food_order_items.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY food_orders
FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/Fooddb/food_orders.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY food_payments
FROM '/Users/saquibhazari/DEVELOPERS/food_sql_database/CSV/Fooddb/food_payments.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

