# Exercises Chp 9

#### 9.1 Write a query to list out all the distinct dates there was some sort of customer interaction (a rental or a payment) and order by output date

We can obtain the result we're after here by unioning the rental date and payment dates (cast to dates to remove the time component), from the rental and payment tables respectively. The union operator will take care of removing any duplicate dates from the output. 

```sql
(
  select cast(rental_date as date) as interaction_date
  from rental
)
union
(
  select cast(payment_date as date) as interaction_date
  from payment
)
order by interaction_date;
```

#### 9.2 Write a query to find the actors that are also customers (assuming same name = same person)

By performing an intersection between the first name and last name columns from both the customer and actor tables we obtain the people who appear in both tables. 

```sql
(
  select first_name, last_name
  from customer
)
intersect
(
  select first_name, last_name
  from actor
);
```

#### 9.3 Have the actors with IDs 49 (Anne Cronyn), 152 (Ben Harris), and 180 (Jeff Silverstone) ever appeared in any films together? Which ones?

We can obtain the list of films each actor has appeared in directly from the film_actor table. By performing an intersection between all 3 lists of films, we are left with any films common to each actor. 

```sql
(
  select film_id
  from film_actor
  where actor_id = 49
)
intersect
(
  select film_id
  from film_actor
  where actor_id = 152
)
intersect
(
  select film_id
  from film_actor
  where actor_id = 180
);
```

#### 9.4 The missing rental IDs problem that we've encountered several times now is the perfect place to use EXCEPT. Write a query using the [generate_series](https://www.postgresql.org/docs/current/functions-srf.html) function and EXCEPT to find missing rental IDs (The rental table has 16,044 rows but the maximum rental ID is 16,049 - some IDs are missing)

We first generate a sequential list of numbers ranging from the minimum rental ID (1) in the rental table to the maximum rental ID (16,049). From this, using EXCEPT, we remove the rental IDs present in the rental table. This leaves us with the missing rental IDs. Of all the different ways you've now learned to solve this exercise (first subqueries and then window functions) I think this is the most intuitive. 

```sql
(
  select t.id
  from generate_series(
    (select min(rental_id) from rental),
    (select max(rental_id) from rental)) as t(id)
)
except
(
  select rental_id
  from rental
);
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
