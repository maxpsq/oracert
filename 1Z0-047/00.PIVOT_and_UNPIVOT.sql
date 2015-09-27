/* 

PIVOT and UNPIVOT 

https://oracle-base.com/articles/11g/pivot-and-unpivot-operators-11gr1

*/

-- connect as user oracert

/*

PIVOT

The PIVOT operator takes data in separate rows, aggregates it and converts it 
into columns. 
To see the PIVOT operator in action we need to create a test table.

*/

CREATE TABLE pivot_test (
  id            NUMBER,
  customer_id   NUMBER,
  product_code  VARCHAR2(5),
  quantity      NUMBER
);

INSERT INTO pivot_test VALUES (1, 1, 'A', 10);
INSERT INTO pivot_test VALUES (2, 1, 'B', 20);
INSERT INTO pivot_test VALUES (3, 1, 'C', 30);
INSERT INTO pivot_test VALUES (4, 2, 'A', 40);
INSERT INTO pivot_test VALUES (5, 2, 'C', 50);
INSERT INTO pivot_test VALUES (6, 3, 'A', 60);
INSERT INTO pivot_test VALUES (7, 3, 'B', 70);
INSERT INTO pivot_test VALUES (8, 3, 'C', 80);
INSERT INTO pivot_test VALUES (9, 3, 'D', 90);
INSERT INTO pivot_test VALUES (10, 4, 'A', 100);
COMMIT;

SELECT * FROM pivot_test;

/*
In its basic form the PIVOT operator is quite limited. 
We are forced to list the required values to PIVOT using the IN clause.
*/
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'B' AS b, 'C' AS c));

-- aliases in the FOR clause are not mandatory
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A', 'B', 'C'));

/*
If we want to break it down by customer, we simply include 
the CUSTOMER_ID column in the initial select list.
*/
SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'B' AS b, 'C' AS c))
ORDER BY customer_id;

/* 
We can convert the output to an XMLTYPE using the XML keyword. This makes
the PIVOT feature more flexible allowing to replace the hard coded IN clause 
with the keyword ANY or a subquery. ANY and the subquery works only with XML.
*/
SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT XML (SUM(quantity) AS sum_quantity FOR (product_code) IN (ANY)) -- ANY
ORDER BY customer_id;

SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT XML (SUM(quantity) AS sum_quantity FOR (product_code) IN 
          (SELECT DISTINCT product_code FROM pivot_test WHERE id < 10)) -- subquery
ORDER BY customer_id;


-- tear down
drop table pivot_test;


/*
UNPIVOT
The UNPIVOT operator converts column-based data into separate rows. 
To see the UNPIVOT operator in action we need to create a test table.
*/

CREATE TABLE unpivot_test (
  id              NUMBER,
  customer_id     NUMBER,
  product_code_a  NUMBER,
  product_code_b  NUMBER,
  product_code_c  NUMBER,
  product_code_d  NUMBER
);

INSERT INTO unpivot_test VALUES (1, 101, 10, 20, 30, NULL);
INSERT INTO unpivot_test VALUES (2, 102, 40, NULL, 50, NULL);
INSERT INTO unpivot_test VALUES (3, 103, 60, 70, 80, 90);
INSERT INTO unpivot_test VALUES (4, 104, 100, NULL, NULL, NULL);
COMMIT;


SELECT * FROM unpivot_test;

/* 
The UNPIVOT operator converts this column-based data into individual rows.

- The columns named 'quantity' and 'product_code' are in the UNPIVOT statement
- The columns to be unpivoted must be named in the IN clause
- The PRODUCT_CODE value will match the column name it is derived from, unless you alias it to another value.
- By default the EXCLUDE NULLS clause is used. To override the default behaviour use the INCLUDE NULLS clause.
*/

SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR product_code IN (product_code_a AS 'A', product_code_b AS 'B', product_code_c AS 'C', product_code_d AS 'D'));

/* 
Notice the IN clause acts as a normal IN() operator and restricts the returned 
rows to the ones matching the values in the set passed to the IN operator. 
Only
*/
SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR product_code IN (product_code_a AS 'A'));

-- INCLUDE NULLS
SELECT *
FROM   unpivot_test
UNPIVOT INCLUDE NULLS (quantity FOR product_code IN (product_code_a AS 'A', product_code_b AS 'B', product_code_c AS 'C', product_code_d AS 'D'));


