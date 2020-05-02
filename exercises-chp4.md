## Exercises Chp 4


#### 4.1 Write a query to return the total count of customers in the customer table and the count of how many customers provided an email address

```sql
select
  count(*) as "# customers",
  count(email) as "# customers with email"
from customer;
```

#### 4.2 Building on the previous exercise, now return an additional result showing the percentage of customers with an email address (as a helpful hint, if you're getting 0 try multiplying the fraction by 100.0 - we'll examine why this is necessary in an upcoming chapter on data types)

```sql
select
  count(*) as "# customers",
  count(email) as "# customers with email",
  100.0 * count(email) / count(*) as "% with email"
from customer;
```

#### 4.3 Write a query to return the number of distinct customers who have made payments

```sql
select count(distinct customer_id)
from payment;
```

#### 4.4 What is the average length of time films are rented out for

```sql
select avg(return_date - rental_date) as "avg rental duration"
from rental;
```

#### 4.5 Write a query to return the sum total of all payment amounts received

```sql
select sum(amount) as total
from payment;
```

#### 4.6 List the number of films each actor has appeared in and order the results from most popular to least

```sql
select actor_id, count(*) as num_films
from film_actor
group by actor_id
order by num_films desc;
```

#### 4.7 List the customers who have made over 40 rentals

```sql
select customer_id
from rental
group by customer_id
having count(*) > 40;
```

#### 4.8 We want to compare how the staff are performing against each other on a month to month basis. So for each month and year, show for each staff member how many payments they handled, the total amount of money they accepted, and the average payment amount

```sql
select
  date_part('year', payment_date) as year,
  date_part('month', payment_date) as month,
  staff_id,
  count(*) as num_payments,
  sum(amount) as payment_total,
  avg(amount) as avg_payment_amount
from payment
group by
  date_part('year', payment_date),
  date_part('month', payment_date),
  staff_id
order by year, month, staff_id;
```
