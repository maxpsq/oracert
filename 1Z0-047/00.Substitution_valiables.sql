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

