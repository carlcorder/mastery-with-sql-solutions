# Exercises Chp 6

#### 6.1 Write a query to return a list of all the films rented by PETER MENARD showing the most recent first

```sql
select r.rental_date, f.title
from rental as r
  inner join customer as c
    on r.customer_id = c.customer_id
  inner join inventory as i
    on r.inventory_id = i.inventory_id
  inner join film as f
    on i.film_id = f.film_id
where c.first_name = 'PETER'
  and c.last_name = 'MENARD'
order by r.rental_date desc;
```

#### 6.2 Write a query to list the full names and contact details for the manager of each store

```sql
select
  store.store_id,
  staff.first_name || ' ' || staff.last_name as "Manager",
  staff.email
from store
  inner join staff
    on store.manager_staff_id = staff.staff_id;
```

#### 6.3 Write a query to return the top 3 most rented out films and how many times they've been rented out

```sql
select f.film_id, f.title, count(*)
from rental as r
  inner join inventory as i
    on r.inventory_id = i.inventory_id
  inner join film as f
    on i.film_id = f.film_id
group by f.film_id, f.title
order by count(*) desc
limit 3;
```

#### 6.4 Write a query to show for each customer how many different (unique) films they've rented and how many different (unique) actors they've seen in films they've rented

```sql
select
  r.customer_id,
  count(distinct f.film_id) as num_films,
  count(distinct fa.actor_id) as num_actors
from rental as r
  inner join inventory as i using (inventory_id)
  inner join film as f using (film_id)
  inner join film_actor as fa using (film_id)
group by r.customer_id
order by r.customer_id;
```

#### 6.5 Re-write the query below written in the older style of inner joins (which you still encounter surprisingly often online) using the more modern style. Re-write it once using ON to establish the join condition and the second time with USING.

```sql
select film.title, language.name as "language"
from film, language
where film.language_id = language.language_id;

select film.title, language.name as "language"
from film
  inner join language
    on film.language_id = language.language_id;

select film.title, language.name as "language"
from film
  inner join language using (language_id);
```

#### 6.6 Write a query to list the films that are not in stock in any of the stores

After performing a left outer join with the film and inventory tables, the only rows in the output with a NULL store ID will be those that didn't have any matching records in both tables - that is, those films not in our inventory. So we can simply filter the output for where the store ID is NULL. 

```sql
select f.title
from film as f
  left outer join inventory as i
    on f.film_id = i.film_id
where i.store_id is null;
```

#### 6.7 Write a query to return a count of how many of each film we have in our inventory (include all films). Order the output showing the lowest in-stock first so we know to buy more!

After joining the film and inventory tables we can then group by the film ID and perform a count of the number of rows, making sure that we're only counting, for each group, the rows where the inventory ID is not NULL (to ensure missing films added by the outer join still end up with a count of 0, not 1) 

```sql
select f.title, count(i.inventory_id)
from film as f
  left outer join inventory as i
    on f.film_id = i.film_id
group by f.film_id, f.title
order by count(i.inventory_id) asc;
```

#### 6.8 Write a query to return a count of the number of films rented by every customer on the 24th May, 2005. Order the results by number of films rented descending.

A key issue you may have run across when solving this exercise is if you tried to perform the date check in the WHERE clause instead of making it one of the join conditions. The problem with making it part of the WHERE clause is it would act to filter the output of the left join, removing any rows that the left join added back in. This is because rows added back in by the left join - customers with no rentals - will have a NULL rental date. If you put the date check in the WHERE clause, you would effectively be making your left join an inner join! 

```sql
select
  c.customer_id,
  count(r.rental_id) as num_rented
from customer as c
  left join rental as r
    on c.customer_id = r.customer_id
    and date_trunc('day', r.rental_date) = '20050524'
group by c.customer_id
order by num_rented desc, c.customer_id;
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
