/* 
Oracle 12c

  ** OUTER APPLY **  &  ** CROSS APPLY **

https://oracle-base.com/articles/12c/lateral-inline-views-cross-apply-and-outer-apply-joins-12cr1

*/

/*==============================================================================
-- OUTER APPLY 
--==============================================================================
The OUTER APPLY clause is a variation of ANSI SQL's LEFT OUTER JOIN.
it returns all rows from the table on the left side of the join. 
If the right side of the join returns no rows, the corresponding columns in 
the output contain NULLs.
*/

-- ANSI SQL LEFT OUTER JOIN.
SELECT DEPARTMENT_NAME, LAST_NAME, FIRST_NAME
  FROM HR.DEPARTMENTS D
    LEFT OUTER JOIN HR.EMPLOYEES E
      ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 ; -- 122 ROWS
 
-- Oracle 12c OUTER APPLY 
SELECT DEPARTMENT_NAME, LAST_NAME, FIRST_NAME
  FROM HR.DEPARTMENTS D
    OUTER APPLY (SELECT * FROM HR.EMPLOYEES E
                  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 ; -- 122 ROWS
 
 
/*==============================================================================
-- CROSS APPLY 
--==============================================================================
The CROSS APPLY clause is a variation of ANSI SQL's CROSS JOIN. It returns 
all rows from the left hand table, where at least one row is returned by the 
table reference or collection expression on the right. The right side of the 
APPLY can reference columns in the FROM clause to the left. The example below 
uses a correlated inline view.
*/
-- ANSI SQL CROSS JOIN.
SELECT DEPARTMENT_NAME, LAST_NAME, FIRST_NAME
  FROM HR.DEPARTMENTS D        -- NOTICE in a CROSS JOIN we cannot use the ON clause
    CROSS JOIN HR.EMPLOYEES E  -- ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 WHERE (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 ; -- 106
 
-- Oracle 12c CROSS APPLY 
SELECT DEPARTMENT_NAME, LAST_NAME, FIRST_NAME
  FROM HR.DEPARTMENTS D
    CROSS APPLY (SELECT * FROM HR.EMPLOYEES E
                  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID)
 ; -- 106 ROWS
 
 