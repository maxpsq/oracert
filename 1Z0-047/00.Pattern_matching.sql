/*

Oracle's Analytic functions
============================================
            Pattern Matching
============================================
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