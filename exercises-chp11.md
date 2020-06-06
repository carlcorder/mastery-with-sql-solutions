# Exercises Chp 11

#### 11.1 In the last video, we imported the data for the users and notes tables from CSV files. Now also import the note tags from CSV.

```sql
copy playground.note_tags
from '...note_tags.csv'
with (format csv, header true);
```

#### 11.2 Export in CSV format (with headings) the number of notes created by each user. Order the users in descending order based on how many notes they've created.

```sql
copy
(
  select
    u.first_name || ' ' || u.last_name as name,
    count(*) as note_count
  from playground.notes as n
    inner join playground.users as u
      on n.user_email = u.email
  group by u.email, u.first_name, u.last_name
  order by note_count desc
)
to '...note_counts.csv'
with (format csv, header true);
```

#### 11.3 Output values (any values of your choosing) of the following types to a plain text file: a) text b) int c) numeric d) real e) boolean f) date g) timestamptz h) interval

```sql
copy
(
  select
    'test'::text,
    33::int,
    33.3::numeric,
    33.3::real,
    true::boolean,
    current_date::date,
    current_timestamp::timestamptz,
    '1 day'::interval
)
to '...output_types.txt';
```

#### 11.4 Write an insert statement to insert a new customer in to the customer table with any details of your choosing. Use the returning clause to return the inserted row. For this and all upcoming exercises, remember to do this inside a transaction block and rollback the change afterwards!

```sql
insert into customer(store_id, first_name, last_name, address_id, active)
values
  (1, 'John', 'Henry', 1, 1)
returning *;
```

#### 11.5 Create a new table called rental_stats with two columns, date and num_rentals, to hold the data for the number of rentals made each day. And write an insert statement to populate the table with correct data as calculated from the rental table

We achieve this with two statements - one to create the rental_stats table (don't worry about PKs) and an insert statement that queries the rental table, calculating the number of rentals made on each day. As an alternative, it is also possible to create a table and populate it with results from a query in a single statement using CREATE TABLE AS - I've included below a solution using this approach as well. With [CREATE TABLE AS](https://www.postgresql.org/docs/current/sql-createtableas.html), the created table column names and types come directly from the query. 

```sql
create table rental_stats (
  date date,
  num_rentals int
);

insert into rental_stats
  select
    rental_date::date as rental_day,
    count(*)
  from rental
  group by rental_day
  order by rental_day;
```

```sql
create table rental_stats as
  select
    rental_date::date as rental_day,
    count(*)
  from rental
  group by rental_day
  order by rental_day; 
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

#### 



```sql

```

#### 



```sql

```
