
/* 
LATERAL INLINE VIEWS

https://oracle-base.com/articles/12c/lateral-inline-views-cross-apply-and-outer-apply-joins-12cr1#lateral-inline-views

http://docs.oracle.com/database/121/SQLRF/statements_10002.htm#SQLRF01702

This select is an attempt of joining a table with a query. It raises an error 
*/
SELECT department_name, employee_name
FROM   hr.departments d,
       (SELECT last_name
        FROM   hr.employees e
        WHERE  e.department_id = d.department_id);  -- ERROR !!!
        
/* 
The problem is D.DEPARTMENT_ID in the inlive view is out of scope 
We sould have written the query as follows:
*/

SELECT d.department_name, e.last_name
FROM   hr.departments d,
       (SELECT last_name, department_id
        FROM   hr.employees ) e
WHERE  e.department_id = d.department_id;


/* 
however it is possible to make it work adding the LATERAL keyword before the
inline query.
specify LATERAL to designate subquery as a lateral inline view. 
Within a lateral inline view, you can specify tables that appear to the LEFT 
of the lateral inline view in the FROM clause of a query. You can specify 
this LEFT correlation anywhere within subquery (such as the SELECT, FROM, 
and WHERE clauses) and at any nesting level.
*/
SELECT department_name, last_name
FROM   hr.departments d,
LATERAL (SELECT e.last_name
         FROM   hr.employees e
         WHERE  e.department_id = d.department_id);



        
/*
Restrictions on LATERAL: 
Lateral inline views are subject to the following restrictions:

R01. If you specify LATERAL, then you cannot specify the pivot_clause, 
the unpivot_clause, or a pattern in the table_reference clause.

R02. If a lateral inline view contains the query_partition_clause, and 
it is the right side of a join clause, then it cannot contain a left 
correlation to the left table in the join clause. However, it can 
contain a left correlation to a table to its left in the FROM clause 
that is not the left table.

R03. A lateral inline view cannot contain a left correlation to the first 
table in a right outer join or full outer join.
*/

