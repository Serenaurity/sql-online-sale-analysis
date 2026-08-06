-- ============================================================
-- Online Sales Intelligence
-- File: 05_category_analysis.sql
-- Purpose: Analyze product category performance
-- ============================================================


-- ------------------------------------------------------------
-- 1. Category performance overview
-- ------------------------------------------------------------

SELECT
    product_category,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value
FROM online_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 2. Revenue share by product category
-- ------------------------------------------------------------

SELECT
    product_category,
    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        100.0
        * SUM(total_revenue)
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_share_pct

FROM online_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 3. Rank categories by revenue and units sold
-- ------------------------------------------------------------

WITH category_performance AS (
    SELECT
        product_category,
        COUNT(*) AS transaction_count,
        SUM(units_sold) AS total_units_sold,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY product_category
)

SELECT
    product_category,
    transaction_count,
    total_units_sold,
    ROUND(total_revenue, 2) AS total_revenue,

    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank,

    RANK() OVER (
        ORDER BY total_units_sold DESC
    ) AS units_sold_rank

FROM category_performance
ORDER BY revenue_rank;


-- ------------------------------------------------------------
-- 4. Average price and revenue per unit by category
-- ------------------------------------------------------------

SELECT
    product_category,
    ROUND(AVG(unit_price), 2) AS average_unit_price,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        SUM(total_revenue) / NULLIF(SUM(units_sold), 0),
        2
    ) AS revenue_per_unit

FROM online_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 5. Top product within each category
-- ------------------------------------------------------------

WITH product_performance AS (
    SELECT
        product_category,
        product_name,
        SUM(units_sold) AS total_units_sold,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY
        product_category,
        product_name
),

ranked_products AS (
    SELECT
        product_category,
        product_name,
        total_units_sold,
        total_revenue,

        ROW_NUMBER() OVER (
            PARTITION BY product_category
            ORDER BY total_revenue DESC
        ) AS product_rank

    FROM product_performance
)

SELECT
    product_category,
    product_name,
    total_units_sold,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_products
WHERE product_rank = 1
ORDER BY total_revenue DESC;
