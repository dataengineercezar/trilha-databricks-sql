-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Semana 01 - SQL Warehouse, workspace e dataset seed
-- MAGIC
-- MAGIC Objetivo: validar o ambiente, conferir o schema e criar a primeira view de auditoria.
-- MAGIC
-- MAGIC Antes de rodar este notebook, execute `datasets/notebooks/00_seed_ecommerce_notebook.sql`.

-- COMMAND ----------

USE CATALOG workspace;
CREATE SCHEMA IF NOT EXISTS databricks_sql_track;
USE SCHEMA databricks_sql_track;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Checkpoint 1 - contexto de execucao

-- COMMAND ----------

SELECT
  current_catalog() AS catalog_name,
  current_schema() AS schema_name,
  current_user() AS executed_by,
  current_timestamp() AS executed_at;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Checkpoint 2 - contagem de linhas Bronze

-- COMMAND ----------

CREATE OR REPLACE VIEW vw_bronze_row_counts AS
SELECT 'bronze_customers_raw' AS table_name, COUNT(*) AS row_count FROM bronze_customers_raw
UNION ALL
SELECT 'bronze_products_raw' AS table_name, COUNT(*) AS row_count FROM bronze_products_raw
UNION ALL
SELECT 'bronze_orders_raw' AS table_name, COUNT(*) AS row_count FROM bronze_orders_raw
UNION ALL
SELECT 'bronze_order_items_raw' AS table_name, COUNT(*) AS row_count FROM bronze_order_items_raw
UNION ALL
SELECT 'bronze_web_events_raw' AS table_name, COUNT(*) AS row_count FROM bronze_web_events_raw;

-- COMMAND ----------

SELECT *
FROM vw_bronze_row_counts
ORDER BY table_name;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Checkpoint 3 - comentarios e exploracao inicial

-- COMMAND ----------

COMMENT ON TABLE bronze_customers_raw IS 'Bronze table with raw customer records for the Databricks SQL track.';
COMMENT ON TABLE bronze_products_raw IS 'Bronze table with raw product records for the Databricks SQL track.';
COMMENT ON TABLE bronze_orders_raw IS 'Bronze table with raw order headers for the Databricks SQL track.';
COMMENT ON TABLE bronze_order_items_raw IS 'Bronze table with raw order item records for the Databricks SQL track.';
COMMENT ON TABLE bronze_web_events_raw IS 'Bronze table with raw web event records for the Databricks SQL track.';

-- COMMAND ----------

SELECT
  order_status,
  COUNT(*) AS orders
FROM bronze_orders_raw
GROUP BY order_status
ORDER BY orders DESC;

-- COMMAND ----------

SELECT
  event_type,
  COUNT(*) AS events
FROM bronze_web_events_raw
GROUP BY event_type
ORDER BY events DESC;

-- COMMAND ----------

DESCRIBE DETAIL bronze_orders_raw;

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ## Criterio de aceite
-- MAGIC
-- MAGIC - A view `vw_bronze_row_counts` existe.
-- MAGIC - Todas as tabelas Bronze aparecem com contagem maior que zero.
-- MAGIC - `DESCRIBE DETAIL bronze_orders_raw` executa sem erro.
