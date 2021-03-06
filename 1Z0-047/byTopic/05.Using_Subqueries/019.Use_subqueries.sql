/*
A subquery in the place of a column name in a SELECT is expected to 
be a single-row subquery. If it is not, the result is an error message.
*/

SELECT col1,
     , (select dummy from dual ) as col2 -- single row/single column subquery
     , col3
  from mytab ;

/*
The WITH Clause
------------------


*/
select * from products;
select * from categories_tab;

WITH
  MOST_EXPENSIVE as (
    SELECT category_id, max(list_price) as highest_price
      FROM products
     group by category_id
  ),
  HARDWARE_CATEGORIES AS (
    SELECT category_id
      FROM CATEGORIES_TAB
     WHERE PARENT_CATEGORY_ID = 10 
  )
select highest_price
  from MOST_EXPENSIVE
 WHERE CATEGORY_ID IN ( SELECT CATEGORY_ID FROM HARDWARE_CATEGORIES);
 