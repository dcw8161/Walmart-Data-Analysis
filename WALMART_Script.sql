CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
    );
    
    
                     -- Feature Engineering--
 -- time_of_day
 
SELECT 
    time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
    -- day_name
    
    SELECT 
    date,
    dayname(date)
    FROM sales;
    
    ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
    
    UPDATE sales
SET day_name = DAYNAME(date);


-- month_name
SELECT 
date,
monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = monthname(date);

--------------------------------------------------------------------------------
------------------------------- GENERIC ----------------------------------------
-- HOW MANY UNIQUE CITIES DOES THE DATA HAVE?

SELECT
distinct city
FROM sales;

-- IN WHICH CITY IS EACH BRANCH?
SELECT
distinct branch
FROM sales;

SELECT
distinct city,
	branch	
FROM sales;


-----------------------------------------------------------------------------------
------------------ PRODUCTS -------------------------------------------------------
-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;


-- What is the most common payment method?
SELECT
payment_method,
COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;


-- What is the most selling product line?
SELECT
product_line,
COUNT(product_line) AS pcnt
FROM sales
GROUP BY product_line
ORDER BY pcnt DESC;


-- What is the total revenue by month?
SELECT month_name AS month,
SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;


-- What month had the largest COGS?
SELECT month_name AS month,
SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;


-- What product line had the largest revenue?
SELECT product_line,
SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- What is the city with the largest revenue?
SELECT branch, city,
SUM(total) AS total_revenue
FROM sales
GROUP BY branch, city
ORDER BY total_revenue DESC;


-- What product line had the largest VAT?
SELECT product_line,
AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;





-- Which branch sold more products than average product sold?
SELECT branch,
SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?
SELECT gender, 
product_line,
COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?
SELECT ROUND(AVG(rating), 2) AS avg_rating, 
product_line
 FROM sales
 GROUP BY product_line
 ORDER BY avg_rating DESC;

------------------------------------------------------------------------------------------
---------------------- SALES -------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'MONDAY'
GROUP BY time_of_day
ORDER BY total_sales DESC;



-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, ROUND(AVG(VAT), 2) AS avg_VAT FROM sales
GROUP BY city
ORDER BY avg_VAT DESC;



-- Which customer type pays the most in VAT?
SELECT customer_type, ROUND(AVG(VAT), 2) AS avg_VAT FROM sales
GROUP BY customer_type
ORDER BY avg_VAT DESC;

----------------------------------------------------------------------------------------------
-------------------------- CUSTOMER ----------------------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type) FROM sales;
SELECT COUNT(DISTINCT(customer_type)) AS cnt FROM sales;


-- How many unique payment methods does the data have?
SELECT DISTINCT(payment_method) FROM sales;
SELECT COUNT(DISTINCT(payment_method)) AS cnt FROM sales;


-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS c_cnt FROM sales
GROUP BY customer_type
ORDER BY c_cnt DESC;

SELECT DISTINCT(customer_type) FROM sales;
SELECT count(DISTINCT(customer_type)) AS cnt FROM sales;


-- Which customer type buys the most?
SELECT customer_type, COUNT(*) AS cstm_cnt FROM sales
GROUP BY customer_type
ORDER BY cstm_cnt DESC;


-- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS gnd_cnt FROM sales
GROUP BY gender
ORDER BY gnd_cnt DESC;


-- What is the gender distribution per branch?
SELECT gender, COUNT(*) AS gnd_cnt FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gnd_cnt DESC;


-- Which time of the day do customers give most ratings?
SELECT time_of_day, ROUND(AVG(rating), 2) AS avg_rating FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, ROUND(AVG(rating), 2) AS avg_rating FROM sales
WHERE branch = 'C'
GROUP BY time_of_day
ORDER BY avg_rating DESC;



-- Which day of the week has the best avg ratings?
SELECT day_name, ROUND(AVG(rating), 2) AS avg_rating FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;



-- Which day of the week has the best average ratings per branch?
SELECT day_name, ROUND(AVG(rating), 2) AS avg_rating FROM sales
WHERE branch = 'C'
GROUP BY day_name
ORDER BY avg_rating DESC;



