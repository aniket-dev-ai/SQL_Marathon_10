DROP TABLE IF EXISTS retail_sales;

create table retail_sales(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time  TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

select * from retail_sales;

select count(*) from retail_sales ;

select * from retail_sales 
	where 
		transactions_id is NULL or
		sale_date is NULL or
		sale_time  is NULL or
		customer_id is NULL or
		gender is NULL or
		age is NULL or
		category is NULL or
		quantiy is NULL or
		price_per_unit is NULL or
		cogs is NULL or
		total_sale is NULL ;

delete from retail_sales
where 
transactions_id is NULL or
		sale_date is NULL or
		sale_time  is NULL or
		customer_id is NULL or
		gender is NULL or
		category is NULL or
		quantiy is NULL or
		price_per_unit is NULL or
		cogs is NULL or
		total_sale is NULL ;

-- Data Exploration

-- How many sales we have?

Select count(*) as total_sale from retail_sales;  -1997

-- How Many unique customers do we have

Select count(DISTINCT customer_id) as total_Customers from retail_sales; -- 155

-- Total no of categories.


Select count(DISTINCT category) as total_Categories from retail_sales; -- 3  

-- one more method to find name of different categories

Select DISTINCT category from retail_sales; -- 3  

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS

-- Q.1 Write a SQL Query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 write a sql query to retreive all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

select * from retail_sales where category = 'Clothing' and quantiy >3 and sale_date between  '2022-11-01' and '2022-11-30';

-- or also

select * from retail_sales where category = 'Clothing' and quantiy >3 and to_char(sale_date , 'YYYY-MM')='2022-11';

-- Q.3 Write a sql wuery to calculate the total sales (total_sale) for each category.

select category , Sum(total_sale) as net_sale , COUNT(*) as total_orders from retail_sales group by category;

-- Q.4 Wrtie a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select Round(avg(age) , 1) as avg_age from retail_sales where category = 'Beauty';

-- Q.5 Write a SQL query to find all the transactions where the total-sales is greater than 1000

select * from retail_sales where total_sale > 1000;

-- Q.6 Write a SQ:L query to find the number of transaction made by each gend in each category.

select category , gender , count(*) from retail_sales group by 1,2;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select year, month , avg_sale from (
	select extract(YEAR from sale_date) as year,
	extract(MONTH from sale_date) as month ,
	Round(avg(total_sale)) as avg_sale  ,
	RANK() OVER(Partition by extract(year from sale_date) order by avg(total_sale) desc )
	from retail_sales group by 1,2 ) 
as t1 where rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales. 

select customer_id , sum(total_sale) as total_sales from retail_sales group by 1 order by 2 desc limit 5;

-- Q.9 Write a sql query to find the number of unique customers who purchased item from each category

select category , count(distinct customer_id) unique_customer from retail_sales group by 1 ;

-- Q.10 Write a SQL query to create each shift and number of orders ( Example Morning <=12 , Afteroon Between 12 & 17 , Evening >17)


WITH hourly_sales 
as
(
select *, 
	Case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'AfterNoon'
		else 'Evening'
	End as shift
from retail_sales 
)
select shift , count(transactions_id) from hourly_sales group by 1;
