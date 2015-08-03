/* DISTINCT and UNIQUE */
Select distinct department_id from employees;

Select unique department_id from employees;


/* Operators precedence 
------------------------------------------------
TABLE 4-2
Arithmetic Operators in Order of Precedence
Parentheses               ()    1
Multiplication, Division  *, /  2
Addition, Subtraction     +, -  3
*/

/* Use of asterisk */
select rownum, * from employees ; -- ERROR !!

select rownum, employees.* from employees ; -- SUCCESS

select rownum, e.* from employees e; -- SUCCESS
