--Write SQL queries to answer the 6 questions using the provided dataset. Upload screenshots of your queries and results.

--1. Find the top 5 states by customer count.
select * from customers
select 
	customer_state,
	count(*) as total_customers
from 
	customers
group by customer_state
order by total_customers desc
limit 5

--2. Count unique customers using customer_unique_id.

select * from customers
select 
	--customer_unique_id,
	count(distinct customer_unique_id) as unique_customers
	--count(*)
from customers

--3. Find the most-used payment type and its total payment value.

select * from order_payments

select 
	payment_type,
	count(*) as Total_used_PaymentType,
	sum(payment_value) as Total_Value
from 
	order_payments
group by payment_type
order by count(*)  desc
limit 1

--4. Count reviews for each score (1-5) and find the average score.
select * from order_reviews where review_score is Null

select 
	review_score,
	count(*) as total_reviews ,
	cast(null as int) as average_score
from order_reviews
group by review_score
union all 
select 
	 cast(null as int) as review_score ,
	cast(null as int) as total_reviews,
	avg(review_score) as average_score
from 
	order_reviews
	
select 
	review_score,
	count(*) as total_reviews,
	avg(review_score) over() as average_score
from 
	order_reviews 
group by review_score 


--5. Find seller states with more than 50 sellers.
select * from sellers where seller_state is null 

select 
	seller_state,
	count(*) as total_sellers
from 
	sellers 
group by seller_state
having count(*)>50


--6. Calculate the average price and freight per item, rounded to 2 decimals.
select * from order_items where 

select 
	product_id,
	round(avg(price),2)  as Average_price,
	round(avg(freight_value),2)  as average_freight
from
	order_items
group by product_id
order by avg(price), avg(freight_value) desc
 