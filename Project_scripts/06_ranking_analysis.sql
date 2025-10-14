/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), LIMIT
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(s.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(s.sales_amount) DESC) AS rank_products
    FROM gold_fact_sales s
    LEFT JOIN gold_dim_products p
        ON p.product_key = s.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_products p
    ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue
LIMIT 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT 
    c.customer_key,
    concat( c.first_name, ' ', c.last_name) AS full_name,
    SUM(s.sales_amount) AS total_revenue
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    full_name
ORDER BY total_revenue DESC
LIMIT 10;

-- The 3 customers with the fewest orders placed
SELECT
    c.customer_key,
    concat( c.first_name, ' ', c.last_name) AS full_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold_fact_sales s
LEFT JOIN gold_dim_customers c
    ON c.customer_key = s.customer_key
GROUP BY 
    c.customer_key,
    full_name
ORDER BY total_orders 
LIMIT 3;
