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



