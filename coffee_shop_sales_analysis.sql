-- ============================================================
-- COFFEE SHOP SALES ANALYSIS
-- PostgreSQL
-- ============================================================
--
-- Objective:
-- Analyse coffee shop transaction data to identify sales trends,
-- store performance, customer purchasing patterns, and product
-- performance across three store locations.
--
-- Analysis period: January 2023 - June 2023
-- ============================================================



-- 1. DATA QUALITY CHECKS
-- Check total rows and uniqueness of transaction IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids
FROM coffee_shop_sales;


-- Check for missing values in key columns
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS null_transaction_id,
    COUNT(*) FILTER (WHERE transaction_date IS NULL) AS null_transaction_date,
    COUNT(*) FILTER (WHERE transaction_time IS NULL) AS null_transaction_time,
    COUNT(*) FILTER (WHERE transaction_qty IS NULL) AS null_transaction_qty,
    COUNT(*) FILTER (WHERE store_location IS NULL) AS null_store_location,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS null_product_category,
    COUNT(*) FILTER (WHERE product_type IS NULL) AS null_product_type,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_price
FROM coffee_shop_sales;


-- Check dataset date range, quantity range, and price range
SELECT
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date,
    MIN(transaction_qty) AS min_quantity,
    MAX(transaction_qty) AS max_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price
FROM coffee_shop_sales;

-- 2. OVERALL SALES PERFORMANCE
-- Overall business performance
SELECT
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(AVG(transaction_qty * unit_price), 2) AS avg_transaction_value,
    ROUND(AVG(transaction_qty), 2) AS avg_units_per_transaction
FROM coffee_shop_sales;

-- 3. STORE PERFORMANCE
-- Compare sales performance across store locations
SELECT
    store_location,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(AVG(transaction_qty * unit_price), 2) AS avg_transaction_value
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY total_revenue DESC;

-- 4. SALES TRENDS
-- Monthly sales performance
SELECT
    DATE_TRUNC('month', transaction_date)::date AS month,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;
-- Month-over-month revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::date AS month,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY DATE_TRUNC('month', transaction_date)
),
revenue_growth AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (revenue - previous_month_revenue)
        / previous_month_revenue,
        2
    ) AS growth_percentage
FROM revenue_growth
ORDER BY month;

-- 5. CUSTOMER PURCHASING PATTERNS
-- Sales performance by hour of day
SELECT
    EXTRACT(HOUR FROM transaction_time) AS hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY EXTRACT(HOUR FROM transaction_time)
ORDER BY hour_of_day;
-- Sales performance by daypart
SELECT
    CASE
        WHEN transaction_time < '10:00:00' THEN 'Early Morning'
        WHEN transaction_time < '12:00:00' THEN 'Late Morning'
        WHEN transaction_time < '15:00:00' THEN 'Lunch / Early Afternoon'
        WHEN transaction_time < '18:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS daypart,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY daypart
ORDER BY total_revenue DESC;

-- 6. PRODUCT PERFORMANCE
-- Revenue performance by product category
SELECT
    product_category,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(
        100.0 * SUM(transaction_qty * unit_price)
        / SUM(SUM(transaction_qty * unit_price)) OVER (),
        2
    ) AS revenue_percentage
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY total_revenue DESC;


-- Top 10 products by revenue
SELECT
    product_type,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_type
ORDER BY total_revenue DESC
LIMIT 10;

-- 7. STORE & PRODUCT ANALYSIS
-- Highest-revenue product at each store
WITH product_sales AS (
    SELECT
        store_location,
        product_detail,
        SUM(transaction_qty) AS units_sold,
        ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY SUM(transaction_qty * unit_price) DESC
        ) AS revenue_rank
    FROM coffee_shop_sales
    GROUP BY store_location, product_detail
)
SELECT
    store_location,
    product_detail,
    units_sold,
    total_revenue
FROM product_sales
WHERE revenue_rank = 1
ORDER BY store_location;
-- Store generating the most revenue for each product category
WITH store_category_sales AS (
    SELECT
        store_location,
        product_category,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY store_location, product_category
),
ranked AS (
    SELECT
        store_location,
        product_category,
        revenue,
        ROW_NUMBER() OVER (
            PARTITION BY product_category
