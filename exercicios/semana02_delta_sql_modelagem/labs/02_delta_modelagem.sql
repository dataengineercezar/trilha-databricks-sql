USE CATALOG workspace;
USE SCHEMA databricks_sql_track;

CREATE OR REPLACE TABLE silver_customers AS
SELECT
  customer_id,
  customer_name,
  lower(email) AS email,
  region_code,
  CAST(created_at_raw AS TIMESTAMP) AS created_at,
  to_date(CAST(created_at_raw AS TIMESTAMP)) AS created_date,
  lower(acquisition_channel) AS acquisition_channel,
  current_timestamp() AS silver_loaded_at
FROM bronze_customers_raw;

CREATE OR REPLACE TABLE silver_products AS
SELECT
  product_id,
  product_name,
  lower(category) AS category,
  CAST(list_price AS DECIMAL(12, 2)) AS list_price,
  CAST(is_active AS BOOLEAN) AS is_active,
  current_timestamp() AS silver_loaded_at
FROM bronze_products_raw;

CREATE OR REPLACE TABLE silver_order_items AS
SELECT
  item.order_id,
  item.product_id,
  CAST(item.quantity AS INT) AS quantity,
  CAST(item.unit_price AS DECIMAL(12, 2)) AS unit_price,
  CAST(item.quantity * item.unit_price AS DECIMAL(12, 2)) AS line_gross_amount,
  current_timestamp() AS silver_loaded_at
FROM bronze_order_items_raw item;

CREATE OR REPLACE TABLE silver_orders AS
WITH item_revenue AS (
  SELECT
    order_id,
    SUM(line_gross_amount) AS gross_revenue
  FROM silver_order_items
  GROUP BY order_id
)
SELECT
  orders.order_id,
  orders.customer_id,
  CAST(orders.order_ts_raw AS TIMESTAMP) AS order_ts,
  to_date(CAST(orders.order_ts_raw AS TIMESTAMP)) AS order_date,
  lower(orders.order_status) AS order_status,
  lower(orders.sales_channel) AS sales_channel,
  orders.region_code,
  CAST(COALESCE(items.gross_revenue, 0) AS DECIMAL(12, 2)) AS gross_revenue,
  CAST(orders.discount_amount AS DECIMAL(12, 2)) AS discount_amount,
  CAST(orders.refund_amount AS DECIMAL(12, 2)) AS refund_amount,
  CAST(
    CASE
      WHEN lower(orders.order_status) = 'cancelled' THEN 0
      ELSE COALESCE(items.gross_revenue, 0) - orders.discount_amount - orders.refund_amount
    END AS DECIMAL(12, 2)
  ) AS net_revenue,
  lower(orders.order_status) IN ('paid', 'shipped', 'delivered', 'refunded') AS is_revenue_order,
  current_timestamp() AS silver_loaded_at
FROM bronze_orders_raw orders
LEFT JOIN item_revenue items
  ON orders.order_id = items.order_id;

COMMENT ON TABLE silver_customers IS 'Clean customer table with typed timestamps and normalized acquisition channel.';
COMMENT ON TABLE silver_products IS 'Clean product table with normalized category and active flag.';
COMMENT ON TABLE silver_orders IS 'Clean order header table with gross and net revenue.';
COMMENT ON TABLE silver_order_items IS 'Clean order item table with line level gross amount.';

SELECT
  'bronze_orders' AS source_name,
  COUNT(*) AS row_count
FROM bronze_orders_raw
UNION ALL
SELECT
  'silver_orders' AS source_name,
  COUNT(*) AS row_count
FROM silver_orders;

SELECT
  order_status,
  COUNT(*) AS orders,
  ROUND(SUM(gross_revenue), 2) AS gross_revenue,
  ROUND(SUM(net_revenue), 2) AS net_revenue
FROM silver_orders
GROUP BY order_status
ORDER BY orders DESC;

SELECT
  order_id,
  gross_revenue,
  discount_amount,
  refund_amount,
  net_revenue
FROM silver_orders
WHERE gross_revenue <= 0 OR net_revenue < 0
ORDER BY order_id;
