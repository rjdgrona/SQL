use sakila;
select * from actor;

-- 1a
select first_name, last_name from actor;

-- 1b
select concat(first_name," ", last_name) as 'Actor Name' from sakila.actor;

-- 2a
select actor_id, first_name, last_name from sakila.actor where first_name = 'Joe';

-- 2b
select actor_id, first_name, last_name from sakila.actor where last_name like '%gen%';

-- 2c
select last_name, first_name from sakila.actor where last_name like '%li%' order by last_name, first_name;

-- 2d
select country_id, country from country
where country in (
select country from country where country = "Afghanistan" or country ="Bangladesh" or country = "China" 
);

-- 3a
alter table actor
add column description blob;

-- 3b
alter table actor
drop column description;

-- 4a
select last_name, count(last_name) as 'no_last_name'
from actor group by last_name;

-- 4b
select last_name, count(last_name) as 'no_last_name'
from actor group by last_name
having count(last_name) > 1;

-- 4c
update actor set first_name = 'HARPO' 
where first_name='GROUCHO'and last_name = 'WILLIAMS';
-- select * from actor where first_name='HARPO';

-- 4d
update actor set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';
-- select *from actor where first_name = 'GROUCHO';

-- 5a
show create table address;

-- 6a 
select * from staff;
select * from address;
select first_name, last_name, address
from staff  inner join address 
on staff.address_id = address.address_id;

-- 6b
select * from staff;
select * from payment;
select staff.staff_id, first_name, last_name, sum(amount)
from payment inner join staff 
on staff.staff_id = payment.staff_id
and (payment.payment_date >= '2005-08-01'and payment.payment_date <= '2005-08-31')
group by staff.staff_id;

-- 6c
select * from film_actor;
select * from film;
select film_actor.film_id, title, count(actor_id) as "No. of Actors"
from film_actor inner join film
on film.film_id = film_actor.film_id
group by film_actor.film_id;

-- 6d
select film_id, count(film_id) as 'Film Count'
from inventory where film_id in 
(
select film_id from film where title = 'Hunchback Impossible'
)
group by film_id;

-- 6e
select * from payment;
select * from customer;
select first_name, last_name, sum(amount) as 'Total Amount Paid'
from payment inner join customer
on payment.customer_id = customer.customer_id
group by payment.customer_id
order by last_name;

-- 7a
select * from film;
select * from language;
select title, (select name from language where film.language_id = language.language_id) as 'language' from film 
where title like 'K%'or title like 'Q%';

-- 7b
select * from film;
select * from actor;
select * from film_actor;
select first_name, last_name 
from actor where actor_id in
(
select actor_id 
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
)
);

-- 7c
select * from customer;
select * from customer_list;
select first_name, last_name, email 
from customer where customer_id in 
(
    select id from customer_list where country = 'Canada'
);

-- 7d
select * from film;
select * from film_category;
select * from category;
select title 
from film
where film_id in 
(
select film_id
from film_category
where category_id in
(
select category_id
from category 
where name = 'Family'
)
);

-- 7e
select * from film;
select * from rental;
select * from inventory;
select film.title, count(title) as 'Rent Count'
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by title
order by count(title) desc;


-- 7f
select store, total_sales
from sales_by_store;

-- 7g
select * from store;
select * from address;
select * from city;
select * from country;
select store_id, city, country.country from store
inner join address on address.address_id = store.address_id
inner join city on address.city_id = city.city_id
inner join country on country.country_id = city.country_id;

-- 7h
select * from category;
select * from film_category; 
select * from inventory;
select * from payment;
select * from rental;
select name,sum(amount) as 'revenue' from payment
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film_category on film_category.film_id = inventory.film_id
inner join category on film_category.category_id = category.category_id
group by name
order by revenue desc LIMIT 5;

-- 8a
create view top_five_genres as
select name,sum(amount) as 'revenue' from payment
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film_category on film_category.film_id = inventory.film_id
inner join category on film_category.category_id = category.category_id
group by name
order by revenue desc limit 5;


-- 8b
select * from top_five_genres; 

-- 8c
drop view top_five_genres;