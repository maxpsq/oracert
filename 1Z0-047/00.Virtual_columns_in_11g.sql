/*
VIRTUAL COLUMNS | Oracle 11gR1 

https://oracle-base.com/articles/11g/virtual-columns-11gr1

   column_name [datatype] [GENERATED ALWAYS] AS (expression) [VIRTUAL]

If the datatype is omitted, it is determined based on the result 
of the expression. The GENERATED ALWAYS and VIRTUAL keywords are 
provided for clarity only.


*/

CREATE TABLE my_employees (
  id          NUMBER,
  first_name  VARCHAR2(10),
  last_name   VARCHAR2(10),
  salary      NUMBER(9,2),
  comm1       NUMBER(3),
  comm2       NUMBER(3),
  -- Short notation
  salary1     AS (ROUND(salary*(1+comm1/100),2)), 
  -- Extended notation
  salary2     NUMBER GENERATED ALWAYS AS (ROUND(salary*(1+comm2/100),2)) VIRTUAL, 
  CONSTRAINT employees_pk PRIMARY KEY (id)
);

INSERT INTO my_employees (id, first_name, last_name, salary, comm1, comm2)
VALUES (1, 'JOHN', 'DOE', 100, 5, 10);

INSERT INTO my_employees (id, first_name, last_name, salary, comm1, comm2)
VALUES (2, 'JAYNE', 'DOE', 200, 10, 20);

COMMIT;


SELECT * FROM my_employees;

/*
The expression used to generate the virtual column is listed in the 
DATA_DEFAULT column of the [DBA|ALL|USER]_TAB_COLUMNS views.
*/
--COLUMN data_default FORMAT A50
SELECT column_name, data_default
FROM   user_tab_columns
WHERE  table_name = 'MY_EMPLOYEES';

/*
Notes and restrictions on virtual columns include:

** Indexes defined against virtual columns are equivalent to function-based indexes.
** Virtual columns can be referenced in the WHERE clause of updates and deletes, 
   but they cannot be manipulated by DML.
** Tables containing virtual columns can still be eligible for result caching.
** Functions in expressions must be deterministic at the time of table creation, 
   but can subsequently be recompiled and made non-deterministic without invalidating 
   the virtual column. In such cases the following steps must be taken after the 
   function is recompiled:
   - Constraint on the virtual column must be disabled and re-enabled.
   - Indexes on the virtual column must be rebuilt.
   - Materialized views that access the virtual column must be fully refreshed.
   - The result cache must be flushed if cached queries have accessed the virtual 
     column.
   - Table statistics must be regathered.
** Virtual columns are not supported for index-organized, external, object, cluster, 
   or temporary tables.
** The expression used in the virtual column definition has the following restrictions:
   - It cannot refer to another virtual column by name.
   - It can only refer to columns defined in the same table.
   - If it refers to a deterministic user-defined function, it cannot be used as a 
     partitioning key column.
   - The output of the expression must be a scalar value. It cannot return an Oracle 
     supplied datatype, a user-defined type, or LOB or LONG RAW.

*/


/* tear down */

drop table my_employees purge;

