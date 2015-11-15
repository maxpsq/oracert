
--==============================================================================
--               CREATE VIEWS WITH VISIBLE/INVISIBLE COLUMNS
--==============================================================================
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






/*
--==============================================================================
                        ALTER VIEW
--==============================================================================
The ALTER VIEW statement is used to accomplish any of the following tasks:
- Create, modify, or drop constraints on a view (*).
- Recompile an invalid view.

(*) You can create constraints on a view in the same way you can create them 
on a table. HOWEVER: Oracle doesn’t enforce them without special configuration 
that’s available primarily to support certain data warehousing requirements. 
This subject is worth noting but not specifically addressed on the exam.
*/

ALTER VIEW my_view COMPILE ;


--==============================================================================
--             WITH CHECK OPTION
--==============================================================================
-- set up
create table employees_t01 as
select *
  from hr.employees ;

create or replace view employees_t01_vw as
select *
  from employees_t01
 where salary > 9000 
 with check option ;

create or replace view employees_t02_vw as
select *
  from employees_t01
 where salary > 9000 ;

-- On the vewi without check option
select * from employees_t02_vw where employee_id = 114 ;

update employees_t02_vw set salary=7900 where employee_id = 114 ;

select * from employees_t02_vw where employee_id = 114 ;

rollback;

-- On the view with check option
select * from employees_t01_vw where employee_id = 114 ;

update employees_t01_vw set salary=7900 where employee_id = 114 ;


-- tear down 
drop view employees_t01_vw ;
drop view employees_t02_vw ;
drop table employees_t01 purge;

/*
It can be used also on INLINE VIEWS...
*/

-- set up
create table departments_t01 as
select * from hr.departments;

select * from departments_t01 where department_id in ( 9998, 9999) ;

/*
The select statement enclosed in parentheses is an INLINE VIEW. It is possible to
insert, update and delete records against a INLINE VIEW as it was a regular view
*/
INSERT INTO (SELECT department_id, department_name, location_id 
               FROM departments_t01 WHERE location_id < 2000)
   VALUES (9999, 'Entertainment', 2500);
   
INSERT INTO (SELECT department_id, department_name, location_id 
               FROM departments_t01 WHERE location_id < 2000 WITH CHECK OPTION)
   VALUES (9998, 'Entertainment', 2500);
   
   
   
-- tear down 
drop table departments_t01 purge;

