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
