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
