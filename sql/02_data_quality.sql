-- ============================================================
-- Online Sales Intelligence
-- File: 02_data_quality.sql
-- Purpose: Check missing values, duplicates, and calculations
-- ============================================================

-- Missing values
SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END)
        AS missing_transaction_id,

    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END)
        AS missing_order_date,

    SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END)
        AS missing_product_category,

    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END)
        AS missing_product_name,

    SUM(CASE WHEN units_sold IS NULL THEN 1 ELSE 0 END)
        AS missing_units_sold,

    SUM(CASE WHEN total_revenue IS NULL THEN 1 ELSE 0 END)
        AS missing_total_revenue

FROM online_sales;


-- Duplicate transaction IDs
SELECT
    transaction_id,
    COUNT(*) AS occurrence_count
FROM online_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;


-- Validate revenue calculation
SELECT
    COUNT(*) AS revenue_mismatch_count
FROM online_sales
WHERE ABS(
    total_revenue - (units_sold * unit_price)
) > 0.01;
