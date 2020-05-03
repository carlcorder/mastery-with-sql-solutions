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

#### 4.9 Write a query to show the number of rentals that were returned within 3 days, the number returned in 3 or more days, and the number never returned (for the logical comparison check you can use the following code snippet to compare against an interval: where return_date - rental_date < interval '3 days')

```sql
select
  count(*) filter
    (where return_date - rental_date < interval '3 days') as "lt 3 days",
  count(*) filter
    (where return_date - rental_date >= interval '3 days') as "gt 3 days",
  count(*) filter
    (where return_date is null) as "never returned"
from rental;
```

#### 4.10 Write a query to give counts of the films by their length in groups of 0 - 1hrs, 1 - 2hrs, 2 - 3hrs, and 3hrs+ (note: you might get slightly different numbers if doing inclusive or exclusive grouping - but don't sweat it!)

```sql
select
  case
    when length between 0 and 59 then '0-1hrs'
    when length between 60 and 119 then '1-2hrs'
    when length between 120 and 179 then '2-3hrs'
    else '3hrs+'
  end as len,
  count(*)
from film
group by 1
order by 1;
```

#### 4.11 Explain why in the following query we obtain two different results for the average film length. Which one is correct?

```sql
select
  1.0 * sum(length) / count(*) as avg1,
  1.0 * avg(length) as avg2
from film;
```

When using the avg aggregate function, NULL lengths are ignored in the calculation. However, the count(*) term in the first selected column will count all the rows, even those with a NULL length. Technically either approach could be correct, depending on how you want to treat NULL length films. Most people would probably argue though that here, the second approach is correct. 

#### 4.12 Write a query to return the average rental duration for each customer in descending order

```sql
select
  customer_id,
  avg(return_date - rental_date) as avg_rent_duration
from rental
group by customer_id
order by avg_rent_duration desc;
```

#### 4.13 Return a list of customer where all payments they’ve made have been over $2 (lookup the bool_and aggregate function which will be useful here)

```sql
select customer_id
from payment
group by customer_id
having bool_and(amount > 2);
```

This was a tricky one. The key here was to realize bool_and is just like the other aggregate functions you've already seen in that it combines multiple rows in to a single output, but unlike all the other aggregate functions you've seen bool_and does this by performing a logical AND between each input expression. 


#### 4.14 As a final fun finish to this chapter, run the following query to see a cool way you can generate ascii histogram charts. Look up the repeat function (you'll find it under 'String Functions and Operators') to see how it works and change the output character...and don't worry, I'll explain the ::int bit in the next chapter!

```sql
select rating, repeat('*', (count(*) / 10)::int) as "count/10"
from film
where rating is not null
group by rating;
```

rating|count/10              |
------|----------------------|
PG-13 |**********************|
R     |*******************   |
G     |*****************     |
PG    |*******************   |
NC-17 |********************  |

The repeat function is used to repeat the '*' character count/10 times for each group (I divided by 10 just to keep the output concise!)

#### 

```sql

```

