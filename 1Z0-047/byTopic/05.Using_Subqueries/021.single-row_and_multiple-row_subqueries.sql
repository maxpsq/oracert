
/* 

Write SINGLE-ROW and MULTIPLE-ROW SUBQUERIES
============================================

IN
----------
Compares a subject value to a set of values. Returns TRUE if the subject value
equals any of the values in the set. 
Returns FALSE if the subquery returns no rows.

ANY, SOME
----------
Used in combination with single-row comparison conditions (such as = or >) to 
compare a subject value with a multirow subquery. Returns TRUE if the subject 
value finds a match consistent with the comparison operator in any of the rows 
returned by the subquery. 
Returns FALSE if the subquery returns no rows.

ALL
---------
Used in combination with single-row comparison conditions to compare a subject 
value with a multirow subquery. Returns TRUE if the subject value finds a match 
consistent with the comparison operator in all of the rows returned by the subquery. 
Returns TRUE if the subquery returns no rows.

Example: Find all products with a price that’s greater than all of the products 
in the ‘Luxury’ category: 

SELECT * FROM PRODUCTS 
 WHERE PRICE > ALL (SELECT PRICE FROM PRODUCTS WHERE CATEGORY = ‘Luxury’);

Operator comparisons
--------------------
IN  - Equal to any member in the list
ANY - Compare value to **each** value returned by the subquery
ALL - Compare value to **EVERY** value returned by the subquery

<ANY() - less than maximum
>ANY() - more than minimum
=ANY() - equivalent to IN()
>ALL() - more than the maximum
<ALL() - less than the minimum
*/


select * 
  from product_information 
 where list_price > ALL (select list_price from product_information where category_id = 32);
