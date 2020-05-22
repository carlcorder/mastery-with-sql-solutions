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
