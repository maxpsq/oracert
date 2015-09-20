/*
Analytic Functions

https://oracle-base.com/articles/misc/analytic-functions

http://orafaq.com/node/55

connect to hr

*/

/*
In order to understand analytic functions, let's start 
from this simple aggregate AVG() function:
*/

SELECT department_id, AVG(salary)
FROM   hr.employees
GROUP BY department_id
ORDER BY department_id;

/*
The aggregate function reduces the number of rows returned 
by the query.

Analytic functions also operate on subsets of rows, similar 
to aggregate functions in GROUP BY queries, but they do not 
reduce the number of rows returned by the query. For example, 
the following query reports the salary for each employee, 
along with the average salary of the employees within the 
department.
*/

SELECT employee_id, department_id, salary,
       AVG(salary) OVER (PARTITION BY department_id) AS avg_dept_sal
FROM   hr.employees;

/*
This brings out the main difference between aggregate and analytic functions. 
Though analytic functions give aggregate result they do not group the result set. 
They return the group value multiple times with each record. As such any other 
non-"group by" column or expression can be present in the select clause.

Analytic functions are computed after all joins, WHERE clause, GROUP BY 
and HAVING are computed on the query. 
The main ORDER BY clause of the query operates after the analytic functions. So 
analytic functions can only appear in the select list and in the main ORDER BY 
clause of the query.
*/

/*
OVER

OVER ( [PARTITION BY <...>] [ORDER BY <....>] [<window_clause>] )

Makes possible to apply an aggregate function on one or more sets of rows 
(called 'partitions') avoiding the use of a subquery containing a GROUP BY clause.
The result of the aggregate function is repeated on each row related to the same
partition passed to the aggregate function via the OVER() clause.

In absence of any PARTITION or <window_clause> inside the OVER() portion, 
the function acts on entire record set returned by the where clause...
*/

SELECT employee_id, department_id, salary,
       AVG(salary) OVER () AS avg_dept_sal
FROM   hr.employees;

/*
...that's the same average as computed with AVG() on the entire record set 
*/
SELECT AVG(salary)
FROM   hr.employees
ORDER BY department_id;

/*
Some functions support the <window_clause> inside the partition to further limit 
the records they act on. In the absence of any <window_clause> analytic functions 
are computed on all the records of the partition clause.

The functions SUM, COUNT, AVG, MIN, MAX are the common analytic functions the 
result of which does not depend on the order of the records.

Functions like LEAD, LAG, RANK, DENSE_RANK, ROW_NUMBER, FIRST, FIRST VALUE, 
LAST, LAST VALUE depends on order of records. 
In the next example we will see how to specify that.

The general syntax of specifying the ORDER BY clause in analytic function is:

ORDER BY <sql_expr> [ASC or DESC] NULLS [FIRST or LAST]


** ROW_NUMBER, RANK and DENSE_RANK **

All the above three functions assign integer values to the rows depending on 
their order. That is the reason of clubbing them together.

ROW_NUMBER() returs the number of each row according to the 'partition' and 
the 'order by' condition given to the OVER() clause.
*/
-- Query-5 (ROW_NUMBER example)
SELECT employee_id, department_id, hire_date
     , ROW_NUMBER( ) OVER (PARTITION BY department_id ORDER BY hire_date NULLS LAST) SRLNO
FROM hr.employees
WHERE department_id IN (90, 20)
ORDER BY department_id, SRLNO;

/*
RANK and DENSE_RANK both provide rank to the records based on some column value 
or expression. 
In case of a tie of 2 records at position N, RANK declares 2 positions N and 
skips position N+1 and gives position N+2 to the next record. While DENSE_RANK 
declares 2 positions N but does not skip position N+1.
*/
SELECT employee_id, department_id, salary
     , RANK( ) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) RANK
     , DENSE_RANK( ) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) DENSE_RANK
FROM hr.employees
WHERE department_id IN (90, 80)
ORDER BY department_id, RANK;

/*
145	80	14000	1	1
146	80	13500	2	2
147	80	12000	3	3
168	80	11500	4	4
174	80	11000	5	5
148	80	11000	5	5  
162	80	10500	7	6  
149	80	10500	7	6
150	80	10000	9	7
156	80	10000	9	7
169	80	10000	9	7
170	80	9600	12	8  --> RANK() skips rank 8 and 9 (last 2 rows with ranked as 9), DENSE_RANK() doesn't skip and just rank the record as the previous + 1
151	80	9500	13	9
163	80	9500	13	9
157	80	9500	13	9
152	80	9000	16	10
158	80	9000	16	10
175	80	8800	18	11
176	80	8600	19	12
177	80	8400	20	13
159	80	8000	21	14
153	80	8000	21	14
154	80	7500	23	15
160	80	7500	23	15
171	80	7400	25	16
172	80	7300	26	17
164	80	7200	27	18
161	80	7000	28	19
155	80	7000	28	19
165	80	6800	30	20
166	80	6400	31	21
179	80	6200	32	22
167	80	6200	32	22
173	80	6100	34	23
100	90	24000	1	1
101	90	17000	2	2
102	90	17000	2	2
*/

/*
LEAD()/LAG()
LEAD has the ability to compute an expression on the next rows (rows which are 
going to come after the current row) and return the value to the current row. 
The general syntax of LEAD is shown below:

LEAD (<sql_expr>, <offset>, <default>) OVER (<analytic_clause>)

<sql_expr> is the expression to compute from the leading row.
<offset> is the index of the leading row relative to the current row.
<offset> is a positive integer with default 1.
<default> is the value to return if the <offset> points to a row outside the partition range.

The syntax of LAG is similar except that the offset for LAG goes into the previous rows.
*/
SELECT department_id, employee_id, salary
     , LEAD(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) NEXT_LOWER_SAL
     ,  LAG(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) PREV_HIGHER_SAL
FROM hr.employees
WHERE department_id IN (90, 20)
ORDER BY department_id, salary DESC;
/*
NEXT_LOWER_SAL equals SALARY on the next row
PREV_HIGHER_SAL equals SALARY on the previous row

here's the resuts:
20	201	13000	 6000	    0
20	202	 6000	    0	13000
90	100	24000	17000	    0
90	101	17000	17000	24000
90	102	17000	    0	17000
*/

/*
FIRST VALUE and LAST VALUE
The general syntax is:

FIRST_VALUE(<sql_expr>) OVER (<analytic_clause>)

The FIRST_VALUE analytic function picks the first record from the partition 
after doing the ORDER BY. 
The <sql_expr> is computed on the columns of this first record and results are 
returned. 
The LAST_VALUE function is used in similar context except that it acts on the 
last record of the partition.
*/
SELECT employee_id, department_id, hire_date
     , FIRST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date) DAY_GAP1
     ,  LAST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date) DAY_GAP2
FROM hr.employees
WHERE department_id IN (20, 30)
ORDER BY department_id, hire_date;


/*
FIRST and LAST

The FIRST function (or more properly KEEP FIRST function) is used in a very 
special situation. Suppose we rank a group of record and found several records 
in the first rank. Now we want to apply an aggregate function on the records of 
the first rank. KEEP FIRST enables that.

The general syntax is:

Function( ) KEEP (DENSE_RANK FIRST ORDER BY <expr>) OVER (<partitioning_clause>)

Please note that FIRST and LAST are the only functions that deviate from the 
general syntax of analytic functions. They do not have the ORDER BY inside
the OVER clause. Neither do they support any <window> clause. The ranking done 
in FIRST and LAST is always DENSE_RANK. 

The query below shows the usage of FIRST function. 
The LAST function is used in similar context to perform computations 
on last ranked records.
*/

-- How each employee's salary compare with the average salary of the first
-- year hires of their department?

SELECT employee_id, department_id, TO_CHAR(hire_date,'YYYY') HIRE_YR, salary
     , TRUNC( 
       AVG(salary) KEEP (DENSE_RANK FIRST ORDER BY TO_CHAR(hire_date,'YYYY') ) OVER (PARTITION BY department_id) 
       ) AVG_SAL_YR1_HIRE
     , TRUNC( 
       AVG(salary) KEEP (DENSE_RANK  LAST ORDER BY TO_CHAR(hire_date,'YYYY') ) OVER (PARTITION BY department_id) 
       ) AVG_SAL_YRL_HIRE
FROM hr.employees
WHERE department_id IN (20, 10)
ORDER BY department_id, employee_id, HIRE_YR;


/*
How to specify the Window clause (ROW type or RANGE type windows)?

Some analytic functions (AVG, COUNT, FIRST_VALUE, LAST_VALUE, MAX, MIN and SUM 
among the ones we discussed) can take a window clause to further sub-partition 
the result and apply the analytic function. An important feature of the windowing 
clause is that it is dynamic in nature.

The general syntax of the <window_clause> is

[ROW or RANGE] BETWEEN <start_expr> AND <end_expr>

<start_expr> can be any one of the following 
  1. UNBOUNDED PECEDING
  2. CURRENT ROW 
  3. <sql_expr> PRECEDING or FOLLOWING.

<end_expr> can be any one of the following
  1. UNBOUNDED FOLLOWING or
  2. CURRENT ROW or
  3. <sql_expr> PRECEDING or FOLLOWING.
  
For ROW type windows the definition is in terms of row numbers before or after 
the current row. So for ROW type windows <sql_expr> must evaluate to 
a positive integer.

For RANGE type windows the definition is in terms of values before or after 
the current ORDER. We will take this up in details latter.

The ROW or RANGE window cannot appear together in one OVER clause. 
The window clause is defined in terms of the current row. But may or may not 
include the current row. The start point of the window and the end point of the 
window can finish before the current row or after the current row. 
Only start point cannot come after the end point of the window. In case any point 
of the window is undefined the default is UNBOUNDED PRECEDING for <start_expr> 
and UNBOUNDED FOLLOWING for <end_expr>.

If the end point is the current row, syntax only in terms of the start point can be
[ROW or RANGE] [<start_expr> PRECEDING or UNBOUNDED PRECEDING ]

[ROW or RANGE] CURRENT ROW is also allowed but this is redundant. In this case 
the function behaves as a single-row function and acts only on the current row.


RANGE Windows
For RANGE windows the general syntax is same as that of ROW:

Function( ) OVER (PARTITION BY <expr1> ORDER BY <expr2> RANGE BETWEEN <start_expr> AND <end_expr>)
or 
Function( ) OVER (PARTITION BY <expr1> ORDER BY <expr2> RANGE [<start_expr> PRECEDING or UNBOUNDED PRECEDING]

For <start_expr> or <end_expr> we can use UNBOUNDED PECEDING, CURRENT ROW 
or <sql_expr> PRECEDING or FOLLOWING. However for RANGE type windows <sql_expr> 
must evaluate to value compatible with ORDER BY expression <expr1>.

<sql_expr> is a logical offset. It must be a constant or expression that evaluates 
to a positive numeric value or an interval literal. Only one ORDER BY expression 
is allowed.

If <sql_expr> evaluates to a numeric value, then the ORDER BY expr must be 
a NUMBER or DATE datatype. If <sql_expr> evaluates to an interval value, then 
the ORDER BY expr must be a DATE datatype.

Note the example (Query-11) below which uses RANGE windowing. The important thing 
here is that the size of the window in terms of the number of records can vary.
*/
-- For each employee give the count of employees getting half more that their 
-- salary and also the count of employees in the departments 20 and 30 getting half 
-- less than their salary.
 
SELECT department_id, employee_id, salary
     , Count(*) OVER (PARTITION BY department_id ORDER BY salary 
       RANGE BETWEEN UNBOUNDED PRECEDING AND (salary/2) PRECEDING) CNT_LT_HALF
     , COUNT(*) OVER (PARTITION BY department_id ORDER BY salary 
       RANGE BETWEEN (salary/2) FOLLOWING AND UNBOUNDED FOLLOWING) CNT_MT_HALF
FROM hr.employees
WHERE department_id IN (20, 30)
ORDER BY department_id, salary ;


/*
Order of computation and performance tips

Defining the PARTITOIN BY and ORDER BY clauses on indexed columns (ordered in 
accordance with the PARTITION CLAUSE and then the ORDER BY clause in analytic 
function) will provide optimum performance. For Query-5, for example, a composite 
index on (deptno, hiredate) columns will prove effective.

It is advisable to always use CBO for queries using analytic functions. The tables 
and indexes should be analyzed and optimizer mode should be CHOOSE.

Even in absence of indexes analytic functions provide acceptable performance but 
need to do sorting for computing partition and order by clause. If the query 
contains multiple analytic functions, sorting and partitioning on two different 
columns should be avoided if they are both NOT indexed.
*/

/*
PERCENTILE_CONT()
*/
/*
PERCENTILE_DISC()
*/
/*
STDDEV()
*/

select * from hr.employees;
