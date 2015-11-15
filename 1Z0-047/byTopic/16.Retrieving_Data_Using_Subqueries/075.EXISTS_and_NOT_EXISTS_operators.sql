/*

Case study on EXISTS and NOT EXISTS

*/

/*   EXISTS
==================================================
*/
select * 
  from hr.departments d
 where exists (
select * 
  from hr.employees e
 where e.department_id = d.department_id ) ;
 
select * 
  from hr.departments d
 where exists (
select employee_id 
  from hr.employees e
 where e.department_id = d.department_id ) ; 
 
/*  NOT EXISTS
==================================================
*/

select * 
  from hr.departments d
 where NOT exists (
select * 
  from hr.employees e
 where e.department_id = d.department_id ) ;
 
 
select * 
  from hr.departments d
 where NOT exists (
select employee_id 
  from hr.employees e
 where e.department_id = d.department_id ) ; 
 
 
/*  Differences between EXISTS and IN()
==================================================
Difference is in how NULL values are theted. 
Furthermore, EXISTS is more performant the IN()
*/

select * 
  from hr.departments d
 where exists (
select employee_id 
  from hr.employees e
 where e.department_id = d.department_id ) ; 

select * 
  from hr.departments d
 where d.department_id in (
      select employee_id 
        from hr.employees e ) ; 


 select * 
  from hr.departments d
 where exists (
select null
  from hr.employees e
 where e.department_id = d.department_id ) ; 
 
 
select * 
  from hr.departments d
 where d.department_id in (
      select null
        from hr.employees e ) ; 
