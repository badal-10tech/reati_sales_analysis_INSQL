-- Sql Retail Sales Analysis
 
use sales;
set sql_safe_updates = 0;
-- Create table 
DROP TABLE  if exists retail_sales;
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(20),
    quantiy INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);

select * from retail_sales limit 20;
select count(*) from retail_sales;

-- Data Cleaning

-- checking for nulls value 
select * from retail_sales 
where transactions_id IS NULL;
-- geting count of null rows in every columns
select count(*) as total_rows,
sum(CASE WHEN  transactions_id IS NULL then 1 else 0 end ) as transaction_id_nulls,
sum(CASE WHEN  sale_date IS NULL then 1 else 0 end ) as sale_date_nulls,
sum(CASE WHEN  sale_time IS NULL then 1 else 0 end ) as sale_time_nulls,
sum(CASE WHEN  customer_id IS NULL then 1 else 0 end ) as customer_id_nulls,
sum(CASE WHEN  gender IS NULL then 1 else 0 end ) as gender_nulls,
sum(CASE WHEN  age IS NULL then 1 else 0 end ) as age_nulls,
sum(CASE WHEN  category IS NULL then 1 else 0 end ) as category_nulls,
sum(CASE WHEN  quantiy IS NULL then 1 else 0 end ) as quantiy_nulls,
sum(CASE WHEN  price_per_unit IS NULL then 1 else 0 end ) asprice_per_unit_nulls,
sum(CASE WHEN  cogs IS NULL then 1 else 0 end ) cogs_nulls,
sum(CASE WHEN  total_sale IS NULL then 1 else 0 end ) total_sale_nulls
from retail_sales;



-- Checking for null rows 
SELECT *
FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantiy IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
-- Deleting the rows where value is null
Delete from  retail_sales where
 transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantiy IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
-- Data Exploration

-- Q.1) How Many sales you have?
select count(transactions_id) as sales_count from retail_sales;


 --   How Many sales you have customer?
 select  count( DISTINCT customer_id) as customer_count from retail_sales;
 
 --   How Many sales you have category?
 select  count( DISTINCT category) as category_count from retail_sales;
 select  DISTINCT category  from retail_sales;


-- Data Analysis 
-- Business Key Problems and Answer

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = "2022-11-05";




-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select * from retail_sales 
where category = 'Clothing' and quantiy > 3  and extract(YEAR_MONTH from sale_date) = 202209;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as total_sales ,  COUNT(*) as total_orders from retail_sales
group by category;
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, ROUND(avg(age)) from retail_sales where category='Beauty'
group by  category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category ,count(transactions_id) from retail_sales
group by gender ,category
order by gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(select *, dense_rank() over(partition by sales_year order by avg_sale desc ) as rnk from 
(select year(sale_date) sales_year,month(sale_date) as sale_month ,avg(total_sale) as avg_sale from retail_sales 
group by year(sale_date) , month(sale_date))t) t2
where t2.rnk =1;
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
select * from
(select customer_id,dense_rank() over(order by customer_total_sale desc) as rnk  from
(select customer_id ,sum(total_sale) as customer_total_sale from retail_sales 
group by customer_id) t)t2
where t2.rnk <=5; 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category ,count(distinct customer_id )from retail_sales
group by category 
order by category;
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)|
select t.shift ,count(transactions_id) as sale_count,sum(total_sale) as total_sum from (
select * ,
case when hour(sale_time) <= 12 then "Morning"
when 12 < hour(sale_time) and hour(sale_time) <= 17 then "Afternoon"
else "Evening"
end as shift
from retail_sales) t
group by t.shift ;

-- Project END
