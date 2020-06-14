/*
from: pick the tables
where: filter the rows
group by: aggregate rows
having: filter aggregates
select: select the columns (distinct after expressions are resolved)
order by: sorts rows
limit: limit rows
*/

select
  case
    when length < 60 then 'short'
    when length between 60 and 120 then 'medium'
    when length > 120 then 'long'
    else 'short'
  end as film_length,
  count(*)
from film
group by 
  case
    when length < 60 then 'short'
    when length between 60 and 120 then 'medium'
    when length > 120 then 'long'
    else 'short'
  end;
  
select
  case
    when length < 60 then 'short'
    when length between 60 and 120 then 'medium'
    when length > 120 then 'long'
    else 'short'
  end as film_length,
  count(*)
from film
group by 1;

select
  sum(case when rating in ('R', 'NC-17') then 1 else 0 end) as adult_films,
  count(*) as total_films
from film;

select
  count(case when rating in ('R', 'NC-17') then 1 end) as adult_films
from film;

select
  count(*) filter(where rating in ('R', 'NC-17')) as adult_films
from film;

select
  count(*) filter(where rating in ('R', 'NC-17')) as adult_films,
  count(*) filter(where rating = 'G' and length > 120) as long_kids
from film;

select
  int '33',
  '33'::int,
  cast('33' as int);

-- numeric(precision, scale) same as decimal(precision, scale)
-- real 6 decimal digit, double 15 decimal digits

select
  0.4235::numeric(5, 4) * 10000000,
  0.4235::real * 10000000;
  
select 
  round(100.00 * count(case when rating = 'G' then 1 end) / count(*)) as "% G",
  round(100.00 * count(case when rating = 'PG' then 1 end) / count(*)) as "% PG",
  round(100.00 * count(case when rating = 'PG-13' then 1 end) / count(*)) as "% PG-13",
  round(100.00 * count(case when rating = 'NC-17' then 1 end) / count(*)) as "% NC-17",
  round(100.00 * count(case when rating = 'R' then 1 end) / count(*)) as "% R"
from film;

select int '33';
select cast(33.3 as int); -- this works
-- select int 33.3; -- this doesn't, why? (syntax error)
-- select int '33.3'; -- invalid input syntax
select cast(33.8 as int); -- 34
select 33::text;
select 'hello'::varchar(2); -- he
select cast(35000 as smallint); -- smallint out of range
select 12.1::numeric(1,1); -- prection = 1, scale = 1 must round to an absolute value less than 1

select
  '2018-01-01 3:00 Australia/Brisbane'::timestamptz,
  '2018-01-01 3:00 +10'::timestamptz,
  '2018-01-01 3:00 AEST'::timestamptz;
  
select 
  '2018-01-01 3:00 EST'::timestamptz; -- output shown relative to your local timezone
  
show timezone; -- America/Chicago
-- postgres stores datetime internally as UTC
-- for conversion in and display out

select 
  '2018-01-01 3:00 EST'::timestamptz at time zone 'Australia/Perth';
  
select timestamptz '2018-01-01 08:35 +8' - timestamptz '2018-01-01 08:35 +5';

select
  customer_id,
  justify_hours(sum(return_date - rental_date)) as "sum_duration"
from rental
group by customer_id
order by sum_duration desc;

select date_part('hour', timestamptz '2018-01-01 08:35 +8');

select '2015-12-05 03:00 UTC'::timestamptz - '2015-11-05 02:00 UTC'::timestamptz;

select date_part('hour', '2015-12-05 03:00 UTC'::timestamptz - '2015-11-05 02:00 UTC'::timestamptz);

-- number of hours between two timestamps
select date_part('epoch', '2015-12-05 03:00 UTC'::timestamptz - '2015-11-05 02:00 UTC'::timestamptz) / 3600;

select date_trunc('year', '2015-12-05 03:00 UTC'::timestamptz);

select
  current_date,
  current_time,
  current_timestamp;

select distinct(utc_offset)
from pg_timezone_names
order by utc_offset desc;

select *
from pg_timezone_abbrevs;

select 
  title, 
  make_interval(days => rental_duration) as "duration",
  make_interval(days => rental_duration + 1) as "duration +1"
from film;

select 
  date_part('hour', rental_date) as "hr",
  count(*) as "count"
from rental
group by hr
order by hr;

select
  date_part('year', payment_date) as "year",
  date_part('month', payment_date) as "month",
  sum(amount) as total
from payment
group by "year", "month"
order by "year", "month";

select
  date_trunc('month', payment_date) as "year_month",
  sum(amount) as "total"
from payment
group by year_month
order by year_month;

select 
  rental_date,
  (date_trunc('month', rental_date) + interval '1 month' - interval '1 day') as "end_of_month"
from rental;

select
  count(*) 
  filter(
    where 
      date_trunc('day', rental_date) = (date_trunc('month', rental_date) + interval '1 month' - interval '1 day'))
      as "total # EOM rentals"
from rental;

select 
  count(*) filter(where length(trim(title)) != length(title))
from film;

select
  customer_id,
  round(sum(date_part('epoch', return_date - rental_date) / 3600)) as "hrs_rented"
from rental
where return_date is not null
group by customer_id
order by hrs_rented desc
limit 3;

select *
from 
  generate_series('2019-01-01 17:00:00 UTC'::timestamptz, '2019-12-01 17:00:00 UTC', '1 month') as "generate_series";

select
  first_name,
  length(first_name) - length(replace(first_name, 'A', '')) as "count"
from customer
order by count desc, first_name;

select
  sum(case when extract(dow from payment_date) in (0, 6) then amount end) as "total $"
from payment;

 select film_id, store_id
 from film
  cross join store
order by film_id, store_id;
  
select * from store;

select customer.email, staff.email
from customer
  cross join staff;

select c.email, s.*
from customer as c
  cross join staff as s;

select * from customer cross join staff; -- modern cross join syntax
select * from customer, staff; -- old style cross join syntax

-- inner join = cross join + filter
select rental_date, first_name, last_name
from rental
  inner join customer
    on rental.customer_id = customer.customer_id;
 -- inner join on foreign key pulls entity for column
 -- no match then no row would appear from the rental table
 
select *
from film
where film_id = 803;

select *
from film_actor
where film_id = 803;

select *
from film as f
  inner join film_actor as fa
    on f.film_id = fa.film_id;
  -- where f.film_id = 803;
  
select
  c.first_name || ' ' || c.last_name as "customer",
  city.city,
  ctry.country
from customer as c
  inner join address as addr
    on c.address_id = addr.address_id
  inner join city
    on addr.city_id = city.city_id
  inner join country as ctry
    on city.country_id = ctry.country_id;
  
select
  c.first_name || ' ' || c.last_name as "customer",
  city.city,
  country.country
from customer as c
  inner join address using (address_id)
  inner join city using (city_id)
  inner join country using (country_id); 
-- by default 'join' performs an 'inner-join'

-- old school syntax = cross join + filter (where clause)
select *
from rental, customer
where rental.customer_id = customer.customer_id;

select rental.rental_date, film.title
from customer
  inner join rental using (customer_id)
  inner join inventory using (inventory_id)
  inner join film using (film_id)
where first_name = 'PETER' and last_name = 'MENARD'
order by rental.rental_date desc;

select
  store_id, manager, email
from store
  inner join store.manager_staff_id = staff.staff_id

select rental.rental_date, film.title
from customer
  inner join rental using (customer_id)
  inner join inventory using (inventory_id)
  inner join film using (film_id)
where first_name = 'PETER' and last_name = 'MENARD'
order by rental.rental_date desc;

select
  store.store_id,
  staff.first_name || ' ' || staff.last_name as "Manager",
  email
from store
  inner join staff
    on store.manager_staff_id = staff.staff_id;
    
select
  film.film_id,
  film.title,
  count(rental.rental_id) as "count"
from rental
  inner join inventory using (inventory_id)
  inner join film using (film_id)
group by film.film_id
order by count desc
limit 3;

select
  customer_id,
  count(distinct(film_id)) as "num_films",
  count(distinct(actor_id)) as "num_actors"
from rental
  inner join inventory using (inventory_id)
  inner join film using (film_id)
  inner join film_actor using (film_id)
group by customer_id;

select film.title, language.name as "language"
from film, language
where film.language_id = language.language_id;

select
  film.title,
  language.name as "language"
from film
  inner join language
    on film.language_id = language.language_id;
  
select
  film.title,
  language.name as "language"
from film
  inner join language using (language_id);

-- cross join: cartesian product
-- inner join: cross join + filtering
-- outer join: cross join + filtering + add missing rows (left, right, full outer)

-- left, right, full => add rows back from which table

select f.film_id, f.title, fa.actor_id
from film as f
  inner join film_actor as fa
    on f.film_id = fa.film_id
order by f.film_id;

-- left outer join = left join (outer is implied)
-- often times instead of right join you can flip order of tables
select f.film_id, f.title, fa.actor_id
from film as f
  left outer join film_actor as fa
    on f.film_id = fa.film_id
order by f.film_id;

-- full outer join adds missing rows from left and right table

select f.film_id, f.title, fa.actor_id
from film as f
  left outer join film_actor as fa
    on f.film_id = fa.film_id
where fa.actor_id is null
order by f.film_id;

-- how many actors in each film (for ALL films)
-- if there are no actors, num_actors = 0
select 
  f.film_id, 
  f.title, 
  count(fa.actor_id) as "num_actors"
from film as f
  left outer join film_actor as fa
    on f.film_id = fa.film_id
group by f.film_id, f.title
order by num_actors desc;

-- commonly left join with generated date table (e.g. every day in certain time interval)
-- generate series


-- show full name & include films with no actors
-- be careful when following outer join with inner join
-- get around by control grouping so join film table with a new table that is already an inner joined version
-- of the film_actor and actor tables
select f.film_id, f.title, fa.actor_id, a.first_name, a.last_name
from film as f
  left join 
    (film_actor as fa
    inner join actor as a
      on fa.actor_id = a.actor_id) -- join film on new table of (film_actor + actor)
    on f.film_id = fa.film_id
order by f.film_id;

-- self, non-equi and composite joins
select
  c1.first_name || ' ' || c1.last_name as "customer1",
  c2.first_name || ' ' || c2.last_name as "customer2"
from customer as c1
  cross join customer as c2;
  
select
  c1.first_name || ' ' || c1.last_name as "customer1",
  c2.first_name || ' ' || c2.last_name as "customer2"
from customer as c1
  inner join customer as c2
    on c1.customer_id > c2.customer_id;-- non-equi join (n choose 2 or pairing)
    
-- composite joins (multiple join conditions)
select
  c1.first_name || ' ' || c1.last_name as "customer1",
  c2.first_name || ' ' || c2.last_name as "customer2"
from customer as c1
  inner join customer as c2
    on c1.customer_id > c2.customer_id
    and c1.customer_id <= 3
    and c2.customer_id <= 3;

-- not quite
select 
  customer.customer_id,
  count(rental.rental_id) as "num_rented"
from rental
  left outer join customer
    on customer.customer_id = rental.customer_id
where date_trunc('day', rental_date) = '2005-05-24'
group by customer.customer_id;

select
  customer.customer_id,
  count(rental.rental_id) as "num_rented"
from customer
  left outer join rental
    on customer.customer_id = rental.customer_id
    and date_trunc('day', rental.rental_date) = '2005-05-24'
group by customer.customer_id
order by num_rented desc, customer.customer_id;

-- scalar sub query
select title, length
from film
where length > (select avg(length) from film) -- uncorrelated subquery (no dependence or relationship to the main query)
order by length, title; -- always enclose in parenthesis

select
  customer_id,
  sum(amount) as cust_amount,
  100.00 * sum(amount) / (select sum(amount) from payment) as pct
from payment
group by customer_id
order by pct desc;

-- sub query can also return a single column of values
-- perform test for membership (in / not in)
select title, rating
from film
where rating in ('PG', 'PG-13');

-- dynamically get PG & PG-13
select title, rating
from film
where rating in
  (select distinct rating
    from film
    where left(cast(rating as text), 2) = 'PG');
  
-- find actors who haven't been in any R rated movies
select *
from actor
where actor_id not in
  (select distinct actor_id
  from actor
    inner join film_actor using (actor_id)
    inner join film using (film_id)
  where rating = 'R');

-- do the same thing using joins?
-- subquery expressions: exists, in, not in, any, some, all

-- exists in the context of correlated subqueries

select
  distinct
  first_name,
  last_name
from customer
  inner join rental using (customer_id)
where date_trunc('day', rental_date) = (select date_trunc('day', min(rental_date)) from rental)
order by first_name asc;

select 
  film_id,
  title
from film 
where film_id not in (select distinct film_id from film_actor)
order by film_id asc;

select
  film.film_id,
  film.title
from film
  left outer join film_actor using (film_id)
where actor_id is null
order by film.film_id asc;

select
  film_id,
  count(film_id) as "rental_count"
from rental
  inner join inventory using (inventory_id)
group by film_id
order by rental_count asc, film_id asc;

select
  film_id,
  count(film_id) as "rental_count"
from customer
  inner join rental using (customer_id)
  inner join inventory using (inventory_id)
group by film_id
order by rental_count asc, film_id asc;

select
  customer_id,
  first_name,
  last_name
from customer
  inner join rental using (customer_id)
  inner join inventory using (inventory_id)
where film_id = 
  (select inventory.film_id
  from rental
    inner join inventory using (inventory_id)
  group by inventory.film_id
  order by count(*) asc, inventory.film_id asc
  limit 1);

-- uncorrelated subquery independent of outer query
-- correlated subquery is dependent on outer query and is run once for each potential row of output in the main/outer query

select c.customer_id, c.first_name, c.last_name,
  (select max(r.rental_date) -- can't run this subquery on its own
  from rental as r
  where r.customer_id = c.customer_id) as "recent_rental"
from customer as c;

-- return all customers who have spent < $100
select 
  c.customer_id, 
  c.first_name, 
  c.last_name
from customer as c
where (select 
        sum(amount) as "total_amount" 
      from payment
      where payment.customer_id = c.customer_id) < 100;
      
-- exists keyword to find all customers who have made a payment
select 
  c.customer_id, 
  c.first_name, 
  c.last_name
from customer as c
where exists -- checks for the existence of some rows, don't care about the value
  (select 
    * -- could also use `select 1`
  from payment
  where payment.customer_id = c.customer_id);
  
-- ^ the above query could also have been done with joins.

-- advanced use case for correlated sub query: obtaining previous or next values
-- for each rental, return the date of the previous rental for the same customer
select
  r1.rental_id,
  r1.customer_id,
  r1.rental_date,
  (select max(r2.rental_date)
  from rental as r2
  where r2.customer_id = r1.customer_id
    and r2.rental_date < r1.rental_date) as "prev_rental_date"
from rental as r1
order by r1.customer_id, r1.rental_date;

-- window functions are more performant for answering questions
-- about previous/next or sequence order

-- subquery in select or where clause to return
-- a single value or a single column of values
-- subqueries can also return tables (rows and columns of data)

-- returns table in from clause => table subquery or derived table
-- show the average number of rentals per customer
-- 1) aggregate rentals by customer - return for each customer how many rentals they've made
-- 2) the average all of the different counts
select 1.0 * count(rental_id) / count(distinct(customer_id)) as "avg_rentals"
from rental;

select avg(t.rental_count)
from (select customer_id, count(*)
      from rental
      group by customer_id) as t(customer, rental_count); -- t(customer, rental_count) renames the returned columns to
                                                          -- customer and rental_count
      
-- useful for doing multiple passes over data
-- first pass in tabled subquery, second pass in the outer query
-- table subqueries can also side step order of operations issues
-- i.e. refering to derived columns created in select clause in where clause
-- from, where, group by, having, select, order by, limit

select
  title,
  rental_rate,
  replacement_cost,
  ceil(replacement_cost / rental_rate) as break_even
from film
where ceil(replacement_cost / rental_rate) > 30;

-- refer to the break_even column in the where clause because
-- the break_even column now comes from the virtual table
-- we created
select *
from
  (select
    title,
    rental_rate,
    replacement_cost,
    ceil(replacement_cost / rental_rate) as break_even
  from film) as t
where t.break_even > 30;

-- use subqueries to generate own table with values you define
select *
from
  (values
    ('short', 0, 60),
    ('medium', 60, 120),
    ('long', 120, 10000)) as c("desc", "min", "max");
-- instead of writing a complex case expression we can join film table onto this derived table
select f.film_id, f.title, f.length, c.length_desc
from film as f
  inner join
    (values
      ('short', 0, 60),
      ('medium', 60, 120),
      ('long', 120, 10000)) as c("length_desc", "min", "max")
    on f.length >= c.min and f.length < c.max;

select
  first_name,
  last_name
from customer
  cross join (values (1), (2), (3), (4)) as v(n);

select *
from (values (1), (2), (3), (4)) as v(n);

select
  dow,
  round(avg(dow_count)) as "average"
from
(select
  count(*) as "dow_count",
  date_trunc('day', rental_date) as rental_date_trunc,
  extract (dow from rental_date) as "dow"
from rental
group by rental_date_trunc, dow
order by dow_count, rental_date_trunc) as t
group by dow;

select *
from (values (0, 'Sunday'),
             (1, 'Monday'), 
             (2, 'Tuesday'), 
             (3, 'Wednesday'),
             (4, 'Thursday'),
             (5, 'Friday'), 
             (6, 'Saturday')) as d("dow", "day_name");
             
select
  day_name,
  average
from (select
  dow,
  round(avg(dow_count)) as "average"
from
(select
  count(*) as "dow_count",
  date_trunc('day', rental_date) as rental_date_trunc,
  extract (dow from rental_date) as "dow"
from rental
group by rental_date_trunc, dow
order by dow_count, rental_date_trunc) as t
group by dow) as v inner join (select *
from (values (0, 'Sunday'),
             (1, 'Monday'), 
             (2, 'Tuesday'), 
             (3, 'Wednesday'),
             (4, 'Thursday'),
             (5, 'Friday'), 
             (6, 'Saturday')) as d("dow", "day_name")) as w
             on v.dow = w.dow;

-- powerful tool for extending table subqueries = lateral subqueries
-- return the 3 most recent rentals for each customer
-- join the customer table onto another table which contains the 3 most recent rentals for each customer
-- want it to be a correlated tabled subquery
-- this will not run as is
-- previously we could refer to outer query from inner query
-- but when you are doing this with tabled subqueries. i.e. inside the `from` clause
-- you have to make use of a new key word `lateral`
select c.customer_id, d.rental_id, d.rental_date
from customer as c
  inner join
    (
      select
        r.customer_id,
        r.rental_id,
        r.rental_date
      from rental as r
      where r.customer_id = c.customer_id
      order by r.rental_date desc
      limit 3
    ) as d
    on c.customer_id = d.customer_id;
  
-- now each customer has 3 rows in the output
-- lateral can be used with other types of joins
-- e.g. with left join there would be a row in the output for any customers who didn't make 3 rentals
-- lateral => perform join on correlated tabled subquery
-- table created for every row in the outer query
select c.customer_id, d.rental_id, d.rental_date
from customer as c
  inner join lateral
    (
      select
        r.customer_id,
        r.rental_id,
        r.rental_date
      from rental as r
      where r.customer_id = c.customer_id
      order by r.rental_date desc
      limit 3
    ) as d
    on c.customer_id = d.customer_id;

    -- customer -> rental -> inventory -> film
-- return for each customer the first 'PG' film they rented
-- include customers who have never rented a 'PG' film as well
select c.first_name, c.last_name, d.title, d.rental_date
from customer as c
  left join lateral
    (select r.customer_id, f.title, r.rental_date
     from rental as r
       inner join inventory as i using (inventory_id)
       inner join film as f using (film_id)
     where r.customer_id = c.customer_id
       and f.rating = 'PG'
     order by r.rental_date
     limit 1) as d
    on c.customer_id = d.customer_id;

-- cte = common table expression -> simple code organization tool for working with tabled subqueries
-- improve readability. cte allows us to pull out the table definition in advance
select
  *
from
  (
  select
    title,
    rental_rate,
    replacement_cost,
    ceil(replacement_cost / rental_rate) as break_even
  from film
  ) as T
where break_even > 30;

-- cte allows us to pull out the tabled subquery definition and append it to the top of the query
 with film_stats as -- definition at top and easier to read. no longer deeply embedded
(
  select
    title,
    rental_rate,
    replacement_cost,
    ceil(replacement_cost / rental_rate) as break_even
  from film
)
select
  *
from film_stats
where break_even > 30;

 with film_stats(t, rr, rc, be) as -- rename table columns
(
  select
    title,
    rental_rate,
    replacement_cost,
    ceil(replacement_cost / rental_rate) as break_even
  from film
)
select
  *
from film_stats
 -- rename here as well
where be > 30;

-- we can have multiple cte definitions
-- each cte can refer to previous cte's
-- break out subqueries or nested subqueries
select
  to_char(rent_day, 'Day') as day_name,
  round(avg(num_rentals)) as average
from
  (-- inner subquery aggregates by date
  select
    date_trunc('day', rental_date) as rent_day,
    count(*) as num_rentals
  from rental
  group by rent_day
  ) as T
group by day_name
order by average desc;

with day_counts as
(
  select
    date_trunc('day', rental_date) as rent_day,
    count(*) as num_rentals
  from rental
  group by rent_day
),-- second cte separated by a comma
dow_counts as -- can refer to day_counts here since it's already been defined
(
  select
    to_char(rent_day, 'Day') as day_name,--timestamp to day of week
    round(avg(num_rentals)) as average
  from day_counts
  group by day_name
  order by average desc
)
select
  *
from dow_counts
where average > 450;
-- cte counteracts information density by making queries longer
-- cte can save some lines of code when dealing with complex self join queries
-- define table subquery once and refer to it multiple times in your query
-- rather than repeating same definition over again

with rental_detail as
(
  select
    r.customer_id,
    r.rental_date,
    f.title
  from rental as r
    inner join inventory as i using (inventory_id)
    inner join film as f using (film_id)
)
select
  rd1.customer_id
from rental_detail as rd1
  inner join rental_detail as rd2
    on rd1.customer_id = rd2.customer_id
    and rd2.rental_date > rd1.rental_date
    and rd2.title = 'STAR OPERATION'
    and rd1.title = 'BRIDE INTRIGUE';
    
with monthly_amounts as
(
  select
    date_trunc('month', payment_date) as "month",
    sum(amount) as "total"
  from payment
  group by month
  order by month asc
)
select
  curr.month,
  curr.total as "income",
  prev.total as "prev month income",
  curr.total - prev.total as "change"
from monthly_amounts as curr
  left join monthly_amounts as prev
    on curr.month = prev.month + interval '1 month';

with monthly_amounts as
(
  select
    date_trunc('month', payment_date) as "month",
    sum(amount) as "amount"
  from payment
  group by month
)
select
  ma1.month,
  ma1.amount,
  (
    select
      sum(ma2.amount)
    from monthly_amounts as ma2
    where ma2.month <= ma1.month
  ) as "cumamount"
from monthly_amounts as ma1
order by ma1.month;

with rental_series as
(
  select *
  from
  generate_series(
    (select min(rental_id) from rental),
    (select max(rental_id) from rental)) as id
),
rental_ids as
(
  select
    distinct(rental_id)
  from rental
)
select
  id
from rental_series
where id not in (select * from rental_ids);

select
  *
from
  (
    select 
      payment_id, 
      amount, 
      payment_date
    from payment
    where 
      payment_date >= '2007-01-01'
      and payment_date < '2007-02-01'
    order by payment_date desc
    limit 3
  ) as p
order by p.payment_date asc;

-- window functions allow us to perform for each row of some query
-- a calculation against a subset of related rows.
-- the subset of related rows is called the "window"
-- like correlated subqueries used in select clause but with some other nice adantages
-- 3 window functions that relate to ranking

-- select all rows from film table. no where, group by or having clauses
-- every row of the film table is ordered by it's length and then functions are ran over the rows
-- like creating a virtual table in the background
select
  title,
  length,
  row_number() over (order by length), -- function operates over window =  all rows of film table ordered by length
  rank() over (order by length),-- 1,2,2,2,5
  dense_rank() over (order by length) -- 1,2,2,2,3
from film;

-- when defining the window we can also introduce a partition keyword
-- partition has the effect of dividing the rows into groups
-- then window function only acts on one window partition at a time
-- partition key let's us apply functions over smaller subgroups

-- new window over each rating so row_number resets
-- row_number function operates over one window at a time
select
  title,
  length,
  rating,
  row_number() over (partition by rating order by length),
  rank() over (partition by rating order by length),
  dense_rank() over (partition by rating order by length)
from film;

-- what are window functions useful for?
-- what if I asked you: return three films with shortest length including ties
-- make the previous query a tabled subquery
select *
from
(
  select
    title,
    length,
    rating,
    row_number() over (order by length),
    rank() over (order by length),
    dense_rank() over (order by length)
  from film
) as t 
where rank <= 3;

-- other applications of window functions: calculating running totals, next and previous type questions

select
  rental_id,
  customer_id,
  rental_date
from
  (
  select
    customer_id,
    rental_id,
    rental_date,
    row_number() over (partition by customer_id order by rental_date desc)
  from rental
  ) as t
where row_number <= 3;

with rent_counts as
(
select
  film_id,
  count(*),
  rank() over (order by count(*))
from rental
  inner join inventory using (inventory_id)
group by film_id
)
select
  distinct customer_id
from rental as r
  inner join inventory as i using (inventory_id)
where i.film_id in
  (select
    film_id
  from rent_counts
  where rank = 1)
  
select rating
from
  (
    select
      rating,
      row_number() over (partition by rating)
    from film
  ) as t
where
  row_number = 1
  and rating is not null;

-- look at some of the aggregate functions as window functions e.g. sum, count, avg
-- see for each film how its length compares to other films with the same rating

select
  title,
  rating,
  length,
  avg(length) over (partition by rating)
from film
order by rating, length, title;

-- add one more element to window functions
-- what does the window look like over the film 'MONTEREY LABYRINTH'?
-- the partition by clause restricts the window so it looks something like:
select
  avg(length)
from film
where rating = 'G';

-- partitions restricts window to rows that have matching value from the underlying query
select
  title,
  rating,
  length,
  avg(length) over (partition by rating)
from film
order by rating, length, title;

-- virtual table would look like
select
  avg(length)
from film
where rating = 'G'
order by avg;

-- third part we can add to a window definition
-- doesn't affect ranking function but will show up when using aggregate functions

-- look at some of the aggregate functions as window functions e.g. sum, count, avg
-- see for each film how its length compares to other films with the same rating

select
  title,
  rating,
  length,
  avg(length) over (partition by rating)
from film
order by rating, length, title;

-- add one more element to window functions
-- what does the window look like over the film 'MONTEREY LABYRINTH'?
-- the partition by clause restricts the window so it looks something like:
select
  avg(length)
from film
where rating = 'G';

-- partitions restricts window to rows that have matching value from the underlying query
select
  title,
  rating,
  length,
  avg(length) over (partition by rating)
from film
order by rating, length, title;

-- virtual table would look like
select
  avg(length)
from film
where rating = 'G'
order by avg;

-- partition, order by, window frame
-- third part we can add to a window definition
-- doesn't affect ranking functions but will show up when using aggregate functions (sum, avg, count)
-- called the window frame
-- window frame even further restricts the window
-- by default if you use order by, then the window frame will consist of all rows from the start
-- of the partition up to the current row
-- without an order by, the default window frame is all of the rows in the partition
-- again, this affects the aggregate functions and not ranking functions
select
  payment_date,
  amount,
  sum(amount) over () -- over is just an empty window, so for each payment we return the sum of all the payments i.e. unrestricted window
from payment;

-- now we see the total amount each customer has paid
select
  customer_id,
  payment_date,
  amount,
  sum(amount) over (partition by customer_id order by payment_date) -- using an order by clause in the window with an aggregate function
  -- so window frame effect will now kick in. window frame = all rows from start of partition up to current row
  -- now we have a running total
from payment;

select
  customer_id,
  payment_date,
  amount
from payment
where customer_id = 1
order by payment_date;

select
  customer_id,
  payment_date,
  amount,
  sum(amount) over (partition by customer_id 
                    order by payment_date
                    rows between unbounded preceding and current row) -- implicit when using aggregate function with window
from payment;

select
  customer_id,
  payment_date,
  amount,
  sum(amount) over (partition by customer_id 
                    order by payment_date
                    rows between unbounded preceding and unbounded following) -- this will restore previous behavior, no more running total
from payment;

-- want to visualize if the amount of money customers are spending is going up over time
-- could create a simple moving average e.g. average of the last 3 payments for each payment
-- this will help to smooth out plot as well and pick up trends

select
  customer_id,
  payment_date,
  amount,
  avg(amount) over (partition by customer_id 
                    order by payment_date
                    rows between 2 preceding and current row) as "avg_last_3"
from payment;

-- lag and lead window functions. useful for retreiving rows before or ahead of current row
-- deals with next and previous type questions that we previously dealt with using more complex self joins
-- lag and lead ignore window frames unlike aggregate functions

select
  rental_id,
  customer_id,
  rental_date,
  -- return for each rental the previous rental from the same customer
  lag(rental_date) over (partition by customer_id order by rental_date) as "previous_rental_date" -- date of previos rental from same customer
from rental;

-- there are two other optional arguments that can be passed to the lag function
-- 1) the number of rows to look back (default is one previous row based on ordering of the window)
-- 

select
  rental_id,
  customer_id,
  rental_date,
  -- look at the rental date from two rentals ago
  -- null is default if there is no corresponding row returned from lag function
  -- however we can override this value
  lag(rental_date, 2) over (partition by customer_id order by rental_date) as "previous_rental_date"
from rental;

-- return unix epoch date when there isn't lag 2
-- cast to timestamp so it matches the type of what lag is trying to return
select
  rental_id,
  customer_id,
  rental_date,
  lag(rental_date, 2, '1970-01-01'::timestamp) over (partition by customer_id order by rental_date) as "previous_rental_date"
from rental;

-- lead is used to look forward
select
  rental_id,
  customer_id,
  rental_date,
  lag(rental_date, 2, '1970-01-01'::timestamp) over (partition by customer_id order by rental_date) as "previous_rental_date",
  lead(rental_date) over (partition by customer_id order by rental_date) as "next_rental_date"
from rental;

-- other window functions: https://www.postgresql.org/docs/current/functions-window.html
-- percent_rank, ntile, cume_dist, first_value, last_value, nth_value
select
  rental_id,
  customer_id,
  rental_date,
  lag(rental_date, 2, '1970-01-01'::timestamp) over (partition by customer_id order by rental_date) as "previous_rental_date",
  lead(rental_date) over (partition by customer_id order by rental_date) as "next_rental_date",
  first_value(rental_date) over (partition by customer_id order by rental_date) as "first_value"
from rental;

-- first_value, nth_value, last_value consider rows within the window frame which by default contains the rows from the start of the
-- partition through the last peer of the current row

-- set operators allow us to combine the outputs from two sql select statements
-- union, intersect, except (all keeps duplicates) -> part of ANSI SQL not postgres specific
-- set operators (e.g. union) remove duplicate rows
-- union all keeps duplicates count(union all) = sum(counts)

-- output column names come from the names in the first query
-- give them the same name to avoid confusion
(
  select 
    first_name as fname, 
    last_name as lname
  from customer
)
union
(
  select 
    first_name as fname2,
    last_name as lname2
  from staff;
)

(
  select customer_id
  from customer
  where customer_id between 1 and 10
)
intersect
(
  select customer_id
  from customer
  where customer_id between 5 and 10
)
order by customer_id;

-- intersect all keeps duplicates
(
select n
from (values (1), (1), (3)) as v(n)
)
intersect all
(
select n
from (values (1), (1), (4)) as v(n)
);

-- filter or aggregate results after using a set filter
-- so far we have only used order by
-- where, group by or having won't work

-- except => implements set difference (A - B) = A without B => order matters
-- except returns distinct rows, except all returns duplicates

-- films that have never been rented out
(
  select
    film_id
  from film
)
except
(
select
  film_id
from rental
  inner join inventory using (inventory_id)
);

-- except all is trickier 

-- use predefine tables from value list
-- 2, 3
(
select n
from (values (1), (2), (3)) as v(n)
)
except
(
select n
from (values (1), (7), (8)) as v(n)
);


-- except all -> performs something closer to a minus operations
-- by doing a 1-1 match and removing matches
-- since there are two 1s and only one of them are matched up, we have one left over
(
select n
from (values (1), (1), (3)) as v(n)
)
except all
(
select n
from (values (1), (7), (8)) as v(n)
);

-- generally you can only use order by & limit on the result of a set operator
-- where and group by don't work
-- tabled subqueries to the rescue

select n
from 
(
  (
    select n
    from (values (1), (2), (3)) as v(n)
  )
  except all
  (
    select n
    from (values (1), (7), (8)) as v(n)
  )
) as t(n)
where n > 1
group by n;

with dows as
(
select
  first_name,
  last_name,
  customer_id,
  extract(dow from rental_date) as "dow"
from rental
  inner join customer using (customer_id)
)
(
select
  first_name,
  last_name
from dows
where dow = 6 -- Saturday
)
except
(
select
  first_name,
  last_name
from dows
where dow = 0 -- Sunday
)
order by first_name;


(
  -- rentals
  select 
    cast(rental_date as date) as interaction_date, 
    'rental' as type
  from rental
)
union
(
  -- payments
  select 
    cast(payment_date as date) as interaction_date, 
    'payment' as type
  from payment
)
order by interaction_date;

with address_country as
(
  select address_id, country
  from address
    inner join city using (city_id)
    inner join country using (country_id)
)
(
  select country
  from staff
    inner join address_country using (address_id)
)
intersect
(
  select country
  from customer
    inner join address_country using (address_id)
);

-- ddl: data definition language (create, alter, drop)
-- dml: data manipulation language (insert, update)
-- dcl: data control language (grant, revoke)
-- tcl: transaction contorl language (begin, commit, rollback)

drop schema if exists playground cascade;

create schema playground;

create table playground.users (
  email varchar(100) check (length(email) > 5 and position('@' in email) > 0),
  first_name varchar(100),
  last_name varchar(100),
  is_active boolean not null default true,
  constraint pk_users primary key (email)
);

create table playground.notes (
  note_id bigint generated by default as identity primary key,
  title text not null unique,
  note text not null,
  user_email varchar(100) references playground.users (email)
    on update cascade
    on delete cascade,
  create_ts timestamptz not null default now(),
  edit_ts timestamptz not null default now (),
  check (edit_ts >= create_ts)
);

create table playground.note_tags (
  note_id bigint,
  tag varchar(20) not null check (tag in ('work', 'personal', 'todo')),
  primary key (note_id, tag),
  foreign key (note_id) references playground.notes (note_id)
    on update cascade
    on delete cascade
);

-- postgres can read from public directory \Users\Public
-- but not from personal directories unless permissions have been set
-- C:\Users\carlc\Documents\mastery-with-sql\ch11-users.csv
copy playground.users
from 'C:\Users\carlc\Documents\mastery-with-sql\ch11-users.csv'
with (format csv, header true);

select * from playground.users;

-- csv file doesn't contain note_id or create/edit timestamps
copy playground.notes(title, note, user_email)
from 'C:\Users\carlc\Documents\mastery-with-sql\ch11-notes.csv'
with (format csv, header true);

select * from playground.notes;

copy playground.note_tags
from 'C:\Users\carlc\Documents\mastery-with-sql\ch11-note_tags.csv'
with (format csv, header true);

select * from playground.note_tags;

-- other options beside format and header
-- https://www.postgresql.org/docs/9.2/sql-copy.html

-- exporting data (true writes as `t`)
-- select cast('t' as boolean);
copy playground.users
to 'C:\Users\carlc\Documents\mastery-with-sql\ch11-users-out.csv'
with (format csv, header true);

-- export the results of a query
copy (
  select first_name || ' ' || last_name as "full_name"
  from playground.users
  where is_active = true
)
to 'C:\Users\carlc\Documents\mastery-with-sql\ch11-active-users.csv'
with (format csv, header true);

-- the copy command is a server command
-- so when importing or exporting the file has to be accessible to the server
-- otherwise use pgAdmin or psql copy command

begin;

update customer
set activebool = true
where exists
  (select *
  from rental
  where rental_date >= '2006-01-01'
    and rental.customer_id = customer.customer_id)
returning *;

rollback;

begin;

delete from payment
where exists
  (select *
  from customer
  where first_name = 'JOHN'
    and payment.customer_id = customer.customer_id)
returning *;

rollback;


-- truncate faster than delete because it's minimally logged
-- and doesn't scan the entire table

-- will need to drop constraints, truncate the table, then
-- add the constraints back


create view vw_address_details as
  select
    a.address_id,
    a.address,
    a.district,
    cty.city,
    ctry.country
  from address as a
    inner join city as cty using (city_id)
    inner join country as ctry using (country_id);
    
select *
from vw_address_details;

select
  vad.country,
  count(*)
from customer as c
  inner join vw_address_details as vad using (address_id)
group by vad.country
order by count(*) desc;

-- views can be used for more than convenience..
-- can also be used to control details that certain database users can see
-- if you want to limit reading from a certain table,
-- as a dba you can not grant the select permissions on that table
-- instead create a view which only shows the non sensitive information
-- and grant those db users access to it. i.e. manage what data is visible
-- can also update the data in tables through views
-- e.g. we can write an insert or update statement against the vw_address_details view
-- we created. But there are caveats. The query that defines the view has to adhere 
-- to certain rules or it won't work

drop view vw_address_details

-- materialized views -> cached view (can be refreshed manually)
-- used materialized views when the underlying view query is really expensive
-- e.g. using a query on a analytics dashboard we can cache results and update it less frequently

-- array_agg aggregates values into an array type
-- takes 1.3s to run
select
  c.customer_id,
  (select array_agg(r.rental_id)
  from rental as r
  where r.customer_id = c.customer_id) as rentals
from customer as c
order by c.customer_id;

create materialized view mvw_customer_rentals as
  select
    c.customer_id,
    (select array_agg(r.rental_id)
    from rental as r
    where r.customer_id = c.customer_id) as rentals
  from customer as c
  order by c.customer_id;
  
select *
from mvw_customer_rentals;

-- new customer rentals won't show up in the materialized view until it's refreshed

begin;

insert
into customer
(store_id, first_name, last_name, address_id, activebool, create_date) 
values (1, 'Carl', 'Corder', 1, true, now());

select count(*)
from mvw_customer_rentals;

refresh materialized view mvw_customer_rentals;

select count(*)
from mvw_customer_rentals;
  
rollback;

select count(*)
from mvw_customer_rentals;

-- set up automatic refresh policy with pg agent
-- pg-agent is a job scheduling agent for postgres databases
-- can run multi-step batch or shell scripts and sql tasks
-- https://www.pgadmin.org/docs/pgadmin4/development/pgagent.html

drop materialized view mvw_customer_rentals;

delete from customer where customer_id = 600;
select customer_id from customer;

-- postgres comes with 3 languages you can write functions with
-- 1) SQL 2) PL/pgSQL 3) C
-- install other languages through postgres extension framework
-- Python, Javascript, Perl, Java and more

-- write custom Aggregate Functions and use them as window functions
create or replace function popular_films
(
  in param_n int,
  in param_rating_mpaa_rating default 'PG',
  out title varchar(255),
  out description text,
  out length int2,
  out rating mpaa_rating
)
returns setof record
language sql
as $$
  select
    f.title,
    f.description,
    f.length,
    f.rating
  from rental as r
    inner join inventory as i using (inventory_id)
    inner join film as f using (film_id)
  where f.rating = $2
  group by f.film_id
  order by count(*) desc, f.title
$$;

-- function written in SQL
-- function returns popular films (based on how many times it's been rented out)
-- inputs:
-- n = number of films to return
-- rating = mpaa rating of film

create or replace function popular_films
(
  p_n int,
  p_rating mpaa_rating default 'PG'
  -- out description text,
  -- out length int2,
  -- out rating mpaa_rating
)
-- if functions returns a single value
-- can specify the type of return e.g. int2
-- if no return, return type is void
returns table -- setof record
(
  title varchar(255),
  description text,
  length int2,
  rating mpaa_rating
)
language sql
as $$ -- dollar quotes are string literals that have built in escaping
  select
    f.title,
    f.description,
    f.length,
    f.rating
  from rental as r
    inner join inventory as i using (inventory_id)
    inner join film as f using (film_id)
  where f.rating = p_rating -- or use `$2`
  group by f.film_id
  order by count(*) desc, f.title
  limit p_n;
$$;

-- immutable is an optimizer hint
-- use when function input params are contstant (and not tables)
create or replace function my_sum(a int, b int)
returns int
-- immutable
-- returns null on null input
language sql
as $$ select a + b $$;

select my_sum(3,5);

-- create function documentation
-- https://www.postgresql.org/docs/current/sql-createfunction.html
-- similar to a correlated subquery
-- RETURNS NULL ON NULL INPUT

-- functions written in PL/pgSQL
-- can loop over the results of a query like a set of records

create or replace function sum_n(n int)
returns int
language plpgsql
as $$
  declare

  begin

  end
$$;


-- should prefer to use sql if possible so the compiler
-- can inline the functions directly (i.e. optimize)
-- complex logic, need looping functionality
create or replace function add_one()
returns int
language plpgsql
as $$
  -- declare variables
  declare
    n int := 1;
  begin
    return n + 1;
  end
$$;

select add_one();

create or replace function circle_area(r numeric)
returns numeric
language plpgsql
as $$
  declare
    PI constant numeric := 3.14159;
  begin
    return PI * r * r;
  end
$$;

select circle_area(10.0);

create or replace function circle_area_desc(r numeric)
returns text
language plpgsql
as $$
  declare
    -- stuff
    PI constant numeric := 3.14159;
    circle_area numeric;
  begin
    circle_area := PI * r * r;
    if circle_area < 20 then
      return 'small circle';
    else
      return 'big circle';
    end if;
  end
$$;

select circle_area_desc(20);

create or replace function sum_n(n int)
returns int
language plpgsql
as $$
  declare
    s_n int := 0;
  begin
    for i in 1..n loop
      s_n := s_n + i;
    end loop;
    return s_n;
  end
$$;

-- gauss number
select sum_n(100);

-- incorporate standard sql queries into your 
-- PL/pg functions as well

-- drop function sum_n;
-- must drop before replacing if changing function's
-- parameters. Don't need to drop if just changing
-- the body of the function

create or replace function sum_i_to_n_customers()
returns int
language plpgsql
as $$
  declare
    n int;
    s_n int := 0;
  begin
    select count(*) into n
    from customer;
  
    for i in 1..n loop
      s_n := s_n + i;
    end loop;
    return s_n;
  end
$$;

select sum_i_to_n_customers();

select count(*) from customer;
-- does this work? No.
-- select sum_n((select count(*) from customer));
select sum_i_to_n_customers(), sum_n(599);

-- looping over the results of a query
-- try to write functions in terms of sql and think in
-- set operations. only resort to plpgsql when things
-- become more complex

-- postgresql.conf file
-- log_filename
-- log_statement
-- logging_collector
-- log_min_duration_statement

-- query planner takes sql and executes it procedurally
explain
select *
from actor
where first_name = 'MARY';
-- Seq Scan on actor  (cost=0.00..4.50 rows=2 width=25)
--  Filter: ((first_name)::text = 'MARY'::text)

-- explain doesn't execute the query, it just gives the query plan

-- see plan and execute
explain analyze
select *
from actor
where first_name = 'MARY';
--Seq Scan on actor  (cost=0.00..4.50 rows=2 width=25) (actual time=0.027..0.044 rows=2 loops=1)
--  Filter: ((first_name)::text = 'MARY'::text)
--  Rows Removed by Filter: 198
--Planning Time: 0.103 ms
--Execution Time: 0.063 ms

-- generally wrap `explain analyze` in a transaction block
-- to roll it back if needed

begin;
explain analyze
update actor
set last_update = now();
--Update on actor  (cost=0.00..5.00 rows=200 width=31) (actual time=11.234..11.234 rows=0 loops=1)
--  ->  Seq Scan on actor  (cost=0.00..5.00 rows=200 width=31) (actual time=0.365..0.559 rows=200 loops=1)
--Planning Time: 0.343 ms
--Execution Time: 12.469 ms
rollback;

-- seq scan reads entire table from disk
-- cost = initial value to total cost of step
-- start up cost is work that needs to be done 
-- before retrieving data from disk
-- width = number of bytes those rows will need
-- postgres maintains statistics about each of the tables
-- query planner uses table statistics to inform its plans
-- postrges will internally cache query plans and data

-- index impact on query performance
-- index, creates a new data structure that points to records in the table
-- fast look-ups vs scanning
-- creating an index comes with up front costs
-- maintained when doing inerst, updates, deletes
-- create index on table or materialized views
-- default index is b-tree structure (balanced search tree)
-- set primary key on table or create a unique constraint

create schema test;

create table test.messages (
  id int,
  account_id int,
  msg text
);

insert into test.messages (id, account_id, msg)
  select 
    id,
    random() * 100000, --random number between 0 - 100K
    substring('hello are you there?', (random() * 20)::int, 5)-- string has 20 characters
  from generate_series(1, 1000000) as s(id);

select * from test.messages;
-- ex: 1, 25899, ello

-- after loading large amount of data into a table
-- run the following command to ensure that statistics are up to date
vacuum analyze test.messages;

select *
from test.messages
limit 100;

explain analyze
select id, msg
from test.messages
where id = 33;

--  Workers Planned: 2
--  Workers Launched: 2
--  ->  Parallel Seq Scan on messages  (cost=0.00..10614.33 rows=1 width=9) (actual time=51.120..51.382 rows=0 loops=3)
--        Filter: (id = 33)
--        Rows Removed by Filter: 333333
--Planning Time: 0.351 ms
--Execution Time: 123.061 ms

-- performs a parallel sequential scan
-- parallelized queries execution is distributed by the planner
-- across multiple processess cores on hardware

create index on test.messages(id);

explain analyze
select id, msg
from test.messages
where id = 33;

--Index Scan using messages_id_idx on messages  (cost=0.42..8.44 rows=1 width=9) (actual time=0.065..0.066 rows=1 loops=1)
--  Index Cond: (id = 33)
--Planning Time: 1.432 ms
--Execution Time: 0.084 ms

-- now performs an index scan
-- went from 123.061 ms to 0.084 ms

-- default index name = append _idx
drop index test.messages_id_idx;

-- create a composite index
create index on test.messages(id, msg);

explain analyze
select id, msg
from test.messages
where id = 33;

--Index Only Scan using messages_id_msg_idx on messages  (cost=0.42..8.44 rows=1 width=9) (actual time=0.139..0.140 rows=1 loops=1)
--  Index Cond: (id = 33)
--  Heap Fetches: 1
--Planning Time: 1.501 ms
--Execution Time: 0.162 ms

-- this time we got an index only scan, which are typically
-- even fast than an index scan
-- we could do an index only scan because the data we requested
-- i.e. id & msg, could be obtained by looking at the index alone
-- no need to follow a pointer to retrieve the actual table data

-- adding index generally improves query performance

-- reading complex query plans
-- query plans for a tree-like structure

-- count the # of films `MARY` has played in
explain analyze
select
  a.first_name,
  a.last_name,
  (select count(*)
  from film_actor as fa
  where fa.actor_id = a.actor_id)
from actor as a
where a.first_name = 'MARY';

-- runs a correlated subquery
--Seq Scan on actor a  (cost=0.00..75.59 rows=2 width=21) (actual time=0.097..0.163 rows=2 loops=1)
--  Filter: ((first_name)::text = 'MARY'::text)
--  Rows Removed by Filter: 198
--  SubPlan 1
--    ->  Aggregate  (cost=35.53..35.54 rows=1 width=8) (actual time=0.041..0.041 rows=1 loops=2)
--          ->  Bitmap Heap Scan on film_actor fa  (cost=4.49..35.47 rows=27 width=0) (actual time=0.023..0.027 rows=36 loops=2)
--                Recheck Cond: (actor_id = a.actor_id)
--                Heap Blocks: exact=2
--                ->  Bitmap Index Scan on film_actor_pkey  (cost=0.00..4.48 rows=27 width=0) (actual time=0.015..0.015 rows=36 loops=2)
--                      Index Cond: (actor_id = a.actor_id)
--Planning Time: 0.423 ms
--Execution Time: 0.377 ms

-- cost cascades up the tree: 0-4.48, 4.49-35.47, 35.53-35.54

-- sequential scans, index scans, index only scans
-- bitmap scan: index & heap
-- bitmap scan fetches multiple pointers from index in one go
-- improves locality of references to the table
-- index, bitmap, sequential

explain analyze
select
  rental.rental_id,
  customer.first_name
from rental
  inner join customer using (customer_id);

--Hash Join  (cost=22.48..375.33 rows=16044 width=10) (actual time=0.460..6.471 rows=16044 loops=1)
--  Hash Cond: (rental.customer_id = customer.customer_id)
--  ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=6) (actual time=0.015..1.435 rows=16044 loops=1)
--  ->  Hash  (cost=14.99..14.99 rows=599 width=10) (actual time=0.431..0.431 rows=599 loops=1)
--        Buckets: 1024  Batches: 1  Memory Usage: 34kB
--        ->  Seq Scan on customer  (cost=0.00..14.99 rows=599 width=10) (actual time=0.014..0.230 rows=599 loops=1)
--Planning Time: 0.319 ms
--Execution Time: 6.981 ms

-- sequential scan, hash, sequential scan, hash join

-- several different types of nodes when doing joins
-- 3 main ones, depending on the size of tables you are working with

-- Nested Loop: for every row of one table, walk through the rows of the other table O(n^2)
-- Merge Join: first sorts each table, then walks through each table joining them together in a in order traversal
-- Hash Join: scans one table and builds a hash table, walks through other table using hash to lookup entries based on key
-- memory intensive because needs to build entire datastructure.

-- postgres has `workmem` variable to specify how much memory it's allowed to use
-- if building a hash exceeds that value postgres won't attempt it

-- nodes for limit, sorting with order by, grouping (hash aggregate)
-- pgadmin has visual query planner
-- http://127.0.0.1:50652/browser/

-- query optimization techniques
-- write for readability first, then performance
-- some forms are equivalent
-- joins, subqueries, set operators, window functions
-- avoid overusing subqueries and try for joins

-- start by deleting 6 ids from the test.messages table
-- then show 3 different queries for returning the missing ids

delete
from test.messages
where id in (66, 67, 68, 1002, 58975, 727109);

-- aproach #1 correlated subquery to test for existence of id from entire series
explain analyze
select s.id
from generate_series(
  (select min(id) from test.messages),
  (select max(id) from test.messages)) as s(id)
where not exists
  (select *
  from test.messages as m
  where m.id = s.id);

--Nested Loop Anti Join  (cost=1.39..6447.21 rows=500 width=4) (actual time=148.927..2428.222 rows=6 loops=1)
--  InitPlan 2 (returns $1)
--    ->  Result  (cost=0.47..0.48 rows=1 width=4) (actual time=0.036..0.036 rows=1 loops=1)
--          InitPlan 1 (returns $0)
--            ->  Limit  (cost=0.42..0.47 rows=1 width=4) (actual time=0.034..0.034 rows=1 loops=1)
--                  ->  Index Only Scan using messages_id_msg_idx on messages  (cost=0.42..44835.49 rows=1000000 width=4) (actual time=0.032..0.032 rows=1 loops=1)
--                        Index Cond: (id IS NOT NULL)
--                        Heap Fetches: 1
--  InitPlan 4 (returns $3)
--    ->  Result  (cost=0.47..0.48 rows=1 width=4) (actual time=0.020..0.020 rows=1 loops=1)
--          InitPlan 3 (returns $2)
--            ->  Limit  (cost=0.42..0.47 rows=1 width=4) (actual time=0.019..0.020 rows=1 loops=1)
--                  ->  Index Only Scan Backward using messages_id_msg_idx on messages messages_1  (cost=0.42..44835.49 rows=1000000 width=4) (actual time=0.019..0.019 rows=1 loops=1)
--                        Index Cond: (id IS NOT NULL)
--                        Heap Fetches: 1
--  ->  Function Scan on generate_series s  (cost=0.00..10.00 rows=1000 width=4) (actual time=148.750..352.258 rows=1000000 loops=1)
--  ->  Index Only Scan using messages_id_msg_idx on messages m  (cost=0.42..7.63 rows=1 width=4) (actual time=0.002..0.002 rows=1 loops=1000000)
--        Index Cond: (id = s.id)
--        Heap Fetches: 999994
--Planning Time: 2.169 ms
--Execution Time: 2431.688 ms

-- aproach #2 CTE (common table expression) and window functions
explain analyze
with t as
(
  select
    id as current,
    lead(id) over (order by id) as next
  from test.messages
)
select
  current + 1 as missing_from,
  next - 1 as missing_to
from t
where next - current > 1;

--Subquery Scan on t  (cost=0.42..74002.15 rows=333333 width=8) (actual time=0.098..948.815 rows=4 loops=1)
--  Filter: ((t.next - t.current) > 1)
--  Rows Removed by Filter: 999990
--  ->  WindowAgg  (cost=0.42..57335.49 rows=1000000 width=8) (actual time=0.033..837.996 rows=999994 loops=1)
--        ->  Index Only Scan using messages_id_msg_idx on messages  (cost=0.42..42335.49 rows=1000000 width=4) (actual time=0.017..259.600 rows=999994 loops=1)
--              Heap Fetches: 999994
--Planning Time: 0.141 ms
--Execution Time: 948.856 ms

-- has quicker execution time than approac #1

-- approach #3 set operators
explain analyze
(
  select t.id
  from generate_series(
    (select min(id) from test.messages),
    (select max(id) from test.messages)) as t(id)
)
except
(
  select id
  from test.messages
);
-- this is the second fastest approach

--HashSetOp Except  (cost=0.96..32934.46 rows=200 width=8) (actual time=1413.613..1437.742 rows=6 loops=1)
--  ->  Append  (cost=0.96..30431.96 rows=1001000 width=8) (actual time=141.279..781.680 rows=1999994 loops=1)
--        ->  Subquery Scan on "*SELECT* 1"  (cost=0.96..20.96 rows=1000 width=8) (actual time=141.278..391.021 rows=1000000 loops=1)
--              ->  Function Scan on generate_series t  (cost=0.96..10.96 rows=1000 width=4) (actual time=141.275..274.145 rows=1000000 loops=1)
--                    InitPlan 2 (returns $1)
--                      ->  Result  (cost=0.47..0.48 rows=1 width=4) (actual time=0.025..0.025 rows=1 loops=1)
--                            InitPlan 1 (returns $0)
--                              ->  Limit  (cost=0.42..0.47 rows=1 width=4) (actual time=0.023..0.023 rows=1 loops=1)
--                                    ->  Index Only Scan using messages_id_msg_idx on messages messages_1  (cost=0.42..44835.49 rows=1000000 width=4) (actual time=0.021..0.021 rows=1 loops=1)
--                                          Index Cond: (id IS NOT NULL)
--                                          Heap Fetches: 1
--                    InitPlan 4 (returns $3)
--                      ->  Result  (cost=0.47..0.48 rows=1 width=4) (actual time=0.020..0.020 rows=1 loops=1)
--                            InitPlan 3 (returns $2)
--                              ->  Limit  (cost=0.42..0.47 rows=1 width=4) (actual time=0.019..0.019 rows=1 loops=1)
--                                    ->  Index Only Scan Backward using messages_id_msg_idx on messages messages_2  (cost=0.42..44835.49 rows=1000000 width=4) (actual time=0.019..0.019 rows=1 loops=1)
--                                          Index Cond: (id IS NOT NULL)
--                                          Heap Fetches: 1
--        ->  Subquery Scan on "*SELECT* 2"  (cost=0.00..25406.00 rows=1000000 width=8) (actual time=0.034..260.725 rows=999994 loops=1)
--              ->  Seq Scan on messages  (cost=0.00..15406.00 rows=1000000 width=4) (actual time=0.033..131.090 rows=999994 loops=1)
--Planning Time: 0.276 ms
--Execution Time: 1453.250 ms

-- missing indexes are the leading cause of query performance issues
-- sequential scans on large tables are bad
-- index types: GIN, BRIN

-- partial idexes
-- let you index a subset of the records in the table based on conditions
-- resulting index is much smaller and faster to work with
-- perfect where you are commonly interested in only working with certain records (e.g. active users, etc..)

-- create index on customer(email) where active = 1;

-- CTEs can act as an optimization fence
-- the query inside the CTE is evaluated and "materialized" indpendently
-- conditions and joins in the main query should get optimized but don't since
-- it's treated as a black box

-- potential missed opportunites to optimize based on conditions in the main query
-- fixed in postgreSQL 12!

-- other performance tips
-- instead of using IN - try to turn it into a join
-- instead of using NOT IN - try using a left join or NOT EXISTS
-- user filter instead of CASE expressions
-- try to avoid subquery overuse


-- return all the customers that have rented films

-- uses in and subquery
select
  first_name,
  last_name
from customer
where customer_id in
(
  select 
    customer_id
  from rental
);


-- turn that query into an inner join
-- the join condition will take care of the filtering
-- of customers that don't appear in the rental table
select
  first_name,
  last_name
from customer
  inner join 
  (
    select
      distinct customer_id
    from rental
  ) as t2
  using (customer_id);

-- return the films that don't have any actors
explain analyze
select
  film_id,
  title
from film
where film_id not in
(
  select 
    film_id
  from film_actor
);


explain analyze
select
  f.film_id,
  f.title
from film as f
where not exists
(-- correlated subquery
  select 
    *
  from film_actor as fa
  where fa.film_id = f.film_id
);

explain analyze
select
  f.film_id,
  f.title
from film as f
  left join film_actor as fa using (film_id)
where fa.film_id is null;
  
-- left join > where exists > not in

-- query rewritting tips
-- use filter instead of case expressions
-- e.g. performing aggregation such as sum or count
-- count based on condition, make use of filter with postgres

-- window functions, set operators, joins > subqueries