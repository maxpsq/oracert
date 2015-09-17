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


/* 
Row Limiting Clause for Top-N Queries in Oracle Database 12c 

https://oracle-base.com/articles/12c/row-limiting-clause-for-top-n-queries-12cr1

*/

CREATE TABLE rownum_order_test (
  val  NUMBER
);

INSERT ALL
  INTO rownum_order_test
  INTO rownum_order_test
SELECT level
FROM   dual
CONNECT BY level <= 10;

COMMIT;

SELECT val FROM rownum_order_test ORDER BY val ;

-- Returns the first five rows ONLY
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 5 ROWS  ONLY; -- 5 rows fetched

-- Returns the first five rows and eventually
-- adds rows with the same value of the last one (WITH TIES)
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 5 ROWS  WITH TIES; -- 6 rows fetched

-- LIMIT BY PERCENTAGE
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 25 PERCENT ROWS  ONLY; -- 5 rows fetched

-- LIMIT BY PERCENTAGE WITH TIES
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 25 PERCENT ROWS  WITH TIES; -- 5 rows fetched

-- the keyword FIRST is interchangable with NEXT in any situation
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH NEXT 5 ROWS  ONLY; -- 5 rows fetched

-- An OFFSET may be applied for pagination.
-- The starting point for the FETCH is OFFSET+1
-- The OFFSET is always based on a number of rows, 
-- but this can be combined with a FETCH using a PERCENT
SELECT val FROM rownum_order_test 
 ORDER BY val 
 OFFSET 5 ROWS FETCH FIRST 5 ROWS  ONLY; -- 5 rows fetched

SELECT val FROM rownum_order_test 
 ORDER BY val 
 OFFSET 5 ROWS FETCH NEXT 25 PERCENT ROWS ONLY; -- 5 rows fetched

-- Syntax
-- (OFFSET n ROWS) FETCH [FIRST|NEXT] m (PERCENT) ROWS  [ONLY | WITH TIES]

DROP TABLE rownum_order_test ;


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


/* * * * * * Substitution Variables * * * * * */

-- The variables prefixed with a 'single ampersand' are prompted to be entered each
-- time the statement is executed.
Select employee_id, last_name, phone_number
  from employees
 where last_name = '&LASTNAME' or employee_id = &EMPNO ;

-- The variables prefixed with a 'double ampersand' are prompted to be entered 
-- on statement execution only if they're not yet defined.
Select employee_id, last_name, phone_number
  from employees
 where last_name = '&&LASTNAME' or employee_id = &EMPNO ;

-- Shows all the defined variables
DEFINE;
-- define a new variable or set an exixsting one to a new value
DEFINE variable=value;
-- destroy the variable
UNDEFINE variable;

-- SQL*Plus can switch on and off the ability to define variables
select 'Me & You' from dual;
SET DEFINE OFF
select 'Me & You' from dual;
SET DEFINE ON

