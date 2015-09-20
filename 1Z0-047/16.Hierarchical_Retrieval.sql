/* Hierarchical retrieval */

-- connect to oracert --

/* 
START WITH and CONNECT BY 

When a 'connect by' clause is added to a query, a pseudo-column named 'level'
is automatically added to the query. 
The values provaded by 'level' range from 1 to N.

Connect by clause gives the condition about how to navigate the hierarchical tree.
Notice the reserved word 'prior' identifies the node which comes before 
in importance to the related node according to the hierarchy.

You will not receive a syntax error if you omit the PRIOR clause. 
But note that you are required to include it in order to satisfy the documented 
requirements of the CONNECT BY clause.
*/

select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 ;

-- same as above, we just swapped the columns in the 'connect by' clause
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with manager_id is null
 connect by prior employee_id = manager_id 
 ;

-- omitting 'prior' will not raise any error, but it will show only one row 
-- (the one specified by the 'start with' caluse)
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with manager_id is null
 connect by manager_id = employee_id 
 ;

-- Reverting traversal direction
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;

select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with employee_id = 108
 connect by prior manager_id = employee_id 
 ;

-- Notice the order of 'start with' and 'connect by' is interchangable
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 connect by manager_id = prior employee_id 
 start with manager_id is null 
 ;

-- =============================================================================
-- Restrictig rows using a WHERE condition
-- the 'Where clause' MUST preceede both 'start with' and 'connect by'
-- =============================================================================
-- Take this query and see the results...
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;
 
-- Now we apply a Where clause to exclude employees with id less the 112
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 where employee_id < 112 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;
 
-- Notice the where CLAUSE DOES NOT AFFECT the CONNECT BY clause in navigating
-- the hierarchical tree: here whe exclude the root node (id=108) and we'll see 
-- the all its children are returned
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 where employee_id != 108 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;

-- =============================================================================
-- "order siblings by" clause oders the resuts by a given column within each level.
-- =============================================================================
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 order siblings by last_name
 ;

-- sys_connect_by_path()
-- 1. it is only valid in hierarchical queries.
select sys_connect_by_path(employee_id||' '||first_name||' '||last_name, ' > ') as x 
  from hr.employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 order siblings by last_name
 ;

-- connect_by_root() 
-- Note 
-- 1. it is only valid in hierarchical queries.
-- 2. parentheses may be omitted (see 'root2')
select employee_id||' '||first_name||' '||last_name as x
     , connect_by_root(employee_id) as root1
     , connect_by_root employee_id  as root2
  from hr.employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 order siblings by last_name
 ;

/* excluda a branch from the hierarchical tree */
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
        and employee_id <> 108 -- the 'connect by' clause may exclude a branch given a its root node
 ;

/*==============================================================================
-- Some specific cases worth to note
--==============================================================================
Here I'll make a copy of employees and update the root node (employee_id=100) in
order to get a loop (manager_id = employee_id)
*/
create table my_employees as
select * from hr.employees ;

update my_employees set manager_id = 100 where employee_id = 100;
commit;

/*
This query will raise this error
ORA-01436: CONNECT BY in loop sui dati utente
01436. 00000 -  "CONNECT BY loop in user data"
*/
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from my_employees
 start with employee_id =100
 connect by manager_id = prior employee_id 
 ;

drop table my_employees ;

/* 
A note on 'connect by' clause 
'connect by' connects a row to another one given a condition to follow the
hierarchy.
If we use a always true condition, we'll get an infinite set of rows made by the
first row retrieved by the query itself.
Here's an example on DUAL table that contains only one row:
*/
select level, x from dual connect by 1 = 1;

-- here's another interesting use of 'connect by' on dual
select level from dual connect by level <= 10;
