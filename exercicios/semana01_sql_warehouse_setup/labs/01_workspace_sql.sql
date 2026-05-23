USE CATALOG workspace;
CREATE SCHEMA IF NOT EXISTS databricks_sql_track;
USE SCHEMA databricks_sql_track;

SELECT
  current_catalog() AS catalog_name,
  current_schema() AS schema_name,
  current_user() AS executed_by,
  current_timestamp() AS executed_at;

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

COMMENT ON TABLE bronze_customers_raw IS 'Bronze table with raw customer records for the Databricks SQL track.';
COMMENT ON TABLE bronze_products_raw IS 'Bronze table with raw product records for the Databricks SQL track.';
COMMENT ON TABLE bronze_orders_raw IS 'Bronze table with raw order headers for the Databricks SQL track.';
COMMENT ON TABLE bronze_order_items_raw IS 'Bronze table with raw order item records for the Databricks SQL track.';
COMMENT ON TABLE bronze_web_events_raw IS 'Bronze table with raw web event records for the Databricks SQL track.';

SELECT *
FROM vw_bronze_row_counts
ORDER BY table_name;

SELECT
  order_status,
  COUNT(*) AS orders
FROM bronze_orders_raw
GROUP BY order_status
ORDER BY orders DESC;

SELECT
  event_type,
  COUNT(*) AS events
FROM bronze_web_events_raw
GROUP BY event_type
ORDER BY events DESC;

DESCRIBE TABLE bronze_orders_raw;

DESCRIBE DETAIL bronze_orders_raw;
