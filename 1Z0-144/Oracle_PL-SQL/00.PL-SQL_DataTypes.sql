/*
BOOLEAN
A bolean type can be TRUE, FALSE or NULL

The logical operators AND, OR, and NOT follow the tri-state logic shown below.
AND and OR are binary operators; NOT is a unary operator.

x		y		x AND y		x OR y
TRUE	TRUE	 TRUE		 TRUE

TRUE	FALSE	 FALSE		 TRUE

TRUE	NULL	 NULL		*TRUE*

FALSE	TRUE	 FALSE		 TRUE

FALSE	FALSE	 FALSE		 FALSE

FALSE	NULL	*FALSE*		 NULL

NULL	TRUE	 NULL		*TRUE*

NULL	FALSE	*FALSE*		 NULL

NULL	NULL	 NULL		 NULL


NOT x
TRUE  -> FALSE
FALSE -> TRUE
NULL  -> NULL

*/

create or replace
PROCEDURE print_boolean (
  b_name   VARCHAR2,
  b_value  BOOLEAN
) IS
BEGIN
  IF b_value IS NULL THEN
    DBMS_OUTPUT.PUT_LINE (b_name || ' = NULL');
  ELSIF b_value = TRUE THEN
    DBMS_OUTPUT.PUT_LINE (b_name || ' = TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE (b_name || ' = FALSE');
  END IF;
END;
/


declare
  t  boolean := TRUE ;
  f  t%type  := FALSE ;
  n  t%type  := NULL ;
BEGIN
   print_boolean('TRUE' ,t);
   print_boolean('FALSE',f);
   print_boolean('NULL' ,n);
   print_boolean('TRUE AND NULL'  ,t AND n);
   print_boolean('FALSE AND NULL' ,f AND n);
   print_boolean('TRUE OR NULL'   ,t OR n);
   print_boolean('FALSE OR NULL'  ,f OR n);
end;
/


/*
NULL values and comparison operators
--------------------------------------
you might expect the sequence of statements to run because x and y seem unequal.
But, NULL values are indeterminate. Whether x equals y is unknown. Therefore, 
arithmetic comparison operators yield NULL.
*/

declare
  i  INTEGER := 5 ;
  n  i%type  := NULL ;
begin
  print_boolean(''||i||'  = NULL' , i  = n);
  print_boolean(''||i||' ^= NULL' , i ^= n);
  print_boolean(''||i||'  > NULL' , i  > n);
  print_boolean(''||i||'  < NULL' , i  < n);
  print_boolean(''||i||' >= NULL' , i >= n);
  print_boolean(''||i||' <= NULL' , i <= n);
  print_boolean(''||i||' IN NULL' , i in(n));
  print_boolean(''||i||' !IN NULL' , i not in(n));
end ;
/

/*
Short-Circuit Evaluation
-------------------------
When evaluating a logical expression, PL/SQL uses short-circuit evaluation. 
That is, PL/SQL stops evaluating the expression as soon as it can determine 
the result. Therefore, you can write expressions that might otherwise cause 
errors.
*/
DECLARE
  on_hand  INTEGER := 0;
  on_order INTEGER := 100;
BEGIN
  -- Does not cause divide-by-zero error;
  -- evaluation stops after first expression
  
  IF (on_hand = 0) OR ((on_order / on_hand) < 5) THEN
    DBMS_OUTPUT.PUT_LINE('On hand quantity is zero.');
  END IF;
END;
/

/*
Comparison Operators
-------------------------
Comparison operators compare one expression to another. The result is always 
either TRUE, FALSE, or NULL. If the value of one expression is NULL, then the 
result of the comparison is also NULL.

IS [NOT] NULL Operator
Relational    Operators
LIKE          Operator
BETWEEN       Operator
IN            Operator

NOTE
Character comparisons are affected by NLS parameter settings, which can change 
at runtime. Therefore, character comparisons are evaluated at runtime, and the 
same character comparison can have different values at different times. 
For information about NLS parameters that affect character comparisons, see 
Oracle Database Globalization Support Guide.

Note:
Using CLOB values with comparison operators can create temporary LOB values. 
Ensure that your temporary tablespace is large enough to handle them.


"not equal to" operators are:   <>, !=, ~=, ^=

Character Comparisons
---------------------
By default, one character is greater than another if its binary value is larger. 
For example, this expression is true:

'y' > 'r'
Strings are compared character by character. For example, this expression is true:

'Kathy' > 'Kathryn'

If you set the initialization parameter NLS_COMP=ANSI, string comparisons use 
the collating sequence identified by the NLS_SORT initialization parameter.

A collating sequence is an internal ordering of the character set in which a 
range of numeric codes represents the individual characters. One character 
value is greater than another if its internal numeric value is larger. 
Each language might have different rules about where such characters occur 
in the collating sequence. For example, an accented letter might be sorted 
differently depending on the database character set, even though the binary 
value is the same in each case.

By changing the value of the NLS_SORT parameter, you can perform comparisons 
that are case-insensitive and accent-insensitive.

A case-insensitive comparison treats corresponding uppercase and lowercase 
letters as the same letter. For example, these expressions are true:

'a' = 'A'
'Alpha' = 'ALPHA'
To make comparisons case-insensitive, append _CI to the value of the NLS_SORT 
parameter (for example, BINARY_CI or XGERMAN_CI).

*/

/*
-------------------------------------------------------------------------------
SIMPLE_INTEGER Datatype

https://oracle-base.com/articles/11g/plsql-new-features-and-enhancements-11gr1#simple_integer
-------------------------------------------------------------------------------
The SIMPLE_INTEGER datatype is a subtype of the PLS_INTEGER datatype and can 
dramatically increase the speed of integer arithmetic in natively compiled code, 
but only shows marginal performance improvements in interpreted code. 
The following procedure compares the performance of the SIMPLE_INTEGER 
and PLS_INTEGER datatypes.
*/
CREATE OR REPLACE PROCEDURE simple_integer_test_proc AS
  l_start               NUMBER;
  l_loops               NUMBER := 10000000;
  l_pls_integer         PLS_INTEGER := 0;
  l_pls_integer_incr    PLS_INTEGER := 1;
  l_simple_integer      SIMPLE_INTEGER := 0;
  l_simple_integer_incr SIMPLE_INTEGER := 1;
BEGIN

  l_start := DBMS_UTILITY.get_time;

  FOR i IN 1 .. l_loops LOOP
    l_pls_integer := l_pls_integer + l_pls_integer_incr;
  END LOOP;

  DBMS_OUTPUT.put_line('PLS_INTEGER: ' || (DBMS_UTILITY.get_time - l_start) || ' hsecs');

  l_start := DBMS_UTILITY.get_time;

  FOR i IN 1 .. l_loops LOOP
    l_simple_integer := l_simple_integer + l_simple_integer_incr;
  END LOOP;

  DBMS_OUTPUT.put_line('SIMPLE_INTEGER: ' || (DBMS_UTILITY.get_time - l_start) || ' hsecs');


END simple_integer_test_proc;
/

/*
When run in the default interpreted mode the performance improvement of the 
SIMPLE_INTEGER datatype is not spectacular.
*/
SET SERVEROUTPUT ON ;
EXEC simple_integer_test_proc;
/*
PLS_INTEGER: 43 hsecs
SIMPLE_INTEGER: 31 hsecs

PL/SQL procedure successfully completed.

SQL>

We natively compile the procedure by altering the PLSQL_CODE_TYPE value for 
the session and recompiling the procedure.
*/
ALTER SESSION SET PLSQL_CODE_TYPE=NATIVE;
ALTER PROCEDURE simple_integer_test_proc COMPILE;
/*
Natively compiling the procedure produces dramatic speed improvements for both 
datatypes, but more so for the SIMPLE_INTEGER datatype.
*/
SET SERVEROUTPUT ON ;
EXEC simple_integer_test_proc;
/*
PLS_INTEGER: 10 hsecs
SIMPLE_INTEGER: 2 hsecs

PL/SQL procedure successfully completed.

SQL>

The speed improvements are a result of two fundamental differences between the 
two datatypes. First, SIMPLE_INTEGER and PLS_INTEGER have 
the same range (-2,147,483,648 through 2,147,483,647), but SIMPLE_INTEGER wraps 
round when it exceeds its bounds, rather than throwing an error like PLS_INTEGER.

SET SERVEROUTPUT ON
DECLARE
  l_simple_integer SIMPLE_INTEGER := 2147483645;
BEGIN
  FOR i IN 1 .. 4 LOOP
    l_simple_integer := l_simple_integer + 1;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(l_simple_integer, 'S9999999999'));
  END LOOP;

  FOR i IN 1 .. 4 LOOP
    l_simple_integer := l_simple_integer - 1;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(l_simple_integer, 'S9999999999'));
  END LOOP;
END;
/
+2147483646
+2147483647
-2147483648
-2147483647
-2147483648
+2147483647
+2147483646
+2147483645

PL/SQL procedure successfully completed.

SQL>

Second, SIMPLE_INTEGER can never have a NULL value, either when it is declared, 
or by assignment.

DECLARE
  l_simple_integer SIMPLE_INTEGER;
BEGIN
  NULL;
END;
/
                   *
ERROR at line 2:
ORA-06550: line 2, column 20:
PLS-00218: a variable declared NOT NULL must have an initialization assignment

SQL>

DECLARE
  l_simple_integer SIMPLE_INTEGER := 0;
BEGIN
  l_simple_integer := NULL;
END;
/
                      *
ERROR at line 4:
ORA-06550: line 4, column 23:
PLS-00382: expression is of wrong type
ORA-06550: line 4, column 3:
PL/SQL: Statement ignored

SQL>

The removal of overflow and NULL checking result in a significant reduction in 
overhead compared to PLS_INTEGER.
*/


