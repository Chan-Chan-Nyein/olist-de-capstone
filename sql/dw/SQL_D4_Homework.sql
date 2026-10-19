--1. Revenue (SUM of price) by customer_state for delivered orders. Top 10 states.
--select count(*) from customers; --99441
--select count(*) from order_items; --112650

--select count(distinct customer_id) as Total_customers, --99441
      -- count(distinct customer_unique_id) as total_customer_unique_id --96096
--from customers;

--select customer_unique_id,count(*) from customers group by customer_unique_id having count(*)>1;
--select customer_id,count(*) from customers group by customer_id having count(*)>1;-- primany key

--select * from customers;
--select * from order_items;
--select * from orders;

--select order_id,count(*) from order_items group by order_id having count(*)>1; --forgein key
--select product_id,count(*) from order_items group by product_id having count(*)>1; -- forgein key
--select seller_id,count(*) from order_items group by seller_id having count(*)>1; -- forgein key

--select order_id,count(*) from orders group by order_id having count(*)>1;--primary key
--select customer_id,count(*) from orders group by customer_id having count(*)>1; -- primary 

select c.customer_state,sum(price) as revenue from orders o 
inner join customers c on o.customer_id = c.customer_id
inner join order_items oi on oi.order_id = o.order_id 
group by c.customer_state
order by revenue desc limit 10;



--2. How many orders have no review at all? (anti-join)
select * from order_reviews;
select * from orders ;
select count(*) from order_reviews group by order_id having count(*)>1;
set search_path = raw;

from 
	(select o.order_id,oi.review_score
	from orders o 
	left join order_reviews oi on o.order_id = oi.order_id
	where oi.review_score is null);


--3. Top 10 product categories in English by items sold. Why LEFT JOIN to the translation?
--select * from category_translation;
--select * from order_items;
--select * from products;
--select count(*) from order_items group by order_id having count(*)>1; --foregin key
--select count(*) from products group by product_id having count(*)>1; --primary key
--select count(*) from products group by product_category_name  having count(*)>1; -- foregin key
--select count(*) from category_translation group by product_category_name having count(*)>1; -- primary key

--select count(*), product_id 
--from order_items group by product_id;

--select p.product_id ,p.product_category_name 
--from products p;

select ct.product_category_name_english  ,count(*)
from order_items oi
left join products p on oi.product_id =p.product_id 
left join category_translation ct on ct.product_category_name = p.product_category_name 
group by ct.product_category_name_english 
order by count(*) desc
limit 10;

Reason using left join is to include all order_items from order_items table


--4. What share(percentage) of order items were sold by a seller in the same state as the customer?

--select count(*) from sellers group by seller_id having count(*)>1;--primary
--select count(*) from order_items group by seller_id having count(*)>1;--foregin

--select s.seller_state ,sum(oi.total_sold_items )/100 as total_sold_items from 
--(select seller_id,count(*) as total_sold_items
--from order_items group by seller_id) oi
--left join sellers s on oi.seller_id = s.seller_id
--group by s.seller_state ;
set search_path = raw;

select * from sellers ; --state
select * from orders; --cuid,
select * from customers; --cu_state,cusomerid
select * from order_items; --seller_state,sellerid

select 
		sum(case when s.seller_state = c.customer_state then 1 else 0 end) as same_state,
		count(*) as total_items,
		round(100.0*sum(case when s.seller_state = c.customer_state then 1 else 0 end)/count(*) ,1) as share
from order_items oi 
join sellers s on s.seller_id = oi.seller_id
join orders o on o.order_id = oi.order_id
join customers c on c.customer_id = o.customer_id;




--5. For 5 orders, show item revenue and payment total side by side — without fan-out.
--select * from order_items oi ;
--select * from order_payments;
--select count(*) from order_payments group by order_id having count(*)>1; --f
--select count(*) from order_items group by order_id having count(*)>1; --f
set search_path = raw;
select p.order_id,(total_price+total_freight_value ) as revenuue ,p.total_payment from
     (select order_id ,sum(price) as total_price, sum(freight_value) as total_freight_value
     from order_items group by order_id) as oi
     right join
     (select order_id, sum(payment_value ) as total_payment
     from order_payments group by order_id) as p
     on oi.order_id = p.order_id 
order by total_payment desc
limit 5;

--select count(*)   from 
     --(select order_id ,sum(price) as total_price, sum(freight_value) as total_freight_value
    -- from order_items group by order_id);-- 98666
--select count(*) from
    -- (select order_id, sum(payment_value ) as total_payment
     --from order_payments group by order_id); -- 99440

--6. Find orders where payments differ from price + freight by more than 1.00.

select order_id,revenue-total_payment as difference from
(select p.order_id,oi.total_price+oi.total_freight_value as revenue,p.total_payment from
     (select order_id ,sum(price) as total_price, sum(freight_value) as total_freight_value
     from order_items group by order_id) as oi
     right join
     (select order_id, sum(payment_value ) as total_payment
     from order_payments group by order_id) as p
     on oi.order_id = p.order_id 
order by total_payment desc)
where revenue-total_payment >1;


