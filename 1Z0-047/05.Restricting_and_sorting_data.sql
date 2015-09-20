/* Comparison operators */
Select * 
  from employees              -- NOT EQUAL
 where department_id <> 100   -- <>
   and department_id != 100   -- !=
   and department_id ^= 100 ; -- ^=
   
   
/* Boolean operator precedence 
NOT
AND
OR
*/   
SELECT *
  FROM employees
 WHERE First_name LIKE 'St%'
    OR First_name LIKE 'Jo%' 
   AND NOT salary > 3000;
   
-- is equivalent to:

SELECT *
FROM   employees
WHERE  First_name LIKE 'St%'
   OR  ( First_name LIKE 'Jo%' AND ( not salary > 3000 ) );
   
/* Order by */

/* It is possible to sort by columns not included in the projection clause */
Select first_name, Last_name
  from employees
order by employee_id ;

/* NULL is considered (by default) the highest value. */
Select first_name, Last_name, commission_pct 
  from employees
order by commission_pct ;

Select first_name, Last_name, commission_pct 
  from employees
order by commission_pct desc;


/* * * * * ALIASES * * * * */

/* Column names may be used for sorting even on aliased columns */
Select first_name, Last_name as family_name
  from employees
order by Last_name ;

/* aliases may be used to for sorting */
Select first_name, Last_name as "family name"
  from employees
order by "family name" ;

/* Aliases cannot be used in WHERE, GROUP BY or HAVING clauses */

/* Order by reference */
Select first_name, Last_name as family_name
  from employees
order by 2 ;

/* Won't execute */
Select first_name, Last_name as family_name
  from employees
order by 5 ; --> we have only 2 columns in the projection


/* reference techniques can be mixed */
Select first_name, Last_name as "family name"
  from employees
order by "family name", 1 desc;

