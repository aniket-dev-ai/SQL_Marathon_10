````markdown
# SQL-Based Retail Sales Analysis

### Overview

This repository showcases a comprehensive analysis of a retail sales dataset using SQL. The project involves answering key business questions by writing targeted queries to explore, filter, and aggregate the data. The solutions demonstrate proficiency in a range of SQL concepts, from basic filtering and aggregation to more advanced techniques like window functions and Common Table Expressions (CTEs).

This script successfully answers **10 key business questions**.

---

### Questions Solved

1.  Retrieve all sales data for a specific date ('2022-11-05').
2.  Find all 'Clothing' transactions with more than 3 items sold in November 2022.
3.  Calculate the total sales and order count for each product category.
4.  Find the average age of customers who purchased 'Beauty' products.
5.  List all transactions with total sales exceeding $1000.
6.  Count the number of transactions made by each gender within each product category.
7.  Determine the best-selling month for each year based on average sales.
8.  Identify the top 5 customers by total sales contribution.
9.  Count the number of unique customers for each product category.
10. Segment sales into 'Morning', 'Afternoon', and 'Evening' shifts and count the orders in each.

---

### Detailed Analysis and Solutions

Below is a detailed breakdown of each question, the corresponding SQL query, and an explanation of the approach.

#### 1. Retrieve Sales on a Specific Date

* **Question:** Write a SQL Query to retrieve all columns for sales made on '2022-11-05'.
* **Solution:**
    ```sql
    SELECT *
    FROM retail_sales
    WHERE sale_date = '2022-11-05';
    ```
* **Explanation:**
    This query uses a simple `WHERE` clause to filter the `retail_sales` table. It selects all columns (`*`) for rows where the `sale_date` column exactly matches the specified date. This is the most fundamental and direct way to retrieve date-specific records.

---

#### 2. Filter Transactions by Category, Quantity, and Month

* **Question:** Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022.
* **Solution:**
    ```sql
    SELECT *
    FROM retail_sales
    WHERE category = 'Clothing'
      AND quantiy > 3
      AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
    ```
* **Explanation:**
    This query combines multiple conditions using the `AND` operator to find highly specific transactions. It filters for records that meet all three criteria: the `category` is 'Clothing', the `quantiy` is greater than 3, and the `sale_date` falls within November 2022. Using `BETWEEN` is an efficient and readable way to filter a date range.
* **Alternative Solution:**
    ```sql
    SELECT *
    FROM retail_sales
    WHERE category = 'Clothing'
      AND quantiy > 3
      AND to_char(sale_date, 'YYYY-MM') = '2022-11';
    ```
* **Note:** The `to_char` function (or equivalent date formatting functions) is highly readable but may be less performant on very large datasets compared to `BETWEEN`, as it can prevent the database from using an index on the `sale_date` column. The `BETWEEN` approach is generally preferred for performance.

---

#### 3. Calculate Total Sales and Orders per Category

* **Question:** Write a SQL query to calculate the total sales (`total_sale`) and number of orders for each category.
* **Solution:**
    ```sql
    SELECT
        category,
        SUM(total_sale) AS net_sale,
        COUNT(*) AS total_orders
    FROM retail_sales
    GROUP BY category;
    ```
* **Explanation:**
    This query demonstrates the use of aggregate functions to summarize data. `SUM(total_sale)` calculates the total revenue, while `COUNT(*)` counts the number of transactions. The `GROUP BY category` clause is essential, as it groups all rows with the same category together and applies the aggregate functions to each group, providing a powerful summary.

---

#### 4. Find the Average Customer Age for a Category

* **Question:** Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
* **Solution:**
    ```sql
    SELECT ROUND(AVG(age), 1) AS avg_age
    FROM retail_sales
    WHERE category = 'Beauty';
    ```
* **Explanation:**
    This query first uses the `WHERE` clause to isolate all sales from the 'Beauty' category. Then, the `AVG(age)` aggregate function calculates the average age of customers in that filtered subset. `ROUND(..., 1)` is used to format the result to one decimal place for cleaner presentation.

---

#### 5. Find High-Value Transactions

* **Question:** Write a SQL query to find all the transactions where the total sale is greater than 1000.
* **Solution:**
    ```sql
    SELECT *
    FROM retail_sales
    WHERE total_sale > 1000;
    ```
* **Explanation:**
    A straightforward query that uses a `WHERE` clause to filter for high-value transactions. The condition `total_sale > 1000` effectively segments the data, allowing for a quick analysis of the most significant sales.

---

#### 6. Transactions by Gender and Category

* **Question:** Write a SQL query to find the number of transactions made by each gender in each category.
* **Solution:**
    ```sql
    SELECT
        category,
        gender,
        COUNT(*) AS transaction_count
    FROM retail_sales
    GROUP BY 1, 2;
    ```
* **Explanation:**
    This query showcases grouping by multiple columns to create a more granular summary. By including both `category` and `gender` in the `GROUP BY` clause (using positional references `1, 2` for brevity), it creates unique groups for each combination (e.g., 'Clothing-Male', 'Clothing-Female') and then counts the number of transactions for each specific group.

---

#### 7. Best Selling Month of Each Year

* **Question:** Write a SQL query to calculate the average sale for each month and find the best-selling month in each year.
* **Solution:**
    ```sql
    SELECT year, month, avg_sale
    FROM (
        SELECT
            EXTRACT(YEAR FROM sale_date) AS year,
            EXTRACT(MONTH FROM sale_date) AS month,
            ROUND(AVG(total_sale)) AS avg_sale,
            RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
        FROM retail_sales
        GROUP BY 1, 2
    ) AS monthly_sales
    WHERE rnk = 1;
    ```
* **Explanation:**
    This advanced query uses a **window function** within a subquery to perform a complex ranking.
    1.  **Inner Query:** First, it calculates the average sale for each month-year combination.
    2.  **Window Function:** The `RANK()` function is applied over the results. `PARTITION BY EXTRACT(YEAR FROM sale_date)` resets the rank for each year, and `ORDER BY AVG(total_sale) DESC` sorts the months within each year by their average sale.
    3.  **Outer Query:** The query then filters these results to show only the rows where the rank is 1, corresponding to the month with the highest average sale for that year.

---

#### 8. Top 5 Customers by Sales

* **Question:** Write a SQL query to find the top 5 customers based on their highest total sales.
* **Solution:**
    ```sql
    SELECT
        customer_id,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 5;
    ```
* **Explanation:**
    This is a classic "Top N" query. It first groups all transactions by `customer_id` and calculates the total sales for each customer using `SUM()`. The results are then sorted in descending order (`ORDER BY 2 DESC`) to place the highest-spending customers at the top. Finally, `LIMIT 5` restricts the output to only the top five customers.

---

#### 9. Unique Customers per Category

* **Question:** Write a SQL query to find the number of unique customers who purchased items from each category.
* **Solution:**
    ```sql
    SELECT
        category,
        COUNT(DISTINCT customer_id) AS unique_customers
    FROM retail_sales
    GROUP BY 1;
    ```
* **Explanation:**
    This query uses `COUNT(DISTINCT customer_id)` to ensure that each customer is only counted once per category, even if they made multiple purchases. It groups the results by `category` to provide a count of unique customers for each distinct product category, offering insight into customer reach.

---

#### 10. Segment Sales by Time of Day

* **Question:** Write a SQL query to create each shift ('Morning', 'Afternoon', 'Evening') and count the number of orders in each.
* **Solution:**
    ```sql
    WITH hourly_sales AS (
        SELECT
            *,
            CASE
                WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
                WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
        FROM retail_sales
    )
    SELECT
        shift,
        COUNT(transactions_id)
    FROM hourly_sales
    GROUP BY 1;
    ```
* **Explanation:**
    This solution uses a **Common Table Expression (CTE)** named `hourly_sales` for better readability and modularity.
    1.  **CTE (`WITH` clause):** A temporary `shift` column is created using a `CASE` statement. This statement categorizes each transaction based on the hour of the `sale_time`.
    2.  **Final Query:** The main query then selects from this CTE, groups the data by the newly created `shift` column, and counts the number of transactions to provide a summary of orders per shift.

---

### SQL Best Practices and Concepts Demonstrated

This project effectively demonstrates the application of several key SQL concepts and best practices:

* **Data Aggregation:** Proficient use of `SUM()`, `AVG()`, and `COUNT()` to summarize data and derive business metrics.
* **Advanced Filtering:** Combining multiple conditions using `AND`, `BETWEEN`, and comparison operators for precise data extraction.
* **Grouping and Sorting:** Strategic use of `GROUP BY` on single and multiple columns, along with `ORDER BY` and `LIMIT`, to structure and rank data.
* **Window Functions:** Application of `RANK() OVER (PARTITION BY ...)` for complex, partitioned ranking, a critical skill for advanced analysis.
* **Common Table Expressions (CTEs):** Use of the `WITH` clause to improve the readability and structure of complex queries.
* **Conditional Logic:** Implementation of `CASE` statements to create custom categories and segment data dynamically.
* **Data Uniqueness:** Using `COUNT(DISTINCT ...)` to accurately count unique entities.
````