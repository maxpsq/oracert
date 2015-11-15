

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
 