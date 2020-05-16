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

#### 

```sql

```

#### 

```sql

```

#### 

```sql

```

#### 

```sql

```

#### 

```sql

```

#### 

```sql

```

#### 

```sql

```
