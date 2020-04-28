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

