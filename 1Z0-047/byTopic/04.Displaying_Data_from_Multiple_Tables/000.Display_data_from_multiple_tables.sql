/* 
         08 - Joining_tables 
========================================= */
select * from employees;
select * from DEPARTMENTS;

/******************************************
 INNER Join 
*******************************************/

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES e INNER JOIN DEPARTMENTS d
ON       e.DEPARTMENT_ID = d.DEPARTMENT_ID 
WHERE    e.LAST_NAME like 'K%'
order by e.FIRST_NAME;

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES e JOIN DEPARTMENTS d -- "INNER JOIN" is the default
ON       e.DEPARTMENT_ID = d.DEPARTMENT_ID 
WHERE    e.LAST_NAME like 'K%'
order by e.FIRST_NAME;

/* OLD STYLE SYNTAX */
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES e, DEPARTMENTS d
WHERE    e.DEPARTMENT_ID = d.DEPARTMENT_ID 
  AND    e.LAST_NAME like 'K%'
order by e.FIRST_NAME;


/*******************************************
 OUTER JOIN 
*******************************************/

/* LEFT OUTER JOIN 
Shows unmatching records on the LEFT side of the JOIN expression
*/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l LEFT OUTER JOIN DEPARTMENTS r
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
WHERE    l.LAST_NAME like 'G%'
order by l.FIRST_NAME;

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l LEFT JOIN DEPARTMENTS r -- OUTER is optional
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
WHERE    l.LAST_NAME like 'G%'
order by l.FIRST_NAME;

/* old DEPRECATED syntax */
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l , DEPARTMENTS r 
WHERE    l.DEPARTMENT_ID = r.DEPARTMENT_ID (+)
  AND    l.LAST_NAME like 'G%'
order by l.FIRST_NAME;


/* RIGHT OUTER JOIN 
Shows unmatching records on the RIGHT side of the JOIN expression
*/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l RIGHT OUTER JOIN DEPARTMENTS r
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
WHERE    r.DEPARTMENT_NAME like 'P%'
order by l.FIRST_NAME;

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l RIGHT JOIN DEPARTMENTS r -- OUTER is optional
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
WHERE    r.DEPARTMENT_NAME like 'P%'
order by l.FIRST_NAME;

/* old DEPRECATED syntax */
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l , DEPARTMENTS r 
WHERE    l.DEPARTMENT_ID (+) = r.DEPARTMENT_ID
  AND    r.DEPARTMENT_NAME like 'P%'
order by l.FIRST_NAME;

/* FULL OUTER JOIN 
Shows unmatching records on BOTH sides of the JOIN expression
*/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l FULL OUTER JOIN DEPARTMENTS r 
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
order by l.FIRST_NAME;

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES l FULL JOIN DEPARTMENTS r -- OUTER is optional
ON       l.DEPARTMENT_ID = r.DEPARTMENT_ID 
order by l.FIRST_NAME;

/* There is no direct equivalent with OLD DEPRECATED syntax.
One may use a UNION on two select statements implementing LEFT and RIGHT JOIN.
*/


/*******************************************
 NATURAL JOIN 
*******************************************
Joins on ALL columns sharing common names on the two tables
It may be dangerous! Look at the example:
*/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES NATURAL JOIN DEPARTMENTS  -- WARNING!!! joins on DEPARTMENT_ID and MANAGER_ID
WHERE    LAST_NAME like 'K%'
order by FIRST_NAME;


/*******************************************
 The "USING" keyword
*******************************************/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
FROM     EMPLOYEES INNER JOIN DEPARTMENTS USING (DEPARTMENT_ID)
WHERE    LAST_NAME like 'K%'
order by FIRST_NAME;



/*******************************************
 Joining multiple tables
*******************************************/
SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, MIN_SALARY, MAX_SALARY
FROM     EMPLOYEES INNER JOIN DEPARTMENTS USING (DEPARTMENT_ID)
                   INNER JOIN JOBS        USING (JOB_ID)
WHERE    LAST_NAME like 'K%' 
order by FIRST_NAME;

SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, MIN_SALARY, MAX_SALARY
FROM     EMPLOYEES e INNER JOIN DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
                     INNER JOIN JOBS        j ON e.JOB_ID = j.JOB_ID
WHERE    LAST_NAME like 'K%' 
order by FIRST_NAME;

SELECT   e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME, m.FIRST_NAME as MANAGER_FN, m.LAST_NAME as MANAGER_LN
FROM     EMPLOYEES e INNER JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID 
                     INNER JOIN EMPLOYEES   m ON m.employee_id   = d.MANAGER_ID 
WHERE    e.LAST_NAME like 'K%' 
order by e.FIRST_NAME;


select * from user_tables;
select * from departments;

/*******************************************
 NON EQUIJOINS
*******************************************/

/* JOBS IN WHICH JENNIFER WHALEN'S SALARY IS IN RANGE */
select e.FIRST_NAME, e.LAST_NAME, e.salary,  j.Job_title, j.min_salary, j.max_salary
from   employees e INNER JOIN JOBS j ON e.salary BETWEEN j.min_salary AND j.max_salary
where  employee_id = 200 ;

/* JOBS JENNIFER WHALEN MAY APPLY FOR IN ORDER TO GET A BETTER SALARY */
select e.FIRST_NAME, e.LAST_NAME, e.salary,  j.Job_title, j.min_salary, j.max_salary
from   employees e INNER JOIN JOBS j ON e.salary < j.min_salary 
where  employee_id = 200 ;


/*******************************************
 SELF-JOINS
*******************************************/
SELECT e.FIRST_NAME, e.LAST_NAME, m.FIRST_NAME as MANAGER_FN, m.LAST_NAME as MANAGER_LN
from   employees e LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id;


/*******************************************
 CROSS JOINS (Cartesian product)
*******************************************/
SELECT e.FIRST_NAME, e.LAST_NAME, m.FIRST_NAME as MANAGER_FN, m.LAST_NAME as MANAGER_LN
from   employees e CROSS JOIN employees m ;
