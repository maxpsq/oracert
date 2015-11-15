/*
CREATETABLE and Subqueries
================================

CREATE TABLE INVOICES_ARCHIVED AS
   SELECT *
   FROM   INVOICES
   WHERE  SHIPPING_DATE < (ADD_MONTHS(SYSDATE,-12));

any CONSTRAINT or INDEX objects, or any other supporting objects that might exist 
for the source table or tables, are not replicated but need to be created 
individually if desired for the new table...

                       WITH ONE EXCEPTION

... any explicitly created NOT NULL constraints on the queried table 
(GENERATED = 'USER NAME') are copied into the new table, are assigned a system-generated 
name, and form part of the new table’s definition. 
NOT NULL constraints that were created implicitly (GENERATED = 'GENERATED NAME'), 
for example, as part of a PRIMARY KEY constraint—are not included.
*/

CREATE TABLE CTAS_SRC1 (
  ID      NUMBER PRIMARY KEY,
  COL1    NUMBER(7) CONSTRAINT CTAS_SRC1$NN01 NOT NULL,
  COL2    NUMBER(7)
);

/* this query will show all the constaints on CTAS_SRC1 table. 
We have 2 constraints */
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, GENERATED, SEARCH_CONDITION 
  FROM USER_CONSTRAINTS 
 WHERE TABLE_NAME = 'CTAS_SRC1' ;

CREATE TABLE CTAS_SRC2 AS SELECT * FROM CTAS_SRC1;

/* this query will show all the constaints on CTAS_SRC1 table 
We have 1 constraint (the one explicitly created on COL1 */
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, GENERATED, SEARCH_CONDITION 
  FROM USER_CONSTRAINTS 
 WHERE TABLE_NAME = 'CTAS_SRC2' ;
 
-- tear down 
drop table CTAS_SRC1 purge ;
drop table CTAS_SRC2 purge ;

/*
You cannot create a table unless you provide a name for each column.
*/

CREATE TABLE ROOM_SUMMARY AS
SELECT A.SHIP_ID,
       A.SHIP_NAME,
       B.ROOM_NUMBER,
       B.SQ_FT + NVL(B.BALCONY_SQ_FT,0) AS TOT_SQ_FT
  FROM SHIPS A JOIN SHIP_CABINS B
          ON A.SHIP_ID = B.SHIP_ID;

/* Alternate syntax 
Any valid database name may be provided—they are not required to match 
the subquery’s column names
*/
CREATE TABLE ROOM_SUMMARY (SHIP_ID, SHIP_NAME, ROOM_NUMBER, TOT_SQ_FT) AS
SELECT A.SHIP_ID,
       A.SHIP_NAME,
       B.ROOM_NUMBER,
       B.SQ_FT + NVL(B.BALCONY_SQ_FT,0)
  FROM SHIPS A JOIN SHIP_CABINS B
          ON A.SHIP_ID = B.SHIP_ID;

/*
CTAS can also be used to name each column in the new table.
CTAS can also define the datatype of each new column.
*/

-- setup
create table CTAS_SRC3 (data varchar2(4));

insert into CTAS_SRC3
  select level + 2000 from dual connect by level < 9;
  
commit;


create table CTAS4 (year primary key) as  --> column name
  select to_number(data) from CTAS_SRC3 ;  --> column type( to_number() )

select * from user_constraints where table_name = 'CTAS4' ;

-- tear down 
drop table CTAS_SRC3 purge;
drop table CTAS4 purge;

/*
INSERT and Subqueries
======================================================
Note that the datatypes for the expressions in the SELECT statement subquery 
must match the datatypes in the target table of the INSERT statement.

If any one row fails the INSERT due to a constraint violation or datatype 
conflict, the entire INSERT fails and no rows are inserted.
*/

/*
UPDATE and Correlated Subqueries
======================================================
UPDATE PORTS 
SET (TOT_SHIPS_ASSIGNED, TOT_SHIPS_ASGN_CAP) = 
       (SELECT   COUNT(S.SHIP_ID) TOTAL_SHIPS,
                 SUM(S.CAPACITY)  TOTAL_SHIP_CAPACITY
        FROM     SHIPS S
        WHERE    S.HOME_PORT_ID = PT.PORT_ID
GROUP BY S.HOME_PORT_ID);

Note that records not matching the correlated subquery will be set to NULL

*/

