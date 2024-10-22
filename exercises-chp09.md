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

#### 9.5 Write a query to list all the customers who have rented out a film on a Saturday but never on a Sunday. Order the customers by first name.

We first obtain a list of all the customers who have rented out a film on Saturday using the [date_part](https://www.postgresql.org/docs/current/functions-datetime.html) function with 'isodow' (ISO Day Of Week) which returns a number between 1 and 7 identifying the day of the week. From this, using EXCEPT, we remove the customers who have made rentals on Sunday. 

```sql
(
  select first_name, last_name
  from rental
    inner join customer using (customer_id)
  where date_part('isodow', rental_date) = 6
)
except
(
  select first_name, last_name
  from rental
    inner join customer using (customer_id)
  where date_part('isodow', rental_date) = 7
)
order by first_name;
```

#### 9.6 Write a query to list out all the distinct dates there was some sort of customer interaction (a rental or a payment) and order by output date. Include only one row in the output for each type of interaction

Similar to the first exercise, we union the rental dates with the payment dates. This time however each query contains a static column describing the type of interaction (this pattern of adding a column to each query describing the source table is quite common when encountering set operators in real-world situations) 

```sql
(
  select cast(rental_date as date) as interaction_date, 'rental' as type
  from rental
)
union
(
  select cast(payment_date as date) as interaction_date, 'payment' as type
  from payment
)
order by interaction_date;
```

#### 9.7 Write a query to return the countries in which there are both customers and staff. Use a CTE to help simplify your code.

Not such a tricky question in this case but it does involve the same joined table in more than one case so the use of a CTE can be quite handy here instead of having to repeat the same query elements to resolve an address ID in to a country. Yes, you can use CTEs with set operators without any problems!

```sql
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
```

#### 9.8 Imagine you had two queries - let's call them A and B. Can you figure out how you would use set operators to return the rows in either A or B, but not both.

To obtain the rows in either A or B but not in both, you could first perform A union B. From this, you would then minus A intersect B. In full then: (A union B) except (A intersect B). Can you think of another way too?
