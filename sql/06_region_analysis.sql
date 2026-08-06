-- ============================================================
-- Online Sales Intelligence
-- File: 06_region_analysis.sql
-- Purpose: Analyze regional sales performance
-- ============================================================


-- ------------------------------------------------------------
-- 1. Regional performance overview
-- ------------------------------------------------------------

SELECT
    region,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value
FROM online_sales
GROUP BY region
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 2. Revenue share by region
-- ------------------------------------------------------------

SELECT
    region,
    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        100.0
        * SUM(total_revenue)
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_share_pct

FROM online_sales
GROUP BY region
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 3. Rank regions by revenue and transaction volume
-- ------------------------------------------------------------

WITH regional_performance AS (
    SELECT
        region,
        COUNT(*) AS transaction_count,
        SUM(units_sold) AS total_units_sold,
        SUM(total_revenue) AS total_revenue,
        AVG(total_revenue) AS average_transaction_value
    FROM online_sales
    GROUP BY region
)

SELECT
    region,
    transaction_count,
    total_units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(average_transaction_value, 2) AS average_transaction_value,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY transaction_count DESC
    ) AS transaction_rank

FROM regional_performance
ORDER BY revenue_rank;


-- ------------------------------------------------------------
-- 4. Category performance within each region
-- ------------------------------------------------------------

SELECT
    region,
    product_category,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM online_sales
GROUP BY
    region,
    product_category
ORDER BY
    region,
    total_revenue DESC;


-- ------------------------------------------------------------
-- 5. Top-performing category in each region
-- ------------------------------------------------------------

WITH regional_category_performance AS (
    SELECT
        region,
        product_category,
        SUM(units_sold) AS total_units_sold,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY
        region,
        product_category
),

ranked_categories AS (
    SELECT
        region,
        product_category,
        total_units_sold,
        total_revenue,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY total_revenue DESC
        ) AS category_rank

    FROM regional_category_performance
)

SELECT
    region,
    product_category,
    total_units_sold,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_categories
WHERE category_rank = 1
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 6. Monthly revenue by region
-- ------------------------------------------------------------

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    region,
    COUNT(*) AS transaction_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM online_sales
GROUP BY
    sales_month,
    region
ORDER BY
    sales_month,
    total_revenue DESC;
