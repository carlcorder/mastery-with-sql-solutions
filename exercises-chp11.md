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

#### 11.6 All customers should have an email address of the form [first_name].[last_name]@sakilacustomer.org (all in lower case). Write an update statement so that all customers have an email address in this format.

In this case since we can visually observe that none of the customer email addresses are in the correct format, writing a blanket statement to update all the rows is fine. In general though, you are better off limiting your update statements to only update rows that you have to for performance reasons. 

```sql
update customer
set email = lower(first_name || '.' || last_name || '@sakilacustomer.org');
```

#### 11.7 Write an update statement to update the rental rate of the 20 most rented films by 10%

For this update statement, we update the rental_rate for those films that exist in the results of a subquery. The subquery returns the 20 most rented films. 

```sql
update film
set rental_rate = rental_rate * 1.1
where film_id in
  (
    select
      i.film_id
    from rental as r
      inner join inventory as i using (inventory_id)
    group by i.film_id
    order by count(*) desc
    limit 20
  );
```

#### 11.8 Write a script to add a new column to the films table to hold the length of each film in hours (have a look at some of the examples for the [ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html) command) and then populate this new column with the correct values

The script first creates the new column length_hrs of type numeric(2, 1) - allowing the storing of lengths like 1.2 hrs, 3.0 hrs, etc. Next the update statement populates the column with correct values, taking care to avoid integer division by dividing by 60.0.

```sql
alter table film
  add column length_hrs numeric(2, 1);

update film
set length_hrs = length / 60.0
returning *;
```

#### 11.9 Delete all the payments where the payment amount was zero, returning the deleted rows

```sql
delete from payment
where amount = 0
returning *;
```

#### 11.10 Delete all the unused languages from the language table

This solution makes use of a plain uncorrelated subquery to return all the languages that are in use in the film table and deletes any languages from the language table not in this list. 

```sql
delete from language
where language_id not in
  (select distinct language_id
   from film);
```

#### 11.11 Write a single update statement to update the activebool column for customers to be true if they made a rental in 2006 or later, and false otherwise.

In this exercise, the update statement must update the value of the activebool column conditionally. If the customer has made rentals in 2006 or later, the value must be set to true. If the customer hasn't made any rentals in 2006 or later, the value must be set to false. Whenever you come across conditional situations like this, case expressions often come in handy. Here we use a case expression that depends on the result of a correlated subquery that evaluates whether any rentals were made for each customer in 2006 or later. 

```sql
update customer
set activebool =
  case
    when exists
      (select *
       from rental
       where rental.customer_id = customer.customer_id
         and rental_date >= '2006-01-01')
       then true
    else false
  end;
```

#### 11.12 Create a new table, with appropriate primary keys and foreign keys, to hold the amount of inventory of each film in each store (store_id, film_id, stock_count). In this table we want to store the stock level for every film in every store - including films that aren't in stock. Write an "upsert" statement to populate the table with the correct values. By "upsert", I mean insert a SQL statement that will either insert a new row in the table (ie. a new film, store, stock count) or update the stock count if the film/store attempting to be inserted already exists in the table). Research PostgreSQL's [INSERT ON CONFLICT](https://www.postgresql.org/docs/current/sql-insert.html) and look at the examples for some guidance on how to do this.

This was a quite difficult exercise so give yourself a big pat on the back if you were able to work it out. Starting with the table creation, we create a new table called inventory_stats with a composite primary key consisting of the store_id and film_id. For the INSERT statement the underlying query providing the data to be inserted (or updated) is a cross join between the film and store tables to produce all unique combinations of films and stores, and then left joined with the inventory table to tally up stock levels, including films that aren't in stock. Finally, the ON CONFLICT clause ensures that if there is a primary key violation on insert, the stock count is still updated. Upsert statements can come in handy in many situations! /

```sql
create table inventory_stats
(
  store_id smallint references store (store_id),
  film_id smallint references film (film_id),
  stock_count int not null,
  primary key (store_id, film_id)
);

insert into inventory_stats(store_id, film_id, stock_count)
  select s.store_id, f.film_id, count(i.inventory_id)
  from film as f
    cross join store as s
    left join inventory as i
      on f.film_id = i.film_id
      and s.store_id = i.store_id
  group by f.film_id, s.store_id
on conflict (store_id, film_id)
do update set
  stock_count = excluded.stock_count;
```

#### 11.13 Write a single statement to delete the first rental made by each customer and to avoid any foreign key violations you'll also have to delete any associated payments in that same statement. You might need to do some research online to figure this one out. As a hint, you can use Common Table Expressions (CTEs) with delete statements and delete statements themselves can return results with the RETURNING clause!

Another very tricky exercise. With this exercise, a DISTINCT ON subquery is used to obtain the first rental_id for each customer to be deleted, and the deletion from the rental table takes place within a CTE and returns the IDs that were deleted. Using the CTE results, associated payments are also deleted. Note that since both deletes occur within a single statement we avoid violating the foreign key (even though the rentals are deleted "first"). 

```sql
with deleted_rentals as
(
  delete from rental
  where rental_id in
    (select distinct on (customer_id) rental_id
     from rental
     order by customer_id, rental_date)
  returning rental_id
)
delete from payment
where rental_id in
  (select rental_id
   from deleted_rentals);
```

#### 11.14 In the films table the rating column is of type mpaa_rating, which is an ENUM. You've read online about the [downsides of ENUMs](http://komlenic.com/244/8-reasons-why-mysqls-enum-data-type-is-evil/) and now want to convert your table design to instead store the different mpaa rating types in a reference table with the type as the primary key. Write a script to create the new table, populate it with data, convert the film table, and then drop the mpaa_rating type so it won't be used ever again. You're going to need to Google a few ideas and look up some documentation to get through this one - good luck!

After creating the mpaa_ratings table, the different values the ENUM can take on are inserted in to the table. The query to obtain the different enum values for insertion in to the new table is quite strange, making use of several new functions you haven't seen before...it's just one of those things you end up Googling when infrequently needed. In the next statement we then make a number of changes to the film table - converting the rating column to type text, dropping and re-adding the default constraint (we have to do this because the column is specified to get a default value of type mpaa_rating), and then adding the foreign key constraint to reference the new table. Finally, we're able to drop the mpaa_rating type. 

```sql
create table mpaa_ratings
(
  rating text primary key
);

insert into mpaa_ratings
  select unnest(enum_range(null::mpaa_rating));

alter table film
  alter column rating drop default,
  alter column rating type text,
  alter column rating set default 'G',
  add foreign key (rating) references mpaa_ratings(rating);

drop type mpaa_rating;
```
