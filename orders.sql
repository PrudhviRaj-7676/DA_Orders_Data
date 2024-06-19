--find top 10 highest reveue generating products 

SELECT product_id,SUM(sale_price) AS sales
FROM new_orders
GROUP BY product_id
ORDER BY sales DESC
LIMIT 10;


--find top 5 highest selling products in each region

with cte as (
SELECT region,product_id, ROUND(SUM(sale_price), 2) AS sales
FROM new_orders
GROUP BY region,product_id)
select * from(
select *
, row_number()over(partition by region order by sales desc) as rn
from cte) A
where rn<=5


--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

with cte as (
select year(order_date) as order_year, month(order_date) as order_month, round(sum(sale_price),2) as sales
from new_orders
group by year(order_date),month(order_date)
)
select order_month,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month

--for each category which month had highest sales 

with cte as(
SELECT category, 
       DATE_FORMAT(order_date, '%Y%m') AS order_year_month, 
       ROUND(SUM(sale_price),3) AS sales
FROM new_orders
GROUP BY category, DATE_FORMAT(order_date, '%Y%m')
ORDER BY category, DATE_FORMAT(order_date, '%Y%m')
)
select * from (
select *,
row_number() over(partition by category order by sales desc) as rn
from cte 
) a
where rn=1 

--which sub category had highest growth by profit in 2023 compare to 2022

with cte as (
select sub_category,year(order_date) as order_year, round(sum(sale_price),2) as sales
from new_orders
group by sub_category,year(order_date)
),
cte2 as(
select sub_category,
sum(case when order_year=2022 then sales else 0 end) as sales_2022,
sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
)
select sub_category,round(((sales_2023-sales_2022)*100/sales_2022),2) as growth_percentage
from cte2
order by growth_percentage desc
LIMIT 1
