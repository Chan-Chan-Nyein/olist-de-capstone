-- Sellers with at least one 1-star review
SELECT s.seller_id
FROM raw.sellers s
WHERE EXISTS (
  SELECT 1 FROM raw.order_items oi
  JOIN raw.order_reviews r
    ON r.order_id = oi.order_id
  WHERE oi.seller_id = s.seller_id
    AND r.review_score = 1);

set search_path = raw;
select s.seller_id,r.review_score,oi.seller_id
from order_items oi
join order_reviews r on r.order_id = oi.order_id 
join sellers s on s.seller_id = oi.seller_id
where r.review_score=1 ;

select * from order_items;
select * from sellers;
select * from order_reviews;
select * from orders;

select count(*) from order_reviews where order_id is null;
select count(*) from order_items where order_id is null;
select count(*) from order_reviews;--99224
select count(*) from order_items;--112650

select *
from raw.order_items oi join raw.orders o on o.order_id = oi.order_id ;

select *
from raw.order_items oi left join raw.order_reviews o on o.order_id = oi.order_id where o.order_id is null;


select s.seller_id
from sellers s
where exists 
(select 1 from raw.order_items oi 
join raw.order_reviews r on r.order_id = oi.order_id 
where oi.seller_id = s.seller_id
and r.review_score =3
);

