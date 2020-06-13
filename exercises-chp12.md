# Exercises Chp 12

#### 12.1 We often need to get basic film information for a rental and so regularly find ourselves writing queries to join from the rental table on to the inventory and film tables. Write a view called vw_rental_film to make this more convenient, returning for each rental ID the film's title, length, and rating. Then write a query to return all the rows from this view to check it's working as expected.

For this exercise we write a simple query not so different from queries we've written many times in this course now, but embed it within the create view statement. You can now use this view to simplify any queries you write in the future! 

```sql
create view vw_rental_film as
  select
    r.rental_id,
    f.title,
    f.length,
    f.rating
  from rental as r
    inner join inventory as i using (inventory_id)
    inner join film as f using (film_id)
  order by r.rental_id;
```

#### 12.2 Use the vw_rental_film view you just created to return, for each customer, the number of 'R' films they've rented out. Include customers who haven't rented any R films also. Note - this is trickier than it first appears...be very careful and double-check your results!

For this exercise, the requirement to return 0 counts for customers who haven't rented any 'R' films complicates matters quite a bit. Quite a bit of care must be taken to ensure all customers appear in the output. For my solution, I first inner join the rental table with the view and use parentheses to combine this in to a single unit. The left outer join then takes place between the customer table and this unit. You could also achieve the same effect by first inner joining the rental table with the view, and then performing a right join on to the customer table. Due to the left join, care must also be taken when the count() function. If you had a lot of trouble with this exercise, make sure to go back and watch the "Outer joins" and "Advanced join topics" videos. 

```sql
select
  c.customer_id,
  count(r.rental_id)
from customer as c
  left join (rental as r
               inner join vw_rental_film as rf
                 on r.rental_id = rf.rental_id
                 and rf.rating = 'R')
    using (customer_id)
group by c.customer_id
order by c.customer_id;
```

#### 12.3 Create a view called vw_monthly_totals that returns the amount of income received each month (you've done this a couple of times in this course now - time to finally save this in a view to avoid the repetition!)

We simply wrap the query we've written a few times now inside a view definition. 

```sql
create view vw_monthly_totals as
  select
    date_trunc('month', payment_date) as month,
    sum(amount) as total
  from payment
  group by month
  order by month;
```

#### 12.4 Using the new vw_monthly_totals view and window functions (remember how those work? If not, here's your chance to refresh!), write a query that returns the amount of income received each month and compares it against the previous month's income, showing the change.

Using the LAG window function, you can access the previous month's total from the view and then use that to calculate the monthly income change. 

```sql
select
  month,
  total as income,
  lag(total) over (order by month) as "prev month income",
  total - lag(total) over (order by month) as "change"
from vw_monthly_totals;
```

#### 12.5 Continuing on from Exercise 1, you now have a view called vw_rental_film. You create a new materialized view called mvw_rental_film defined as below. Imagine a period of time has now passed and the materialized view's cache is out of date. Write a query which will output the difference between the original view and the materialized view (essentially this boils down to writing a query to show the difference between two sets of results). Within a test transaction block you can roll back, make some insertions and deletions to test your query works as expected.

To find out the differences between two sets of results, you need to identify two things. First, you need to find the elements that are in the first set but not in the second. And you also need to find the elements that are in the second set, but not in the first. Combining those two lists of differences, you then have the complete list. You can achieve all these operations using the set operators EXCEPT and UNION ALL as below. 

```sql
(
  select * from vw_rental_film
  except
  select * from mvw_rental_film
)
union all
(
  select * from mvw_rental_film
  except
  select * from vw_rental_film
);
```

#### 12.6 Write a function using SQL that takes as an argument a customer_id and returns the number of unreturned rentals for that customer

An unreturned rental is identified by having a return date of NULL so you must filter for that with your query. One thing which may catch you out when writing this function is to make sure the right types are being used. The count function in particular actually returns a bigint - so you can make the return type of your function bigint or cast to an int as I have (my reasoning for going with int is because the count will never be larger than int can store since the primary key of the rental table is also of type int) 

```sql
create or replace function unreturned_rentals
(
  p_customer_id int
)
returns int
language sql
as $$
  select cast(count(*) as int)
  from rental
  where customer_id = p_customer_id
    and return_date is null;
$$;
```

#### 12.7 Using the function you just created, write a query that outputs the number of unreturned rentals for each customer

Notice how from a behaviour perspective this is similar to a correlated subquery! We effectively have some SQL code that is run for each customer in the customer table and returns a single value. 

```sql
select
  customer_id,
  unreturned_rentals(customer_id)
from customer;
```

#### 12.8 Write a function using SQL to generate a random int between HIGH and LOW inclusive (two input int arguments)

There are a couple of different ways you can do this. Regardless of the approach you take, make sure to test your function by running it a number of times and observing the output. If you're uncomfortable with the math used in the solution grab a pen and paper and walk through a couple of simple examples on paper alone (eg. try rand(1, 4)). Note that the built-in random() function returns values between 0 (inclusive) and 1.0 (exclusive) which if you're not careful to account for, can cause your rand function to be off-by-one. 

```sql
create or replace function rand
(
  p_low int,
  p_high int
)
returns int
language sql
as $$
  select floor(random() * (p_high - p_low + 1))::int + p_low;
$$;
```

#### 12.9 Write a function using PL/pgSQL that decides whether a customer should get a discount when renting a film. Discounts are provided if a customer has no unreturned rentals (feel free to use the function you wrote in Exercise 12.6) and has also never rented the film before. The function should take a customer_id and film_id as arguments and return true if the customer should receive a discount, or false otherwise.

This function has a couple of key parts. First, the previously written unreturned_rentals function is used and the result stored in num_outstanding. Secondly, a inline SQL query is used to count the number of times the customer has rented the film before and the result stored in num_rented. The final return expression returns the value of the boolean expression, which is true if the customer has no unreturned rentals and also has never rented the film before (both variables are 0), and false otherwise. 

```sql
create or replace function apply_discount
(
  p_customer_id int,
  p_film_id int
)
returns boolean
language plpgsql
as $$
  declare
    num_outstanding int;
    num_rented int;
  begin
    num_outstanding := unreturned_rentals(p_customer_id);

    select count(*) into num_rented
    from rental as r
      inner join inventory as i using (inventory_id)
      inner join film as f using (film_id)
    where customer_id = p_customer_id
      and film_id = p_film_id;

    return (num_outstanding = 0 and num_rented = 0);
  end
$$;
```

#### 



```sql

```
