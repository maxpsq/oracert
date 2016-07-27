/*
Conditional selection statements
--------------------------------
 which run different statements for different data values.
 The conditional selection statements are IF and and CASE.

Loop statements
--------------------------------
 which run the same statements with a series of different data values.
 The loop statements are the basic LOOP, FOR LOOP, and WHILE LOOP.
 The EXIT statement transfers control to the end of a loop. 
 The CONTINUE statement exits the current iteration of a loop and 
 transfers control to the next iteration. Both EXIT and CONTINUE have 
 an optional WHEN clause, where you can specify a condition.

Sequential control statements
--------------------------------
 which are not crucial to PL/SQL programming.
 The sequential control statements are GOTO, which goes to a specified 
  statement, and NULL, which does nothing.



CASE Expressions
=================================
Topics

- Simple CASE Expression
- Searched CASE Expression

Simple CASE Expression
-----------------------
For this explanation, assume that a simple CASE expression has this syntax:

CASE selector
	WHEN selector_value_1 THEN result_1
	WHEN selector_value_2 THEN result_2
	...
	WHEN selector_value_n THEN result_n
	[ ELSE
  		else_result ]
END

The selector is an expression (typically a single variable). Each selector_value 
and each result can be either a literal or an expression. 
** At least one result must not be the literal NULL **

The simple CASE expression returns the first result for which selector_value 
matches selector. Remaining expressions are not evaluated. If no selector_value 
matches selector, the CASE expression returns else_result if it exists 
and NULL otherwise.

*/
set serveroutput on ;
DECLARE
  grade CHAR(1) := 'B';
  appraisal VARCHAR2(20);
BEGIN
  appraisal :=
    CASE grade
      WHEN 'A' THEN 'Excellent'
      WHEN 'B' THEN 'Very Good'
      WHEN 'C' THEN 'Good'
      WHEN 'D' THEN 'Fair'
      WHEN 'F' THEN 'Poor'
      ELSE 'No such grade'
    END;
    DBMS_OUTPUT.PUT_LINE ('Grade ' || grade || ' is ' || appraisal);
END;
/
/*
If selector has the value NULL, it cannot be matched by WHEN NULL, 
use a "SEARCHED CASE expression" with WHEN boolean_expression IS NULL 
*/
DECLARE
  grade CHAR(1); -- NULL by default
  appraisal VARCHAR2(20);
BEGIN
  appraisal :=
  CASE grade
    WHEN NULL THEN 'No grade assigned'  --> ** NOT MATCHING **
    WHEN 'A' THEN 'Excellent'
    WHEN 'B' THEN 'Very Good'
    WHEN 'C' THEN 'Good'
    WHEN 'D' THEN 'Fair'
    WHEN 'F' THEN 'Poor'
    ELSE 'No such grade'  --> ** MATCHED **
  END;
  DBMS_OUTPUT.PUT_LINE ('Grade ' || grade || ' is ' || appraisal);
END;
/

/*
Searched CASE Expression
----------------------------
For this explanation, assume that a searched CASE expression has this syntax:

CASE
  WHEN boolean_expression_1 THEN result_1
  WHEN boolean_expression_2 THEN result_2
  ...
  WHEN boolean_expression_n THEN result_n
  [ ELSE
    else_result ]
  END]

The searched CASE expression returns the first result for which 
boolean_expression is TRUE. Remaining expressions are not evaluated. 
If no boolean_expression is TRUE, the CASE expression returns else_result 
if it exists and NULL otherwise.
*/

DECLARE
  grade      CHAR(1) := 'B';
  appraisal  VARCHAR2(120);
  id         NUMBER  := 8429862;
  attendance NUMBER := 150;
  min_days   CONSTANT NUMBER := 200;
  
  FUNCTION attends_this_school (id NUMBER)
    RETURN BOOLEAN IS
  BEGIN
    RETURN TRUE;
  END;
BEGIN
  appraisal :=
  CASE
    WHEN attends_this_school(id) = FALSE
      THEN 'Student not enrolled'
    WHEN grade = 'F' OR attendance < min_days
      THEN 'Poor (poor performance or bad attendance)'
    WHEN grade = 'A' THEN 'Excellent'
    WHEN grade = 'B' THEN 'Very Good'
    WHEN grade = 'C' THEN 'Good'
    WHEN grade = 'D' THEN 'Fair'
    ELSE 'No such grade'
  END;
  DBMS_OUTPUT.PUT_LINE
    ('Result for student ' || id || ' is ' || appraisal);
END;
/

DECLARE
  grade CHAR(1); -- NULL by default
  appraisal VARCHAR2(20);
BEGIN
  appraisal :=
    CASE
      WHEN grade IS NULL THEN 'No grade assigned'  --> ** MATCHED **
      WHEN grade = 'A' THEN 'Excellent'
      WHEN grade = 'B' THEN 'Very Good'
      WHEN grade = 'C' THEN 'Good'
      WHEN grade = 'D' THEN 'Fair'
      WHEN grade = 'F' THEN 'Poor'
      ELSE 'No such grade'
    END;
    DBMS_OUTPUT.PUT_LINE ('Grade ' || grade || ' is ' || appraisal);
END;
/
