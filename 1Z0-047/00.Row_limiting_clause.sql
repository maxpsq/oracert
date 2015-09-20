/* 
Row Limiting Clause for Top-N Queries in Oracle Database 12c 

https://oracle-base.com/articles/12c/row-limiting-clause-for-top-n-queries-12cr1

*/

CREATE TABLE rownum_order_test (
  val  NUMBER
);

INSERT ALL
  INTO rownum_order_test
  INTO rownum_order_test
SELECT level
FROM   dual
CONNECT BY level <= 10;

COMMIT;

SELECT val FROM rownum_order_test ORDER BY val ;

-- Returns the first five rows ONLY
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 5 ROWS  ONLY; -- 5 rows fetched

-- Returns the first five rows and eventually
-- adds rows with the same values of the columns in the order by clause
-- returned by the fifth row (WITH TIES)
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 5 ROWS  WITH TIES; -- 6 rows fetched

-- LIMIT BY PERCENTAGE
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 25 PERCENT ROWS  ONLY; -- 5 rows fetched

-- LIMIT BY PERCENTAGE WITH TIES
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH FIRST 25 PERCENT ROWS  WITH TIES; -- 5 rows fetched

-- the keyword FIRST is interchangable with NEXT in any situation
SELECT val FROM rownum_order_test 
 ORDER BY val 
 FETCH NEXT 5 ROWS  ONLY; -- 5 rows fetched

-- An OFFSET may be applied for pagination.
-- The starting point for the FETCH is OFFSET+1
-- The OFFSET is always based on a number of rows, 
-- but this can be combined with a FETCH using a PERCENT
SELECT val FROM rownum_order_test 
 ORDER BY val 
 OFFSET 5 ROWS FETCH FIRST 5 ROWS  ONLY; -- 5 rows fetched

SELECT val FROM rownum_order_test 
 ORDER BY val 
 OFFSET 5 ROWS FETCH NEXT 25 PERCENT ROWS ONLY; -- 5 rows fetched

-- Syntax
-- (OFFSET n ROWS) FETCH [FIRST|NEXT] m (PERCENT) ROWS  [ONLY | WITH TIES]

DROP TABLE rownum_order_test ;
