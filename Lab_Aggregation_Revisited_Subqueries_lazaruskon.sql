-- Lab | Aggregation Revisited - Subqueries --

-- Write the SQL queries to answer the following questions:
use sakila;

-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
select * from customer;
select * from rental;

select first_name, last_name, email from customer
where customer_id in (
select customer_id from rental
);

-- same with joins as a sanity check
select cu.first_name, cu.last_name, cu.email from customer cu
join rental r
on r.customer_id = cu.customer_id
group by cu.customer_id;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
-- getting the tables
select * from customer;
select * from payment;

-- getting the subqueries
select customer_id from customer;
select avg(amount) as average_payment from payment;
select concat(first_name, " ", last_name) as customer_name from customer;

-- Final query
create or replace view average_customer_payment as
with average_customer_payment as (
select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name, round(avg(p.amount), 2) as average_payment
from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id
)
select * from average_customer_payment;

select * from average_customer_payment;

-- same but with aggregations as a sanity check
select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name, round(avg(p.amount),2) as average_payment from customer c
join payment p
on c.customer_id = p.customer_id
group by c.customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
        -- Write the query using multiple join statements
        -- Write the query using sub queries with multiple WHERE clause and IN condition
        -- Verify if the above two queries produce the same results or not
select * from customer;
select * from rental;
select * from inventory;
select * from film_category;
select * from category; # checking out which tables I need

select cu.first_name, cu.last_name, cu.email from customer cu
join rental r
on r.customer_id = cu.customer_id
join inventory i
on i.inventory_id = r.inventory_id
join film_category fc
on fc.film_id = i.film_id
join category c
on c.category_id = fc.category_id
where c.name = "Action"
group by cu.customer_id;

select first_name, last_name, email from customer
where customer_id in (
select customer_id from rental 
where inventory_id in (
select inventory_id from inventory
where film_id in (
select film_id from film_category
where category_id in (
select category_id from category
where name = "Action"
)
)
)
)
;

-- 4. Use the case statement to create a new column classifying existing columns as either low or high value transactions based on the amount of payment. 
-- If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
select * from payment;

select *,
case
when amount between 0 and 2 then "low"
when amount > 4 then "high"
else "medium"
end as "classifing"
from payment;

# Note: I'm not sure about this question. I just did this with a simple case statement but I find the phrasing of the question unclear.

# Note2: I worked on this Lab together with Victor so if our code is similar or the same is because of that. <3