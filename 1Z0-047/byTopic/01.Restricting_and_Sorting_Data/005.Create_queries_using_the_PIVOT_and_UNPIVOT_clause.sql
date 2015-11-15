/* 
                   PIVOT and UNPIVOT 

https://oracle-base.com/articles/11g/pivot-and-unpivot-operators-11gr1

-- connect as user oracert
*/


/*******************************************************************************
                                  PIVOT
*******************************************************************************
The PIVOT operator takes data in separate rows, aggregates it and converts it 
into columns. 
To see the PIVOT operator in action we need to create a test table.
*******************************************************************************/

-- set up

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

-- /set up

SELECT * FROM pivot_test;

/*

SYNATX

SELECT * FROM ( <inline view> )
 PIVOT ( aggr_func(col2) AS alc1, aggr_func(col3) AS alc2 FOR (col1) IN (val1 AS al1, val2 AS al2, ..., valN AS alN ) )

In its basic form the PIVOT operator is quite limited. 
We are forced to list the required values to PIVOT using the IN clause.

The IN clause defines the number of columns that will appear in ALL the 
rows returned.

Here's the case of four columns (all the pruduct codes in the source table) ...
*/
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'B' AS b, 'C' AS c, 'D' as d));

/*
.. or just two columns (valus A and C) ...
*/
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'C' AS c));

/*
.. or some values not present in the table (always NULL)
*/
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'X' as x, 'Z' as z));

/*
Notice how the column names are set depending on the use of aliases within the
PIVOT clause.
*/
-- aliases in the FOR clause are not mandatory
-- aliases pivoted columns must be specified in order to avoid column names
-- collision in case (ambiguous column name) in case we pivot more then one column
SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) FOR (product_code) IN ('A', 'B', 'C'));

SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) FOR (product_code) IN ('A' as a, 'B' as b, 'C' as c));

SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) as sum FOR (product_code) IN ('A', 'B', 'C'));

SELECT *
FROM   (SELECT product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) as sum FOR (product_code) IN ('A' as a, 'B' as b, 'C' as c));

/*
If we want to break it down by customer, we simply include 
the CUSTOMER_ID column in the initial select list.
*/
SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'B' AS b, 'C' AS c))
ORDER BY customer_id;

/* We can filter the results using the WHERE clause after PIVOT */
SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT  (SUM(quantity) AS sum_quantity FOR (product_code) IN ('A' AS a, 'B' AS b, 'C' AS c))
where customer_id = 3
ORDER BY customer_id;

/*
We can pivot multiple columns. In this example we pivot quantity and id. The 
column named 'id' needs to be added to the source query
*/
select * 
  from ( select customer_id, product_code, quantity, id
           from pivot_test )
  pivot ( sum(quantity) as SQ, sum(id) as SI for product_code in ('B', 'C') );

/* 
of course we can use the asterisk to specify all the columns in the
source table, but it's better to avoid this approach for better performance.
*/
select * 
  from ( select *
           from pivot_test )
  pivot ( sum(quantity) as SQ, sum(id) as SI for product_code in ('B', 'C') );

/* 
We can convert the output to an XMLTYPE using the XML keyword. This makes
the PIVOT feature more flexible allowing to replace the hard coded IN clause 
with the keyword ANY or a subquery. ANY and the subquery works only with XML 
because in a XML structure the number of pivoted elements change within each 
group of curtomer_id (see the output for better understanding)
*/
SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT XML (SUM(quantity) AS sum_quantity FOR (product_code) IN (ANY)) -- ANY
ORDER BY customer_id;

/* 
XML for 'customer_id' = 4 in case of ANY (any product_code value is returned)

<PivotSet>
 <item>
  <column name = "PRODUCT_CODE">A</column>
  <column name = "SUM_QUANTITY">100</column>
 </item>
</PivotSet>

*/

SELECT *
FROM   (SELECT customer_id, product_code, quantity
        FROM   pivot_test)
PIVOT XML (SUM(quantity) AS sum_quantity FOR (product_code) IN 
          (SELECT DISTINCT product_code FROM pivot_test WHERE id < 10)) -- subquery
ORDER BY customer_id;

/*
XML for 'customer_id' = 4 in case of subquery returning A, B, C, D: 
all the product_id codes returned by the subquery are present in the XML even if
there are quantities for each product id.

<PivotSet>
 <item>
  <column name = "PRODUCT_CODE">A</column>
  <column name = "SUM_QUANTITY">100</column>
 </item>
 <item>
  <column name = "PRODUCT_CODE">B</column>
  <column name = "SUM_QUANTITY"></column>
 </item>
 <item>
  <column name = "PRODUCT_CODE">C</column>
  <column name = "SUM_QUANTITY"></column>
 </item>
 <item>
  <column name = "PRODUCT_CODE">D</column>
  <column name = "SUM_QUANTITY"></column>
 </item>
</PivotSet>
*/

-- tear down
drop table pivot_test purge;


/******************************************************************************
                                  UNPIVOT
*******************************************************************************
The UNPIVOT operator converts column-based data into separate rows. 
To see the UNPIVOT operator in action we need to create a test table.
*******************************************************************************/

-- set up

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

-- /set up

SELECT * FROM unpivot_test;

/*
The UNPIVOT operator converts this column-based data into individual rows.

- The columns named 'quantity' and 'product_code' are in the UNPIVOT statement
- The columns to be unpivoted must be named in the IN clause
- The PRODUCT_CODE value will match the column name it is derived from, unless 
  you alias it to another value.
- By default the EXCLUDE NULLS clause is used. To override the default behaviour 
  use the INCLUDE NULLS clause.
*******************************************************************************/

SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR 
         product_code IN (product_code_a AS 'A', 
                          product_code_b AS 'B', 
                          product_code_c AS 'C', 
                          product_code_d AS 'D')
        );

/*
Columns returned by 'SELECT * '
  id              NUMBER,
  customer_id     NUMBER,
  product_code_a  NUMBER,
  product_code_b  NUMBER,
  product_code_c  NUMBER,
  product_code_d  NUMBER

columns with name 'product_code_*' are removed by the IN () clause and replaced 
with 'product_code'
  id              NUMBER,
  customer_id     NUMBER,
  product_code    VARCHAR2(1) -- AS 'A', AS 'B', etc ... define the type
  
a new column 'quantity' is added  
  id              NUMBER,
  customer_id     NUMBER,
  product_code    VARCHAR2(1)
  quantity        NUMBER -- ( product_code_* columns define the type)
  
*/

/* 
we can filter the results using the WHERE clause and 
sort them using the ORDER BY clause
*/
SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR 
         product_code IN (product_code_a AS 'A', 
                          product_code_b AS 'B', 
                          product_code_c AS 'C', 
                          product_code_d AS 'D')
        )
where quantity > 30
order by 1;

/* 
Notice the IN clause acts as a normal IN() operator and restricts the returned 
rows to the ones matching the values in the set passed to the IN operator. 
Only
*/
SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR product_code IN (product_code_a AS 'A'));

SELECT *
FROM   unpivot_test
UNPIVOT (quantity FOR product_code IN (product_code_a AS 'A', product_code_c AS 'C'));

-- the INCLUDE NULLS clause will add rows containing a NULL values
-- to the result set
SELECT *
FROM   unpivot_test
UNPIVOT INCLUDE NULLS (quantity FOR 
        product_code IN (product_code_a AS 'A', -- the literal after 'AS' is the content of the new created column
                         product_code_b AS 'B', 
                         product_code_c AS 'C', 
                         product_code_d AS 'D')
                      );


-- tear down
drop table unpivot_test purge ;

/*
UNPIVOT multiple columns

http://stackoverflow.com/questions/10747355/oracle-11g-unpivot-multiple-columns-and-include-column-name
*/

-- set up
CREATE TABLE T5 (
  idnum NUMBER, 
  f1 NUMBER(10,5), f2 NUMBER(10,5), f3 NUMBER(10,5), 
  e1 NUMBER(10,5), e2 NUMBER(10,5), 
  h1 NUMBER(10,5), h2 NUMBER(10,5)
);

INSERT INTO T5 (IDNUM,F1,F2,F3,E1,E2,H1,H2) VALUES (1,null,5.009,7.330,9.008,8.003,.99383,1.43243);
INSERT INTO T5 (IDNUM,F1,F2,F3,E1,E2,H1,H2) VALUES (2,4.2004,6.009,9.330,4.7008,4.60333,1.993,3.3243);
INSERT INTO T5 (IDNUM,F1,F2,F3,E1,E2,H1,H2) VALUES (3,10.2040,52.6009,67.330,9.5008,8.003,.99383,1.43243);
INSERT INTO T5 (IDNUM,F1,F2,F3,E1,E2,H1,H2) VALUES (4,9.20704,45.009,17.330,29.008,5.003,3.9583,1.243);

COMMIT;

select * from t5;

/*
In this case the columns that have to be part of the same row need to be tupled.

All tuples need to be made by the same number of elements, so it may be necessary
to add fake ALIASED columns containing NULL values (see E3 and H3). 
Notice that when unpivoting tupled columns the uSE on INCLUDE NULL or EXCLUDE NULLS
won't affect the result because NULLs will be always included to fit the multiple 
columns structure of unpivoted tuple.
*/
select *
from (select IDNUM, F1, F2, F3, E1, E2, H1, H2, null as E3, null as H3
        from T5)
UnPivot ((F,E,H) for sk in ((F1,E1,H1) as 1,
                            (F2,E2,H2) as 2,
                            (F3,E3,H3) as 3))
order by IDNUM,SK;


-- tear down
drop table t5 purge;
