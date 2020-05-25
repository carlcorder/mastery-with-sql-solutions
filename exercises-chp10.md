# Exercises Chp 10

#### 10.1 In this and the following exercises in this chapter, we're going to be doing some lightweight database modelling work for a fictional beach equipment rental business. Your answers may deviate a little from mine as we go, and that's fine - database design is a quite subjective topic. To kick things off, we'll keep working with our existing database but we want to create all our tables within a schema called 'beach'. Write a SQL statement to create the 'beach' schema.

```sql
create schema beach;
```

#### 10.2 Create a table to store customers. For each customer we want to capture their first name, last name, email address, phone number, and the date the account was created. Don't worry about primary keys and constraints for now - just focus on the create statement and choosing what you think are appropriate data types for the listed attributes.

The text data type is actually ideal for the email, first name, and last name. When it comes to PostgreSQL, you should typically prefer to use text instead of varchar(n) - there's no performance difference, and unless you have a good reason to want to set a maximum length just use text (you can also set a maximum length with text via a CHECK constraint - and more too!). For the phone number, you could get more fancy and try to denormalize it further in to a few columns (for international dialing prefix, number, extension, etc.) but it's awfully complicated and there are many exceptions and edge cases. text is the more flexible approach. The create date can be of type date - we don't need a time component. 

```sql
create table beach.customers (
  email text,
  first_name text,
  last_name text,
  phone text,
  create_date date
);
```

#### 10.3 Create a table to store details about the equipment to be rented out. For each item, we want to store the type ('surf board', 'kayak', etc.), a general ad-hoc description of the item (color, brand, condition, etc), and replacement cost so we know what to charge customers if they lose the item.

Both the item type and description can be text. Because the business will be only stocking certain types of items, in a future exercise we'll investigate ways to restrict the item_type just to particular values. The replacement cost is an interesting one - PostgreSQL actually does actually have a [money data type](https://www.postgresql.org/docs/current/datatype-money.html) that should in theory be ideal. In practice though, it has a range of problems you can read about online and so numeric is the better choice. I've opted for a precision of 7 and scale of 2, which allows storing items of up to value $99,999.99 which seems more than adequate! 

```sql
create table beach.equipment (
  item_type text,
  description text,
  replacement_cost numeric(7, 2)
);
```

#### 10.4 After running the business for a while, we notice that customers sometimes lose equipment. Write a SQL statement to alter the equipment table (assume it already has data in it we don't want to lose) to add a column to track whether the item is missing.

You can use the ALTER TABLE statement to add a column to an existing table. In this case, we add the column missing to be of type boolean. 

```sql
alter table beach.equipment
  add missing boolean;
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
