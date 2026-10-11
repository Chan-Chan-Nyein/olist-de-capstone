-- Peak as a table : always limit while exploring
select * from orders limit 10;

-- Choose and rename columns
select 
	order_id,
	order_status as status,
	order_purchase_timestamp as purchased_at
from orders
limit 3;

-- Which statuese exit?
select 
	distinct order_status
from orders;

-- filtering rows with where

select
	order_id,  --"," use for column seperation
	order_status as status
from orders
where order_status='delivered';

select
	order_id,
	order_status as Status
from orders 
where order_status <>'canceled'

select 
	*
from customers limit 5

select distinct
	customer_state
from 
	customers
where
	customer_state in ('RS','PA','AP')
	

select * from order_items
where price between 200 and 400

select * from customers
where customer_city like 'mo%' -- like '%' = any text

select * from customers
where customer_city like '__gi-guacu' --like '__gi' = any characher infrnt of gi








