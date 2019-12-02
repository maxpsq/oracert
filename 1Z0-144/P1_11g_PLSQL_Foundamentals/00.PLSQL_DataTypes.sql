/*
BOOLEAN
A bolean type can be TRUE, FALSE or NULL

The logical operators AND, OR, and NOT follow the tri-state logic shown below.
AND and OR are binary operators; NOT is a unary operator.

x	  	y	     x AND y		x OR y
TRUE	TRUE	 TRUE		    TRUE

TRUE	FALSE	 FALSE		  TRUE

TRUE	NULL	 NULL	     *TRUE*

FALSE	TRUE	 FALSE		  TRUE

FALSE	FALSE	 FALSE		  FALSE

FALSE	NULL	*FALSE*		  NULL

NULL	TRUE	 NULL		   *TRUE*

NULL	FALSE	*FALSE*		  NULL

NULL	NULL	 NULL 		  NULL


**** NOTICE THIS ****

TRUE  AND NULL = NULL
FALSE AND NULL = FALSE

TRUE   OR NULL = TRUE
FALSE  OR NULL = NULL

**********************

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


/*

BINARY_FLOAT, BINARY_DOUBLE: these binary datatypes are not decimal in 
nature — they have binary precision — so you can expect rounding.
Supported by both SQL and PL/SQL.
Support NaN, positive and negative infinity.
They're fast cause arithmetics is performed in hardware whnever the underlying 
platform allows.

BINARY_INTEGER:
Not supported by SQL


PLS_INTEGER is an integer type with its arithmetic implemented in hardware.


SIMPLE_FLOAT, SIMPLE_DOUBLE, SIMPLE_INTEGER: 
Like BINARY_* but they don't allow NULL values nor they raise an exception on
overflow.
NOT SUPPORTED BY SQL, only by PL/SQL
They're very fast expecially with natively compiled code.

*/

create table test_plsql_types (
   c01      BINARY_FLOAT,
   c02      BINARY_DOUBLE
);

drop table test_plsql_types purge ;


set serveroutput on;
declare
   l_dec   NUMBER(5,2);
   
   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;
   
begin
   l_dec := 123.12 ;   --> OK
   print('A',l_dec);  
   l_dec := 123.129 ;  --> OK (rounding up to 123.13)
   print('B',l_dec);
   l_dec := 1234.12 ;  --> PL/SQL numeric or value error !!!
   print('C',l_dec);   
end;
/

set serveroutput on;
declare
   l_dec  NUMBER(3,5); -- 0.00001 to 0.00999  plus  -0.00999 to -0.0001  plus  0
   
   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;
   
begin
   l_dec := .001 ;     --> OK
   print('A',l_dec);  
   l_dec := .00999 ;   --> OK
   print('B',l_dec);  
   l_dec := 0 ;        --> OK
   print('C',l_dec);  
   l_dec := -.001 ;    --> OK
   print('D',l_dec);  
end;
/

set serveroutput on;
declare
   l_dec   NUMBER(3,-5); -- 99900000 to 0.00999
   
   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;
   
begin
   l_dec := 100000 ;     --> OK : mininum value
   print('A',l_dec);  
   l_dec := 99900000 ;   --> OK : maximum value
   print('B',l_dec);  
   l_dec := 0 ;        --> OK
   print('C',l_dec);  
   l_dec := -.001 ;    --> OK
   print('D',l_dec);  
end;
/

set serveroutput on;
declare
   l_int   NUMBER(3);  --> integer (no decimal part)
   
   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;
   
begin
   l_int := 123 ;      --> OK
   print('A',l_int);  
   l_int := 123.929 ;  --> OK (rounding up to 124)
   print('B',l_int);
   l_int := 1234.12 ;  --> PL/SQL numeric or value error !!!
   print('C',l_int);   
end;
/


DECLARE
  int1 PLS_INTEGER; int2 PLS_INTEGER; int3 PLS_INTEGER;
  nbr NUMBER; 
BEGIN
  int1 := 100;
  int2 := 49;
  int3 := int2/int1;
  nbr := int2/int1;
  DBMS_OUTPUT.PUT_LINE('integer 49/100 =' || TO_CHAR(int3) || ' --> 100/49=.49=0 (round down)'); 
  DBMS_OUTPUT.PUT_LINE('number 49/100 =' || TO_CHAR(nbr)); 
  int2 := 50;
  int3 := int2/int1;
  nbr := int2/int1;
  DBMS_OUTPUT.PUT_LINE('integer 50/100 =' || TO_CHAR(int3) || ' --> 100/50=.5=1 (round up)'); 
  DBMS_OUTPUT.PUT_LINE('number 50/100 =' || TO_CHAR(nbr));
END;
/



declare
  l_bf   binary_float ;
  l_bd   binary_double ;
  procedure print(msg varchar2, v binary_float) is
  begin
    dbms_output.put_line(msg||': '||v);
  end ;   
  
begin
  l_bf := BINARY_FLOAT_NAN ;
  l_bf := BINARY_FLOAT_INFINITY ;
  l_bf := -BINARY_FLOAT_INFINITY ;
  l_bf := BINARY_FLOAT_MIN_NORMAL ;
  l_bf := BINARY_FLOAT_MAX_NORMAL ;
  l_bf := BINARY_FLOAT_MIN_SUBNORMAL ;
  l_bf := BINARY_FLOAT_MAX_SUBNORMAL ;
  
  l_bd := BINARY_DOUBLE_NAN ;
  l_bd := BINARY_DOUBLE_INFINITY ;
  l_bd := -BINARY_DOUBLE_INFINITY ;
  l_bd := BINARY_DOUBLE_MIN_NORMAL ;
  l_bd := BINARY_DOUBLE_MAX_NORMAL ;
  l_bd := BINARY_DOUBLE_MIN_SUBNORMAL ;
  l_bd := BINARY_DOUBLE_MAX_SUBNORMAL ;
  
  -- Not a Number (NaN) literals
  l_bf := 'NaN';  
  print('Not a Nuber', l_bf);
  l_bf := 'Nan';  
  print('Not a Nuber', l_bf);
  l_bf := 'NAN';  
  print('Not a Nuber', l_bf);
  l_bf := 'nan';  
  print('Not a Nuber', l_bf);
  l_bf := 'naN';  
  print('Not a Nuber', l_bf);
  l_bf := '-naN';  
  print('Not a Nuber', l_bf);

  l_bf := nanvl(l_bf, 999);
  print('nanvl(Nan,999)', l_bf);

  -- Infinity
  l_bf := 'Inf';  
  print('Infinity', l_bf);
  l_bf := 'INF';  
  print('Infinity', l_bf);
  l_bf := 'Infinity';  
  print('Infinity', l_bf);
  
  l_bf := '-Inf';  
  print('-Infinity', l_bf);
  l_bf := '-INF';  
  print('-Infinity', l_bf);
  l_bf := '-Infinity';  
  print('-Infinity', l_bf);
  
  
  l_bf := 999999999999999999999999999999999/0.0000000000000000000000000000001 ;
  print('Infinity', l_bf);
  l_bf := -999999999999999999999999999999999/0.0000000000000000000000000000001 ;
  print('-Infinity', l_bf);
  l_bf := 'NaN';
  print('Not a Nuber', l_bf);
end;
/

/*
INFINITY an NOT-a-number operators for BINARY_FLOAT and BINARY_DOUBLE types

Notice
** BINARY_INTEGER DON'T SUPPERT INFINITY and NAN **
*/
declare
   l_bf  binary_double ;
begin
   l_bf := 'Infinity';
   if ( l_bf IS INFINITE ) then
     dbms_output.put_line(q'!It's infinite!');
   else
     dbms_output.put_line(q'!It's NOT infinite!');
   end if ;
   l_bf := 'Nan';
   if ( l_bf IS nan ) then
     dbms_output.put_line(q'!It's NaN!');
   else
     dbms_output.put_line(q'!It's NOT Nan!');
   end if ;
exception
   when others then
      raise;
end;
/
/*==============================================================================
-- String comparison
--==============================================================================
-- KEYWORDS: String comparison, CHAR, VARCHAR2

*/
set serveroutput on;

/*==============================================================================
-- Strings 
--==============================================================================
*/

declare
   l_char1       char(34) := 'ab';  --> right padding up to 34 chars
   l_char2       char(12) := '  ab'; --> right padding up to 12 chars
   l_varchar21   varchar2(12) := 'ab   '; --> no padding nor trimming

   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;   
  
begin
   print('l_char1 size',length(l_char1));
   print('l_char2 size',length(l_char2));
   print('l_varchar21 size',length(l_varchar21));
exception
   when others then
      raise;
end;
/

declare
   l_char1      char(35)     := 'Hello';
   l_char2      char(30)     := 'Hello  ';
   l_varchar21  varchar2(35) := 'Hello';
   l_varchar22  varchar2(35) := 'Hello  ';
begin
   /*
   When a comparison is made between variables of type CHAR, a blank-padding 
   comparison takes place.
   That means that variables of type CHAR are right padded to the size of the 
   longest variable definition.
   Notice that variables are not actually padded but the comparison is made
   against copies of the actual variables.
   */
   if ( l_char1 = l_char2) then
      dbms_output.put_line('First comparison is TRUE');
   else
      dbms_output.put_line('First comparison is FALSE');
   end if;
   
   /* 
   When at least one of the involved variables is a VARCHAR2, then a
   non-blank-padding comparison talse place.
   None of the variables involved in the comparison is then modified.
   */
   if ( l_char1 = l_varchar21) then
      dbms_output.put_line('Second comparison is TRUE');
   else
      dbms_output.put_line('Second comparison is FALSE');
   end if;

   if ( l_varchar21 = l_varchar22) then
      dbms_output.put_line('Third comparison is TRUE');
   else
      dbms_output.put_line('Third comparison is FALSE');
   end if;
   
   /* String literals are treated as CHAR values, so blank-padding
      comparison takes place when no VARCHAR2 is involved. */
   if ( 'Hello' = 'Hello ') then
      dbms_output.put_line('Fourth comparison is TRUE');
   else
      dbms_output.put_line('Fourth comparison is FALSE');
   end if;

   /* String literals are treated as CHAR values, tough non-blank-padding
      comparison takes place when a VARCHAR2 datatype is involved. */
   if ( l_varchar21 = 'Hello     ') then
      dbms_output.put_line('Fifth comparison is TRUE');
   else
      dbms_output.put_line('Fifth comparison is FALSE');
   end if;
end;
/

/*
                     *** ERRATA ***
When a character function returns a character value, that value is always of 
type VARCHAR2 (variable length), with the exceptions of UPPER and LOWER 
                     *** ERRATA ***
See function signature in package STANDARD (query DBA_SOURCE)                     
*/
set serveroutput on;
declare
   l_char1   char(40) := 'hELlo';
   l_vrch1   varchar2(40) := 'hELlo';
begin
   if ( 'hello       ' = LOWER(l_char1) ) then
      dbms_output.put_line('LOWER returns a CHAR');
   else
      dbms_output.put_line('LOWER does not return a CHAR');
   end if;
   if ( 'HELLO       ' = UPPER(l_char1) ) then
      dbms_output.put_line('UPPER returns a CHAR');
   else
      dbms_output.put_line('UPPER does not return a CHAR');
   end if;
   if ( 'Hello       ' = INITCAP(l_char1) ) then
      dbms_output.put_line('INITCAP returns a CHAR');
   else
      dbms_output.put_line('INITCAP does not return a CHAR');
   end if;
exception
   when others then
      raise;
end;
/


--==============================================================================
--
--==============================================================================
DECLARE
   tiny_nbr NUMBER := 1e-130;
   test_nbr NUMBER;
   --
   --
   big_nbr          number := 9.999999999999999999999999999999999999999e125;
   --
   --
   fmt_nbr VARCHAR2(50) := '9.99999999999999999999999999999999999999999EEEE';
BEGIN
   DBMS_OUTPUT.PUT_LINE('tiny_nbr =' || TO_CHAR(tiny_nbr, '9.9999EEEE')); -- NUMBERs that are too small round down to zero
   test_nbr := tiny_nbr / 1.0001;
   DBMS_OUTPUT.PUT_LINE('tiny made smaller =' || TO_CHAR(test_nbr, fmt_nbr));
   -- NUMBERs that are too large throw an error
   DBMS_OUTPUT.PUT_LINE('big_nbr =' || TO_CHAR(big_nbr, fmt_nbr)); test_nbr := big_nbr * 1.0001; -- too big
   DBMS_OUTPUT.PUT_LINE('big made bigger =' || TO_CHAR(test_nbr, fmt_nbr));
END;
/

/*==============================================================================
-- The V format element
--==============================================================================
align the decimal separator to the V format element and then removes the decimal 
separator (example assing integer 123)

suppose localization = AMERICA

              999G9V99
                123.00
               12,3.00
               12,300   
*/
DECLARE
  shares_sold NUMBER := 123;
BEGIN 
  DBMS_OUTPUT.PUT_LINE( TO_CHAR(shares_sold,'999G9V99') );
END;
/


/*==============================================================================

--==============================================================================


*/
set serveroutput on;

create or replace procedure aa as
  dts1    INTERVAL year TO month := '2-2'; 
  dts2    INTERVAL year TO month; 
  ratio   number;
BEGIN
  dts2 := dts1 * 2 ; 
  ratio := dts2 / dts1 ;
END;
/


set serveroutput on;
DECLARE
  dts1    INTERVAL DAY TO SECOND := '2 3:4:5.6'; 
  dts2    INTERVAL DAY TO SECOND; 
  ratio   number;
BEGIN
  dts2 := dts1 * 2 ; 
  ratio := dts2 / dts1 ;
END;
/

