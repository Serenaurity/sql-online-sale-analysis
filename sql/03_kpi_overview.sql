-- ============================================================
-- Online Sales Intelligence
-- File: 03_kpi_overview.sql
-- Purpose: Calculate primary sales KPIs
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value,
    ROUND(AVG(units_sold), 2) AS average_units_per_transaction
FROM online_sales;
