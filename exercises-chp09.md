# Exercises Chp 9

#### 9.1 Write a query to list out all the distinct dates there was some sort of customer interaction (a rental or a payment) and order by output date

We can obtain the result we're after here by unioning the rental date and payment dates (cast to dates to remove the time component), from the rental and payment tables respectively. The union operator will take care of removing any duplicate dates from the output. 

```sql
(
  select cast(rental_date as date) as interaction_date
  from rental
)
union
(
  select cast(payment_date as date) as interaction_date
  from payment
)
order by interaction_date;
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
