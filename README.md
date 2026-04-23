# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sales;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

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
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail_sales where sale_date = "2022-11-05";
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail_sales 
where category = 'Clothing' and quantiy > 3  and extract(YEAR_MONTH from sale_date) = 202209;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,sum(total_sale) as total_sales ,  COUNT(*) as total_orders from retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select category, ROUND(avg(age)) from retail_sales where category='Beauty'
group by  category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales where total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select gender,category ,count(transactions_id) from retail_sales
group by gender, category
order by gender;

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select * from
(select *, dense_rank() over(partition by sales_year order by avg_sale desc ) as rnk from 
(select year(sale_date) sales_year,month(sale_date) as sale_month ,avg(total_sale) as avg_sale from retail_sales 
group by year(sale_date) , month(sale_date))t) t2
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select * from
(select customer_id,dense_rank() over(order by customer_total_sale desc) as rnk  from
(select customer_id ,sum(total_sale) as customer_total_sale from retail_sales 
group by customer_id) t)t2
where t2.rnk <=5; 
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select category ,count(distinct customer_id )from retail_sales
group by category 
order by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
select t.shift ,count(transactions_id) as sale_count,sum(total_sale) as total_sum from (
select * ,
case when hour(sale_time) <= 12 then "Morning"
when 12 < hour(sale_time) and hour(sale_time) <= 17 then "Afternoon"
else "Evening"
end as shift
from retail_sales) t
group by t.shift ;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
