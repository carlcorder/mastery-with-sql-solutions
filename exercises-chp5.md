## Exercises Chp 5


#### 5.1 Write a query to print a description of each film's length as shown in the output below. When a film does not have a length, print: [title] is unknown length

```sql
select
  title || ' is ' || coalesce(length || ' minutes', 'unknown length') as length_desc 
from film;
```

#### 5.2 You want to play a movie title guessing game with some friends. Write a query to print only the first 3 letters of each film title and then '*' for the rest (The repeat function may come in handy here...)

```sql
select left(title, 3) || repeat('*', length(title) - 3) as "Guess!"
from film;
```

#### 5.3 Write a query to list the percentage of films that are rated NC-17, G, PG, PG-13, NC-17, and R, rounded to the nearest integer.

```sql
select
  round(100.0 * count(*) filter(where rating = 'NC-17') / count(*)) as "% NC-17",
  round(100.0 * count(*) filter(where rating = 'PG') / count(*)) as "% PG",
  round(100.0 * count(*) filter(where rating = 'G') / count(*)) as "% G",
  round(100.0 * count(*) filter(where rating = 'R') / count(*)) as "% R",
  round(100.0 * count(*) filter(where rating = 'PG-13') / count(*)) as "% PG-13"
from film; 
```

#### 5.4 Try a few of the different explicit casting operations listed below to get familiar with how casting behaves. Was the behaviour what you expected?

```sql
select int '33';
select int '33.3';
select cast(33.3 as int);
select cast(33.8 as int);
select 33::text;
select 'hello'::varchar(2);
select cast(35000 as smallint);
select 12.1::numeric(1,1);
```

There's a few interesting things to point out here. First, note that the second query fails - when you're using the decorated literal form, the literal must exactly match the target type. For the third and fourth queries when 33.3 and 33.8 are cast to int, both succeed and round up or down to the nearest integer. Casting a number to text works just fine as does casting some literal text to a varchar, but the result is truncated to as many characters as the varchar can fit. The final two queries fail - 35,000 does not fit within a smallint and likewise 12.1 does not fit within a numeric(1,1).

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
