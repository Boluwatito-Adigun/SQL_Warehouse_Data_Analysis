# Introduction
This project represents my second data analysis project as a budding data analyst.
The goal was to perform data exploration and analysis on a company’s sales database to better understand its structure, sales performance, customer demographics, and product trends.

Through this project, I practiced using SQL for data exploration, aggregation, and ranking. I also focused on improving my ability to extract insights from raw data and present them in a clear and structured format

SQL Queries? Check them out here: [project_sql_folder](/Project_scripts/)

# Background

The company’s sales database contains information about customers, products, and sales transactions.
The analysis aimed to answer key business questions such as:

### The questions I wanted to answer through my SQL queries were

1. How is the data structured across the database?

2. What are the total sales, orders, and customers?

3. Which countries and customer groups generate the most revenue?

4. Which products are top (and worst) performers in sales?

5. How does revenue vary across product categories?

# Tools Used
For this project, I employed several key tools which are;

- **SQL:** The backbone of my analysis, allowing me to query the database and discover key insights.
- **PostgresSQL:** The chosen database management system ideal for handling the job posting data
- **Git and GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.  

- **SQL Functions:**
    - Aggregations: SUM(), AVG(), COUNT()
    - Ranking: RANK(), DENSE_RANK(), ROW_NUMBER()
    - Date Functions: MIN(), MAX(), EXTRACT(), AGE()
    - Filtering and Sorting: GROUP BY, ORDER BY, LIMIT, DISTINCT, JOIN

# The Analysis
Here's how I approached each question:

### 1. Database Exploration

Retrieved the list of tables and their schemas using INFORMATION_SCHEMA.TABLES.

Inspected columns, data types, and metadata to understand table relationships.

```sql
-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG, 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES;

-- Retrieve all columns for a specific table (gold_dim_customers)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'gold_dim_customers';


```

### 2. Dimensions Exploration

Identified key dimensions such as country, category, and product name.

Used DISTINCT queries to view unique values and understand grouping opportunities for future analysis.

```sql
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
```

### 3. Date Range Exploration

Determined the earliest and latest order dates to understand the time span of the data.

Calculated age ranges of customers using date functions.
```sql
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

```

### 4. Measures Exploration (Key Metrics)

Generated quick insights on key business metrics such as:

- 🛒 Total Sales

- 📦 Total Quantity Sold

- 💰 Average Selling Price

- 🧾 Total Orders

- 👥 Total Customers and Active Customers

- 🧍‍♂️ Total Products

```sql
-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold_fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold_fact_sales

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM gold_fact_sales

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold_fact_sales

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold_dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold_dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold_fact_sales;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold_fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold_fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold_fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold_fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold_dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold_dim_customers;

```

### 5. Magnitude Analysis

Grouped and summarized data to understand patterns across dimensions:

- Total customers by country and gender

- Total products and average cost by category

- Total revenue by category and customer

- Distribution of sold items across countries

```sql

-- Find total customers by countries
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold_dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Find total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold_dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold_dim_products
GROUP BY category
ORDER BY total_products DESC;

-- What is the average costs in each category?
SELECT
    category,
    ROUND(AVG(cost),0)AS avg_cost
FROM gold_dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- What is the total revenue generated for each category?
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;


-- What is the total revenue generated by each customer?
SELECT
    c.customer_key,
    concat(c.first_name, ' ' , c.last_name) AS Full_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold_fact_sales f
LEFT JOIN gold_dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    Full_name
ORDER BY total_revenue DESC;

-- What is the distribution of sold items across countries?
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;

```

### 6. Ranking Analysis

-Applied ranking functions to highlight top and bottom performers:

- Top 5 products generating the highest revenue

- Bottom 5 products with the lowest sales

- Top 10 customers by revenue contribution

- 3 customers with the fewest orders

```sql
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
```


# What I learned

- **Project Type:** Data Exploration & Analysis
- **Language Used:**	SQL
- **Focus Areas:**	Sales Performance, Customer Analysis, Product Insights
- **Skills Practiced:**	Database exploration, aggregation, ranking, joins, and date functions
- **Learning Outcome:**	Strengthened understanding of SQL for real-world business data analysis

# Conclusions

From the analysis, several general insights emerged:

- The database is well-structured with clear relationships between customers, products, and sales.

- A few product categories generate the majority of sales revenue.

- There is variation in customer distribution by country and gender.

- The use of SQL window functions helped efficiently identify top and low performers.

This project improved my ability to explore unfamiliar datasets, identify key business metrics, and communicate data-driven insights using SQL.

