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

#### 



```sql

```

#### 



```sql

```
