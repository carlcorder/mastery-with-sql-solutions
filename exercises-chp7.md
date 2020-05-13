# Exercises Chp 7

#### 7.1 Write a query to return all the customers who made a rental on the first day of rentals (without hardcoding the date for the first day of rentals in your query)

For this exercise we use a subquery to obtain the date when rentals were first made. We then cast this timestamp to a date to allow ease of comparison - an alternative approach which will give you the same result would be to use the date_trunc function to truncate the rental date to the 'day'. Distinct is used to eliminate duplicates just in case any one customer rented more than once on the opening day. 

```sql
select distinct c.first_name, c.last_name
from rental as r
  inner join customer as c using (customer_id)
where r.rental_date::date = 
  (select min(rental_date)::date
   from rental);
```

#### 7.2 Using a subquery, return the films that don't have any actors. Now write the same query using a left join. Which solution do you think is better? Easier to read?

The two solutions are listed below - I would personally prefer the subquery solution because I find that easier to think about but it's up to you! 

```sql
select film_id, title
from film
where film_id not in
  (select film_id
   from film_actor);
   
select film_id, title
from film as f
  left join film_actor as fa using (film_id)
where fa.film_id is null;
```

#### 7.3 You intend to write a humorous email to congratulate some customers on their poor taste in films. To that end, write a query to return the customers who rented out the least popular film (that is, the film least rented out - if there is more than one, pick the one with the lowest film ID)

The subquery here is used to obtain the ID for the least popular film. This is achieved by grouping the rentals by film ID, ordering by count ascending, and picking the first. In this instance there is more than one "least popular" film so the film ID is used for tiebreaking in the order by clause. 

```sql
select c.customer_id, c.first_name, c.last_name
from rental as r1
  inner join inventory as i1 using (inventory_id)
  inner join customer as c using (customer_id)
where i1.film_id =
  (select i2.film_id
   from rental as r2
     inner join inventory as i2 using (inventory_id)
   group by i2.film_id
   order by count(*) asc, i2.film_id asc
   limit 1);
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
