import os
import pandas as pd
from dotenv import load_dotenv
import psycopg

load_dotenv()

conn = psycopg.connect(
  dbname = os.getenv('dbname'),
  user = os.getenv('dbuser'),
  password = os.getenv('password'),
  host = os.getenv('dbhost'),
  port = os.getenv('dbport')
)

queries = {
  "dim_customer" : "SELECT * FROM gold.dim_customers",
  "dim_products" : "SELECT * FROM gold.dim_products",
  "fact_sales" : "SELECT * FROM gold.fact_sales"
}

for name, query in queries.items():
  df = pd.read_sql(query, conn)
  df.to_csv(f"{name}.csv", index=False)
  print(f"Exported {name}.csv successfully!");
conn.close()


