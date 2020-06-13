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
