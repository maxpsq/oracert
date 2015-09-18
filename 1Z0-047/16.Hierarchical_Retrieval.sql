/* Hierarchical retrieval */

/* 
START WITH and CONNECT BY 

When a 'connect by' clause is added to a query, a pseudo-column named 'level'
is automatically added to the query. 
The values provaded by 'level' range from 1 to N.
*/

select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 ;

-- omitting 'prior' will not raise any error, but it will show only one row 
-- (the one specified by the 'start with' caluse)
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with manager_id is null
 connect by manager_id = employee_id 
 ;

-- Reverting traversal direction
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;

select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with employee_id = 108
 connect by prior manager_id = employee_id 
 ;

-- Notice the order of 'start with' and 'connect by' is interchangable
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 connect by manager_id = prior employee_id 
 start with manager_id is null 
 ;


-- Restrictig rows using a WHERE condition
-- the 'Where clause' MUST preceede both 'start with' and 'connect by'
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;

select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 where employee_id < 112 
 start with employee_id = 108
 connect by manager_id = prior employee_id 
 ;

-- "order siblings by" clause oders the resuts by a given column within each level.
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 order siblings by last_name
 ;

-- sys_connect_by_path()
-- 1. it is only valid in hierarchical queries.
select sys_connect_by_path(employee_id||' '||first_name||' '||last_name, ' > ') as x 
  from employees 
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
  from employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
 order siblings by last_name
 ;

/* excluda a branch from the hierarchical tree */
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from employees 
 start with manager_id is null
 connect by manager_id = prior employee_id 
        and employee_id <> 108 -- the 'connect by' clause may exclude a branch given a its root node
 ;


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
