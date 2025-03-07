# Exercises Chp 8

#### 8.1 Write a query to return the 3 most recent rentals for each customer. Earlier you did this with a lateral join - this time do it with window functions

For each rental we can calculate a row number based on a window of rentals partitioned by customer ID and ordered by rental date descending. By then picking those rentals with a row number less than or equal to 3 we obtain the 3 most recent rentals for each customer. 

```sql
select rental_id, customer_id, rental_date
from
 (select
    rental_id,
    customer_id,
    rental_date,
    row_number() over (partition by customer_id order by rental_date desc) as rn
  from rental) as t
where rn <= 3;
```

#### 8.2 We want to re-do [exercise 7.3](https://github.com/carlcorder/mastery-with-sql-solutions/blob/master/exercises-chp7.md#73-you-intend-to-write-a-humorous-email-to-congratulate-some-customers-on-their-poor-taste-in-films-to-that-end-write-a-query-to-return-the-customers-who-rented-out-the-least-popular-film-that-is-the-film-least-rented-out---if-there-is-more-than-one-pick-the-one-with-the-lowest-film-id), where we wrote a query to return the customers who rented out the least popular film (that is, the film least rented out). This time though we want to be able to handle if there is more than one film that is least popular. So if several films are each equally unpopular, return the customers who rented out any of those films.

The rent_counts CTE returns for each film the number of times it has been rented out and a corresponding ranking. If you run this on its own, you'll find that there are 3 equally unpopular films, each only rented out 4 times. We then return those distinct customers from the rental table who rented any film that has a ranking of 1. 

```sql
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
select distinct customer_id
from rental as r
  inner join inventory as i using (inventory_id)
where i.film_id in
  (select film_id
   from rent_counts
   where rank = 1);
```

#### 8.3 Write a query to return all the distinct film ratings without using the DISTINCT keyword

The key insight for this exercise is to recognize that window functions only operate over one window at a time. So by partitioning the film table table by rating and using the row_number() function, each new rating encountered will belong to a new window. And the first such film for each rating will therefore get a row number of 1. Filtering for only those films and removing NULL yields us a distinct list of ratings. 

```sql
select rating
from
  (select
     rating,
     row_number() over (partition by rating) as rn
   from film) as t
where rn = 1
  and rating is not null;
```

#### 8.4 Write a query to show for each rental both the rental duration and also the average rental duration from the same customer

```sql
select
  customer_id,
  rental_id,
  return_date - rental_date as rent_duration,
  avg(return_date - rental_date) over (partition by customer_id)
from rental;
```

#### 8.5 Write a query to calculate a running total of payments received, grouped by month (ie. for each month show the total amount of money received that month and also the total amount of money received up to and including that month)

We can re-use the monthly_amounts CTE we've encountered several times now to give us a baseline table to work with.Then by using the sum function over a window ordered by month ascending, we're able to take advantage of the default window frame and obtain a running total of payments received. 

```sql
with monthly_amounts as
(
  select
    date_trunc('month', payment_date) as month,
    sum(amount) as amount
  from payment
  group by month
)
select
  month,
  amount,
  sum(amount) over (order by month) as running_total
from monthly_amounts;
```

#### 8.6 Write a query to return the top 3 earning films in each rating category. Include ties. To calculate the earnings for a film, multiply the rental rate for the film by the number of times it was rented out

We can build this query up in several steps. The first CTE calculates the amount of income received from each film by multiplying the rental rate by the number of times the film was rented out. The second CTE assigns a rank for each film based on the rating of the film and income - it also filters out those films without a rating. The final query filters the output to only return the films with a ranking less than or equal to 3. 

```sql
with film_incomes as
(
  select
    f.film_id,
    f.title,
    f.rating,
    f.rental_rate * count(*) as income
  from rental as r
    inner join inventory as i using (inventory_id)
    inner join film as f using (film_id)
  group by f.film_id
),
film_rankings as
(
  select
    film_id,
    title,
    rating,
    income,
    rank() over(partition by rating order by income desc)
  from film_incomes
  where rating is not null
)
select title, rating, income
from film_rankings
where rank <= 3
order by rating, rank;
```

#### 8.7 The rental table has 16,044 rows but the maximum rental ID is 16,049. This suggests that some rental IDs have been skipped over. Write a query to find the missing rental IDs (you [previously](https://github.com/carlcorder/mastery-with-sql-solutions/blob/master/exercises-chp07.md#715-the-rental-table-has-16044-rows-but-the-maximum-rental-id-is-16049-this-suggests-that-some-rental-ids-have-been-skipped-over-write-a-query-to-find-the-missing-rental-ids-the-generate_series-function-may-come-in-handy) did this using the generate_series function. Now do it using only window functions). Note you don't have to have your output formatted the same.

This exercise falls under a general class of problems known as 'finding the gap' - a quite popular question in technical interviews! For each rental, you can use the lead() function to obtain the very next rental ID (when ordered by ID). Any missing IDs therefore are when this "gap" is greater than 1, with current + 1 identifying the first missing ID and next - 1 identifying the last missing ID in the "gap". 

```sql
with t as
(
  select
    rental_id as current,
    lead(rental_id) over (order by rental_id) as next
  from rental
)
select
  current + 1 as missing_from,
  next - 1 as missing_to
from t
where next - current > 1;
```

#### 8.8 Calculate for each customer the longest amount of time they've gone between renting a film

The days_between CTE is used here to calculate for each rental the time difference between it and the next rental from the same customer. To obtain the longest break for each customer, the final query groups the results by customer and picks the largest such difference. 

```sql
with days_between as
(
  select customer_id, rental_date,
    lead(rental_date) over (partition by customer_id order by rental_date) - rental_date as diff
  from rental
)
select customer_id, max(diff) as "longest break"
from days_between
group by customer_id
order by customer_id;
```
