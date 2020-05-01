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

#### 3.22 Write a query the list all the customers with an email address. Order the customers by last name descending

```sql
select first_name, last_name
from customer
where email is not null
order by last_name desc;
```

#### 3.23 Write a query to list the country id's and cities from the city table, first ordered by country id ascending, then by city alphabetically.

```sql
select country_id, city
from city
order by country_id, city;
```

#### 3.24 Write a query to list actors ordered by the length of their full name ("[first_name] [last_name]") descending.

```sql
select
  first_name || ' ' || last_name as full_name,
  length(first_name || ' ' || last_name) as len
from actor
order by len desc;
```

#### 3.25 Describe the difference between ORDER BY x, y DESC and ORDER BY x DESC, y DESC (where x and y are columns in some imaginary table you're querying)

ORDER BY x, y DESC is equivalent to ORDER BY x ASC, y DESC - order first by x ascending, then by y descending. This is different from ORDER BY x DESC, y DESC - order by x descending, then by y descending. When asc/desc is omitted, ascending is the default. 

#### 3.26 Fix the query below, which we wanted to use to list all the rentals that happened after 10pm at night.

```sql
select rental_id, date_part('hour', rental_date) as "rental hour"
from rental
where date_part('hour', rental_date) >= 22;
```

#### 3.27 Write a query to return the 3 most recent payments received

```sql
select payment_id, payment_date
from payment
order by payment_date desc
limit 3;
```

#### 3.28 Return the 4 films with the shortest length that are not R rated. For films with the same length, order them alphabetically

```sql
select title, length, rating
from film
where rating != 'R'
  or rating is null
order by length, title
limit 4;
```

#### 3.29 Write a query to return the last 3 payments made in January, 2007

```sql
select payment_id, amount, payment_date
from payment
where payment_date < '2007-02-01'
  and payment_date >= '2007-01-01'
order by payment_date desc
limit 3;
```

#### 3.30 Can you think of a way you could, as in the previous exercise, return the last 3 payments made in January, 2007 but have those same 3 output rows ordered by date ascending? (Don't spend too long on this...)

You don't yet have the tools to do this and it's a bit of a problem with using ORDER BY/LIMIT while wanting separate output row ordering. I'll show you how to handle situations like this in a future video.

#### 3.31 Write a query to return all the unique ratings films can have, ordered alphabetically (not including NULL)

```sql
select distinct rating
from film
where rating is not null
order by rating;
```
#### 3.32 Write a query to help us quickly see if there is any hour of the day that we have never rented a film out on (maybe the staff always head out for lunch?)

```sql
select distinct date_part('hour', rental_date) as hr
from rental
order by hr;
```

#### 3.33 Write a query to help quickly check whether the same rental rate is used for each rental duration (for example - is the rental rate always 4.99 when the rental duration is 3?)

```sql
select distinct rental_duration, rental_rate
from film
order by rental_duration;
```

#### 3.34 Can you explain why the first query below works, but the second one, which simply adds the DISTINCT keyword, doesn't? (this is quite challenging)

In the second query, multiple rows of actors are combined in to a single row due to the use of DISTINCT. For example, there are two actors with the first name ADAM (ADAM HOPPER and ADAM GRANT), however after the SELECT DISTINCT clause has been processed, there is only one row with first name ADAM. Ordering then by last name is undefined - eg. In the case of ADAM, Postgres has no way to know which last name should be used (HOPPER or GRANT?). In general, avoid ordering by columns you haven't selected and you can sidestep complex situations like this.

#### 3.35 Write a query to return an ordered list of distinct ratings for films in our films table along with their descriptions (you will have to type in the descriptions yourself)

```sql
select distinct rating,
  case rating
    when 'G' then 'General'
    when 'PG' then 'Parental Guidance Recommended'
    when 'PG-13' then 'Parents Strongly Cautioned'
    when 'R' then 'Restricted'
    when 'NC-17' then 'Adults Only'
  end as "rating description"
from film
where rating is not null
order by rating;
```

#### 3.36 Write a query to output 'Returned' for returned rentals and 'Not Returned' for rentals that haven't been returned. Order the output to show those not returned first.

```sql
select rental_id, rental_date, return_date,
  case
    when return_date is null then 'Not Returned'
    else 'Returned'
  end as return_status
from rental
order by return_status;
```

#### 3.37 Imagine you were asked to write a query to populate a 'country picker' for some internal company dashboard. Write a query to return the countries in alphabetical order, but also with the twist that the first 3 countries in the list must be 1) Australia 2) United Kingdom 3) United States and then normal alphabetical order after that (maybe you want them first because, for example, most of your customers come from these countries)

```sql
select country
from country
order by
  case country
    when 'Australia' then 0
    when 'United Kingdom' then 1
    when 'United States' then 2
    else 3
  end, country;
```

#### 3.38 We want to give a prize to 5 random customers each month. Write a query that will return 5 random customers each time it is run (you may find a particular math function helpful - make sure to search the documentation!)

```sql
select first_name, last_name, email
from customer
order by random()
limit 5;
```

#### 3.39 Give 3 different solutions to list the rentals made in June, 2005. In one solution, use the date_part function. In another, use the BETWEEN keyword. In the third, don't use either date_part or BETWEEN.

```sql
select rental_id, rental_date
from rental
where date_part('year', rental_date) = 2005
  and date_part('month', rental_date) = 6;
```

```sql
select rental_id, rental_date
from rental
where rental_date between
  '2005-06-01 00:00:00' and '2005-06-30 24:00:00';
```

```sql
select rental_id, rental_date
from rental
where rental_date >= '2005-06-01 00:00:00'
  and rental_date <= '2005-06-30 24:00:00';
```

#### 3.40 Return the top 5 films for $ per minute (rental_rate / length) of entertainment

```sql
select title, rental_rate, length,
  rental_rate / length as per_minute
from film
where length is not null
  and length != 0
order by per_minute desc
limit 5;
```

#### 3.41 Write a query to list all customers who have a first name containing the letter 'A' twice or more

```sql
select first_name
from customer
where first_name ilike '%a%a%';
```

#### 3.42 PostgreSQL supports an interesting variation of DISTINCT called DISTINCT ON. Visit the official documentation page and read about DISTINCT ON. See if you can figure out how you would use it in a query to return the most recent rental for each customer

```sql
select distinct on (customer_id) customer_id, rental_date
from rental
order by customer_id asc, rental_date desc;
```

#### 3.43 Write a query to list all the customers with an email address but not in the format [first_name].[last_name]@sakilacustomer.org

```sql
select first_name, last_name, email
from customer
where email != (first_name || '.' || last_name || '@sakilacustomer.org')
```
