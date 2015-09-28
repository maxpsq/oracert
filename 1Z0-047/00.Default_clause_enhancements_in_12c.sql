

CREATE TABLE test_default (
  col1   NUMBER,
  col2   NUMBER DEFAULT 100,
  col3   NUMBER DEFAULT ON NULL 200
);

-- Columns col2 and col3 are both filled with DEFAULTS values
INSERT INTO test_default (col1) values (1);

-- Column col2 contains NULL, col3 contains its DEFAULT.
-- The DEFAULT clause assigs a default value to a column
-- in case the column is not passed to the INSERT clause.
-- NOTICE if the columns is passd NULL, then NULL will be
-- inserted in the column despite the DEFAULT clause.
-- The DEFAULTS ON NULL option will put the default value
-- in the column in case the column is not specified and
-- in case the column is passed a NULL value.
INSERT INTO test_default values (2, null, null);

-- Columns col2 and col3 are both filled with DEFAULTS values
INSERT INTO test_default values (3, DEFAULT, DEFAULT);

COMMIT;

select * FROM test_default;

-- Column col2 is set to its DEFAULT value
UPDATE test_default SET col2 = DEFAULT WHERE col1 = 2 ;
COMMIT;

select * FROM test_default;

/* Using SEQUENCES as DEFAULT values */

CREATE SEQUENCE master_seq;
CREATE SEQUENCE detail_seq;

CREATE TABLE master (
  id          NUMBER DEFAULT master_seq.NEXTVAL,
  description VARCHAR2(30)
);

CREATE TABLE detail (
  id          NUMBER DEFAULT detail_seq.NEXTVAL,
  master_id   NUMBER DEFAULT master_seq.CURRVAL,
  description VARCHAR2(30)
);

INSERT INTO master (description) VALUES ('Master 1');
INSERT INTO detail (description) VALUES ('Detail 1');
INSERT INTO detail (description) VALUES ('Detail 2');

INSERT INTO master (description) VALUES ('Master 2');
INSERT INTO detail (description) VALUES ('Detail 3');
INSERT INTO detail (description) VALUES ('Detail 4');

SELECT * FROM master;
/*
        ID DESCRIPTION
---------- ------------------------------
         1 Master 1
         2 Master 2

2 rows selected.
*/

SELECT * FROM detail;
/*
        ID  MASTER_ID DESCRIPTION
---------- ---------- ------------------------------
         1          1 Detail 1
         2          1 Detail 2
         3          2 Detail 3
         4          2 Detail 4

4 rows selected.
*/

/*
Of course, this would only make sense if you could guarantee the 
inserts into the detail table would always immediately follow the 
insert into the master table, which would prevent you from using 
bulk-bind operations.

A few things to remember about using sequence pseudocolumns as 
defaults include:

** During table creation, the SEQUENCE MUST EXIST and YOU 
   MUST HAVE SELECT PRIVILEGE ON IT for it to be used as 
   a column default.

** The users performing inserts against the table must have 
   select privilege on the sequence, as well as insert privilege 
   on the table.

** If the sequence is dropped after table creation, subsequent 
   inserts will error.

** Sequences used as default values are always stored in the 
   data dictionary with fully qualified names. Normal name 
   resolution rules are used to determine the sequence owner, 
   including expansion of private and public synonyms.

** As with any use of a sequence, gaps in the sequence of numbers 
   can occur for a number of reasons. For example, if a sequence 
   number is requested and not used, a statement including a 
   sequence is rolled back, or the databases is turned off and 
   cached sequence values are lost.
*/

/* a DEFAULT expression cannot contain references to pseudocolumns */
create table test_invalid_default (
  col1   number  default rownum
);

create table test_invalid_default (
  col1   number  default prior
);

create table test_invalid_default (
  col1   number  default level
);

/* a DEFAULT expression cannot contain references to other columns */
create table test_invalid_default (
  col1   number,
  col2   number  default col1
);

/* The expression can be of any form except a scalar subquery expression */
create table test_invalid_default (
  col1   number  default (select 1 from dual)
);


/* 
adding a new column to a table: Metadata-Only DEFAULT Values
===============================================================
Prior to Oracle 11g, adding a new column to an existing table required all rows 
in that table to be modified to add the new column.

Oracle 11g introduced the concept of metadata-only default values. 
Adding a NOT NULL column with a DEFAULT clause to an existing table involved 
just a metadata change, rather than a change to all the rows in the table. 
Queries of the new column were rewritten by the optimizer to make sure the 
result was consistent with the default definition.

Oracle 12c takes this a step further, allowing metadata-only default values of 
both mandatory and optional columns. As a result, adding a new column with a 
DEFAULT clause to an existing table will be handled as a metadata-only change, 
regardless of whether that column is defined as NOT NULL or not. This represents 
both a space saving and performance improvement.

There are some fairly obvious restrictions on this functionality:

** The table cannot have any LOB columns. It cannot be index-organized, 
   temporary, or part of a cluster. It also cannot be a queue table, an object 
   table, or the container table of a materialized view.

** If the table has a Virtual Private Database (VPD) policy on it, then the 
   optimized behavior will not take place unless the user who issues the ALTER 
   TABLE ... ADD statement has the EXEMPT ACCESS POLICY system privilege.

** The column being added cannot be encrypted, and cannot be an object column, 
   nested table column, or a LOB column.

** The DEFAULT expression cannot include the sequence pseudocolumns CURRVAL 
   or NEXTVAL.

If the optimized behavior cannot take place due to the preceding restrictions, 
then Oracle Database updates each row in the newly created column with the 
default value, and then fires any update triggers defined on the table.
Heres' an example:
*/

CREATE SEQUENCE s1 START WITH 1;

CREATE TABLE t1 (name VARCHAR2(10));
INSERT INTO t1 VALUES('Kevin');
INSERT INTO t1 VALUES('Julia');
INSERT INTO t1 VALUES('Ryan');

-- This will update all records in the table, avoiding to use 
-- the metadata-only feature
ALTER TABLE t1 ADD (id NUMBER DEFAULT ON NULL s1.NEXTVAL NOT NULL);

SELECT id, name FROM t1 ORDER BY id;





/* tear down */
drop table test_default PURGE;
drop table master PURGE;
drop sequence master_seq;
drop table detail PURGE;
drop sequence detail_seq;
drop table t1 PURGE;
drop sequence s1;