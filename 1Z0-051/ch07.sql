/*
select r.REGION_NAME
  from regions r NATURAL JOIN COUNTRIES c
 WHERE r.REGION_NAME = 'Americas'; 
 
 select * 
  from regions r, COUNTRIES c
 WHERE REGIoN_NAME = 'Americas'
   and r.region_id = c.region_id ; 
   
select * 
  from regions r  JOIN COUNTRIES c USING (region_id)
 WHERE r.REGION_NAME = 'Americas'; 


select * 
  from regions r JOIN countries c ON (r.region_id = c.region_id)
 WHERE r.REGION_NAME = 'Americas'; 

SELECT emp.employee_id, department_id, emp.manager_id, departments.manager_id
  from employees emp JOIN departments using (department_id)
 where department_id > 80 ;
*/ 
 
SELECT emp.employee_id, department_id, emp.manager_id, dep.manager_id
  FROM employees emp JOIN departments dep USING (department_id)
 WHERE department_id > 80 ;

SELECT EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP NATURAL JOIN JOB_HISTORY JH
  ;

/* JOIN ... USING */

SELECT EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP JOIN JOB_HISTORY JH USING (EMPLOYEE_ID, JOB_ID)
  ; -- ERROR on DEPARTMENT_ID (ambiguously defined)

SELECT EMPLOYEE_ID, EMP.DEPARTMENT_ID, JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP JOIN JOB_HISTORY JH USING (EMPLOYEE_ID, JOB_ID)
  ; -- OK  (see EMP.DEPARTMENT_ID )
  
SELECT EMPLOYEE_ID, JH.DEPARTMENT_ID, JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP JOIN JOB_HISTORY JH USING (EMPLOYEE_ID, JOB_ID)
  ; -- OK  (see JH.DEPARTMENT_ID )

/* JOIN ... ON */ 

SELECT EMPLOYEE_ID, DEPARTMENT_ID, JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP JOIN JOB_HISTORY JH 
    ON ( EMP.EMPLOYEE_ID = JH.EMPLOYEE_ID AND 
         EMP.JOB_ID      = JH.JOB_ID
       )
  ; -- ERROR column ambiguously defined

SELECT EMP.EMPLOYEE_ID, JH.DEPARTMENT_ID, EMP.JOB_ID, EMP.LAST_NAME, EMP.HIRE_DATE, JH.END_DATE
  FROM EMPLOYEES EMP JOIN JOB_HISTORY JH 
    ON ( EMP.EMPLOYEE_ID = JH.EMPLOYEE_ID AND 
         EMP.JOB_ID      = JH.JOB_ID
       )
  ; -- OK  (see DOT NOTATION on all columns)


/* Exercise 7.2 */
SELECT FIRST_NAME||' '||LAST_NAME||' is manager of '||DEPARTMENT_NAME||' department' AS WHO_IS_MANAGER
  FROM DEPARTMENTS JOIN EMPLOYEES USING (MANAGER_ID);


/* JOIN MULTIPLE TABLES */
DESC COUNTRIES
SELECT * 
  FROM LOCATIONS
  JOIN COUNTRIES USING (COUNTRY_ID)
  JOIN REGIONS USING (REGION_ID)
  ;  -- 23 ROWS
  
SELECT * 
  FROM LOCATIONS L
  JOIN COUNTRIES C ON (C.COUNTRY_ID=L.COUNTRY_ID)
  JOIN REGIONS R ON (R.REGION_ID=C.REGION_ID)
  ;  -- 23 ROWS  
  
SELECT * 
  FROM LOCATIONS L
  NATURAL JOIN COUNTRIES C
  NATURAL JOIN REGIONS R 
  ;  -- 23 ROWS  
  

SELECT * 
  FROM LOCATIONS L
  NATURAL JOIN COUNTRIES C
  JOIN REGIONS R USING (REGION_ID)
  ;  -- 23 ROWS  
  
SELECT * 
  FROM LOCATIONS L
  JOIN COUNTRIES C USING (COUNTRY_ID)
  JOIN REGIONS R ON (R.REGION_ID = C.REGION_ID)
  ;  -- 23 ROWS  
  
  
SELECT department_name from departments d
JOIN locations l ON (l.location_id = d.location_id)
WHERE d.department_name like 'P%';

SELECT department_name from departments d
JOIN locations l ON (l.location_id = d.location_id AND d.department_name like 'P%' );



SELECT E.JOB_ID AS CURRENT_JOB
     , e.last_name||' can earn twice their salary by changing job to '||J.JOB_ID as hint
     , e.salary as current_salary
     , j.max_salary as potential_salary
  FROM EMPLOYEES E JOIN JOBS J ON ( 2 * E.SALARY < J.MAX_SALARY )
 where e.salary > 5000
 order by e.last_name;
  
  
/* SELF JOINS */  

select e.LAST_NAME as employee, m.last_name as manager
  from employees e JOIN employees m ON  m.employee_id = e.manager_id 
 order by m.LAST_NAME;
 
 
 
 
 /* OUTER JOINS */
 
 SELECT E.LAST_NAME||' '||E.FIRST_NAME, E.DEPARTMENT_ID , d.department_name
   FROM EMPLOYEES E
   JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
   ORDER BY 1; -- INNER JOIN 106 rows
   
 SELECT E.LAST_NAME||' '||E.FIRST_NAME, E.DEPARTMENT_ID , d.department_name
   FROM EMPLOYEES E
   LEFT OUTER JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
   ORDER BY 1; -- LEFT OUTER JOIN 107 rows
   
 SELECT E.LAST_NAME||' '||E.FIRST_NAME, E.DEPARTMENT_ID , d.department_name
   FROM EMPLOYEES E
   RIGHT OUTER JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
   ORDER BY 1; -- RIGHT OUTER JOIN 122 rows
   
SELECT E.LAST_NAME||' '||E.FIRST_NAME, E.DEPARTMENT_ID , d.department_name
   FROM EMPLOYEES E
   FULL OUTER JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
   ORDER BY 1; -- RIGHT OUTER JOIN 123 rows


/* CROSS JOIN (CARTESIAN PRODUCT) */   

-- ANSI SQL:1999
SELECT * 
  FROM regions
  CROSS JOIN countries ;

-- ORACLE TRADITIONAL NOTATION
SELECT * 
  FROM regions, countries ;
  
SELECT COUNT(DISTINCT D.DEPARTMENT_ID) "#DEP"
     , COUNT(DISTINCT E.EMPLOYEE_ID) "#EMP"
     , COUNT(DISTINCT D.DEPARTMENT_ID) * COUNT(DISTINCT E.EMPLOYEE_ID) AS "#DEP x #EMP"
     , COUNT(*) AS "#CARTESIAN"
  FROM DEPARTMENTS D
  CROSS JOIN EMPLOYEES E ;