## Exercises Chp 3
#### 3.1 Write a query to list all the film titles
 
```sql
select title
from film;
```

#### 3.2 Write a query to return the actor's first names and last names only (with the column headings "First Name" and "Last Name")

```sql
select first_name as "First Name", last_name as "Last Name"
from actor;
```

#### 3.3 How many rows are in the inventory table?

```sql
select count(*)
from inventory;
```

#### 3.4 Write a query that returns all the columns from the actor table without using the * wildcard in the SELECT clause

```sql
select actor_id, first_name, last_name, last_update
from actor;
```

#### 3.5 Write a query to obtain the length of each customer's first name (*remember to look for string functions in the documentation that can help*)

```sql
select first_name, length(first_name)
from customer;
```

#### 3.6 Write a query to return the initials for each customer

```sql
select
  first_name,
  last_name,
  left(first_name, 1) || left(last_name, 1) as "initial"
from customer;
```

#### 3.7 Each film has a rental_rate, which is how much money it costs for a customer to rent out the film. Each film also has a replacement_cost, which is how much money the film costs to replace. Write a query to figure out how many times each film must be rented out to cover its replacement cost.

```sql
select
  title,
  rental_rate,
  replacement_cost,
  ceil(replacement_cost / rental_rate) as "# rentals to break-even"
from film;
```

#### 3.8 Write a query to list all the films with a 'G' rating

```sql
select title, rating
from film
where rating = 'G';
```

#### 3.9 List all the films longer than 2 hours (note each film has a length in minutes)


```sql
select title, length
from film
where length > 120;
```

#### 3.10 Write a query to list all the rentals made before June, 2005

```sql
select rental_id, rental_date
from rental
where rental_date < '2005-06-01';
```

#### 3.11 In Exercise 3.7, you wrote a query to figure out how many times each film must be rented out to cover its replacement cost. Now write a query to return only those films that must be rented out more than 30 times to cover their replacement cost.

```sql
select
  title,
  rental_rate,
  replacement_cost,
  ceil(replacement_cost / rental_rate) as "# rentals to break-even"
from film
where ceil(replacement_cost / rental_rate) > 30;
```

#### 3.12 Write a query to show all rentals made by the customer with ID 388 in 2005

```sql
select rental_id, rental_date
from rental
where rental_date >= '2005-01-01'
  and rental_date < '2006-01-01'
  and customer_id = 388;
```

#### 3.13 We’re trying to list all films with a length of an hour or less. Show two different ways to fix our query below that isn't working (one using the NOT keyword, and one without)

```sql
select title, rental_duration, length
from film
where not length > 60;

select title, rental_duration, length
from film
where length <= 60;
```

#### 3.14 Explain what each of the two queries below are doing and why they generate different results. Which one is probably a mistake and why?

The first query will return all films where the rating is neither 'G' nor 'PG'. Stated another way, if a film is rated 'G' it won't be in the output. If a film is rated 'PG' it also won't be in the output. All other films will be in the output. The second query almost does nothing. It returns almost all the films - including those with a 'G' rating and also those with a 'PG' rating. (I say almost for reasons you'll learn about in the next video). Think carefully about how both AND and OR work to understand this behaviour. 

#### 3.15 Write a single query to show all rentals where the return date is greater than the rental date, or the return date is equal to the rental date, or the return date is less than the rental date. How many rows are returned? Why doesn't this match the number of rows in the table overall?

```sql
select rental_id, rental_date, return_date
from rental
where return_date > rental_date
  or return_date = rental_date
  or return_date < rental_date;
```

#### 3.16 Write a query to list the rentals that haven't been returned

```sql
select rental_id, return_date
from rental
where return_date is null;
```

#### 3.17 Write a query to list the films that have a rating that is not 'G' or 'PG'

```sql
select title, rating
from film
where rating != 'PG'
  and rating != 'G'
  or rating is null;
```

#### 3.18 Write a query to return the films with a rating of 'PG', 'G', or 'PG-13'

```sql
select title, rating
from film
where rating in ('PG', 'G', 'PG-13');
```

#### 3.19 Write a query equivalent to the one below using BETWEEN.

```sql
select title, length
from film
where length between 90 and 120;
```

#### 3.20 Write a query to return all film titles that end with the word "GRAFFITI"

```sql
select title
from film
where title like '%GRAFFITI';
```

#### 3.21 In exercise 3.17 you wrote a query to list the films that have a rating that is not 'G' or 'PG'. Re-write this query using NOT IN. Do your results include films with a NULL rating?

```sql
select title, rating
from film
where rating not in ('G', 'PG');
```
