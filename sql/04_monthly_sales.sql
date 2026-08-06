-- ============================================================
-- Online Sales Intelligence
-- File: 04_monthly_sales.sql
-- Purpose: Analyze monthly sales trends and revenue growth
-- ============================================================


-- ------------------------------------------------------------
-- 1. Monthly sales performance
-- ------------------------------------------------------------

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value
FROM online_sales
GROUP BY sales_month
ORDER BY sales_month;


-- ------------------------------------------------------------
-- 2. Month-over-month revenue growth
-- ------------------------------------------------------------

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        COUNT(*) AS transaction_count,
        SUM(units_sold) AS total_units_sold,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY sales_month
),

monthly_comparison AS (
    SELECT
        sales_month,
        transaction_count,
        total_units_sold,
        total_revenue,

        LAG(total_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    transaction_count,
    total_units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        100.0
        * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS month_over_month_growth_pct

FROM monthly_comparison
ORDER BY sales_month;


-- ------------------------------------------------------------
-- 3. Rank months by revenue
-- ------------------------------------------------------------

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS sales_month,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY sales_month
)

SELECT
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank

FROM monthly_sales
ORDER BY revenue_rank, sales_month;


-- ------------------------------------------------------------
-- 4. Best-performing month
-- ------------------------------------------------------------

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM online_sales
GROUP BY sales_month
ORDER BY total_revenue DESC
LIMIT 1;
