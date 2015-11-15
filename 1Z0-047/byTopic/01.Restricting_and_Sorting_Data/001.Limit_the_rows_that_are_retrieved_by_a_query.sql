/* DISTINCT and UNIQUE */
Select distinct department_id from employees;

Select unique department_id from employees;



/* Use of asterisk */
select rownum, * from employees ; -- ERROR !!

select rownum, employees.* from employees ; -- SUCCESS

select rownum, e.* from employees e; -- SUCCESS

/* Comparison operators */
Select * 
  from employees              -- NOT EQUAL
 where department_id <> 100   -- <>
   and department_id != 100   -- !=
   and department_id ^= 100 ; -- ^=
   
   
/* Operators precedence 
------------------------------------------------
TABLE 4-2
Arithmetic Operators in Order of Precedence
Parentheses               ()    1
Multiplication, Division  *, /  2
Addition, Subtraction     +, -  3
*/

/* Boolean operator precedence 
-----
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
   
