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
