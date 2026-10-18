--- checking orders table
select column_name , data_type from information_schema.columns where table_schema = 'raw' and table_name ='orders';
SET search_path = raw;
select * from orders;

select count(*) from orders; --99441

select count(distinct order_id) as total_orders,
	   count(distinct customer_id) as total_customerids
from orders;

select order_id, count(*) from orders group by order_id having count(*)>2;
select customer_id, count(*) from orders group by customer_id having count(*)>2;

select order_id, count(*) from order_items group by order_id having count(*)>2;
select count(distinct order_id) from order_items;

select * from orders where order_id = '7dfff541b2a848ecb18ceb83d02bfa6a'; -- 8columns
select * from order_items where order_id = '7dfff541b2a848ecb18ceb83d02bfa6a'; --7columns

--select * from orders O
--inner join order_items oi on oi.order_id = o.order_id where oi.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

--select * from order_items oi
--inner join orders o on o.order_id = oi.order_id where o.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

--select * from order_items oi
--left join orders o on o.order_id = oi.order_id where o.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

select * from orders o
left join order_items oi on oi.order_id = o.order_id where o.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

select * from order_items oi
left join orders o on o.order_id = oi.order_id where o.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

select * from order_items oi
full outer join orders o on o.order_id = oi.order_id where o.order_id = '7dfff541b2a848ecb18ceb83d02bfa6a';

select order_id, count(*) from orders group by order_id having count(*)>2;
select order_id, count(*) from order_items group by order_id having count(*)>2;

SELECT 
    tb1.order_id,
    tb2.order_id,
    tb1.item_count,
    tb2.order_count
FROM (
    SELECT 
        order_id,
        COUNT(*) AS item_count
    FROM order_items
    GROUP BY order_id
    ) AS tb1
 right join (
    SELECT 
        order_id,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY order_id
) AS tb2
ON tb1.order_id = tb2.order_id;


SELECT o.order_id, r.review_score
FROM raw.orders o
LEFT JOIN raw.order_reviews r
  ON r.order_id = o.order_id
WHERE r.review_score = 5;

select o.order_id, r.review_score
from orders o
left join order_reviews r on o.order_id = r.order_id ;--- 99992

select o.order_id, r.review_score
from orders o
left join order_reviews r on o.order_id = r.order_id where r.review_score = 5;---57328

select o.order_id, r.review_score
from orders o
left join order_reviews r on o.order_id = r.order_id and r.review_score = 5; ---99693


select * from order_items where order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';
select * from order_payments where order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';

select oi.order_id,
	   sum(oi.price) as price,
	   sum(oi.freight_value) as freight_value,
	   sum(p.payment_value) as payment
from order_items oi
join order_payments p
on oi.order_id = p.order_id
where oi.order_id = '00143d0f86d6fbd9f9b38ab440ac16f5'
group by oi.order_id;


select oi.order_id,
	   sum(oi.price) as revenue,
	   sum(p.payment_value) as payment
from order_items oi
join order_payments p on p.order_id = oi.order_id
where oi.order_id = '00143d0f86d6fbd9f9b38ab440ac16f5'
group by oi.order_id; -- wrong, beacasue payment327.87

select oi.order_id,
	   oi.price as price,
	   oi.freight_value as freight_value,
	   p.payment_value as payment
from order_items oi
join order_payments p
on oi.order_id = p.order_id
where oi.order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';
--group by oi.order_id;

select oi.order_id,
	   oi.Total_price,
	   oi.Total_freight_value,
	   p.total_payment
from (select order_id,
	   sum(price) as Total_price,
	   sum(freight_value) as Total_freight_value
	from order_items group by order_id ) 
as oi
join 
	(select order_id,sum(payment_value) as total_payment
	from order_payments group by order_id) 
as p
on oi.order_id = p.order_id
where oi.order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';




