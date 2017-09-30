/*
Simple CASE Statement
The simple CASE statement has this structure:

CASE selector
WHEN selector_value_1 THEN statements_1
WHEN selector_value_2 THEN statements_2
...
WHEN selector_value_n THEN statements_n
[ ELSE
  else_statements ]
END CASE;]

The selector is an expression (typically a single variable). Each selector_value 
can be either a literal or an expression. 
(For complete syntax, see "CASE Statement".)

The simple CASE statement runs the first statements for which selector_value 
equals selector. Remaining conditions are not evaluated. If no selector_value 
equals selector, the CASE statement runs else_statements if they exist and 
raises the predefined exception CASE_NOT_FOUND otherwise.

Example 4-6 uses a simple CASE statement to compare a single value to many 
possible values. The CASE statement in Example 4-6 is logically equivalent to 
the IF THEN ELSIF statement in Example 4-5.


Example 4-6 Simple CASE Statement
*/
DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';

  CASE grade
    WHEN 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
    ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END CASE;
END;
/

/*
Searched CASE Statement
The searched CASE statement has this structure:

CASE
WHEN condition_1 THEN statements_1
WHEN condition_2 THEN statements_2
...
WHEN condition_n THEN statements_n
[ ELSE
  else_statements ]
END CASE;]

The searched CASE statement runs the first statements for which condition is true. 
Remaining conditions are not evaluated. If no condition is true, the CASE statement 
runs else_statements if they exist and raises the predefined exception CASE_NOT_FOUND 
otherwise. (For complete syntax, see "CASE Statement".)

The searched CASE statement in Example 4-7 is logically equivalent to the simple 
CASE statement in Example 4-6.

*/

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  
  CASE
    WHEN grade = 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN grade = 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN grade = 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN grade = 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN grade = 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
    ELSE DBMS_OUTPUT.PUT_LINE('No such grade');
  END CASE;
END;
/
 
-- Example 4-8 EXCEPTION Instead of ELSE Clause in CASE Statement

DECLARE
  grade CHAR(1);
BEGIN
  grade := 'B';
  
  CASE
    WHEN grade = 'A' THEN DBMS_OUTPUT.PUT_LINE('Excellent');
    WHEN grade = 'B' THEN DBMS_OUTPUT.PUT_LINE('Very Good');
    WHEN grade = 'C' THEN DBMS_OUTPUT.PUT_LINE('Good');
    WHEN grade = 'D' THEN DBMS_OUTPUT.PUT_LINE('Fair');
    WHEN grade = 'F' THEN DBMS_OUTPUT.PUT_LINE('Poor');
  END CASE;
EXCEPTION
  WHEN CASE_NOT_FOUND THEN --> specific EXCEPTION
    DBMS_OUTPUT.PUT_LINE('No such grade');
END;
/


