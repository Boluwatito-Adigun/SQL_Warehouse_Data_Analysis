/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of each column we can use as dimensions in the tables.

Why?
This helps to identify the columns we can group our queries by and also understand the 
unique values contained in them.
	
Understanding how data might be grouped is quite useful for future analysis.

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT country
FROM gold_dim_customers
ORDER BY country;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    category,
    subcategory, 
    product_name 
FROM gold_dim_products
ORDER BY category, subcategory, product_name;
