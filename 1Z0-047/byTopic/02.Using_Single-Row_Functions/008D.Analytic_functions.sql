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

The aggregate functions reduce the number of rows returned 
by the query.

*** !!!
Analytic functions also operate on subsets of rows, similar to aggregate 
functions in GROUP BY queries, but THEY DO NOT REDUCE THE NUMBER OF ROWS 
returned by the query. 
*** !!!

For example, the following query reports the salary for each employee, 
along with the average salary of the employees within the department.
*/

SELECT employee_id, department_id, salary,
       AVG(salary) OVER (PARTITION BY department_id) AS avg_dept_sal
FROM   hr.employees;

/*
This time AVG() is an analytic function.
This brings out the main difference between aggregate and analytic functions. 
Though analytic functions give aggregate result, they do not group the result set. 
They return the group value multiple times with each record. As such any other 
non-"group by" column or expression can be present in the select clause.

Analytic functions are computed:

 ** AFTER all joins, WHERE clause, GROUP BY and HAVING **
 
are computed on the query. 
 
The main ORDER BY clause of the query operates AFTER the analytic functions. 

So ANALYTIC FUNCTIONS CAN ONLY APPEAR
  - in the select list 
  - in the main ORDER BY 
clause of the query.
*/

/*
                       Analytic Function Syntax

There are some variations in the syntax of the individual analytic functions, but 
the basic syntax for an analytic function is as follows.

            analytic_function([ arguments ]) OVER (analytic_clause)

The analytic_clause breaks down into the following optional elements.

      [ query_partition_clause ] [ order_by_clause [ windowing_clause ] ]
      
The sub-elements of the analytic_clause each have their own syntax diagrams, 
shown here. Rather than repeat the syntax diagrams, the following sections 
describe what each section of the analytic_clause is used for.


QUERY_PARTITION_CLAUSE    (PARTITION BY columns)
-------------------------------------------------
The query_partition_clause divides the result set into partitions, or groups, 
of data. The operation of the analytic function is restricted to the boundary 
imposed by these partitions, similar to the way a GROUP BY clause affects the 
action of an aggregate function. 

In other words, it makes possible to apply an aggregate function on one or more 
sets of rows (called 'partitions') avoiding the use of a subquery containing 
a GROUP BY clause. The result of the aggregate function is repeated on each row 
related to the same partition passed to the aggregate function via the OVER() 
clause.

If the query_partition_clause is omitted, the whole result set is treated as a 
single partition. The following query uses an empty OVER clause, so the average 
presented is based on all the rows of the result set.
*/


SELECT employee_id, department_id, salary,
       AVG(salary) OVER () AS avg_dept_sal --> OVER is empty, so the result will be computed on just one partition
FROM   hr.employees;

/*
...that's the same average as computed with AVG() on the entire record set 
*/
SELECT AVG(salary)
FROM   hr.employees
ORDER BY department_id;

/*
If we change the OVER clause to include a query_partition_clause based on the 
department, the averages presented are specifically for the department the 
employee belongs too.
*/

SELECT employee_id, department_id, salary,
       AVG(salary) OVER (PARTITION BY department_id) AS avg_dept_sal
FROM   hr.employees e
where  e.department_id = 50;

-- PARTITION BY can include columns not present in the projection
SELECT employee_id, department_id, salary,
       AVG(salary) OVER (PARTITION BY department_id, job_id) AS avg_dept_sal
FROM   hr.employees e
where  e.department_id = 50;


/*
order_by_clause
-----------------------------------
The order_by_clause is used to order rows, or siblings, within a partition. So 
if an analytic function is sensitive to the order of the siblings in a partition 
you should include an order_by_clause. The following query uses the FIRST_VALUE 
function to return the first salary reported in each department. Notice we have 
partitioned the result set by the department, but there is no order_by_clause.

The general syntax of specifying the ORDER BY clause in analytic function is:

ORDER BY <sql_expr> [ASC | DESC] NULLS [FIRST | LAST]

Functions like LEAD, LAG, RANK, DENSE_RANK, ROW_NUMBER, FIRST, FIRST VALUE, 
LAST, LAST VALUE depends on order of records. 

The functions SUM, COUNT, AVG, MIN, MAX are the common analytic functions the 
result of which does not depend on the order of the records.

***
ORDER_BY_CLAUSE may be used without the PARTITION_CLAUSE

   func(x) OVER( ORDER BY column)
***
*/

-- FIRST_VALUE without ORDER BY clause
SELECT employee_id, department_id, salary, 
       FIRST_VALUE(salary IGNORE NULLS) 
        OVER (PARTITION BY department_id) AS first_sal_in_dept
FROM   HR.EMPLOYEES;

/*
Now compare the values of the FIRST_SAL_IN_DEPT column when we include an 
order_by_clause to order the siblings by ascending salary.
*/

SELECT employee_id, department_id, salary, 
       FIRST_VALUE(salary IGNORE NULLS) 
        OVER (PARTITION BY department_id ORDER BY salary ASC NULLS LAST) AS first_sal_in_dept
FROM   HR.EMPLOYEES;

/*
In this case the "ASC NULLS LAST" keywords are unnecessary as ASC is the default 
for an order_by_clause and NULLS LAST is the default for ASC orders. 
When ordering by DESC, the default is NULLS FIRST.

It is important to understand how the order_by_clause affects display order. 

****
The order_by_clause is guaranteed to affect the order of the rows as they are 
processed by the analytic function, but it may not always affect the display 
order. 
****

As a result, you must always use a conventional ORDER BY clause in the 
query if display order is important. Do not rely on any implicit ordering done 
by the analytic function. 

Remember, the conventional ORDER BY clause is performed after the analytic 
processing, so it will always take precedence.
*/


/*
windowing_clause
-----------------------------------
We have seen previously the query_partition_clause controls the window, or group 
of rows, the analytic operates on. The windowing_clause gives some analytic 
functions a further degree of control over this window within the current partition. 

****
The windowing_clause is an extension of the order_by_clause and as such, it can 
only be used if an order_by_clause is present. 
****
Not all analitic functions support the windowing_clause
****

The windowing_clause has two basic forms:

    RANGE BETWEEN start_point AND end_point
    ROWS  BETWEEN start_point AND end_point

Possible values for "start_point" and "end_point" are:

UNBOUNDED PRECEDING : The window starts at the first row of the partition. 
                      Only available for start points.
UNBOUNDED FOLLOWING : The window ends at the last row of the partition. 
                      Only available for end points.
CURRENT ROW : The window starts or ends at the current row. Can be used as start 
                      or end point.
value_expr PRECEDING : A physical or logical offset before the current row using 
                      a constant or expression that evaluates to a positive 
                      numerical value. When used with RANGE, it can also be 
                      an interval literal if the order_by_clause uses a 
                      DATE column.
                        
value_expr FOLLOWING : As above, but an offset after the current row.


The documentation states the start point must always be before the end point, 
but this is not true, as demonstrated by this rather silly ( 0 .. 0), 
but valid, query.

ROWS vs RANGE
-------------------

ROWS consider the values specified by the ORDER BY clause coming from ALL THE ROWS
extracted by the WINDOWING CLAUSE.

RANGE consider the values specified by the ORDER BY clause enclosed between the 
start_point and end_point of the WINDOWING CLAUSE.

So that ...

sum(salary) OVER ( PARTITION BY department_id ORDER BY salary      RANGE BETWEEN OUTBOUND PRECEEDING AND CURRENT ROW)

... is different then ...

sum(salary) OVER ( PARTITION BY department_id ORDER BY employee_id RANGE BETWEEN OUTBOUND PRECEEDING AND CURRENT ROW)



but...

sum(salary) OVER ( PARTITION BY department_id ORDER BY salary      ROWS BETWEEN OUTBOUND PRECEEDING AND CURRENT ROW)

... is equal to --

sum(salary) OVER ( PARTITION BY department_id ORDER BY employee_id ROWS BETWEEN OUTBOUND PRECEEDING AND CURRENT ROW)


http://www.kibeha.dk/2013/02/rows-versus-default-range-in-analytic.html



*/

SELECT employee_id, department_id, salary, 
       AVG(salary) OVER (PARTITION BY department_id 
                         ORDER BY salary 
                         ROWS BETWEEN 0 PRECEDING AND 0 PRECEDING
                         ) AS avg_of_current_sal
FROM   hr.employees;
/*

***
In fact, the start point must be before or equal to the end point. 
***

In addition, 
***
the current row does not have to be part of the window. The window can be defined 
to start and end before or after the current row.
***

For analytic functions that support the windowing_clause, the default action is 

        "RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW" (default)

The following query is similar to one used previously to report the employee 
salary and average department salary, but now we have included an order_by_clause 
so we also get the default windowing_clause.
*/
SELECT employee_id, department_id, salary, 
       AVG(salary) OVER (PARTITION BY department_id 
                         ORDER BY salary 
                         ) AS avg_of_current_sal
FROM   hr.employees;

/*
There are two things to notice here.
1) The addition of the order_by_clause without a windowing_clause means the query 
   is now returning a running average.
2) The default windowing_clause is "RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT 
   ROW", not "ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW". The fact it is 
   RANGE, not ROWS, means it stops at the first occurrence of the value in the 
   current row, even if that is several rows earlier. As a result, duplicate rows 
   are only included in the average when the salary value changes. You can see 
   this in the last two records of department 20 and in the second and third 
   records of department 30.
   
**** 
Adding a ORDER BY CLAUSE to an analitic function will affect the result compared
to the same funcion called without ordering clause because of the variation on
the partition caused by the DEFAULT WINDOWING_CLAUSE that restrict the partition
from ... to RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
****

Here are a few examples: 
*/

select distinct x.* from (
select department_id
     , avg(salary) over(partition by job_id) as avgsal
  from hr.employees
 where department_id = 50
) x; 

-- The result changes due to the use of 'order by salary'....
select distinct x.* from (
select department_id
     , avg(salary) over(partition by job_id order by salary) as avgsal
  from hr.employees
 where department_id = 50
) x; 

-- ... the injects a DEFAULT WINDOWING CLAUSE that corrsponds to...
select distinct x.* from (
select department_id
     , avg(salary) over(partition by job_id order by salary RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as avgsal
  from hr.employees
 where department_id = 50
) x; 

-- In order to get the same result as from the first query, whe have to change the
-- WINDOWING CLAUSE like this
select distinct x.* from (
select department_id
     , avg(salary) over(partition by job_id order by salary RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as avgsal
  from hr.employees
 where department_id = 50
) x; 

-- Selecting the preceding employee for each record basing the order on employee_id (v1)
SELECT employee_id
     , FIRST_VALUE(employee_id) OVER (order by employee_id rows between 1 preceding and current row) as x
  from hr.employees e
 where e.department_id = 50; 

-- Selecting the preceding employee for each record basing the order on employee_id (v2)
SELECT employee_id
     , FIRST_VALUE(employee_id) OVER (order by employee_id rows between 1 preceding and 1 preceding) as x
  from hr.employees e
 where e.department_id = 50; 

-- Selecting the preceding employee for each record basing the order on employee_id (v3)
SELECT employee_id
     , LAG(employee_id) OVER (order by employee_id ) as x
  from hr.employees e
 where e.department_id = 50; 

-- Selecting a preceding employee for each record basing the order on employee_id and usin a offset
SELECT employee_id
     , FIRST_VALUE(employee_id) OVER (order by employee_id rows between (3+1) preceding and 4 preceding) as x
  from hr.employees e
 where e.department_id = 50; 

-- Selecting a preceding employee for each record basing the order on employee_id and usin a offset
SELECT employee_id
     , FIRST_VALUE(employee_id) OVER (order by employee_id RANGE between (3+1) preceding and 4 preceding) as x
  from hr.employees e
 where e.department_id = 50; 

/*                      Using Analytic Functions
--------------------------------------------------------------------------------
*/

/*
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
<default> is the value to return if the <offset> points to a row outside the partition range (defaults to NULL)

The syntax of LAG is similar except that the offset for LAG goes into the previous rows.
*/
SELECT department_id, employee_id, salary
     , LEAD(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) NEXT_SAL
     ,  LAG(salary, 1, 0) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) PREV_SAL
     , LEAD(salary) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) NEXT_SAL
     ,  LAG(salary) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) PREV_SAL
     , LEAD(salary, 2, -1) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) OFF2_SAL
     ,  LAG(salary, 2, -1) OVER (PARTITION BY department_id ORDER BY salary DESC NULLS LAST) OFF2_SAL
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
     ,  LAST_VALUE(hire_date) OVER (PARTITION BY department_id ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) DAY_GAP2
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
This function has two arguments and two modes. Modes are FIRST e LAST. 
In case FIRST is used, the table will be sort ascending and the minimum 
value of the column on which rows are ordered will be kept, meaning: 
the lowest value. 
Then the rows containing the value just found earlier will be passed to 
the gouping function specified before KEEP. 

Vejamos um exemplo para ficar mais claro:
We sort the rows by commission_pct in ascending order, we keep the first 
value (the lowest NOT NULL in the table). Then we send the rows matching
the value we found on the commission_pct column to the MAX(salary) function,
getting as a result the maximum salary among the employees having the 
lowest commission_pct.

*/
Select max(salary) KEEP (DENSE_RANK FIRST ORDER BY commission_pct)
  FROM hr.employees ;

/*
How to specify the Window clause (ROWS type or RANGE type windows)?

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
PERCENTILE_CONT(expr)
Inverse distribution analytic function which works on a "continuous distribution" 
model to get the median of a column value. It takes a numeric input which is 
assumed as a percentile rank (meaning expr may range from 0 to 1) and a grouping 
specification as input. The method of linear interpolation is as below.

Calculate Row Number (R) of each row within the group using percentile value
  Get CEIL(C) and FLOOR(F) value for the row number
  If (C=F=R) then value at R
  Else, (C-R) * (Value at F) + (R-F) * (Value at C)
  
The ORDER_BY_CLAUSE and WINDOWING_CLAUSE are NOT ALLOWED.
*/
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY, 
       PERCENTILE_CONT(0.5)  
	        WITHIN GROUP (ORDER BY SALARY DESC)
	          OVER (PARTITION BY DEPARTMENT_ID) "Percentile_Cont"
	FROM hr.EMPLOYEES ;

/*
PERCENTILE_DISC(expr)
Inverse distribution analytic function which works on "discrete distribution" 
model to get the median of a column value. It takes a numeric input which is 
assumed as percentile rank (meaning expr may range from 0 to 1) and grouping 
specification as input. It returns the least value 
whose percentile is greater than or equal to the given percentile.  
*/
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY, 
       PERCENTILE_DISC(0.5)  
	        WITHIN GROUP (ORDER BY SALARY DESC)
	          OVER (PARTITION BY DEPARTMENT_ID) "Percentile_Disc"
	FROM hr.EMPLOYEES ;


/*
STDDEV( [ DISTINCT | ALL ] expression ) [ OVER ( analytical_clause ) ]

this function returns the standard deviation of a set of numbers, i.e. the square 
root of the variance for the input number set. 
It can be used as both an Aggregate and an Analytic function.

Standard deviation is a widely used measurement of variability or diversity used 
in statistics and probability theory. It shows how much variation or "dispersion" 
there is from the "average" (mean, or expected/budgeted value). A low standard 
deviation indicates that the data points tend to be very close to the mean, 
whereas high standard deviation indicates that the data are spread out over a 
large range of values.

Note that STDDEV returns zero for input set which contains only one element.

The ORDER_BY_CLAUSE and WINDOWING_CLAUSE are NOT ALLOWED.

*/

SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY, 
       STDDEV(SALARY)  
          OVER (PARTITION BY DEPARTMENT_ID) "STANDARD DEVIATION",
       STDDEV(DISTINCT SALARY)  
          OVER (PARTITION BY DEPARTMENT_ID) "STANDARD DEVIATION DISTINCT"
	FROM hr.EMPLOYEES ;

