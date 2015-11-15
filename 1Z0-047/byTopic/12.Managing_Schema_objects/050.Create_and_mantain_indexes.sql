/*
================================================================================
                                INDEXES
================================================================================
================================================================================
For a given table, the INDEX stores a set of presorted data 
from one or more columns that you designate. Also stored in 
the INDEX is the address of data from the source table. SQL 
can use the INDEX object to speed up querying of WHERE and 
ORDER BY clauses.

Each DML statement that modifies data in a table that is 
indexed will also perform index maintenance as required. In 
other words, each index you add to a table puts more workload 
on each DML statement that affects indexed data.

PERFORMANCE ISSUES
Each index added to a table can potentially increase the 
workload on future INSERT, UPDATE, and DELETE statements.


Implicit Index Creation
---------------------------------------------------------------
If you create a constraint on a table that is of type 
PRIMARY KEY or UNIQUE, then as part of the creation of the 
constraint, SQL will automatically create an index to support 
that constraint on the column or columns, if such an index 
does not already exist.

Dropping a constraint will drop the INDEX as well, only if the
index was created implicity. In case it was created explicitly

...
, CONSTRAINT PRIMARY KEY my_pk (col1) USING INDEX (CREATE INDEX myidx ON tablename (col1) )
...

it will not be dropped while dropping the constraint.


UNIQUE Index
---------------------------------------------------------------

This SQL statement creates an index that will ensure that data 
entered into the SSN column of the table EMPLOYEES is unique.

CREATE UNIQUE INDEX IX_EMP_SSN ON EMPLOYEES(SSN);

You cannot (obviousy) create a UNIQUE BITMAP index.

This is different from the UNIQUE constraint that you can apply 
to a column on a table. However, note that if you create a 
PRIMARY KEY or UNIQUE constraint on a table, a unique index will 
automatically be created along with the constraint.

DROP INDEX IX_EMP_SSN;

if you drop a table upon which an index is based, the index is 
automatically dropped.
*/

--          EXAMPLES        --

/* 
Let's create a SEMINARS table with two constraints, a PK and a UQ constraint
*/

CREATE TABLE SEMINARS
(SEMINAR_ID         NUMBER(11)   CONSTRAINT SEMINARS$PK PRIMARY KEY,
 SEMINAR_NAME       VARCHAR2(30) CONSTRAINT SEMINARS$UN UNIQUE,
 SEMINAR_ALT_NAME   VARCHAR2(30) 
);

/*
This statement will create the table SEMINARS
   - two CONSTRAINTs 
   - two INDEX objects. 
*/
SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;
 
SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;

/* Let's create a UNIQUE INDEX on SEMINARS table */
CREATE UNIQUE INDEX SEMINARS$UN2 ON SEMINARS (SEMINAR_ALT_NAME);

/* Now we have 3 indexes... */
SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;

/* ... but still have 2 constraints */ 
SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;


/* * * * * * * * * * * * * * * * * * * * * * * * * *
  Let's try to violate the UNIQUE constraint 
 * * * * * * * * * * * * * * * * * * * * * * * * * */

INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'ORACLE DATABASE TUNING', 'SEMINAR 2'); -- UN VIOLATION
ROLLBACK;

/*
If we try to drop the index, we'll get an error:
ORA-02429: impossibile eliminare indice usato per imposizione di chiave unica/primaria
*/
DROP INDEX SEMINARS$UN;

/* We have to drop the constraint instead... */
ALTER TABLE SEMINARS DROP CONSTRAINT SEMINARS$UN;

/* ...this will drop the constraint and the index enforcing it */
SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;

SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;
 
/* Let's try insertion again */
INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'ORACLE DATABASE TUNING', 'SEMINAR 2'); -- OK
ROLLBACK;



/* * * * * * * * * * * * * * * * * * * * * * * * * *
  Let's try to violate the PRIMARY KEY constraint   
 * * * * * * * * * * * * * * * * * * * * * * * * * */

INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (1,'SQL FOUNDAMENTALS', 'SEMINAR 2'); -- PK VIOLATION
ROLLBACK;

/*
If we try to drop the index, we'll get an error:
ORA-02429: impossibile eliminare indice usato per imposizione di chiave unica/primaria
*/
DROP INDEX SEMINARS$PK;

/* We have to drop the constraint instead... */
ALTER TABLE SEMINARS DROP PRIMARY KEY;
-- or as an alternative
-- ALTER TABLE SEMINARS DROP CONSTRAINT SEMINARS$PK;

/* ...this will drop the constraint and the index enforcing it */
SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;
 
SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;

/* Let's try insertion again */
INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (1,'SQL FOUNDAMENTALS', 'SEMINAR 2'); -- OK
ROLLBACK;




/* * * * * * * * * * * * * * * * * * * * * * * * * *
  Let's try to violate the UNIQUE INDEX
 * * * * * * * * * * * * * * * * * * * * * * * * * */

INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'SQL FOUNDAMENTALS', 'SEMINAR 1'); -- UNIQUE INDEX VIOLATION
ROLLBACK;

-- Let's drop the index
DROP INDEX SEMINARS$UN2;


/* ...this will drop the constraint and the index enforcing it */
SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;

INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'SQL FOUNDAMENTALS', 'SEMINAR 1'); -- OK
ROLLBACK;

/* 
At this point table SEMINARS no longer has any constraint or index 
Let's recreate the UNIQUE INDEX we dropped.
*/

CREATE UNIQUE INDEX SEMINARS$UN2 ON SEMINARS (SEMINAR_ALT_NAME);

SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;
 
SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;

/*
Now we add a UNIQUE constraint to the same column
*/

alter table seminars add constraint SEMINARS$UQ UNIQUE (SEMINAR_ALT_NAME);

/*
This command will create the constraint but NOT the index because the column is
alredy enfoced by an index.
*/

SELECT INDEX_NAME, COLUMN_NAME , INDEX_TYPE, TABLE_NAME, UNIQUENESS
  FROM USER_INDEXES 
   NATURAL JOIN USER_IND_COLUMNS
 WHERE TABLE_NAME = 'SEMINARS'
 ORDER BY INDEX_NAME;
 
SELECT CONSTRAINT_NAME, COLUMN_NAME , CONSTRAINT_TYPE, TABLE_NAME, STATUS, DEFERRABLE, DEFERRED, INDEX_NAME
  FROM USER_CONSTRAINTS
   NATURAL JOIN USER_CONS_COLUMNS
WHERE TABLE_NAME = 'SEMINARS'
;


INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'SQL FOUNDAMENTALS', 'SEMINAR 1'); -- UNIQUE CONSTRAINT VIOLATION
ROLLBACK;

-- Let's drop the index
DROP INDEX SEMINARS$UN2;

/* This will fail because now the index enforces a constraint. 
We need to drop the constraint  */

ALTER TABLE SEMINARS DROP CONSTRAINT SEMINARS$UQ;

/* Let's insert records again */
INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'SQL FOUNDAMENTALS', 'SEMINAR 1'); -- UNIQUE INDEX VIOLATION
ROLLBACK;

/*
WHAT HAPPENED ???
When we dropped the constrint SEMINARS$UQ, the index SEMINARS$UN2 was NOT 
dropped with the constraint because it was not created as part of the constraint.
We need to drop the index explicitely.
*/
DROP INDEX SEMINARS$UN2;

/* Let's insert records again */
INSERT INTO SEMINARS VALUES (1,'ORACLE DATABASE TUNING', 'SEMINAR 1'); -- OK
INSERT INTO SEMINARS VALUES (2,'SQL FOUNDAMENTALS', 'SEMINAR 1'); -- OK
ROLLBACK;


/* Tear down */
DROP TABLE SEMINARS PURGE;




/*

Invisible Indexes in Oracle Database 11g Release 1
---------------------------------------------------------------
https://oracle-base.com/articles/11g/invisible-indexes-11gr1

Oracle 11g allows indexes to be marked as invisible. Invisible indexes are 
maintained like any other index, but they are ignored by the optimizer unless 
the OPTIMIZER_USE_INVISIBLE_INDEXES parameter is set to TRUE at the instance or
session level. Indexes can be created as invisible by using the INVISIBLE 
keyword, and their visibility can be toggled using the ALTER INDEX command.

CREATE INDEX index_name ON table_name(column_name) INVISIBLE;

ALTER INDEX index_name INVISIBLE;
ALTER INDEX index_name VISIBLE;

*/


CREATE TABLE ii_tab (
  id  NUMBER
);

BEGIN
  FOR i IN 1 .. 10000 LOOP
    INSERT INTO ii_tab VALUES (i);
  END LOOP;
  COMMIT;
END;
/

CREATE INDEX ii_tab_id ON ii_tab(id) INVISIBLE;

EXEC DBMS_STATS.gather_table_stats(USER, 'ii_tab', cascade=> TRUE);

/*
A query using the indexed column in the WHERE clause ignores the index and does
a full table scan.
*/
-- On SQL*Plus enable AUTOTRACE, on SQL Dveloper just click on the Explain Plan button
-- SET AUTOTRACE OFF
SELECT * FROM ii_tab WHERE id = 9999; -- Table access FULL (cost 7)

/* We can modifiy this session so we can use INVISIBLE indexes */
ALTER SESSION SET OPTIMIZER_USE_INVISIBLE_INDEXES=TRUE;

SELECT * FROM ii_tab WHERE id = 9999; 
-- INDEX RANGE SCAN (cost 1)

/* restore the OPTIMIZER_USE_INVISIBLE_INDEXES option and make the index VISIBLE */
ALTER SESSION SET OPTIMIZER_USE_INVISIBLE_INDEXES=FALSE;

ALTER INDEX ii_tab_id VISIBLE;

SELECT * FROM ii_tab WHERE id = 9999; 
-- INDEX RANGE SCAN (cost 1)


/* tear down */

drop table ii_tab purge;



/*
   Multiple Indexes on the Same Set of Columns in Oracle Database 12c Release 1
--------------------------------------------------------------------------------
https://oracle-base.com/articles/12c/multiple-indexes-on-same-set-of-columns-12cr1

Why Use Multiple Indexes

Invisible indexes are still maintained, so having multiple indexes on the same 
set of columns allows you to quickly switch between them, making testing the 
impact of various indexes much quicker. 

**
Remember, there is an impact on DML performance of having too many indexes on a 
table, so this should be a short term situation.
**

WHEN TO CREATE MULTIPLE INDEXES ON THE SAME SET OF COLUMNS
  
** The indexes are of different types.

   See "About Indexes" and Oracle Database Concepts for information about the different types of indexes.

   However, the following exceptions apply:

   . You cannot create a B-tree index and a B-tree cluster index on the same set of columns.
   . You cannot create a B-tree index and an index-organized table on the same set of columns.


** The indexes use different partitioning.

   Partitioning can be different in any of the following ways:

   . Indexes that are not partitioned and indexes that are partitioned
   . Indexes that are locally partitioned and indexes that are globally partitioned
   . Indexes that differ in partitioning type (range or hash)
   
** The indexes have different uniqueness properties.

   You can create both a unique and a non-unique index on the same set of columns.


ABOUT INDEXES
   
  . B-tree indexes: the default and the most common
  . B-tree cluster indexes: defined specifically for cluster
  . Hash cluster indexes: defined specifically for a hash cluster
  . Global and local indexes: relate to partitioned tables and indexes
  . Reverse key indexes: most useful for Oracle Real Application Clusters applications
  . Bitmap indexes: compact; work best for columns with a small set of values
  . Function-based indexes: contain the precomputed value of a function/expression
  . Domain indexes: specific to an application or cartridge.

== B*TREE ==
B*Tree (B stands for balanced): the root node points to many nodes at t
he second level which can point to other nodes at the third level and so on.
The depth of the tree is largely determined by  the number of rows in the table
and the length of the idex key values.
The B*Tree structure is very effitient if the depth is greater then three or four, 
then either the index keys are very ong or the table has billion of rows.

It is often said that if the query is going to retrieve  more then 2 or 4 percent of
the total amount of rows in the table, then a full table scan will be quicker.
A major exception to this is if the vale specified in the WHERE clause is NULL.

NULLs do not go into B*Tree Indexes, so a query such as 

SELECT * from EMPLOYEES WHERE last_name IS NULL;

will always esult in a FULL TABLE SCAN

A B*Tree index shoul be used if the cardinality in the column is high AND the 
number of rows in the table is high AND the column is used in WHERE clauses 
or JOIN conditions.

== BITMAP ==
A bitmap index stores the rowids associated with each key-value as a bitmap.

CHANNEL
  WALKING   11010111000101011101011101...
  DELIVERY  00101000111010100010100010...

SHOP
  LONDON    11001000001001101001010000...
  OXFORD    00100010010000010001001000...
  READING   00010001000100000100100010...
  GLASGOW   00000100100010000010000101...

This indicates that the first two sales were in LONDON, the third in OXFORD,
the fourth in READING and so on.

SELECT count(*) FROM SALES WHERE channel = 'WALKING' and shop = 'OXFORD'

will be solved applying the AND operator to the bitmaps associated to the 
given values of the tho columns.

  WALKING           11010111000101011101011101...
  OXFORD            00100010010000010001001000...
  WALKING & OXFORD  00000010000000010001001000...
                          ^        ^   ^  ^
An advantage of BITMAP indexes over B*TREE is tha they include NULLs.

A BITMAP index shoul be used if the cardinality in the column is low AND the 
number of rows in the table is high AND the column is used in Boolean angebra
(AND/OR/NOT) operations.


** BITMAP INDEX RESTRICTIONS **

You cannot specify both UNIQUE and BITMAP.

You cannot specify BITMAP for a domain index.

A bitmap index can have a maximum of 30 columns.

*/


-- Non-Partitioned Tables
--------------------------------------------------------------------------------
CREATE TABLE t1 (
  id            NUMBER,
  description   VARCHAR2(50),
  created_date  DATE
);

INSERT INTO t1 VALUES (1, 't1 ONE', TO_DATE('01/07/2014', 'DD/MM/YYYY'));
INSERT INTO t1 VALUES (2, 't1 TWO', TO_DATE('01/07/2015', 'DD/MM/YYYY'));
INSERT INTO t1 VALUES (3, 't1 THREE', TO_DATE('01/07/2016', 'DD/MM/YYYY'));
COMMIT;

CREATE INDEX t1_idx1 ON t1(created_date) VISIBLE;
CREATE INDEX t1_idx2 ON t1(created_date) INVISIBLE;
/*                         *
ERROR at line 1:
ORA-01408: such column list already indexed

If we alter something about it, like make it a bitmapped index, it works.
*/
CREATE BITMAP INDEX t1_idx3 ON t1(created_date) INVISIBLE;


-- Partitioned Tables
--------------------------------------------------------------------------------
CREATE TABLE t2 (
  id            NUMBER,
  description   VARCHAR2(50),
  created_date  DATE
)
PARTITION BY RANGE (created_date) (
  PARTITION part_2014 VALUES LESS THAN (TO_DATE('01/01/2015', 'DD/MM/YYYY')) TABLESPACE users,
  PARTITION part_2015 VALUES LESS THAN (TO_DATE('01/01/2016', 'DD/MM/YYYY')) TABLESPACE users,
  PARTITION part_2016 VALUES LESS THAN (TO_DATE('01/01/2017', 'DD/MM/YYYY')) TABLESPACE users
);

INSERT INTO t2 VALUES (1, 't1 ONE', TO_DATE('01/07/2014', 'DD/MM/YYYY'));
INSERT INTO t2 VALUES (2, 't1 TWO', TO_DATE('01/07/2015', 'DD/MM/YYYY'));
INSERT INTO t2 VALUES (3, 't1 THREE', TO_DATE('01/07/2016', 'DD/MM/YYYY'));
COMMIT;

-- Create a global index.
CREATE INDEX t2_idx1 ON t2(created_date) GLOBAL VISIBLE;

-- Create some indexes with differing partitioning schemes.
CREATE INDEX t2_idx2 ON t2(created_date) GLOBAL
PARTITION BY RANGE (created_date) (
  PARTITION t2_p1 VALUES LESS THAN (TO_DATE('01/01/2015', 'DD/MM/YYYY')) TABLESPACE users,
  PARTITION t2_p2 VALUES LESS THAN (TO_DATE('01/01/2016', 'DD/MM/YYYY')) TABLESPACE users,
  PARTITION t2_p3 VALUES LESS THAN (MAXVALUE) TABLESPACE users
)
INVISIBLE;

CREATE INDEX t2_idx3 ON t2(created_date) LOCAL INVISIBLE;

CREATE BITMAP INDEX t2_idx4 ON t2(created_date) LOCAL INVISIBLE;

/* 
You can switch from indexes built on the same set of columns simply using the 
ALTER INDEX command 
*/

ALTER INDEX t1_idx1 INVISIBLE;
ALTER INDEX t1_idx2 VISIBLE;



/* tear down */

DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

/*
Good to know....
======================================================================
ALTER SESSION SET QUERY_REWRITE_INTEGRITY = TRUSTED; 
ALTER SESSION SET QUERY_REWRITE_ENABLED = TRUE;

When you drop and re-create an index with the same name but in a different way,
QUERY_REWRITE_INTEGRITY and QUERY_REWRITE_ENABLED parameters must be set or the 
server will not be able to rewrite the queries, and will therefore not be able 
to use the new index. 

*** Later releases have them enabled by default ***

----------------------------------------------------------------------

Oracle has no compiler that evaluates and simplifies (mathematical) expressions, 
so a WHERE clause like 

  WHERE col_a + col_b = 42 

does not use an index on col_a because the lef-hand side also includes col_b. 
To use an index on col_a , you have to rewrite the predicate as 

  WHERE col_a = 42 - col_b

----------------------------------------------------------------------


*/

