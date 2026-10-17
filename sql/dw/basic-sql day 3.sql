set search_path = raw

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

select column_name,data_type
from information_schema.columns 
where table_schema = 'raw' and table_name = 'order_items'


select max(price) as highest_price, min(price) as lowest_price
from order_items

select order_id, order_item_id,product_id,price
from order_items
order by price desc
limit 10

-- Aggregate functions

-- count all rows including NULL
select count (*) as total_order
from order_items

-- count all rows only unique
select count(distinct order_id) as total_order_id, 
		count(*) as total_orders
from order_items

-- to check null value
select 
	*
from 
	orders
where 
	order_approved_at is null

-- count all rows not including null
select 
	count(*) as total_orders,
	count(distinct order_id) as total_ids,
	count(distinct customer_id) as total_customers,
	count(distinct order_status) as total_status,---only unique
	count(distinct order_delivered_carrier_date) as order_date,
	count(order_status) as total_status_includenull
from 
	orders

---- to see including null
select 
	order_status,
	count(*) as total_orders
from orders
group by grouping sets (
	(order_status),
	()
)

-- not including null
select 
	order_status,
	count (*) as total_orders
from 
	orders
group by order_status

-- total and including null
select 
	order_status,
	count(*) as total_orders	
from 
	orders
group by order_status
union all --- to union two table ,is to have same column names
select
	'Total' as order_status,
	count(*) as total_orders
from
	orders
-- averge, sum, min,max,total
	select * from order_payments
select
	payment_type,
	avg(payment_value) as averge_payment,
	sum(payment_value) as total_payment,
	count(*) as populate_payment
from order_payments
group by payment_type

SELECT
    CASE 
        WHEN payment_type IS NULL THEN 'Unknown'
        ELSE payment_type
    END AS payment_type,
    AVG(payment_value) AS average_payment,
    SUM(payment_value) AS total_payment,
    COUNT(*) AS populate_payment
FROM order_payments
GROUP BY GROUPING SETS (
    (payment_type),
    ()
);

SELECT customer_state,
       COUNT(*) AS customers
FROM raw.customers
WHERE customer_state like 'A_'
GROUP BY customer_state
having count(*)>2

select * from customers

select customer_state,
	   count(*) as customer
from customers
group by customer_state
having  count(*)>100 and count(*)<300

SELECT seller_id,
       COUNT(*) AS items_sold
FROM raw.order_items
GROUP BY seller_id
HAVING COUNT(*) > 100;









