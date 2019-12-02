document

  =================================================================================
  OBJECTIVE: List the uses of variables, declare and initialize variables, use bind variables
  =================================================================================

  KEYWORDS: INITIALIZATION, DEFAULT

  A variable declaration always specifies
    - the name
    - the data type
    - a constraint (optional)
    - a initial value (optional)

  ***
  The data type can be both a PL/SQL data type or a any SQL data type. A data type is
  either scalar (without internal components) or composite (with internal components).
  ***

  INITIALIZATION
  To specify the initial value, use either the assignment operator (:=) or the
  keyword DEFAULT, followed by either a scalar value or an expression. The expression
  can include previously declared constants and previously initialized variables.

  Use DEFAULT for variables that have a typical value.

  Use the ASSIGNEMENT OPERATOR for variables (such as counters and accumulators)
  that have no typical value.

  ASSIGNEMENT OPERATOR and DEFAULT have the same effect on a variable declaration.


  Scalar Variable Declaration Syntax:

  variable  datatype [ NOT NULL ] [ [ DEFAULT | := ] expression ];

#
set echo on

DECLARE
  blood_type      CHAR DEFAULT 'O';    -- Same as blood_type CHAR := 'O';
  hours_worked    INTEGER DEFAULT 40;  -- Typical value
  employee_count  INTEGER := 0;        -- No typical value
BEGIN
  NULL;
END;
/

pause Press ENTER to continue

document

  KEYWORDS: NOT NULL, NATURALN, POSITIVEN, SIMPLE_INTEGER

  A declaration can impose the NOT NULL constraint, which prevents you from
  assigning a null value to the variable. Because variables are initialized
  to NULL by default, a declaration that specifies NOT NULL must also specify
  a default value.

  *** NOTICE ***
  PL/SQL subtypes NATURALN, POSITIVEN, and SIMPLE_INTEGER are predefined as
  NOT NULL. When declaring a variable of one of these subtypes, you can omit
  the NOT NULL constraint, and you must specify a default value (ndr, either
  using "DEFAULT value" or " := value ").

#

DECLARE
  acct_id INTEGER(4)       NOT NULL := 9999;
  a       NATURALN                  := 9999;
  b       POSITIVEN                 := 9999;
  c       SIMPLE_INTEGER            := 9999;
BEGIN
  NULL;
END;
/

pause Press ENTER to continue

DECLARE
-- The following declarations will raise the exception
-- PLS-00218: a variable declared NOT NULL must have an initialization assignment
  a       NATURALN;
BEGIN
  NULL;
END;
/

pause Press ENTER to continue

DECLARE
-- The following declarations will raise the exception
-- PLS-00218: a variable declared NOT NULL must have an initialization assignment
  b       POSITIVEN;
BEGIN
  NULL;
END;
/

pause Press ENTER to continue

DECLARE
-- The following declarations will raise the exception
-- PLS-00218: a variable declared NOT NULL must have an initialization assignment
  c       SIMPLE_INTEGER;
BEGIN
  NULL;
END;
/

pause Press ENTER to continue

document

  CONSTANTS
  ----------------------------
  In a constant declaration, the initial value is required.
  A constant can be initialized with NULL.

  Constant declaration syntax

  value  CONSTANT datatype  [ DEFAULT | := ] expression ];

#

declare
   c   CONSTANT  number;  --> PLS-00322: declaration of a constant 'C' must contain an initialization assignment
begin
  NULL;
end;
/

pause Press ENTER to continue

declare
-- But notice constants can default to NULL !!
   c1   CONSTANT  number :=      NULL;  -- Success!
   c2   CONSTANT  number DEFAULT NULL;  -- Success!
begin
  NULL;
end;
/

pause Press ENTER to continue

document

  Initial Values of Variables and Constants
  -----------------------------------------
  If the declaration is in a BLOCK or SUBPROGRAM, the initial value is
  assigned to the variable or constant every time control passes to the
  block or subprogram.

  If the declaration is in a PACKAGE SPECIFICATION,
  the initial value is assigned to the variable or constant for each
  session (whether the variable or constant is PUBLIC or PRIVATE).

#

pause Press ENTER to continue

document

  Assigning bind Variables

#

VARIABLE v_bind1 VARCHAR2(1000) ;
EXEC :v_bind1 := 'A bad assignament'; -- ERROR ! We're not in PL/SQL scope
print :v_bind1

pause Press ENTER to continue

VARIABLE v_bind1 VARCHAR2(1000) ;
 -- ERROR ! We're not in PL/SQL scope, so you'll be asked to type in a value for v_bind1
select 'yet another bad assignament' into :v_bind1 from dual;
print :v_bind1

pause Press ENTER to continue

VARIABLE v_bind1 VARCHAR2(1000) ;
begin
-- OK, we're in PL/SQL scope
  select 'a good assignament' into :v_bind1 from dual;
end;
/
-- bind variable with the leading colon
Print :v_bind1
-- bind variable without the leading colon
Print v_bind1
