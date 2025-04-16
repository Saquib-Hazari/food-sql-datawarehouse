# =====================================================================
# Script: export_gold_layer_to_csv.py
# Purpose: Connects to the PostgreSQL data warehouse and exports the
# Gold Layer tables (dim_customers, dim_products, fact_sales) to CSV.
# 
# Key Steps:
# - Loads environment variables from .env for secure credential handling.
# - Establishes connection to PostgreSQL using psycopg.
# - Executes SQL queries to fetch data from Gold Layer tables.
# - Exports each table to a CSV file with the table name as filename.
# - Closes the database connection upon completion.
#
# Prerequisites:
# - Ensure `.env` file contains: dbname, dbuser, password, dbhost, dbport.
# - Install required packages: pandas, psycopg[binary], python-dotenv.
#
# Notes:
# - Tables exported: gold.dim_customers, gold.dim_products, gold.fact_sales.
# - Output: dim_customer.csv, dim_products.csv, fact_sales.csv in the script directory.
# =====================================================================
import os
import pandas as pd
from dotenv import load_dotenv
import psycopg

load_dotenv()

conn = psycopg.connect(
  dbname = os.getenv('DB_NAME'),
  user = os.getenv('DB_USER'),
  password = os.getenv('DB_PASSWORD'),
  host = os.getenv('DB_HOST'),
  port = os.getenv('DB_PORT')
)

queries = {
  "dim_customer" : "SELECT * FROM gold.dim_customers LIMIT 5000",
  "dim_products" : "SELECT * FROM gold.dim_products LIMIT 5000",
  "fact_sales" : "SELECT * FROM gold.fact_sales LIMIT 5000"
}

for name, query in queries.items():
  df = pd.read_sql(query, conn)
  df.to_csv(f"{name}.csv", index=False)
  print(f"Exported {name}.csv successfully!");
conn.close()


