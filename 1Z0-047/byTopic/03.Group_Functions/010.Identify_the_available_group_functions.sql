/* COUNT(e)
e: any data type
*/

/* MIN(e)
e: any data type
*/

/* MAX(e)
e: any data type
*/

/* SUM(e)
e: numeric
*/

/* AVG(e)
e: numeric
*/

/* MEDIAN(e)
e: numeric or date

MEDIAN will sort the values, and if there is an odd number of values, 
it will identify the value in the middle of the list; otherwise, if 
there an even number of values, it will locate the two values in the 
middle of the list and perform linear interpolation between them to 
locate a result.
*/

-- set up
CREATE TABLE TEST_MEDIAN(a NUMBER(3));
INSERT INTO TEST_MEDIAN VALUES (1);
INSERT INTO TEST_MEDIAN VALUES (10);
INSERT INTO TEST_MEDIAN VALUES (3);

-- test
SELECT MEDIAN(A) FROM TEST_MEDIAN; -- 3

INSERT INTO TEST_MEDIAN VALUES (4); -- 3.5  (3+4)/2

SELECT MEDIAN(A) FROM TEST_MEDIAN;

-- tear down
drop table TEST_MEDIAN purge;

/* 
RANK(c1) WITHIN GROUP (ORDER BY e1)
---------------------------------------
Parameters: c1 is a constant; e1 is an expression with a datatype matching the
corresponding c1 datatype. Numeric and character pairs are allowed.
In this format, the parameters can be repeated in such a way that for each c1, 
you can have a corresponding e1, for each c2 (if included), there must be a 
corresponding e2, etc. Each successive parameter is separated from the previous 
parameter by a comma, as in

RANK(c1, c2, c3) WITHIN GROUP (ORDER BY e1, e2, e3)

Also, the datatype of c1 must match the datatype of e1, and the datatype of c2 
(if included) must match the datatype of e2, etc.
The RANK function calculates the rank of a value within a group of values. 
Ranks may not be consecutive numbers, since SQL counts tied rows individually, 
so if three rows are tied for first, they will each be ranked 1, 1, and 1, and 
the next row will be ranked 4.

For example:

  SELECT   RANK(300) WITHIN GROUP (ORDER BY SQ_FT)
  FROM     SHIP_CABINS;
  
  RANK(300)WITHINGROUP(ORDERBYSQ_FT)
  ----------------------------------
  6
  
This answer of 6 is telling us when we sort the rows of the SHIP_CABINS table, 
and then consider the literal value 300 and compare it to the values in the SQ_FT 
column, that the value 300, if inserted into the table, and if sorted with the 
existing rows, would be the sixth row in the listing. In other words, there are 
five rows with a SQ_FT value less than 300.
*/

-- set up
create table rank_test(a number, b number);
insert into rank_test values (3,5);
insert into rank_test values (4,7);
insert into rank_test values (12,9);
insert into rank_test values (13,11);
insert into rank_test values (15,13);
insert into rank_test values (21,18);
insert into rank_test values (23,20);
commit;

-- test

  SELECT   RANK(4,7) WITHIN GROUP (ORDER BY a,b)
  FROM     rank_test; -- 2 means 4,7 is the second value according to the sorting criteria
  
  SELECT   RANK(4,7) WITHIN GROUP (ORDER BY a desc, b desc)
  FROM     rank_test; -- 6 means 4,7 is the sixth value according to the sorting criteria (descending)
  
  SELECT   RANK(13) WITHIN GROUP (ORDER BY a)
  FROM     rank_test; -- 4 means 13 is the fourth value according to the sorting criteria
  
  -- ** NOTICE 9 is not in the table **
  SELECT   RANK(9) WITHIN GROUP (ORDER BY a)
  FROM     rank_test; -- 3 means 9 would be the eighth value according to the sorting criteria

  -- ** NOTICE 80 is not in the table **
  SELECT   RANK(80) WITHIN GROUP (ORDER BY a)
  FROM     rank_test; -- 8 means 80 would be the eighth value according to the sorting criteria

  -- ** NOTICE -1 is not in the table **
  SELECT   RANK(-1) WITHIN GROUP (ORDER BY a)
  FROM     rank_test; -- 1 means -1 would be the first value according to the sorting criteria

  truncate table rank_test;

  -- ** NOTICE the table is empty (no rows) **
  SELECT   RANK(80) WITHIN GROUP (ORDER BY a)
  FROM     rank_test; -- 1 means 80 would be the first value according to the sorting criteria

-- tear down
drop table rank_test purge;
  
/* FIRST and LAST

     aggregate_function KEEP (DENSE_RANK FIRST ORDER BY e1) 
     aggregate_function KEEP (DENSE_RANK LAST  ORDER BY e1)
     
Parameters: e1 is an expression with a numeric or character datatype.

The aggregate functions FIRST and LAST are similar. For a given range of sorted 
values, they return either the first value (FIRST) or the last value (LAST) of 
the population of rows defining e1, in the sorted order. For example:

        SELECT   MAX(SQ_FT) KEEP (DENSE_RANK FIRST ORDER BY GUESTS) "Largest"
        FROM     SHIP_CABINS;
        
        Largest
        ----------------------
        225
                
In this example, we are doing the following:

- First, we’re sorting all the rows in the SHIP_CABINS table according to
the value in the GUESTS column, and identifying the FIRST value in that sort order, 
which is a complex way of saying that we’re identifying the lowest value for the 
GUESTS column.

- For all rows with a GUEST value that matches the lowest value we just found, 
determine the MAX value for SQ_FT.
In others, display the highest number of square feet for any and all cabins that 
accommodate the lowest number of guests according to the GUESTS column.

*/

create table SHIP_CABINS (guests number(2,0), sq_mt number(4,2) );
insert into SHIP_CABINS values (1,13.4);
insert into SHIP_CABINS values (1,13.7);
insert into SHIP_CABINS values (1,12.8);
insert into SHIP_CABINS values (1,12.35);
insert into SHIP_CABINS values (1,13.85);
insert into SHIP_CABINS values (1,13.3);
insert into SHIP_CABINS values (2,24.3);
insert into SHIP_CABINS values (2,24.9);
insert into SHIP_CABINS values (2,25.9);
insert into SHIP_CABINS values (2,26.3);
insert into SHIP_CABINS values (2,26.1);
insert into SHIP_CABINS values (3,44);
insert into SHIP_CABINS values (4,50);
insert into SHIP_CABINS values (4,52);
insert into SHIP_CABINS values (4,52);
insert into SHIP_CABINS values (4,54);
insert into SHIP_CABINS values (4,55);
insert into SHIP_CABINS values (4,58);
commit;

select max(sq_mt) keep (dense_rank first order by guests) "largest for mininum # guests"
  from SHIP_CABINS;
  
select max(sq_mt) keep (dense_rank last order by guests) "largest for maximum # guests"
  from SHIP_CABINS;
  
drop table SHIP_CABINS purge;



/*

APPROX_COUNT_DISTINCT(expr)

APPROX_COUNT_DISTINCT returns the approximate number of rows that contain distinct 
values of expr. This function provides an alternative to the COUNT (DISTINCT expr) 
function, which returns the exact number of rows that contain distinct values of
expr. APPROX_COUNT_DISTINCT processes large amounts of data significantly faster 
than COUNT, with negligible deviation from the exact result.

For expr, you can specify a column of any scalar data type
other than BFILE, BLOB, CLOB, LONG, LONG RAW, or NCLOB.

APPROX_COUNT_DISTINCT ignores rows that contain a null value for expr. This 
function returns a NUMBER.
*/
SELECT APPROX_COUNT_DISTINCT(manager_id) AS "Active Managers"
  FROM hr.employees;
/*
COLLECT(ALL|DISTINCT|UNIQUE column ORDER BY expr)
COLLECT is an aggregate function that takes as its argument a column of any type 
and creates a nested table of the input type out of the rows selected. To get 
accurate results from this function you must use it within a CAST function.

If column is itself a collection, then the output of COLLECT is a nested table 
of collections. If column is of a user-defined type, then column must have a MAP 
or ORDER method defined on it in order for you to use the optional DISTINCT, 
UNIQUE, and ORDER BY clauses.
*/

CREATE TYPE phone_book_t AS TABLE OF varchar2(40);
/

select cast( collect(distinct first_name) as phone_book_t ) as everybody 
  from hr.employees ;

drop type phone_book_t ;

/*
CORR
CORR_*
COVAR_POP
COVAR_SAMP
CUME_DIST
*/

/*
LISTAGG
PERCENT_RANK
PERCENTILE_CONT
PERCENTILE_DISC
REGR_ (Linear Regression) Functions
STATS_BINOMIAL_TEST
STATS_CROSSTAB
STATS_F_TEST
STATS_KS_TEST
STATS_MODE
STATS_MW_TEST
STATS_ONE_WAY_ANOVA
STATS_T_TEST_*
STATS_WSR_TEST
STDDEV
STDDEV_POP
STDDEV_SAMP
SYS_OP_ZONE_ID
SYS_XMLAGG
VAR_POP
VAR_SAMP
VARIANCE
XMLAGG
*/