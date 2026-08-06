-- ============================================================
-- Online Sales Intelligence
-- File: 01_data_exploration.sql
-- Purpose: Explore the dataset structure and coverage
-- ============================================================

-- Preview records
SELECT *
FROM online_sales
LIMIT 10;


-- Check dataset coverage
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM online_sales;


-- Review available categories
SELECT DISTINCT
    product_category
FROM online_sales
ORDER BY product_category;


-- Review available regions
SELECT DISTINCT
    region
FROM online_sales
ORDER BY region;
