-- Databricks SQL seed dataset for the track.
-- Change the catalog if your workspace does not have `workspace`.

USE CATALOG workspace;
CREATE SCHEMA IF NOT EXISTS databricks_sql_track;
USE SCHEMA databricks_sql_track;

CREATE OR REPLACE TABLE bronze_customers_raw AS
SELECT * FROM VALUES
  ('C001', 'Ana Silva',     'ana@example.com',     'BR-SP', '2025-12-15T10:00:00Z', 'paid_search'),
  ('C002', 'Bruno Costa',   'bruno@example.com',   'BR-RJ', '2025-12-20T11:20:00Z', 'organic'),
  ('C003', 'Carla Souza',   'carla@example.com',   'BR-MG', '2026-01-05T09:15:00Z', 'social'),
  ('C004', 'Diego Lima',    'diego@example.com',   'BR-SP', '2026-01-12T18:45:00Z', 'referral'),
  ('C005', 'Elisa Rocha',   'elisa@example.com',   'BR-PR', '2026-01-18T08:30:00Z', 'organic'),
  ('C006', 'Felipe Alves',  'felipe@example.com',  'BR-BA', '2026-02-02T13:10:00Z', 'paid_search'),
  ('C007', 'Giulia Martins','giulia@example.com',  'BR-RS', '2026-02-07T15:40:00Z', 'social'),
  ('C008', 'Hugo Pereira',  'hugo@example.com',    'BR-PE', '2026-02-20T17:05:00Z', 'partner')
AS t(customer_id, customer_name, email, region_code, created_at_raw, acquisition_channel);

CREATE OR REPLACE TABLE bronze_products_raw AS
SELECT * FROM VALUES
  ('P001', 'Notebook Pro 14',      'electronics', 6200.00, true),
  ('P002', 'Mechanical Keyboard',  'electronics',  420.00, true),
  ('P003', 'Cloud Data Book',      'books',        180.00, true),
  ('P004', 'Ergonomic Chair',      'office',      1400.00, true),
  ('P005', 'SQL Course Voucher',   'education',    350.00, true),
  ('P006', 'Monitor 27',           'electronics', 1800.00, true),
  ('P007', 'Standing Desk',        'office',      2300.00, false)
AS t(product_id, product_name, category, list_price, is_active);

CREATE OR REPLACE TABLE bronze_orders_raw AS
SELECT * FROM VALUES
  ('O1001', 'C001', '2026-03-01T10:15:00Z', 'paid',      'web',    'BR-SP',  30.00,   0.00),
  ('O1002', 'C002', '2026-03-01T12:40:00Z', 'paid',      'mobile', 'BR-RJ',   0.00,   0.00),
  ('O1003', 'C001', '2026-03-02T09:00:00Z', 'shipped',   'web',    'BR-SP', 100.00,   0.00),
  ('O1004', 'C003', '2026-03-02T14:30:00Z', 'cancelled', 'mobile', 'BR-MG',   0.00,   0.00),
  ('O1005', 'C004', '2026-03-03T16:10:00Z', 'paid',      'partner','BR-SP',  50.00,   0.00),
  ('O1006', 'C005', '2026-03-04T08:20:00Z', 'refunded',  'web',    'BR-PR',  20.00, 180.00),
  ('O1007', 'C006', '2026-03-04T20:05:00Z', 'paid',      'mobile', 'BR-BA',   0.00,   0.00),
  ('O1008', 'C007', '2026-03-05T11:55:00Z', 'paid',      'web',    'BR-RS',  80.00,   0.00),
  ('O1009', 'C008', '2026-03-05T21:15:00Z', 'shipped',   'partner','BR-PE',   0.00,   0.00),
  ('O1010', 'C002', '2026-03-06T13:35:00Z', 'paid',      'web',    'BR-RJ',  25.00,   0.00),
  ('O1011', 'C003', '2026-03-07T10:05:00Z', 'paid',      'mobile', 'BR-MG',  15.00,   0.00),
  ('O1012', 'C004', '2026-03-07T19:45:00Z', 'paid',      'web',    'BR-SP',   0.00,   0.00)
AS t(order_id, customer_id, order_ts_raw, order_status, sales_channel, region_code, discount_amount, refund_amount);

CREATE OR REPLACE TABLE bronze_order_items_raw AS
SELECT * FROM VALUES
  ('O1001', 'P002', 1,  420.00),
  ('O1001', 'P003', 1,  180.00),
  ('O1002', 'P001', 1, 6200.00),
  ('O1003', 'P004', 1, 1400.00),
  ('O1003', 'P005', 2,  350.00),
  ('O1004', 'P003', 1,  180.00),
  ('O1005', 'P006', 1, 1800.00),
  ('O1005', 'P002', 1,  420.00),
  ('O1006', 'P003', 1,  180.00),
  ('O1007', 'P005', 1,  350.00),
  ('O1007', 'P002', 1,  420.00),
  ('O1008', 'P004', 1, 1400.00),
  ('O1009', 'P006', 2, 1800.00),
  ('O1010', 'P003', 2,  180.00),
  ('O1010', 'P005', 1,  350.00),
  ('O1011', 'P002', 1,  420.00),
  ('O1012', 'P001', 1, 6200.00),
  ('O1012', 'P006', 1, 1800.00)
AS t(order_id, product_id, quantity, unit_price);

CREATE OR REPLACE TABLE bronze_web_events_raw AS
SELECT * FROM VALUES
  ('E001', 'C001', '2026-03-01T09:50:00Z', 'product_view', 'web',    'P002'),
  ('E002', 'C001', '2026-03-01T10:05:00Z', 'add_to_cart',  'web',    'P002'),
  ('E003', 'C001', '2026-03-01T10:15:00Z', 'purchase',     'web',    'P002'),
  ('E004', 'C002', '2026-03-01T12:10:00Z', 'product_view', 'mobile', 'P001'),
  ('E005', 'C002', '2026-03-01T12:40:00Z', 'purchase',     'mobile', 'P001'),
  ('E006', 'C003', '2026-03-02T14:10:00Z', 'product_view', 'mobile', 'P003'),
  ('E007', 'C004', '2026-03-03T15:45:00Z', 'product_view', 'partner','P006'),
  ('E008', 'C004', '2026-03-03T16:10:00Z', 'purchase',     'partner','P006'),
  ('E009', 'C005', '2026-03-04T08:10:00Z', 'product_view', 'web',    'P003'),
  ('E010', 'C006', '2026-03-04T19:55:00Z', 'add_to_cart',  'mobile', 'P005'),
  ('E011', 'C006', '2026-03-04T20:05:00Z', 'purchase',     'mobile', 'P005'),
  ('E012', 'C007', '2026-03-05T11:30:00Z', 'product_view', 'web',    'P004'),
  ('E013', 'C008', '2026-03-05T21:00:00Z', 'product_view', 'partner','P006'),
  ('E014', 'C008', '2026-03-05T21:15:00Z', 'purchase',     'partner','P006')
AS t(event_id, customer_id, event_ts_raw, event_type, channel, product_id);

SELECT
  'seed_loaded' AS status,
  current_catalog() AS catalog_name,
  current_schema() AS schema_name,
  current_timestamp() AS loaded_at;
