/* Hierarchical retrieval */

-- connect to oracert --

/* 
START WITH and CONNECT BY 

- START WITH specifies the root row(s) of the hierarchy.

- CONNECT BY specifies the relationship between parent rows and child rows of
  the hierarchy.

When a 'connect by' clause is added to a query, pseudo-columns 
are automatically added to the query. 

LEVEL: the values provaded by 'level' range from 1 to N.

CONNECT_BY_ISLEAF: pseudocolumn returns 1 if the current row is a leaf of the 
tree defined by the CONNECT BY condition. Otherwise it returns 0. 
This information indicates whether a given row can be further expanded to show 
more of the hierarchy.


Connect by clause gives the condition about how to navigate the hierarchical tree.
Notice the reserved word 'prior' identifies the node which comes before 
in importance to the related node according to the hierarchy.

... PRIOR child_expression = parent_expression    or
... parent_expression = PRIOR child_expression

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



-- Notice a hierarchy may have MORE THEN ONE ROOT NODE !!
select lpad(level,3)||lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with employee_id in (100,108) --> 2 ROOT NODES
 connect by manager_id = prior employee_id 
 ;

/*
If the CONNECT BY condition is compound, then only one condition requires the 
PRIOR operator, although you can have multiple PRIOR conditions. For example:
*/
select lpad(level,3)||lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||')' as x 
  from hr.employees 
 start with employee_id = 100 
 connect by manager_id = prior employee_id and last_name != 'King' --> only one occurrence of prior
 ;

select * from hr.employees ;


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

/*
The NOCYCLE parameter instructs Oracle Database to return rows from a query even 
if a CONNECT BY LOOP exists in the data. Use this parameter along with 
the CONNECT_BY_ISCYCLE pseudocolumn to see which rows contain the loop. 

The CONNECT_BY_ISCYCLE pseudocolumn returns 1 if the current row has a child 
which is also its ancestor. Otherwise it returns 0.
You can specify CONNECT_BY_ISCYCLE only if you have specified the NOCYCLE 
parameter of the CONNECT BY clause. NOCYCLE enables Oracle to return the results 
of a query that would otherwise fail because of a CONNECT BY loop in the data.
*/
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||') '||
       decode(CONNECT_BY_ISCYCLE,1,'--> CYCLE: '||employee_id||'/'||manager_id,'') as x 
  from my_employees
 start with employee_id = 100
 connect by NOCYCLE manager_id = prior employee_id 
 ;

-- here I revert the direction of the hierarchy and I start from employee 109:
-- employee 100 is not retrieved and CONNECT_BY_ISCYCLE is TRUE on employee 101
select lpad(' ',level*3,' ')||employee_id||' '||first_name||' '||last_name||' ('||manager_id||') '||
       decode(CONNECT_BY_ISCYCLE,1,'--> CYCLE: '||employee_id||'/'||manager_id,'') as x 
  from my_employees
 start with employee_id = 109
 connect by NOCYCLE prior manager_id = employee_id 
 ;

-- tear down 
drop table my_employees purge ;

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
