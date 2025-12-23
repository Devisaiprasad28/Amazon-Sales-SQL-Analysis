-- =====================================
-- Amazon Sales Data Analysis (SQL)
-- =====================================

-- 1. View all records
SELECT * FROM amazons;

-- 2. Number of unique cities
SELECT COUNT(DISTINCT city) AS no_of_cities
FROM amazons;

-- 3. Number of distinct product lines
SELECT COUNT(DISTINCT `Product line`) AS distinct_product_lines
FROM amazons;

-- 4. Most frequently used payment method
SELECT COUNT(payment) AS freq_of_payment, payment
FROM amazons
GROUP BY payment
ORDER BY freq_of_payment DESC
LIMIT 1;

-- 5. Product line with highest sales quantity
SELECT SUM(quantity) AS total_sales, `Product line`
FROM amazons
GROUP BY `Product line`
ORDER BY total_sales DESC
LIMIT 1;

-- 6. Monthly revenue
SELECT SUM(quantity * `Unit_price`) AS total_revenue,
       MONTHNAME(date) AS month
FROM amazons
GROUP BY month;

-- 7. Number of months in data
SELECT COUNT(DISTINCT MONTHNAME(date)) AS no_of_months
FROM amazons;

-- 8. Month with highest COGS
SELECT SUM(cogs) AS total_cogs,
       MONTHNAME(date) AS month
FROM amazons
GROUP BY month
ORDER BY total_cogs DESC
LIMIT 1;

-- 9. Product line with highest revenue
SELECT SUM(quantity * `Unit_price`) AS total_revenue,
       `Product line`
FROM amazons
GROUP BY `Product line`
ORDER BY total_revenue DESC
LIMIT 1;

-- 10. City with highest revenue
SELECT SUM(quantity * `Unit_price`) AS total_revenue,
       city
FROM amazons
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- 11. Product line with highest VAT
SELECT SUM(`Tax 5%`) AS vat,
       `Product line`
FROM amazons
GROUP BY `Product line`
ORDER BY vat DESC
LIMIT 1;

-- 12. Branches with sales above average
SELECT branch, SUM(quantity) AS total_quantity
FROM amazons
GROUP BY branch
HAVING SUM(quantity) >
(
  SELECT AVG(totalquantity)
  FROM (
        SELECT SUM(quantity) AS totalquantity
        FROM amazons
        GROUP BY branch
       ) t
);

-- 13. Most purchased product line by gender (Window Function)
SELECT gender, `Product line`, purchase_count
FROM (
    SELECT gender,
           `Product line`,
           COUNT(*) AS purchase_count,
           RANK() OVER (PARTITION BY gender ORDER BY COUNT(*) DESC) AS rnk
    FROM amazons
    GROUP BY gender, `Product line`
) t
WHERE rnk = 1;

-- 14. Average rating by product line
SELECT AVG(rating) AS avg_rating, `Product line`
FROM amazons
GROUP BY `Product line`
ORDER BY avg_rating DESC;

-- 15. Add weekday/weekend column
ALTER TABLE amazons ADD COLUMN weektype VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE amazons
SET weektype =
CASE
    WHEN WEEKDAY(date) IN (5,6) THEN 'Weekend'
    ELSE 'Weekday'
END;

-- 16. Sales by time of day on weekdays
SELECT partoftime,
       SUM(quantity) AS quantity_sold
FROM amazons
WHERE WEEKDAY(date) IN (0,1,2,3,4)
GROUP BY partoftime
ORDER BY quantity_sold DESC;

-- 17. Customer type with highest revenue
SELECT SUM(quantity * `Unit_price`) AS total_revenue,
       `Customer type`
FROM amazons
GROUP BY `Customer type`
ORDER BY total_revenue DESC
LIMIT 1;

-- 18. City with highest VAT
SELECT city, SUM(`Tax 5%`) AS vat
FROM amazons
GROUP BY city
ORDER BY vat DESC
LIMIT 1;

-- 19. Customer type with highest VAT
SELECT `Customer type`, SUM(`Tax 5%`) AS vat
FROM amazons
GROUP BY `Customer type`
ORDER BY vat DESC
LIMIT 1;

-- 20. Count of customer types
SELECT COUNT(DISTINCT `Customer type`) AS customer_type_count
FROM amazons;

-- 21. Check null values in branch
SELECT COUNT(*) AS null_count
FROM amazons
WHERE branch IS NULL;

-- 22. View table columns
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'task'
  AND TABLE_NAME = 'amazons';
