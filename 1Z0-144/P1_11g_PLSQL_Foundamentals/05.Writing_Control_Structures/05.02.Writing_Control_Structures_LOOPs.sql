/*
BASIC LOOP
=======================

[ label ] LOOP
  statements
END LOOP [ label ];    --> the label here is can be omitted even if the labele before LOOP is used

In order to avoid an infinite loop an EXIT or raised exception must exit the loop.

EXIT
=======================
Transfer the control conditionally or unconditionally to the END of the current
loop or the end of a given labeled loop.

Syntax
EXIT [label] [WHEN expression] ;


LOOP
    ...
    IF x > 3 THEN
      EXIT;
    END IF;
    ...
END LOOP;


LOOP
    ...
    EXIT when x > 3;
    ...
END LOOP;


In Example 4-11, one basic LOOP statement is nested inside the other, and both 
have labels. The inner loop has two EXIT WHEN statements; one that exits the 
loop and one that exits the outer loop.
In case of referencing a non-existent label, an error will be raised
*/


set SERVEROUTPUT ON ;
DECLARE
  s  PLS_INTEGER := 0;
  i  PLS_INTEGER := 0;
  j  PLS_INTEGER;
BEGIN
  <<outer_loop>>
  LOOP
    i := i + 1;
    j := 0;
    <<inner_loop>>
    LOOP
      j := j + 1;
      s := s + i * j; -- Sum several products
      EXIT inner_loop WHEN (j > 5);
      EXIT outer_loop WHEN ((i * j) > 15);
    END LOOP inner_loop; --> the label here is NOT mandatory, it just improves readability
  END LOOP outer_loop; --> the label here is NOT mandatory, it just improves readability
  DBMS_OUTPUT.PUT_LINE
    ('The sum of products equals: ' || TO_CHAR(s));
END;
/


/*
CONTINUE statement

Syntax:

  CONTINUE [label] [WHEN condition]



*/


/*
FOR LOOP

[ label ] FOR index IN [ REVERSE ] lower_bound..upper_bound LOOP
  statements
END LOOP [ label ];

Without REVERSE, the value of index starts at lower_bound and increases by one 
with each iteration of the loop until it reaches upper_bound. If lower_bound is 
greater than upper_bound, then the statements never run.

With REVERSE, the value of index starts at upper_bound and decreases by one with 
each iteration of the loop until it reaches lower_bound. If upper_bound is less 
than lower_bound, then the statements never run.

An EXIT or CONTINUE in the statements can cause the loop or the current iteration
of the loop to end early.

In some languages, the FOR LOOP has a STEP clause that lets you specify a loop 
index increment other than 1. To simulate the STEP clause in PL/SQL, multiply 
each reference to the loop index by the desired increment.

*/

BEGIN
  DBMS_OUTPUT.PUT_LINE ('lower_bound < upper_bound');
 
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (i);
  END LOOP;
 
  DBMS_OUTPUT.PUT_LINE ('lower_bound = upper_bound');
 
  FOR i IN 2..2 LOOP
    DBMS_OUTPUT.PUT_LINE (i);
  END LOOP;
 
  DBMS_OUTPUT.PUT_LINE ('lower_bound > upper_bound');
 
  FOR i IN 3..1 LOOP
    DBMS_OUTPUT.PUT_LINE (i); --> NO ITERATION AT ALL
  END LOOP;
    
END;
/

-- Lower and upper bounds must be NOT NULL !!
BEGIN
  FOR i IN Null..1 LOOP
    DBMS_OUTPUT.PUT_LINE (i); --> Runtime ERROR: ORA-06502 PL/SQL: numeric or value error%s
  END LOOP;
  FOR i IN 1..null LOOP
    DBMS_OUTPUT.PUT_LINE (i); --> Runtime ERROR: ORA-06502 PL/SQL: numeric or value error%s
  END LOOP;
END;
/


BEGIN
  DBMS_OUTPUT.PUT_LINE ('upper_bound > lower_bound');
 
  FOR i IN REVERSE 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (i);
  END LOOP;
 
  DBMS_OUTPUT.PUT_LINE ('upper_bound = lower_bound');
 
  FOR i IN REVERSE 2..2 LOOP
    DBMS_OUTPUT.PUT_LINE (i);
  END LOOP;
 
  DBMS_OUTPUT.PUT_LINE ('upper_bound < lower_bound');
 
  FOR i IN REVERSE 3..1 LOOP
    DBMS_OUTPUT.PUT_LINE (i); --> NO ITERATION AT ALL
  END LOOP;
END;
/

-- Example 4-17 Simulating STEP Clause in FOR LOOP Statement

DECLARE
  step  PLS_INTEGER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (i*step);
  END LOOP;
END;
/

/*
FOR LOOP Index
-------------------
The index of a FOR LOOP statement is implicitly declared as a variable of 
type PLS_INTEGER that is local to the loop. The statements in the loop can read 
the value of the index, but cannot change it. Statements outside the loop cannot 
reference the index. After the FOR LOOP statement runs, the index is undefined. 
(A loop index is sometimes called a loop counter.)

*/
BEGIN
  FOR i IN 1..3 LOOP
    IF i < 3 THEN
      DBMS_OUTPUT.PUT_LINE (TO_CHAR(i));
    ELSE
      i := 2;
    END IF;
  END LOOP;
END;
/
 /*
 ERROR at line 6:
ORA-06550: line 6, column 8:
PLS-00363: expression 'I' cannot be used as an assignment target
*/
<<main>>  -- Label block.
DECLARE
  i NUMBER := 5;
BEGIN
  FOR i IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE (
      'local: ' || TO_CHAR(i) || ', global: ' ||
      TO_CHAR(main.i)  -- Qualify reference with block label.
    );
  END LOOP;
END main;
/

/* 
Result:

local: 1, global: 5
local: 2, global: 5
local: 3, global: 5


Lower Bound and Upper Bound
-------------------------------
The lower and upper bounds of a FOR LOOP statement can be either numeric literals, 
numeric variables, or numeric expressions. If a bound does not have a numeric value, 
then PL/SQL raises the predefined exception VALUE_ERROR.
*/

BEGIN
  FOR i IN 1..null LOOP --> Error !
    DBMS_OUTPUT.PUT_LINE ('hello');
  END LOOP;
END;
/

/*
WHILE LOOP Statement
============================
The WHILE LOOP statement runs one or more statements while a condition is true. 
It has this structure:

[ label ] WHILE condition LOOP
  statements
END LOOP [ label ];

If the condition is true, the statements run and control returns to the top of 
the loop, where condition is evaluated again. If the condition is not true, control 
transfers to the statement after the WHILE LOOP statement. 
To prevent an infinite loop, a statement inside the loop must make the condition 
FALSE or NULL. 
For complete syntax, see "WHILE LOOP Statement".

An EXIT, EXIT WHEN, CONTINUE, or CONTINUE WHEN in the statements can cause the 
loop or the current iteration of the loop to end early.


*/
DECLARE
  AA  BOOLEAN DEFAULT TRUE;
  BB  BOOLEAN DEFAULT TRUE;
BEGIN
  <<OUTER_LOOP>>
  WHILE AA LOOP
    WHILE BB LOOP
      AA := FALSE ;
      EXIT OUTER_LOOP ;
      DBMS_OUTPUT.PUT_LINE('HELLO');
      BB := FALSE ;
    END LOOP;
  END LOOP;
END;
/


/*
GOTO Statement
============================
The GOTO statement transfers control to a label unconditionally. The label must 
be unique in its scope and 

  *** MUST precede an executable statement or a PL/SQL block. ***
  
When run, the GOTO statement transfers control to the labeled statement or block. 

*/

DECLARE
  p  VARCHAR2(30);
  n  PLS_INTEGER := 37;
BEGIN
  FOR j in 2..ROUND(SQRT(n)) LOOP
    IF n MOD j = 0 THEN
      p := ' is not a prime number';
      GOTO print_now;
    END IF;
  END LOOP;

  p := ' is a prime number';
 
  <<print_now>>
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(n) || p);
END;
/
 
DECLARE
  done  BOOLEAN;
BEGIN
  FOR i IN 1..50 LOOP
    IF done THEN
       GOTO end_loop;
    END IF;
    <<end_loop>> -- ERROR: WRONG PLACEMENT ...
  END LOOP;
END;
/

DECLARE
  done  BOOLEAN;
BEGIN
  FOR i IN 1..50 LOOP
    IF done THEN
      GOTO end_loop;
    END IF;
    <<end_loop>>
    NULL;  --> ... add a NULL statement to avoid the error
  END LOOP;
END;
/

/*
Restrictions on GOTO Statement:

- A GOTO statement cannot transfer control into an IF statement, CASE statement, 
  LOOP statement, or sub-block.

- A GOTO statement cannot transfer control from one IF statement clause to another, 
  or from one CASE statement WHEN clause to another.

- A GOTO statement cannot transfer control out of a subprogram.

- A GOTO statement cannot transfer control into an exception handler.

- A GOTO statement cannot transfer control from an exception handler back into 
  the current block (but it can transfer control from an exception handler into 
  an enclosing block).
*/ 

BEGIN
  GOTO mylabel;
  
  IF true THEN
    <<mylabel>>  -- ERROR: cannot transfer control into an IF statement
    null;
  END IF;
END;
/

DECLARE
  bool  BOOLEAN ;
BEGIN
  GOTO mylabel;
  
  CASE bool
    WHEN TRUE THEN
      null;
    WHEN false THEN
      null;
    else
      <<mylabel>>  -- ERROR: cannot transfer control into a CASE statement
      null;
  END case;
END;
/ 

BEGIN
  GOTO mylabel;
  
  while false loop
    <<mylabel>>  -- ERROR: cannot transfer control inside a LOOP
    null;
  END loop;
END;
/

BEGIN
  GOTO mylabel;
  
  begin
    <<mylabel>>  -- ERROR: cannot transfer control to a sub-block
    null;
  END ;
END;
/

BEGIN
  if true then
    GOTO mylabel;
  end if ;
  if true then
    <<mylabel>>  -- ERROR: cannot transfer control froma IF statement to another
    null;
  END if;
END;
/

BEGIN
  if true then
    GOTO mylabel;
  else
    <<mylabel>>  -- ERROR: cannot transfer control from a IF statement to another
    null;
  end if ;
END;
/

BEGIN
  case true 
    when true then
      GOTO mylabel;
    else
      <<mylabel>>  -- ERROR: cannot transfer control from a CASE statement to another
       null ;
  end case ;
  
  case true 
    when true then
      null;
    else
      null;
  END case;
END;
/

declare
   procedure loc is
   begin
    GOTO mylabel;
   end;
BEGIN
  loc ;
  <<mylabel>>  -- ERROR: cannot transfer control out of a sub-program
  null;
END;
/

BEGIN
  GOTO mylabel;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    <<mylabel>>  -- ERROR: cannot transfer control into an exception handler
    NULL;
END;
/


BEGIN
  <<mylabel>>  -- ERROR: cannot transfer control from an exception handler back into the current block 
  NULL;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    GOTO mylabel;
END;
/

BEGIN
  NULL;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    GOTO mylabel;   -- SUCCESS it can transfer control within an exception handler block.
    begin
      null;
    end ;       
    <<mylabel>>
    begin
      null;
    end ;
END;
/

BEGIN
  BEGIN
    RAISE NO_DATA_FOUND;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      GOTO mylabel; -- SUCCESS: it can transfer control from an exception handler to an enclosing block.
  END;

  <<mylabel>>  
  begin
    null;
  end ;
END;
/



/*
NULL Statement
======================
The NULL statement only passes control to the next statement. Some languages 
refer to such an instruction as a no-op (no operation).

Some uses for the NULL statement are:

- To provide a target for a GOTO statement

- To improve readability by making the meaning and action of conditional statements 
  clear

- To create placeholders and stub subprograms

- To show that you are aware of a possibility, but that no action is necessary

*/