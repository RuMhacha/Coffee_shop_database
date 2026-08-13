SELECT current_database();
CREATE TABLE coffee_shop_sales (
    transaction_id INTEGER,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INTEGER,
    store_id INTEGER,
    store_location TEXT,
    product_id INTEGER,
    unit_price NUMERIC(10, 2),
    product_category TEXT,
    product_type TEXT,
    product_detail TEXT
);
SELECT *
FROM coffee_shop_sales;
SELECT COUNT(*)
FROM coffee_shop_sales;
SELECT *
FROM coffee_shop_sales
LIMIT 10;
SELECT
    MIN(transaction_date) AS earliest_date,
    MAX(transaction_date) AS latest_date
FROM coffee_shop_sales;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids
FROM coffee_shop_sales;
SELECT
    COUNT(*) FILTER (WHERE transaction_id IS NULL) AS null_transaction_id,
    COUNT(*) FILTER (WHERE transaction_date IS NULL) AS null_transaction_date,
    COUNT(*) FILTER (WHERE transaction_time IS NULL) AS null_transaction_time,
    COUNT(*) FILTER (WHERE transaction_qty IS NULL) AS null_transaction_qty,
    COUNT(*) FILTER (WHERE store_id IS NULL) AS null_store_id,
    COUNT(*) FILTER (WHERE store_location IS NULL) AS null_store_location,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS null_unit_price,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS null_product_category,
    COUNT(*) FILTER (WHERE product_type IS NULL) AS null_product_type,
    COUNT(*) FILTER (WHERE product_detail IS NULL) AS null_product_detail
FROM coffee_shop_sales;
SELECT
    MIN(transaction_qty) AS min_quantity,
    MAX(transaction_qty) AS max_quantity,
    MIN(unit_price) AS min_price,
    MAX(unit_price) AS max_price
FROM coffee_shop_sales;
SELECT
    transaction_id,
    transaction_qty,
    unit_price,
    transaction_qty * unit_price AS revenue
FROM coffee_shop_sales
LIMIT 10;
SELECT
    SUM(transaction_qty * unit_price) AS total_revenue
FROM coffee_shop_sales;
SELECT
    store_location,
    SUM(transaction_qty * unit_price) AS total_revenue
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY total_revenue DESC;
SELECT
    store_location,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    SUM(transaction_qty * unit_price) AS total_revenue,
    AVG(transaction_qty * unit_price) AS avg_transaction_value
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY total_revenue DESC;
SELECT
    store_location,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(AVG(transaction_qty * unit_price), 2) AS avg_transaction_value,
    ROUND(AVG(transaction_qty), 2) AS avg_units_per_transaction
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY total_revenue DESC;
SELECT
    product_category,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY total_revenue DESC;
SELECT
    product_type,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_type
ORDER BY total_revenue DESC;
SELECT
    DATE_TRUNC('month', transaction_date)::date AS month,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;
SELECT
    TO_CHAR(transaction_date, 'Day') AS day_of_week,
    EXTRACT(ISODOW FROM transaction_date) AS day_number,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY
    TO_CHAR(transaction_date, 'Day'),
    EXTRACT(ISODOW FROM transaction_date)
ORDER BY day_number;
SELECT
    EXTRACT(HOUR FROM transaction_time) AS hour_of_day,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY EXTRACT(HOUR FROM transaction_time)
ORDER BY hour_of_day;
SELECT
    product_detail,
    product_category,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_detail, product_category
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    DATE_TRUNC('month', transaction_date)::date AS month,
    store_location,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY
    DATE_TRUNC('month', transaction_date),
    store_location
ORDER BY month, total_revenue DESC;
SELECT
    store_location,
    product_category,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY
    store_location,
    product_category
ORDER BY
    store_location,
    total_revenue DESC;
WITH product_sales AS (
    SELECT
        store_location,
        product_detail,
        SUM(transaction_qty) AS units_sold,
        ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY SUM(transaction_qty * unit_price) DESC
        ) AS rank
    FROM coffee_shop_sales
    GROUP BY store_location, product_detail
)
SELECT
    store_location,
    product_detail,
    units_sold,
    total_revenue
FROM product_sales
WHERE rank = 1
ORDER BY store_location;
WITH product_sales AS (
    SELECT
        store_location,
        product_detail,
        SUM(transaction_qty) AS units_sold,
        ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY SUM(transaction_qty) DESC
        ) AS rank
    FROM coffee_shop_sales
    GROUP BY store_location, product_detail
)
SELECT
    store_location,
    product_detail,
    units_sold,
    total_revenue
FROM product_sales
WHERE rank = 1
ORDER BY store_location;
WITH category_revenue AS (
    SELECT
        product_category,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY product_category
)
SELECT
    product_category,
    revenue,
    ROUND(
        100 * revenue / SUM(revenue) OVER (),
        2
    ) AS revenue_percentage
FROM category_revenue
ORDER BY revenue DESC;
WITH category_revenue AS (
    SELECT
        product_category,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY product_category
),
ranked_categories AS (
    SELECT
        product_category,
        revenue,
        SUM(revenue) OVER (
            ORDER BY revenue DESC
        ) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM category_revenue
)
SELECT
    product_category,
    ROUND(revenue, 2) AS revenue,
    ROUND(100 * revenue / total_revenue, 2) AS revenue_percentage,
    ROUND(100 * cumulative_revenue / total_revenue, 2) AS cumulative_percentage
FROM ranked_categories
ORDER BY revenue DESC;
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::date AS month,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
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
    revenue,
    previous_month_revenue,
    ROUND(
        100 * (revenue - previous_month_revenue)
        / previous_month_revenue,
        2
    ) AS growth_percentage
FROM revenue_growth
ORDER BY month;
WITH monthly_store_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::date AS month,
        store_location,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY
        DATE_TRUNC('month', transaction_date),
        store_location
),
store_growth AS (
    SELECT
        month,
        store_location,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY store_location
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_store_revenue
)
SELECT
    month,
    store_location,
    revenue,
    ROUND(
        100 * (revenue - previous_month_revenue)
        / previous_month_revenue,
        2
    ) AS growth_percentage
FROM store_growth
ORDER BY store_location, month;
WITH monthly_store_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date)::date AS month,
        store_location,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY
        DATE_TRUNC('month', transaction_date),
        store_location
),
ranked_months AS (
    SELECT
        month,
        store_location,
        revenue,
        RANK() OVER (
            PARTITION BY store_location
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM monthly_store_revenue
)
SELECT
    store_location,
    month,
    revenue
FROM ranked_months
WHERE revenue_rank = 1
ORDER BY store_location;
SELECT
    CASE
        WHEN transaction_time < '10:00:00' THEN 'Early Morning'
        WHEN transaction_time < '12:00:00' THEN 'Late Morning'
        WHEN transaction_time < '15:00:00' THEN 'Lunch / Early Afternoon'
        WHEN transaction_time < '18:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS daypart,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY daypart
ORDER BY total_revenue DESC;
WITH daypart_sales AS (
    SELECT
        store_location,
        CASE
            WHEN transaction_time < '10:00:00' THEN 'Early Morning'
            WHEN transaction_time < '12:00:00' THEN 'Late Morning'
            WHEN transaction_time < '15:00:00' THEN 'Lunch / Early Afternoon'
            WHEN transaction_time < '18:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END AS daypart,
        COUNT(*) AS transactions,
        SUM(transaction_qty) AS units_sold,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY store_location, daypart
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY store_location
            ORDER BY transactions DESC
        ) AS rank
    FROM daypart_sales
)
SELECT
    store_location,
    daypart,
    transactions,
    units_sold,
    revenue
FROM ranked
WHERE rank = 1
ORDER BY store_location;
WITH daypart_products AS (
    SELECT
        CASE
            WHEN transaction_time < '10:00:00' THEN 'Early Morning'
            WHEN transaction_time < '12:00:00' THEN 'Late Morning'
            WHEN transaction_time < '15:00:00' THEN 'Lunch / Early Afternoon'
            WHEN transaction_time < '18:00:00' THEN 'Afternoon'
            ELSE 'Evening'
        END AS daypart,
        product_category,
        SUM(transaction_qty) AS units_sold,
        ROUND(SUM(transaction_qty * unit_price), 2) AS revenue
    FROM coffee_shop_sales
    GROUP BY daypart, product_category
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY daypart
            ORDER BY revenue DESC
        ) AS revenue_rank
    FROM daypart_products
)
SELECT
    daypart,
    product_category,
    units_sold,
    revenue
FROM ranked
WHERE revenue_rank = 1
ORDER BY revenue DESC;
SELECT
    product_type,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_type
HAVING SUM(transaction_qty * unit_price) < 10000
ORDER BY total_revenue ASC;
SELECT
    CASE
        WHEN EXTRACT(ISODOW FROM transaction_date) IN (6, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(AVG(transaction_qty * unit_price), 2) AS avg_transaction_value
FROM coffee_shop_sales
GROUP BY day_type
ORDER BY total_revenue DESC;
WITH daily_sales AS (
    SELECT
        transaction_date,
        CASE
            WHEN EXTRACT(ISODOW FROM transaction_date) IN (6, 7)
                THEN 'Weekend'
            ELSE 'Weekday'
        END AS day_type,
        COUNT(*) AS transactions,
        SUM(transaction_qty) AS units_sold,
        SUM(transaction_qty * unit_price) AS revenue
    FROM coffee_shop_sales
    GROUP BY transaction_date, day_type
)
SELECT
    day_type,
    COUNT(*) AS number_of_days,
    ROUND(AVG(transactions), 2) AS avg_daily_transactions,
    ROUND(AVG(units_sold), 2) AS avg_daily_units_sold,
    ROUND(AVG(revenue), 2) AS avg_daily_revenue
FROM daily_sales
GROUP BY day_type;
SELECT
    transaction_date,
    TO_CHAR(transaction_date, 'Day') AS day_of_week,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY transaction_date
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
    product_type,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_type
HAVING SUM(transaction_qty * unit_price) > (
    SELECT AVG(product_revenue)
    FROM (
        SELECT
            SUM(transaction_qty * unit_price) AS product_revenue
        FROM coffee_shop_sales
        GROUP BY product_type
    ) AS revenue_by_product
)
ORDER BY total_revenue DESC;
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
        RANK() OVER (
            PARTITION BY product_category
            ORDER BY revenue DESC
        ) AS store_rank
    FROM store_category_sales
)
SELECT
    product_category,
    store_location,
    revenue
FROM ranked
WHERE store_rank = 1
ORDER BY revenue DESC;
-- Row count and transaction ID check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids
FROM coffee_shop_sales;
SELECT
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales;
SELECT
    store_location,
    COUNT(*) AS total_transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(AVG(transaction_qty * unit_price), 2) AS avg_transaction_value,
    ROUND(AVG(transaction_qty), 2) AS avg_units_per_transaction
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY total_revenue DESC;
SELECT
    DATE_TRUNC('month', transaction_date)::date AS month,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month;
SELECT
    TO_CHAR(transaction_date, 'Day') AS day_of_week,
    EXTRACT(ISODOW FROM transaction_date) AS day_number,
    COUNT(*) AS transactions,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY
    TO_CHAR(transaction_date, 'Day'),
    EXTRACT(ISODOW FROM transaction_date)
ORDER BY day_number;
SELECT
    product_type,
    SUM(transaction_qty) AS units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue
FROM coffee_shop_sales
GROUP BY product_type
HAVING SUM(transaction_qty * unit_price) < 10000
ORDER BY total_revenue ASC;
-- =====================================================
-- COFFEE SHOP SALES ANALYSIS
-- PostgreSQL
-- =====================================================


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
            ORDER BY revenue DESC
        ) AS store_rank
    FROM store_category_sales
)
SELECT
    product_category,
    store_location,
    revenue
FROM ranked
WHERE store_rank = 1
ORDER BY revenue DESC;
