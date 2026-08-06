-- ============================================================
-- Online Sales Intelligence
-- File: 07_payment_analysis.sql
-- Purpose: Analyze payment method usage and performance
-- ============================================================


-- ------------------------------------------------------------
-- 1. Payment method overview
-- ------------------------------------------------------------

SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value
FROM online_sales
GROUP BY payment_method
ORDER BY transaction_count DESC;


-- ------------------------------------------------------------
-- 2. Transaction share by payment method
-- ------------------------------------------------------------

SELECT
    payment_method,
    COUNT(*) AS transaction_count,

    ROUND(
        100.0
        * COUNT(*)
        / SUM(COUNT(*)) OVER (),
        2
    ) AS transaction_share_pct

FROM online_sales
GROUP BY payment_method
ORDER BY transaction_count DESC;


-- ------------------------------------------------------------
-- 3. Revenue share by payment method
-- ------------------------------------------------------------

SELECT
    payment_method,
    ROUND(SUM(total_revenue), 2) AS total_revenue,

    ROUND(
        100.0
        * SUM(total_revenue)
        / SUM(SUM(total_revenue)) OVER (),
        2
    ) AS revenue_share_pct

FROM online_sales
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 4. Payment method usage by region
-- ------------------------------------------------------------

SELECT
    region,
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS average_transaction_value
FROM online_sales
GROUP BY
    region,
    payment_method
ORDER BY
    region,
    transaction_count DESC;


-- ------------------------------------------------------------
-- 5. Most frequently used payment method in each region
-- ------------------------------------------------------------

WITH payment_usage AS (
    SELECT
        region,
        payment_method,
        COUNT(*) AS transaction_count,
        SUM(total_revenue) AS total_revenue
    FROM online_sales
    GROUP BY
        region,
        payment_method
),

ranked_payment_methods AS (
    SELECT
        region,
        payment_method,
        transaction_count,
        total_revenue,

        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY transaction_count DESC, total_revenue DESC
        ) AS payment_rank

    FROM payment_usage
)

SELECT
    region,
    payment_method,
    transaction_count,
    ROUND(total_revenue, 2) AS total_revenue
FROM ranked_payment_methods
WHERE payment_rank = 1
ORDER BY region;


-- ------------------------------------------------------------
-- 6. Payment method usage by product category
-- ------------------------------------------------------------

SELECT
    product_category,
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM online_sales
GROUP BY
    product_category,
    payment_method
ORDER BY
    product_category,
    transaction_count DESC;


-- ------------------------------------------------------------
-- 7. Monthly payment method trends
-- ------------------------------------------------------------

SELECT
    DATE_TRUNC('month', order_date) AS sales_month,
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM online_sales
GROUP BY
    sales_month,
    payment_method
ORDER BY
    sales_month,
    transaction_count DESC;
