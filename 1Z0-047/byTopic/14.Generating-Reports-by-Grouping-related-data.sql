/*
          ROLLUP, CUBE, GROUPING Functions and GROUPING SETS

https://oracle-base.com/articles/misc/rollup-cube-grouping-functions-and-grouping-sets
*/
--==============================================================================
-- SET UP
--==============================================================================
CREATE TABLE dimension_tab (
  fact_1_id   NUMBER NOT NULL,
  fact_2_id   NUMBER NOT NULL,
  fact_3_id   NUMBER NOT NULL,
  fact_4_id   NUMBER NOT NULL,
  sales_value NUMBER(10,2) NOT NULL
);

INSERT INTO dimension_tab
SELECT TRUNC(DBMS_RANDOM.value(low => 1, high => 3)) AS fact_1_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 6)) AS fact_2_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 11)) AS fact_3_id,
       TRUNC(DBMS_RANDOM.value(low => 1, high => 11)) AS fact_4_id,
       ROUND(DBMS_RANDOM.value(low => 1, high => 100), 2) AS sales_value
FROM   dual
CONNECT BY level <= 1000;
COMMIT;

/*
Let's start be reminding ourselves how the GROUP BY clause works. An aggregate 
function takes multiple rows of data returned by a query and aggregates them 
into a single result row.
*/

SELECT fact_1_id,
       fact_2_id,
       COUNT(*) AS num_rows,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY fact_1_id, fact_2_id
ORDER BY fact_1_id, fact_2_id;

/*
FACT_1_ID  FACT_2_ID   NUM_ROWS SALES_VALUE
---------- ---------- ---------- -----------
         1          1         83     4363.55
         1          2         96     4794.76
         1          3         93     4718.25
         1          4        105     5387.45
         1          5        101     5027.34
         2          1        109     5652.84
         2          2         96     4583.02
         2          3        110     5555.77
         2          4        113     5936.67
         2          5         94     4508.74

10 rows selected.
SQL>
*/

--==============================================================================
--                                 ROLLUP
--==============================================================================
/*
    ROLLUP
====================================
The ROLLUP operation is a subclause of GROUP BY that aggregates the aggregate 
data in the SELECT statement’s output. The aggregated aggregate rows are known 
as superaggregate rows.
*/

-- set up
create table SHIP_CABINS (
   SHIP_CABIN_ID    NUMBER,
   ROOM_STYLE       VARCHAR2(20),
   ROOM_TYPE        VARCHAR2(20),
   SQ_FT            NUMBER
);

INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (1,'Suite','Standard',533);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (2,'Stateroom','Standard',160);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (3,'Suite','Standard',533);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (4,'Stateroom','Standard',205);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (5,'Suite','Standard',586);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (6,'Suite','Royal',1524);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (7,'Stateroom','Large',211);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (8,'Stateroom','Standard',180);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (9,'Stateroom','Large',225);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (10,'Suite','Presidential',1142);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (11,'Suite','Royal',1745);
INSERT INTO SHIP_CABINS(SHIP_CABIN_ID,ROOM_STYLE,ROOM_TYPE,SQ_FT) VALUES (12,'Suite','Skyloft',722);
COMMIT;

SELECT ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROOM_STYLE, ROOM_TYPE
 ORDER BY ROOM_STYLE, ROOM_TYPE ;


SELECT ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROLLUP (ROOM_STYLE, ROOM_TYPE)
 ORDER BY ROOM_STYLE, ROOM_TYPE ;

/*
ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
----------------------------------
Stateroom   Large          872
Stateroom	  Standard	    1090
Stateroom		              1962  <-- superaggregate row
Suite	      Presidential	2284
Suite	      Royal	        6538
Suite	      Skyloft	      1444
Suite	      Standard	    3304
Suite		                 13570  <-- superaggregate row
                         15532  <-- superaggregate row
*/

/*
1. The keyword ROLLUP is used after the keywords GROUP BY, 
   and is part of the GROUP BY clause.
2. The keyword ROLLUP is followed by a grouping expression list enclosed 
   in parentheses.
3. ROLLUP can be repeated for each grouping in the GROUP BY clause 
   you wish to roll up.
   
You can include as many GROUP BY groups as you would in a typical GROUP BY clause. 
ROLLUP can be used to compute a subtotal for each group.   

For every n groups, ROLLUP produces n+1 groupings.
*/    
    
SELECT ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROLLUP (ROOM_STYLE), ROLLUP (ROOM_TYPE)  -- ** NOTICE this will produce the same result of "GROUP BY CUBE(ROOM_STYLE, ROOM_TYPE)"
 ORDER BY ROOM_STYLE, ROOM_TYPE ;

/*
Stateroom	  Large	         872
Stateroom	  Standard	    1090
Stateroom		              1962  <-- superaggregate row
Suite	      Presidential	2284
Suite	      Royal	        6538
Suite	      Skyloft     	1444
Suite	      Standard	    3304
Suite		                 13570  <-- superaggregate row
            Large	         872  <-- superaggregate row
            Presidential	2284  <-- superaggregate row
            Royal	        6538  <-- superaggregate row
            Skyloft	      1444  <-- superaggregate row
            Standard	    4394  <-- superaggregate row
                         15532  <-- superaggregate row
*/

SELECT ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROLLUP (ROOM_TYPE)
 ORDER BY ROOM_TYPE ;

/*
Large	         872
Presidential	2284
Royal	        6538
Skyloft	      1444
Standard	    4394
             15532  --> super aggregate
*/

/*
Stateroom	Large	          872
Stateroom	Standard	     1090
Stateroom	         	     1962  --> super aggregate
Suite	    Presidential	 2284
Suite	    Royal	         6538
Suite	    Skyloft	       1444
Suite	    Standard	     3304
Suite		                13570  --> super aggregate
*/

SELECT ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROOM_STYLE, ROLLUP (ROOM_TYPE)
 ORDER BY ROOM_STYLE, ROOM_TYPE ;

  
  

/*
In addition to the regular aggregation results we expect from the GROUP BY clause, 
the ROLLUP extension produces group subtotals from right to left and a grand total. 
If "n" is the number of columns listed in the ROLLUP, there will be n+1 levels 
of subtotals.
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       'Level '||(1+grouping(fact_1_id)+grouping(fact_2_id)) as grp_level
FROM   dimension_tab
GROUP BY ROLLUP (fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id;
/*
FACT_1_ID  FACT_2_ID SALES_VALUE
---------- ---------- -----------
         1          1     4363.55     (Level 1)
         1          2     4794.76     (Level 1)
         1          3     4718.25     (Level 1)
         1          4     5387.45     (Level 1)
         1          5     5027.34     (Level 1)
         1               24291.35     (Level 2)
         2          1     5652.84     (Level 1)
         2          2     4583.02     (Level 1)
         2          3     5555.77     (Level 1)
         2          4     5936.67     (Level 1)
         2          5     4508.74     (Level 1)
         2               26237.04     (Level 2)
                         50528.39     (Level 3) -- = N+1 = 2+1

13 rows selected.
*/

/*
 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1          1          1      381.61     (Level 1)
         1          1          2      235.29     (Level 1)
         1          1          3       270.7     (Level 1)
         1          1          4      634.05     (Level 1)
         1          1          5      602.36     (Level 1)
         1          1          6      538.41     (Level 1)
         1          1          7      245.87     (Level 1)
         1          1          8      435.54     (Level 1)
         1          1          9      506.59     (Level 1)
         1          1         10      513.13     (Level 1)
         1          1                4363.55     (Level 2)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1          2          1      370.97     (Level 1)
         1          2          2      259.31     (Level 1)
         1          2          3      509.68     (Level 1)
         1          2          4      668.64     (Level 1)
         1          2          5      614.99     (Level 1)
         1          2          6      298.12     (Level 1)
         1          2          7      466.98     (Level 1)
         1          2          8      479.95     (Level 1)
         1          2          9      575.89     (Level 1)
         1          2         10      550.23     (Level 1)
         1          2                4794.76     (Level 2)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1          3          1      607.06     (Level 1)
         1          3          2      470.61     (Level 1)
         1          3          3      514.79     (Level 1)
         1          3          4      367.72     (Level 1)
         1          3          5      415.19     (Level 1)
         1          3          6      390.99     (Level 1)
         1          3          7      440.98     (Level 1)
         1          3          8      642.67     (Level 1)
         1          3          9      461.13     (Level 1)
         1          3         10      407.11     (Level 1)
         1          3                4718.25     (Level 2)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1          4          1      834.37     (Level 1)
         1          4          2      471.72     (Level 1)
         1          4          3      339.45     (Level 1)
         1          4          4       337.9     (Level 1)
         1          4          5      409.88     (Level 1)
         1          4          6      719.47     (Level 1)
         1          4          7      390.67     (Level 1)
         1          4          8      595.08     (Level 1)
         1          4          9      890.73     (Level 1)
         1          4         10      398.18     (Level 1)
         1          4                5387.45     (Level 2)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1          5          1      543.39     (Level 1)
         1          5          2      417.36     (Level 1)
         1          5          3      456.34     (Level 1)
         1          5          4      596.86     (Level 1)
         1          5          5      548.51     (Level 1)
         1          5          6      559.91     (Level 1)
         1          5          7      295.35     (Level 1)
         1          5          8       799.8     (Level 1)
         1          5          9      344.41     (Level 1)
         1          5         10      465.41     (Level 1)
         1          5                5027.34     (Level 2)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         1                          24291.35     (Level 3)
         2          1          1      838.08     (Level 1)
         2          1          2      252.93     (Level 1)
         2          1          3      989.74     (Level 1)
         2          1          4      736.87     (Level 1)
         2          1          5      895.58     (Level 1)
         2          1          6      559.87     (Level 1)
         2          1          7      334.42     (Level 1)
         2          1          8       346.8     (Level 1)
         2          1          9      379.27     (Level 1)
         2          1         10      319.28     (Level 1)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         2          1                5652.84     (Level 2)
         2          2          1      466.31     (Level 1)
         2          2          2      648.44     (Level 1)
         2          2          3      262.44     (Level 1)
         2          2          4      343.78     (Level 1)
         2          2          5      331.71     (Level 1)
         2          2          6      594.96     (Level 1)
         2          2          7      707.46     (Level 1)
         2          2          8      512.56     (Level 1)
         2          2          9      170.11     (Level 1)
         2          2         10      545.25     (Level 1)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         2          2                4583.02     (Level 2)
         2          3          1      812.17     (Level 1)
         2          3          2      488.23     (Level 1)
         2          3          3      840.21     (Level 1)
         2          3          4      447.27     (Level 1)
         2          3          5       759.4     (Level 1)
         2          3          6      646.82     (Level 1)
         2          3          7      202.86     (Level 1)
         2          3          8      489.98     (Level 1)
         2          3          9      351.16     (Level 1)
         2          3         10      517.67     (Level 1)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         2          3                5555.77     (Level 2)
         2          4          1      681.29     (Level 1)
         2          4          2      771.78     (Level 1)
         2          4          3      300.61     (Level 1)
         2          4          4      669.27     (Level 1)
         2          4          5      914.13     (Level 1)
         2          4          6      705.48     (Level 1)
         2          4          7      296.23     (Level 1)
         2          4          8      557.92     (Level 1)
         2          4          9      618.33     (Level 1)
         2          4         10      421.63     (Level 1)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         2          4                5936.67     (Level 2)
         2          5          1      714.84     (Level 1)
         2          5          2      686.56     (Level 1)
         2          5          3       579.5     (Level 1)
         2          5          4      336.87     (Level 1)
         2          5          5      215.17     (Level 1)
         2          5          6      268.72     (Level 1)
         2          5          7      667.22     (Level 1)
         2          5          8      451.29     (Level 1)
         2          5          9      365.24     (Level 1)
         2          5         10      223.33     (Level 1)

 FACT_1_ID  FACT_2_ID  FACT_3_ID SALES_VALUE
---------- ---------- ---------- -----------
         2          5                4508.74     (Level 2)
         2                          26237.04     (Level 3)
                                    50528.39     (Level 4 = N+1 = 3+1) 

113 rows selected.
*/

/*
It is possible to do a partial rollup to reduce the number of subtotals calculated
*/
SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY fact_1_id, ROLLUP (fact_2_id, fact_3_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id;

--==============================================================================
--                                    CUBE
--==============================================================================

  
/*
================================================================================
    CUBE
================================================================================
The CUBE operation is a subclause of GROUP BY that aggregates the aggregate 
data in the SELECT statement’s output. The aggregated aggregate rows are known 
as superaggregate rows.

For n expressions, CUBE returns 2 to the nth power groupings. In the following 
example:

GR 1: ROOM_STYLE, ROOM_TYPE
GR 2: ROOM_STYLE
GR 3: ROOM_TYPE
GR 4: Grand Total
*/

SELECT ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT) SUM_SQ_FT
  FROM SHIP_CABINS
 GROUP BY CUBE (ROOM_STYLE, ROOM_TYPE)
 ORDER BY ROOM_STYLE, ROOM_TYPE; 

/*
Stateroom	  Large	         872                          (GROUP 1)
Stateroom	  Standard	    1090                          (GROUP 1) 
Stateroom		              1962  <-- superaggregate row  (GROUP 2)
Suite	      Presidential	2284                          (GROUP 1)
Suite	      Royal	        6538                          (GROUP 1)
Suite	      Skyloft     	1444                          (GROUP 1)
Suite	      Standard	    3304                          (GROUP 1)
Suite		                 13570  <-- superaggregate row  (GROUP 2)
            Large	         872  <-- superaggregate row  (GROUP 3)
            Presidential	2284  <-- superaggregate row  (GROUP 3)
            Royal	        6538  <-- superaggregate row  (GROUP 3)
            Skyloft	      1444  <-- superaggregate row  (GROUP 3)
            Standard	    4394  <-- superaggregate row  (GROUP 3)
                         15532  <-- superaggregate row  (Group 4: Grand Total)
*/


/*
In addition to the subtotals generated by the ROLLUP extension, the CUBE 
extension will generate subtotals for all combinations of the dimensions 
specified. If "n" is the number of columns listed in the CUBE, there will 
be 2^n subtotal combinations.
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY CUBE (fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id;

/*
 FACT_1_ID  FACT_2_ID SALES_VALUE
---------- ---------- -----------
         1          1     4363.55   (Level 1)
         1          2     4794.76   (Level 1)
         1          3     4718.25   (Level 1)
         1          4     5387.45   (Level 1)
         1          5     5027.34   (Level 1)
         1               24291.35   (Level 2)
         2          1     5652.84   (Level 1)
         2          2     4583.02   (Level 1)
         2          3     5555.77   (Level 1)
         2          4     5936.67   (Level 1)
         2          5     4508.74   (Level 1)
         2               26237.04   (Level 2)
                    1    10016.39   (Level 3)
                    2     9377.78   (Level 3)
                    3    10274.02   (Level 3)
                    4    11324.12   (Level 3)
                    5     9536.08   (Level 3)
                         50528.39   (Level 4 = 2^N = 2^2 )

18 rows selected.
*/

-- this demonstrates the 2^N groupings
select distinct gr1, gr2 from (
SELECT grouping(fact_1_id) as gr1,
       grouping(fact_2_id) as gr2,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY CUBE (fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id);


SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY CUBE (fact_1_id, fact_2_id, fact_3_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id;

-- this demonstrates the 2^N gropings
select distinct gr1, gr2, gr3 from (
SELECT grouping(fact_1_id) as gr1,
       grouping(fact_2_id) as gr2,
       grouping(fact_3_id) as gr3,
       SUM(sales_value) AS sales_value
FROM   dimension_tab
GROUP BY CUBE (fact_1_id, fact_2_id, fact_3_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id);


/*
================================================================================
  GROUPING SETS
================================================================================
The GROUPING SETS operation is another subclause of GROUP BY. It provides a finer 
level of detail in specifying which groups you wish to display, with optional 
subtotals and an optional grand total. With GROUPING SETS, you can be more s
elective with the results of a GROUP BY clause, and specify particular groups 
you wish to include in your output, omitting the rest—potentially reducing 
processing time accordingly.
*/

SELECT WINDOW, ROOM_STYLE, ROOM_TYPE, ROUND(SUM(SQ_FT),2) SUM_SQ_FT
  FROM SHIP_CABINS
 WHERE SHIP_ID = 1
 GROUP BY GROUPING SETS( (WINDOW, ROOM_STYLE), (ROOM_TYPE), NULL)
 ORDER BY WINDOW, ROOM_STYLE, ROOM_TYPE;
 
/*
This example uses GROUPING SETS to specify three groups:
1. The first group, WINDOW and ROOM_STYLE, is equivalent to executing a SELECT 
   statement with a GROUP BY WINDOW, ROOM_STYLE. 
2. The second group is ROOM_TYPE by itself, which is the equivalent to
   executing a SEELCT statement with a GROUP BY ROOM_TYPE.
3. The third group is NULL, which is the equivalent (in GROUPING SETS syntax) 
   of asking for a single grand total.
*/
 
/*
================================================================================
 The GROUPING function
================================================================================
The GROUPING function identifies superaggregate or aggregate rows produced by a 
ROLLUP or CUBE operation in a SELECT . . . GROUP BY statement. I
t returns a value of the NUMBER datatype, and its value is either 
a one (1) or a zero (0).
The GROUPING function is only valid in a SELECT statement that uses a GROUP BY 
clause. While GROUPING may be used in a GROUP BY that doesn’t include the ROLLUP 
or CUBE operation, it doesn’t produce anything meaningful without those operators,
it will always return a zero if ROLLUP and CUBE are absent from the statement.
*/
SELECT GROUPING(ROOM_STYLE), GROUPING(ROOM_TYPE), ROOM_STYLE, ROOM_TYPE, SUM(SQ_FT)
  FROM SHIP_CABINS
 GROUP BY ROLLUP (ROOM_STYLE, ROOM_TYPE)
 ORDER BY ROOM_STYLE, ROOM_TYPE ;


/*
================================================================================
The GROUPING_ID function
================================================================================
The GROUPING_ID function provides an alternate and more compact way to identify 
subtotal rows. Passing the dimension columns as arguments, it returns a number 
indicating the GROUP BY level.
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id) AS grouping_id
FROM   dimension_tab
GROUP BY CUBE (fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id;

/*
================================================================================
The GROUP_ID function
================================================================================
It's possible to write queries that return the duplicate subtotals, which can be 
a little confusing. The GROUP_ID function assigns the value "0" to the first set, 
and all subsequent sets get assigned a higher number. The following query forces 
duplicates to show the GROUP_ID function in action.
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id) AS grouping_id,
       GROUP_ID() AS group_id
FROM   dimension_tab
GROUP BY GROUPING SETS(fact_1_id, CUBE (fact_1_id, fact_2_id))
ORDER BY fact_1_id, fact_2_id;

/*
If necessary, you could then filter the results using the group:
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id) AS grouping_id,
       GROUP_ID() AS group_id
FROM   dimension_tab
GROUP BY GROUPING SETS(fact_1_id, CUBE (fact_1_id, fact_2_id))
HAVING GROUP_ID() = 0   --> *** NOTICE THIS ***
ORDER BY fact_1_id, fact_2_id;


/*
================================================================================
GROUPING SETS
================================================================================
Calculating all possible subtotals in a cube, especially those with many 
dimensions, can be quite an intensive process. If you don't need all the 
subtotals, this can represent a considerable amount of wasted effort. 
The following cube with three dimensions gives 8 levels of subtotals 
(GROUPING_ID: 0-7)
If we only need a few of these levels of subtotaling we can use the GROUPING SETS 
expression and specify exactly which ones we need, saving us having to calculate 
the whole cube. In the following query we are only interested in subtotals for 
the "FACT_1_ID, FACT_2_ID" and "FACT_1_ID, FACT_3_ID" groups.
*/

SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id, fact_3_id) AS grouping_id
FROM   dimension_tab
GROUP BY GROUPING SETS( (fact_1_id, fact_2_id), (fact_1_id, fact_3_id) )
ORDER BY fact_1_id, fact_2_id, fact_3_id;

/*
Composite Columns

ROLLUP and CUBE consider each column independently when deciding which subtotals 
must be calculated. For ROLLUP this means stepping back through the list to 
determine the groupings.
*****
The effect of embracing columns in parentheses is to show only those results where
the embraced columns appear together:
*****

ROLLUP (a, b, c)
(a, b, c)
(a, b)
(a)
()

CUBE creates a grouping for every possible combination of columns.

CUBE (a, b, c)
(a, b, c)
(a, b)
(a, c)
(a)
(b, c)
(b)
(c)
()

Composite columns allow columns to be grouped together with braces so they are 
treated as a single unit when determining the necessary groupings. 
In the following ROLLUP columns "a" and "b" have been turned into a composite 
column by the additional braces. As a result the group of "a" is not longer 
calculated as the column "a" is only present as part of the composite column in 
the statement.

ROLLUP (a, b, c)    ROLLUP ((a, b), c)
(a, b, c)           (a, b, c)
(a, b)              (a, b)
(a)                 ** here 'a' doesn't appear together with 'b', so it is skipped **
()                  ()

Not considered:
(a)

In a similar way, the possible combinations of the following CUBE are reduced 
because references to "a" or "b" individually are not considered as they are 
treated as a single column when the groupings are determined.

CUBE (a, b, c)      CUBE ((a, b), c)
(a, b, c)           (a, b, c)
(a, b)              (a, b)
(a, c)              ** here 'a' doesn't appear together with 'b', so it is skipped **
(a)                 ** here 'a' doesn't appear together with 'b', so it is skipped **
(b, c)              ** here 'b' doesn't appear together with 'a', so it is skipped **
(b)                 ** here 'b' doesn't appear together with 'a', so it is skipped **
(c)                 (c)
()                  ()

Not considered:
(a, c)
(a)
(b, c)
(b)

The impact of this is shown clearly in the follow two statements, whose output 
is shown here and here. The regular cube returns 198 rows and 8 groups (0-7), 
while the cube with the composite column returns only 121 rows with 4 
groups (0, 1, 6, 7)

*/
-- Regular Cube.
SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id, fact_3_id) AS grouping_id
FROM   dimension_tab
GROUP BY CUBE(fact_1_id, fact_2_id, fact_3_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id;

-- Cube with composite column.
SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id, fact_3_id) AS grouping_id
FROM   dimension_tab
GROUP BY CUBE((fact_1_id, fact_2_id), fact_3_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id;

/*
================================================================================
Concatenated Groupings
================================================================================
Concatenated groupings are defined by putting together multiple GROUPING SETS, 
CUBEs or ROLLUPs separated by commas. The resulting groupings are the 
cross-product of all the groups produced by the individual grouping sets. 
It might be a little easier to understand what this means by looking at an example. 
The following GROUPING SET results in 2 groups of subtotals, one for the 
fact_1_id column and one for the fact_id_2 column.
*/
SELECT fact_1_id,
       fact_2_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id) AS grouping_id
FROM   dimension_tab
GROUP BY GROUPING SETS(fact_1_id, fact_2_id)
ORDER BY fact_1_id, fact_2_id;
/*
 FACT_1_ID  FACT_2_ID SALES_VALUE GROUPING_ID
---------- ---------- ----------- -----------
         1               24291.35           1
         2               26237.04           1
                    1    10016.39           2
                    2     9377.78           2
                    3    10274.02           2
                    4    11324.12           2
                    5     9536.08           2

7 rows selected.

SQL>
The next GROUPING SET results in another 2 groups of subtotals, one for
the fact_3_id column and one for the fact_4_id column.
*/
SELECT fact_3_id,
       fact_4_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_3_id, fact_4_id) AS grouping_id
FROM   dimension_tab
GROUP BY GROUPING SETS(fact_3_id, fact_4_id)
ORDER BY fact_3_id, fact_4_id;
/*
 FACT_3_ID  FACT_4_ID SALES_VALUE GROUPING_ID
---------- ---------- ----------- -----------
         1                6250.09           1
         2                4702.23           1
         3                5063.46           1
         4                5139.23           1
         5                5706.92           1
         6                5282.75           1
         7                4048.04           1
         8                5311.59           1
         9                4662.86           1
        10                4361.22           1
                    1     4718.55           2
                    2      5439.1           2
                    3      4643.4           2
                    4      4515.3           2
                    5     5110.27           2
                    6     5910.78           2
                    7     4987.22           2
                    8     4846.25           2
                    9     5458.82           2
                   10      4898.7           2

20 rows selected.

*/
/*
If we combine them together into a concatenated grouping we get 4 groups of 
subtotals. The output of the following query is shown here.
*/
SELECT fact_1_id,
       fact_2_id,
       fact_3_id,
       fact_4_id,
       SUM(sales_value) AS sales_value,
       GROUPING_ID(fact_1_id, fact_2_id, fact_3_id, fact_4_id) AS grouping_id
FROM   dimension_tab
GROUP BY GROUPING SETS(fact_1_id, fact_2_id), GROUPING SETS(fact_3_id, fact_4_id)
ORDER BY fact_1_id, fact_2_id, fact_3_id, fact_4_id;

/*
The output from the previous three queries produce the following groupings.

GROUPING SETS(fact_1_id, fact_2_id) 
(fact_1_id)
(fact_2_id)

GROUPING SETS(fact_3_id, fact_4_id) 
(fact_3_id)
(fact_4_id)

GROUPING SETS(fact_1_id, fact_2_id), GROUPING SETS(fact_3_id, fact_4_id) 
(fact_1_id, fact_3_id)
(fact_1_id, fact_4_id)
(fact_2_id, fact_3_id)
(fact_2_id, fact_4_id)
So we can see the final cross-product of the two GROUPING SETS that make up the concatenated grouping. A generic summary would be as follows.

GROUPING SETS(a, b), GROUPING SETS(c, d) 
(a, c)
(a, d)
(b, c)
(b, d)
*/

--==============================================================================
-- TEAR DOWN
--==============================================================================
drop table dimension_tab purge ;
