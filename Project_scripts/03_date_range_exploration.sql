/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To Identify the earliest and latest dates (boundries)
    - To understand the range and time span of the data.

SQL Functions Used:
    - MIN(), MAX(), EXTRACT(), AGE()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    Extract(YEAR FROM MAX(order_date)) - Extract(YEAR FROM MIN(order_date)) AS order_range_year
FROM gold_fact_sales;

-- Find the youngest and oldest customer based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    Extract(YEAR FROM MIN(birthdate)) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    Extract(YEAR FROM MAX(birthdate) ) AS youngest_age
FROM gold_dim_customers;


SELECT
    MIN(birthdate) AS oldest_birthdate,
    Extract(YEAR FROM AGE( MIN(birthdate))) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    Extract(YEAR FROM AGE( MAX(birthdate))) AS youngest_age
FROM 
    gold_dim_customers;

