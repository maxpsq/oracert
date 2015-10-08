
/*
http://stackoverflow.com/questions/31030656/invisible-columns-in-oracle-12c-view
*/



create or replace
view employees_vw (employee_id, first_name, last_name, salary) as
select employee_id, first_name, last_name, salary
  from hr.employees ;

select * from employees_vw;

create or replace
view employees_vw (employee_id, first_name, last_name, salary INVISIBLE) as
select employee_id, first_name, last_name, salary
  from hr.employees ;

select * from employees_vw;

/*
A column cannot be changed to VISIBLE/INVISIBLE using ALTER VIEW command.
*/
