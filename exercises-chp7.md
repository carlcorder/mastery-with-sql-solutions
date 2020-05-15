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
```

```sql
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

#### 7.4 Write a query to return the countries in our database that have more than 15 cities

For this exercise we use a subquery to obtain, for each country, a count of the number of cities listed for that country. This can then be used in the WHERE clause to filter the countries in our final output. 

```sql
select country.country
from country
where
  (select count(*)
   from city
   where city.country_id = country.country_id) > 15;
```

#### 7.5 Write a query to return for each customer the store they most commonly rent from

The correlated subquery in this case is used to obtain, for each customer, the store that the customer visits the most. How do we work that out? By tallying up all the rentals from that customer by store ID, ordering by the count (descending! If you forget to add 'desc' you'll return the least popular store for each customer!) and then taking the first result with LIMIT. 

```sql
select
  c.customer_id,
  c.first_name,
  c.last_name,
  (select i.store_id
   from rental as r
     inner join inventory as i using (inventory_id)
   where r.customer_id = c.customer_id
   group by i.store_id
   order by count(*) desc
   limit 1) as "Favourite Store"
from customer as c;
```

#### 7.6 In the customer table, each customer has a store ID which is the store they originally registered at. Write a query to list for each customer whether they have ever rented from a different store than that one they registered at. Return 'Y' if they have, and 'N' if they haven't.

This was a tricky one due to the combination of using a case expression and EXISTS. If you got it right, well done! The subquery here is used to return for each customer any rentals they made from a store different from the store they registered at. If any exist, then the case expression is used to output 'Y', otherwise 'N'. 

```sql
select c.first_name, c.last_name,
  case
    when exists 
      (select *
       from rental as r
         inner join inventory as i using (inventory_id)
       where r.customer_id = c.customer_id
         and i.store_id != c.store_id) then 'Y'
    else 'N'
  end as "HasRentedOtherStore"
from customer as c;
```

#### 7.7 Write a query to return each customer 4 times

Cross joining the customer table on to any table containing only four rows will do the job - to guarantee that we have exactly four rows we specify a values list and create a new virtual table to join on to. 

```sql
select c.first_name, c.last_name
from customer as c
  cross join (values (1), (2), (3), (4)) as v(n)
order by c.customer_id;
```

#### 7.8 Write a query to return how many rentals the business gets on average on each day of the week. Order the results to show the days of the week with the highest average number of rentals first (use the round function to round the average so it's a nice whole number). Have a look at the [to_char](https://www.postgresql.org/docs/current/functions-formatting.html) function to obtain the day name given a timestamp. For simplicity, don't worry about days in which there were no rentals.

This was a tricky one and there's a couple of different ways you could have solved it. In the solution below, the table subquery aggregates the ratings for each date from the rental table. The outer query then further aggregates by the actual day of the week for each date and performs an average for each day of the week (the to_char function is used to obtain the day name).

```sql
select
  to_char(rent_day, 'Day') as day_name,
  round(avg(num_rentals)) as average
from
  (select date_trunc('day', rental_date) as rent_day, count(*) as num_rentals
   from rental
   group by rent_day) as T
group by day_name
order by average desc;
```

#### 7.9 Write a query to return for each customer the first 'PG' film that they rented (include customers who have never rented a 'PG' film as well)

We make use of a left join lateral here to join on to a table subquery that will return for each customer the first film they rented that was PG. By using a left join, any customers who have not rented any PG films will be in the output with a NULL title and rental_date. There are 6 such customers. 

```sql
select c.first_name, c.last_name, d.title, d.rental_date
from customer as c
  left join lateral
    (select r.customer_id, f.title, r.rental_date
     from rental as r
       inner join inventory as i using (inventory_id)
       inner join film as f using (film_id)
     where r.customer_id = c.customer_id
       and f.rating = 'PG'
     order by r.rental_date
     limit 1) as d
    on c.customer_id = d.customer_id;
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
