/*

Oracle's Analytic functions
============================================
            Pattern Matching
============================================
https://oracle-base.com/articles/12c/pattern-matching-in-oracle-database-12cr1#syntax-made-simple

Since Oracle 12c has been introduced the MATCH_RECOGNIZE clause to make pattern matching
simple.

Data must be processed correctly and in a deterministic fashion. The PARTITION BY and ORDER BY 
clauses of all analytic functions are used to break the data up into groups and make sure it is 
ordered correctly within each group, so order-sensitive analytic functions work as expected. 
This is explained here. If no partitions are defined, it is assumed the whole result set is one 
big partition.

  PARTITION BY product
  ORDER BY tstamp

The MEASURES clause defines the column output that will be produced for each match.

MEASURES  STRT.tstamp AS start_tstamp,
          LAST(UP.tstamp) AS peak_tstamp,
          LAST(DOWN.tstamp) AS end_tstamp

Along with the MEASURES, you need to decide if you want to present all the rows that 
represent the match, or just summary information.

  [ONE ROW | ALL ROWS] PER MATCH

The pattern that represents a match is defined using pattern variables, so it makes 
sense to look at those first. Pattern variables can use any non-reserved word associated 
with an expression. Two examples are given below.

DEFINE
  UP AS UP.units_sold > PREV(UP.units_sold),
  FLAT AS FLAT.units_sold = PREV(FLAT.units_sold),
  DOWN AS DOWN.units_sold < PREV(DOWN.units_sold)

DEFINE
  TWINKIES AS TWINKIES.product='TWINKIES',
  DINGDONGS AS DINGDONG.product='DINGDONGS',
  HOHOS AS HOHOS.product='HOHOS'

The pattern is then defined using regular expressions incorporating the pattern variables. 
Some examples are given below, but a full list of the possibilities is available from the 
documentation.

-- 1-Many increases, followed by 1-Many decreases in a value. A "V" shaped spike.
PATTERN (STRT UP+ DOWN+)

-- 1-Many increases, followed by a single decrease, then 1-Many increases. A single dip, 
-- during the rise.
PATTERN (STRT UP+ DOWN{1} UP+)

-- 1-5 Twinkies, followed by 1 DingDong, followed by 2 HoHos.
PATTERN(STRT TWINKIES{1,5} DINGDONGS{1} HOHOS{2})

The AFTER MATCH SKIP clause defines where the search is restarted from. Available options 
include the following.

AFTER MATCH SKIP TO NEXT ROW : Search continues at the row following the start of the 
   matched pattern.
AFTER MATCH SKIP PAST LAST ROW : (Default) Search continues at the row following the 
   end of the matched pattern.
AFTER MATCH SKIP TO FIRST pattern_variable : Search continues from the first row relating 
   to the pattern defined by the specified pattern variable.
AFTER MATCH SKIP TO LAST pattern_variable : Search continues from the last row relating to 
   the pattern defined by the specified pattern variable.
AFTER MATCH SKIP TO pattern_variable : Equivalent of "AFTER MATCH SKIP TO LAST pattern_variable".

There are a number of functions that provide additional information about the displayed output.

  MATCH_NUMBER() : Sequential numbering of matches 1-N, indicating which output rows 
                   relate to which match.
  CLASSIFIER() : The pattern variable that applies to the output row. This only makes 
                 sense when all rows are displayed.

Navigation around the rows in a patterns is possible using the PREV, NEXT, FIRST and LAST functions.

PREV(UP.units_sold)     -- Value of units_sold from previous row.

PREV(UP.units_sold, 2)  -- Value of units_sold from the row before the previous row (offset of 2 rows).

NEXT(UP.units_sold)     -- Value of units_sold from the next row.

NEXT(UP.units_sold, 2)  -- Value of units_sold from the row after the following row (offset of 2 rows).

FIRST(UP.units_sold)    -- First row in the pattern.

FIRST(UP.units_sold, 1) -- Row following the first row (offset of 1 row).

LAST(UP.units_sold)     -- Last row in the pattern.

LAST(UP.units_sold, 1)  -- Row preceding the last row (offset of 1 row).

The pattern navigation, along with aggregate functions, can be qualified with the FINAL and 
RUNNING semantics keywords. These are effectively a windowing clause within the pattern, 
defining if the action relates to the whole pattern, or from the start of the pattern to 
the current row.

*/

DROP TABLE sales_audit PURGE;

CREATE TABLE sales_history (
  id            NUMBER,
  product       VARCHAR2(20),
  tstamp        TIMESTAMP,
  units_sold    NUMBER,
  CONSTRAINT sales_history_pk PRIMARY KEY (id)
);

ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY';

INSERT INTO sales_history VALUES ( 1, 'TWINKIES', '01-OCT-2014', 17);
INSERT INTO sales_history VALUES ( 2, 'TWINKIES', '02-OCT-2014', 19);
INSERT INTO sales_history VALUES ( 3, 'TWINKIES', '03-OCT-2014', 23);
INSERT INTO sales_history VALUES ( 4, 'TWINKIES', '04-OCT-2014', 23);
INSERT INTO sales_history VALUES ( 5, 'TWINKIES', '05-OCT-2014', 16);
INSERT INTO sales_history VALUES ( 6, 'TWINKIES', '06-OCT-2014', 10);
INSERT INTO sales_history VALUES ( 7, 'TWINKIES', '07-OCT-2014', 14);
INSERT INTO sales_history VALUES ( 8, 'TWINKIES', '08-OCT-2014', 16);
INSERT INTO sales_history VALUES ( 9, 'TWINKIES', '09-OCT-2014', 15);
INSERT INTO sales_history VALUES (10, 'TWINKIES', '10-OCT-2014', 17);
INSERT INTO sales_history VALUES (11, 'TWINKIES', '11-OCT-2014', 23);
INSERT INTO sales_history VALUES (12, 'TWINKIES', '12-OCT-2014', 30);
INSERT INTO sales_history VALUES (13, 'TWINKIES', '13-OCT-2014', 31);
INSERT INTO sales_history VALUES (14, 'TWINKIES', '14-OCT-2014', 29);
INSERT INTO sales_history VALUES (15, 'TWINKIES', '15-OCT-2014', 25);
INSERT INTO sales_history VALUES (16, 'TWINKIES', '16-OCT-2014', 21);
INSERT INTO sales_history VALUES (17, 'TWINKIES', '17-OCT-2014', 35);
INSERT INTO sales_history VALUES (18, 'TWINKIES', '18-OCT-2014', 46);
INSERT INTO sales_history VALUES (19, 'TWINKIES', '19-OCT-2014', 45);
INSERT INTO sales_history VALUES (20, 'TWINKIES', '20-OCT-2014', 30);
COMMIT;

ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY';

/*
The following query shows the pattern of the data, which we will refer to later.
*/
SET PAGESIZE 50
COLUMN product    FORMAT A10
COLUMN tstamp     FORMAT A11
COLUMN graph      FORMAT A50

SELECT id,
       product,
       tstamp,
       units_sold,
       RPAD('#', units_sold, '#') AS graph
FROM   sales_history
ORDER BY id;

/*
The following table defines an audit trail of all sales as they happen.
*/
DROP TABLE sales_audit PURGE;

CREATE TABLE sales_audit (
  id            NUMBER,
  product       VARCHAR2(20),
  tstamp        TIMESTAMP,
  CONSTRAINT sales_audit_pk PRIMARY KEY (id)
);

ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY HH24:MI:SS';

INSERT INTO sales_audit VALUES ( 1, 'TWINKIES', '01-OCT-2014 12:00:01');
INSERT INTO sales_audit VALUES ( 2, 'TWINKIES', '01-OCT-2014 12:00:02');
INSERT INTO sales_audit VALUES ( 3, 'DINGDONGS', '01-OCT-2014 12:00:03');
INSERT INTO sales_audit VALUES ( 4, 'HOHOS', '01-OCT-2014 12:00:04');
INSERT INTO sales_audit VALUES ( 5, 'HOHOS', '01-OCT-2014 12:00:05');
INSERT INTO sales_audit VALUES ( 6, 'TWINKIES', '01-OCT-2014 12:00:06');
INSERT INTO sales_audit VALUES ( 7, 'TWINKIES', '01-OCT-2014 12:00:07');
INSERT INTO sales_audit VALUES ( 8, 'DINGDONGS', '01-OCT-2014 12:00:08');
INSERT INTO sales_audit VALUES ( 9, 'DINGDONGS', '01-OCT-2014 12:00:09');
INSERT INTO sales_audit VALUES (10, 'HOHOS', '01-OCT-2014 12:00:10');
INSERT INTO sales_audit VALUES (11, 'HOHOS', '01-OCT-2014 12:00:11');
INSERT INTO sales_audit VALUES (12, 'TWINKIES', '01-OCT-2014 12:00:12');
INSERT INTO sales_audit VALUES (13, 'TWINKIES', '01-OCT-2014 12:00:13');
INSERT INTO sales_audit VALUES (14, 'DINGDONGS', '01-OCT-2014 12:00:14');
INSERT INTO sales_audit VALUES (15, 'DINGDONGS', '01-OCT-2014 12:00:15');
INSERT INTO sales_audit VALUES (16, 'HOHOS', '01-OCT-2014 12:00:16');
INSERT INTO sales_audit VALUES (17, 'TWINKIES', '01-OCT-2014 12:00:17');
INSERT INTO sales_audit VALUES (18, 'TWINKIES', '01-OCT-2014 12:00:18');
INSERT INTO sales_audit VALUES (19, 'TWINKIES', '01-OCT-2014 12:00:19');
INSERT INTO sales_audit VALUES (20, 'TWINKIES', '01-OCT-2014 12:00:20');
COMMIT;

/*
The following query shows the order of the product sales for a specific time period, which we will refer to later.
*/
COLUMN tstamp FORMAT A20

SELECT *
FROM   sales_audit
ORDER BY tstamp;
/*
        ID PRODUCT    TSTAMP
---------- ---------- --------------------
         1 TWINKIES   01-OCT-2014 12:00:01
         2 TWINKIES   01-OCT-2014 12:00:02
         3 DINGDONG   01-OCT-2014 12:00:03
         4 HOHOS      01-OCT-2014 12:00:04
         5 HOHOS      01-OCT-2014 12:00:05
         6 TWINKIES   01-OCT-2014 12:00:06
         7 TWINKIES   01-OCT-2014 12:00:07
         8 DINGDONGS  01-OCT-2014 12:00:08
         9 DINGDONGS  01-OCT-2014 12:00:09
        10 HOHOS      01-OCT-2014 12:00:10
        11 HOHOS      01-OCT-2014 12:00:11
        12 TWINKIES   01-OCT-2014 12:00:12
        13 TWINKIES   01-OCT-2014 12:00:13
        14 DINDONGS   01-OCT-2014 12:00:14
        15 HOHOS      01-OCT-2014 12:00:15
        16 TWINKIES   01-OCT-2014 12:00:16
        17 TWINKIES   01-OCT-2014 12:00:17
        18 TWINKIES   01-OCT-2014 12:00:18
        19 TWINKIES   01-OCT-2014 12:00:19
        20 TWINKIES   01-OCT-2014 12:00:20
*/
/*
Examples

Check for peaks/spikes in sales, where sales go up then down. Notice the pattern 
variables "UP", "FLAT" and "DOWN" are defined to show an increase, no change and 
decrease in the value respectively. The pattern we are searching for is 1-Many UPs, 
optionally leveling off, followed by 1-Many Downs. The measures displayed are the 
start of the pattern (STRT.tstamp), the top of the peak (LAST(UP.tstamp)) and the 
bottom of the drop (LAST(DOWN.tstamp)), with a single row for each match. We are 
also displaying the MATCH_NUMBER().
*/

ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY';

COLUMN start_tstamp FORMAT A11
COLUMN peak_tstamp  FORMAT A11
COLUMN end_tstamp   FORMAT A11

SELECT *
FROM   sales_history MATCH_RECOGNIZE (
         PARTITION BY product
         ORDER BY tstamp
         MEASURES  STRT.tstamp AS start_tstamp,
                   LAST(UP.tstamp) AS peak_tstamp,
                   LAST(DOWN.tstamp) AS end_tstamp,
                   MATCH_NUMBER() AS mno
         ONE ROW PER MATCH
         AFTER MATCH SKIP TO LAST DOWN
         PATTERN (STRT UP+ FLAT* DOWN+)
         DEFINE
           UP AS UP.units_sold > PREV(UP.units_sold),
           FLAT AS FLAT.units_sold = PREV(FLAT.units_sold),
           DOWN AS DOWN.units_sold < PREV(DOWN.units_sold)
       ) MR
ORDER BY MR.product, MR.start_tstamp;
/*
PRODUCT    START_TSTAM PEAK_TSTAMP END_TSTAMP         MNO
---------- ----------- ----------- ----------- ----------
TWINKIES   01-OCT-2014 03-OCT-2014 06-OCT-2014          1
TWINKIES   06-OCT-2014 08-OCT-2014 09-OCT-2014          2
TWINKIES   09-OCT-2014 13-OCT-2014 16-OCT-2014          3
TWINKIES   16-OCT-2014 18-OCT-2014 20-OCT-2014          4
*/

/*
The output tells us there were 4 distinct peaks/spikes in the sales, 
giving us the location of the start, peak and end of the pattern.

The following query is similar, but shows all the rows for the match 
and includes the CLASSIFIER() function to indicate which pattern 
variable is relevant for each row.
*/

SET LINESIZE 110
ALTER SESSION SET nls_timestamp_format = 'DD-MON-YYYY';

COLUMN start_tstamp FORMAT A11
COLUMN peak_tstamp  FORMAT A11
COLUMN end_tstamp   FORMAT A11
COLUMN cls          FORMAT A5

SELECT *
FROM   sales_history MATCH_RECOGNIZE (
         PARTITION BY product
         ORDER BY tstamp
         MEASURES  STRT.tstamp AS start_tstamp,
                   FINAL LAST(UP.tstamp) AS peak_tstamp,
                   FINAL LAST(DOWN.tstamp) AS end_tstamp,
                   MATCH_NUMBER() AS mno,
                   CLASSIFIER() AS cls
         ALL ROWS PER MATCH
         AFTER MATCH SKIP TO LAST DOWN
         PATTERN (STRT UP+ FLAT* DOWN+)
         DEFINE
           UP AS UP.units_sold > PREV(UP.units_sold),
           DOWN AS DOWN.units_sold < PREV(DOWN.units_sold),
           FLAT AS FLAT.units_sold = PREV(FLAT.units_sold)
       ) MR
ORDER BY MR.product, MR.mno, MR.tstamp;
/*
PRODUCT    TSTAMP      START_TSTAM PEAK_TSTAMP END_TSTAMP         MNO CLS           ID UNITS_SOLD
---------- ----------- ----------- ----------- ----------- ---------- ----- ---------- ----------
TWINKIES   01-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 STRT           1         17
TWINKIES   02-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 UP             2         19
TWINKIES   03-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 UP             3         23
TWINKIES   04-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 FLAT           4         23
TWINKIES   05-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 DOWN           5         16
TWINKIES   06-OCT-2014 01-OCT-2014 03-OCT-2014 06-OCT-2014          1 DOWN           6         10
TWINKIES   06-OCT-2014 06-OCT-2014 08-OCT-2014 09-OCT-2014          2 STRT           6         10
TWINKIES   07-OCT-2014 06-OCT-2014 08-OCT-2014 09-OCT-2014          2 UP             7         14
TWINKIES   08-OCT-2014 06-OCT-2014 08-OCT-2014 09-OCT-2014          2 UP             8         16
TWINKIES   09-OCT-2014 06-OCT-2014 08-OCT-2014 09-OCT-2014          2 DOWN           9         15
TWINKIES   09-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 STRT           9         15
TWINKIES   10-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 UP            10         17
TWINKIES   11-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 UP            11         23
TWINKIES   12-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 UP            12         30
TWINKIES   13-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 UP            13         31
TWINKIES   14-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 DOWN          14         29
TWINKIES   15-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 DOWN          15         25
TWINKIES   16-OCT-2014 09-OCT-2014 13-OCT-2014 16-OCT-2014          3 DOWN          16         21
TWINKIES   16-OCT-2014 16-OCT-2014 18-OCT-2014 20-OCT-2014          4 STRT          16         21
TWINKIES   17-OCT-2014 16-OCT-2014 18-OCT-2014 20-OCT-2014          4 UP            17         35
TWINKIES   18-OCT-2014 16-OCT-2014 18-OCT-2014 20-OCT-2014          4 UP            18         46
TWINKIES   19-OCT-2014 16-OCT-2014 18-OCT-2014 20-OCT-2014          4 DOWN          19         45
TWINKIES   20-OCT-2014 16-OCT-2014 18-OCT-2014 20-OCT-2014          4 DOWN          20         30

23 rows selected.
*/
/*
Notice how some rows are duplicated, as they represent the end of one pattern 
and the start of the next.

The next example identified the only occurrence of a general rise in values, 
containing a single dipping value.
*/
SELECT *
FROM   sales_history MATCH_RECOGNIZE (
         PARTITION BY product
         ORDER BY tstamp
         MEASURES  STRT.tstamp AS start_tstamp,
                   FINAL LAST(UP.tstamp) AS peak_tstamp,
                   MATCH_NUMBER() AS mno,
                   CLASSIFIER() AS cls
         ALL ROWS PER MATCH
         AFTER MATCH SKIP TO LAST DOWN
         PATTERN (STRT UP+ DOWN{1} UP+)
         DEFINE
           UP AS UP.units_sold > PREV(UP.units_sold),
           DOWN AS DOWN.units_sold < PREV(DOWN.units_sold)
       ) MR
ORDER BY MR.product, MR.tstamp;
/*
PRODUCT    TSTAMP      START_TSTAM PEAK_TSTAMP        MNO CLS           ID UNITS_SOLD
---------- ----------- ----------- ----------- ---------- ----- ---------- ----------
TWINKIES   06-OCT-2014 06-OCT-2014 13-OCT-2014          1 STRT           6         10
TWINKIES   07-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP             7         14
TWINKIES   08-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP             8         16
TWINKIES   09-OCT-2014 06-OCT-2014 13-OCT-2014          1 DOWN           9         15
TWINKIES   10-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP            10         17
TWINKIES   11-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP            11         23
TWINKIES   12-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP            12         30
TWINKIES   13-OCT-2014 06-OCT-2014 13-OCT-2014          1 UP            13         31

8 rows selected.
*/

/*
We can see there is only a single match for that pattern in the data.

Next we check for a run of TWINKIES sales separated by exactly three 
sales matching any combination of DINGDONGS and/or HOHOS.
*/
SELECT *
FROM   sales_audit MATCH_RECOGNIZE (
         --PARTITION BY product
         ORDER BY tstamp
         MEASURES  FIRST(TWINKIES.tstamp) AS start_tstamp,
                   FINAL LAST(TWINKIES.tstamp) AS end_tstamp,
                   MATCH_NUMBER() AS mno,
                   CLASSIFIER() AS cls
         ALL ROWS PER MATCH
         AFTER MATCH SKIP TO LAST TWINKIES
         PATTERN(TWINKIES+ (DINGDONGS | HOHOS){3} TWINKIES+)
         DEFINE
           TWINKIES AS TWINKIES.product='TWINKIES',
           DINGDONGS AS DINGDONGS.product='DINGDONGS',
           HOHOS AS HOHOS.product='HOHOS'
       ) MR
ORDER BY MR.mno, MR.tstamp;
/*
TSTAMP               START_TSTAMP         END_TSTAMP                  MNO CLS                ID PRODUCT
-------------------- -------------------- -------------------- ---------- ---------- ---------- ----------
01-OCT-2014 12:00:01 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 TWINKIES            1 TWINKIES
01-OCT-2014 12:00:02 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 TWINKIES            2 TWINKIES
01-OCT-2014 12:00:03 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 DINGDONGS           3 DINGDONGS
01-OCT-2014 12:00:04 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 HOHOS               4 HOHOS
01-OCT-2014 12:00:05 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 HOHOS               5 HOHOS
01-OCT-2014 12:00:06 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 TWINKIES            6 TWINKIES
01-OCT-2014 12:00:07 01-OCT-2014 12:00:01 01-OCT-2014 12:00:07          1 TWINKIES            7 TWINKIES
01-OCT-2014 12:00:12 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           12 TWINKIES
01-OCT-2014 12:00:13 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           13 TWINKIES
01-OCT-2014 12:00:14 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 DINGDONGS          14 DINGDONGS
01-OCT-2014 12:00:15 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 DINGDONGS          15 DINGDONGS
01-OCT-2014 12:00:16 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 HOHOS              16 HOHOS
01-OCT-2014 12:00:17 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           17 TWINKIES
01-OCT-2014 12:00:18 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           18 TWINKIES
01-OCT-2014 12:00:19 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           19 TWINKIES
01-OCT-2014 12:00:20 01-OCT-2014 12:00:12 01-OCT-2014 12:00:20          2 TWINKIES           20 TWINKIES

16 rows selected.
*/


/*
YET ANOTHER EXAMPLE
http://docs.oracle.com/database/121/DWHSG/pattern.htm#DWHSG8959
*/

/*
The MATCH_RECOGNIZE clause lets you choose between showing one row per match 
and all rows per match. In this example, the shorter output of one row per 
match is used.
*/
CREATE TABLE Ticker (SYMBOL VARCHAR2(10), tstamp DATE, price NUMBER);
 
INSERT INTO Ticker VALUES('ACME', '01-Apr-11', 12);
INSERT INTO Ticker VALUES('ACME', '02-Apr-11', 17);
INSERT INTO Ticker VALUES('ACME', '03-Apr-11', 19);
INSERT INTO Ticker VALUES('ACME', '04-Apr-11', 21);
INSERT INTO Ticker VALUES('ACME', '05-Apr-11', 25);
INSERT INTO Ticker VALUES('ACME', '06-Apr-11', 12);
INSERT INTO Ticker VALUES('ACME', '07-Apr-11', 15);
INSERT INTO Ticker VALUES('ACME', '08-Apr-11', 20);
INSERT INTO Ticker VALUES('ACME', '09-Apr-11', 24);
INSERT INTO Ticker VALUES('ACME', '10-Apr-11', 25);
INSERT INTO Ticker VALUES('ACME', '11-Apr-11', 19);
INSERT INTO Ticker VALUES('ACME', '12-Apr-11', 15);
INSERT INTO Ticker VALUES('ACME', '13-Apr-11', 25);
INSERT INTO Ticker VALUES('ACME', '14-Apr-11', 25);
INSERT INTO Ticker VALUES('ACME', '15-Apr-11', 14);
INSERT INTO Ticker VALUES('ACME', '16-Apr-11', 12);
INSERT INTO Ticker VALUES('ACME', '17-Apr-11', 14);
INSERT INTO Ticker VALUES('ACME', '18-Apr-11', 24);
INSERT INTO Ticker VALUES('ACME', '19-Apr-11', 23);
INSERT INTO Ticker VALUES('ACME', '20-Apr-11', 22);
commit;


SELECT *
FROM Ticker MATCH_RECOGNIZE (
     PARTITION BY symbol
     ORDER BY tstamp
     MEASURES  STRT.tstamp AS start_tstamp,
               LAST(DOWN.tstamp) AS bottom_tstamp,
               LAST(UP.tstamp) AS end_tstamp
     ONE ROW PER MATCH
     AFTER MATCH SKIP TO LAST UP
     PATTERN (STRT DOWN+ UP+)
     DEFINE
        DOWN AS DOWN.price < PREV(DOWN.price),
        UP AS UP.price > PREV(UP.price)
     ) MR
ORDER BY MR.symbol, MR.start_tstamp;

/*
What does this query do? The following explains each line in the MATCH_RECOGNIZE
clause:

- PARTITION BY divides the data from the Ticker table into logical groups where
  each group contains one stock symbol.

- ORDER BY orders the data within each logical group by tstamp.

- MEASURES defines three measures: 
  a. the timestamp at the beginning of a V-shape (start_tstamp)
  b. the timestamp at the bottom of a V-shape (bottom_tstamp)
  c. the timestamp at the end of the a V-shape (end_tstamp). 
  The bottom_tstamp and end_tstamp measures use the LAST() function to ensure 
  that the values retrieved are the final value of the timestamp within 
  each pattern match.

- ONE ROW PER MATCH means that for every pattern match found, there will be
  one row of output.

- AFTER MATCH SKIP TO LAST UP means that whenever you find a match you restart 
  your search at the row that is the last row of the UP pattern variable. 
  A pattern variable is a variable used in a MATCH_RECOGNIZE statement, and is 
  defined in the DEFINE clause.
  Because you specified AFTER MATCH SKIP TO LAST UP in the query, two adjacent 
  matches can share a row. That means a single date can have two variables 
  mapped to it. For example, 10-April has both the pattern variables UP and STRT 
  mapped to it: April 10 is the end of Match 1 and the start of Match 2.  

- PATTERN (STRT DOWN+ UP+) says that the pattern you are searching for has three 
  pattern variables: STRT, DOWN, and UP. The plus sign (+) after DOWN and UP 
  means that at least one row must be mapped to each of them. 
  The pattern defines a regular expression, which is a highly expressive way to
  search for patterns.

- DEFINE gives us the conditions that must be met for a row to map to your row 
  pattern variables STRT, DOWN, and UP. Because there is no condition for STRT, 
  any row can be mapped to STRT. Why have a pattern variable with no condition? 
  You use it as a starting point for testing for matches. Both DOWN and UP take 
  advantage of the PREV() function, which lets them compare the price in the 
  current row to the price in the prior row. DOWN is matched when a row has a 
  lower price than the row that preceded it, so it defines the downward (left) 
  leg of our V-shape. A row can be mapped to UP if the row has a higher price 
  than the row that preceded it.
*/


SELECT *
FROM Ticker MATCH_RECOGNIZE (
     PARTITION BY symbol
     ORDER BY tstamp
     MEASURES  STRT.tstamp AS start_tstamp,
               FINAL LAST(DOWN.tstamp) AS bottom_tstamp,
               FINAL LAST(UP.tstamp) AS end_tstamp,
               MATCH_NUMBER() AS match_num,
               CLASSIFIER() AS var_match
     ALL ROWS PER MATCH
     AFTER MATCH SKIP TO LAST UP
     PATTERN (STRT DOWN+ UP+)
     DEFINE
        DOWN AS DOWN.price < PREV(DOWN.price),
        UP AS UP.price > PREV(UP.price)
     ) MR
ORDER BY MR.symbol, MR.match_num, MR.tstamp;

/*
What does this query do? It is similar to the query in Example 20-1 except for 
items in the MEASURES clause, the change to ALL ROWS PER MATCH, and a change to 
the ORDER BY at the end of the query. In the MEASURES clause, there are these 
additions:

- MATCH_NUMBER() AS match_num
  Because this example gives multiple rows per match, you need to know which 
  rows are members of which match. MATCH_NUMBER assigns the same number to each 
  row of a specific match. For instance, all the rows in the first match found 
  in a row pattern partition are assigned the match_num value of 1. Note that 
  match numbering starts over again at 1 in each row pattern partition.

- CLASSIFIER() AS var_match
  To know which rows map to which variable, use the CLASSIFIER function. In this 
  example, some rows will map to the STRT variable, some rows the DOWN variable, 
  and others to the UP variable.

- FINAL LAST()
  By specifying FINAL and using the LAST() function for bottom_tstamp, every row 
  inside each match shows the same date for the bottom of its V-shape. Likewise, 
  applying FINAL LAST() to the end_tstamp measure makes every row in each match 
  show the same date for the end of its V-shape. Without this syntax, the dates 
  shown would be the running value for each row.
  
Changes were made in two other lines:

- ALL ROWS PER MATCH - While Example 20-1 gave a summary with just 1 row about 
  each match using the line ONE ROW PER MATCH, this example asks to show every 
  row of each match.

- ORDER BY on the last line - This was changed to take advantage of the 
  MATCH_NUM, so all rows in the same match are together and in chronological 
  order.  

Note that the row for April 10 appears twice because it is in two pattern 
matches: it is the last day of the first match and the first day of the second 
match.  
*/

-- Example 20-3 Pattern Match with an Aggregate on a Variable
SELECT *
FROM Ticker MATCH_RECOGNIZE (
  PARTITION BY symbol
  ORDER BY tstamp
  MEASURES
    MATCH_NUMBER() AS match_num,
    CLASSIFIER() AS var_match,
    FINAL COUNT(UP.tstamp) AS up_days,
    FINAL COUNT(tstamp) AS total_days,
    RUNNING COUNT(tstamp) AS cnt_days,
    price - STRT.price AS price_dif
  ALL ROWS PER MATCH
  AFTER MATCH SKIP TO LAST UP
  PATTERN (STRT DOWN+ UP+)
  DEFINE
    DOWN AS DOWN.price < PREV(DOWN.price),
    UP AS UP.price > PREV(UP.price)
  ) MR
ORDER BY MR.symbol, MR.match_num, MR.tstamp;

/*
What does this query do? It builds on Example 20-2 by adding three measures that 
use the aggregate function COUNT(). It also adds a measure showing how an 
expression can use a qualified and unqualified column.

The up_days measure (with FINAL COUNT) shows the number of days mapped to the UP 
pattern variable within each match. You can verify this by counting the UP labels 
for each match in Figure 20-2.

The total_days measure (also with FINAL COUNT) introduces the use of unqualified 
columns. Because this measure specified the FINAL count(tstamp) with no pattern 
variable to qualify the tstamp column, it returns the count of all rows included 
in a match.

The cnt_days measure introduces the RUNNING keyword. This measure gives a 
running count that helps distinguish among the rows in a match. Note that it 
also has no pattern variable to qualify the tstamp column, so it applies to all 
rows of a match. You do not need to use the RUNNING keyword explicitly in this 
case because it is the default. 
See "Running Versus Final Semantics and Keywords" for more information.

The price_dif measure shows us each day's difference in stock price from the 
price at the first day of a match. In the expression "price - STRT.price)," you 
see a case where an unqualified column, "price," is used with a qualified 
column, "STRT.price".
*/

-- Example 20-4 Pattern Match for a W-Shape

SELECT *
FROM Ticker MATCH_RECOGNIZE (
  PARTITION BY symbol
  ORDER BY tstamp
  MEASURES
    MATCH_NUMBER() AS match_num,
    CLASSIFIER()  AS  var_match, 
    STRT.tstamp AS start_tstamp,
    FINAL LAST(UP.tstamp) AS end_tstamp
  ALL ROWS PER MATCH
  AFTER MATCH SKIP TO LAST UP
  PATTERN (STRT DOWN+ UP+ DOWN+ UP+)
  DEFINE
    DOWN AS DOWN.price < PREV(DOWN.price),
    UP AS UP.price > PREV(UP.price)
  ) MR
ORDER BY MR.symbol, MR.match_num, MR.tstamp;

/*
What does this query do? It builds on the concepts introduced in Example 20-1 
and seeks W-shapes in the data rather than V-shapes. The query results show one 
W-shape. To find the W-shape, the line defining the PATTERN regular expression 
was modified to seek the pattern DOWN followed by UP two consecutive times: 
PATTERN (STRT DOWN+ UP+ DOWN+ UP+). This pattern specification means it can only 
match a W-shape where the two V-shapes have no separation between them. For 
instance, if there is a flat interval with the price unchanging, and that 
interval occurs between two V-shapes, the pattern will not match that data. 
To illustrate the data returned, the output is set to ALL ROWS PER MATCH. 
Note that FINAL LAST(UP.tstamp) in the MEASURES clause returns the timestamp 
value for the last row mapped to UP.
*/

/* tear down */
drop table Ticker;