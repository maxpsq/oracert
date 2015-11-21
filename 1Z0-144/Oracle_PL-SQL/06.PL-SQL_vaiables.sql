
/*
=================================================================================
OBJECTIVE: Recognize valid and invalid identifiers
=================================================================================
Valid variable names are bound to the same rules as database objects
They must 
  - begin with a letter 
  - contain a letters, digits or the symbols $ _ #
  - not exceed 30 characters in length

A valid PL/SQL variable can be validated against the following regular expression

^[A-Za-z][A-Za-z0-9$#_]{,29}$


=================================================================================
OBJECTIVE: Declaring PL/SQL Variables
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
keyword DEFAULT, followed by an expression. The expression can include previously 
declared constants and previously initialized variables.

Use DEFAULT for variables that have a typical value.

Use the ASSIGNEMENT OPERATOR for variables (such as counters and accumulators) 
that have no typical value.

ASSIGNEMENT OPERATOR and DEFAULT have the same effect on a variable declaration.


Scalar Variable Declaration Syntax:

variable  datatype [ NOT NULL ] [ [ DEFAULT | := ] expression ];

*/

DECLARE
  blood_type      CHAR DEFAULT 'O';    -- Same as blood_type CHAR := 'O';
  hours_worked    INTEGER DEFAULT 40;  -- Typical value
  employee_count  INTEGER := 0;        -- No typical value
BEGIN
  NULL;
END;
/


/*
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


*/
DECLARE
  acct_id INTEGER(4)       NOT NULL := 9999;
  a       NATURALN                  := 9999;
  b       POSITIVEN                 := 9999;
  c       SIMPLE_INTEGER            := 9999;
BEGIN
  NULL;
END;
/

DECLARE
-- The following declarations will raise the exception
-- PLS-00218: a variable declared NOT NULL must have an initialization assignment  
  a       NATURALN                  ; 
  b       POSITIVEN                 ;
  c       SIMPLE_INTEGER            ;
BEGIN
  NULL;
END;
/

/*
CONSTANTS
----------------------------
In a constant declaration, the initial value is required. 
A constant can be initialized with NULL.

Constant declaration syntax

value  CONSTANT datatype  [ DEFAULT | := ] expression ];
*/
declare
   c   CONSTANT  number;  --> PLS-00322: declaration of a constant 'C' must contain an initialization assignment
begin
  NULL;
end;
/

declare
-- But notice this !!
   c1   CONSTANT  number :=      NULL;  -- Success!
   c2   CONSTANT  number DEFAULT NULL;  -- Success!
begin
  NULL;
end;
/

/*
Initial Values of Variables and Constants
-----------------------------------------
If the declaration is in a BLOCK or SUBPROGRAM, the initial value is 
assigned to the variable or constant every time control passes to the 
block or subprogram. 

If the declaration is in a PACKAGE SPECIFICATION, 
the initial value is assigned to the variable or constant for each 
session (whether the variable or constant is PUBLIC or PRIVATE).

*/

/*
Using the %TYPE Attribute
----------------------------
The %TYPE attribute lets you declare a 
  - constant
  - variable
  - field
  - parameter 
to be of the same data type a previously declared 
  - variable
  - field
  - record
  - nested table
  - database column

If the referenced item changes, your declaration is automatically updated. 
You need not change your code when, for example, the length of a VARCHAR2 
column increases.

The referencing item inherits the following from the referenced item:
 - data type and size
 - constraints (unless the referenced item is a column)

The referencing item does not inherit the initial value of the referenced 
item. Therefore, if the referencing item specifies or inherits the NOT NULL 
constraint, you must specify an initial value for it.

*** NOT TRUE ***
The referencing item INHERITS THE DEFAULT VALUE only if the referencing item 
is not a database column and does not have the NOT NULL constraint.
***

In Example 2-10, the variable debit inherits the data type of the variable credit. 
The variables upper_name, lower_name, and init_name inherit the data type and default 
value of the variable name.
*/

DECLARE
  credit  PLS_INTEGER RANGE 1000..25000;
  debit   credit%TYPE;  -- inherits data type

  name1        VARCHAR2(20) := 'JoHn SmItH';
  upper_name1  name1%TYPE;  -- inherits data type and default value
  lower_name1  name1%TYPE;  -- inherits data type and default value
  init_name1   name1%TYPE;  -- inherits data type and default value
BEGIN
  DBMS_OUTPUT.PUT_LINE ('name:       ' || name1);
  DBMS_OUTPUT.PUT_LINE ('upper_name: ' || UPPER(upper_name1));
  DBMS_OUTPUT.PUT_LINE ('lower_name: ' || LOWER(lower_name1));
  DBMS_OUTPUT.PUT_LINE ('init_name:  ' || INITCAP(init_name1));
END;
/

DECLARE
  name1        VARCHAR2(20) NOT NULL := 'JoHn SmItH';
  
  -- inherits data type and constraint, therefore it will raise an error
  -- because of the NOT NULL constraint
  upper_name1  name1%TYPE;  
BEGIN
  DBMS_OUTPUT.PUT_LINE ('name:       ' || name1);
  DBMS_OUTPUT.PUT_LINE ('upper_name: ' || UPPER(upper_name1));
END;
/

/*
References to Identifiers
----------------------------------
When referencing an identifier, you use a name that is 
either simple, qualified, remote, or both qualified and remote.

The simple name of an identifier is the name in its declaration. For example:

DECLARE
  a INTEGER;  -- Declaration
BEGIN
  a := 1;     -- Reference with simple name
END;
/

If an identifier is declared in a named PL/SQL unit, you can (and sometimes 
must) reference it with its qualified name. The syntax (called dot notation) is:

unit_name.simple_identifier_name

If the identifier names an object on a remote database, you must reference it 
with its remote name. The syntax is:

simple_identifier_name@link_to_remote_database

You can create synonyms for remote schema objects, but you CANNOT create synonyms 
for objects declared in PL/SQL subprograms or packages

** NOTE **
You can reference identifiers declared in the packages STANDARD and DBMS_STANDARD 
without qualifying them with the package names, UNLESS you have declared a local 
identifier with the same name.


Scope and Visibility of Identifiers
-------------------------------------
The scope of an identifier is the region of a PL/SQL unit from which you can 
reference the identifier. The visibility of an identifier is the region of a PL/SQL 
unit from which you can reference the identifier without qualifying it. An identifier 
is LOCAL to the PL/SQL unit that declares it. If that unit has subunits, the identifier 
is GLOBAL to them.

If a subunit redeclares a global identifier, then inside the subunit, both identifiers 
are in scope, but only the local identifier is visible.

***
To reference the global identifier, the subunit must qualify it with the name of the 
unit that declared it. If that unit has no name, then the subunit cannot reference 
the global identifier.
***

A PL/SQL unit cannot reference identifiers declared in other units at the same level, 
because those identifiers are neither local nor global to the block.

You cannot declare the same identifier twice in the same PL/SQL unit. If you do, an 
error occurs when you reference the duplicate identifier.

*/

<<outer>>  -- label
DECLARE
  birthdate DATE := '09-AUG-70';
BEGIN
  DECLARE
    birthdate DATE := '29-SEP-70';
  BEGIN
    IF birthdate = outer.birthdate THEN    --> NOTICE this...
      DBMS_OUTPUT.PUT_LINE ('Same Birthday');
    ELSE
      DBMS_OUTPUT.PUT_LINE ('Different Birthday');
    END IF;
  END;
END;
/


CREATE OR REPLACE PROCEDURE check_credit (credit_limit NUMBER) AS
  rating NUMBER := 3;
  
  FUNCTION check_rating RETURN BOOLEAN IS
    rating  NUMBER := 1;
    over_limit  BOOLEAN;
  BEGIN
    IF check_credit.rating <= credit_limit THEN  -- reference global variable
      over_limit := FALSE;
    ELSE
      over_limit := TRUE;
      rating := credit_limit;                    -- reference local variable
    END IF;
    RETURN over_limit;
  END check_rating;
BEGIN
  IF check_rating THEN
    DBMS_OUTPUT.PUT_LINE
      ('Credit rating over limit (' || TO_CHAR(credit_limit) || ').  '
      || 'Rating: ' || TO_CHAR(rating));
  ELSE
    DBMS_OUTPUT.PUT_LINE
      ('Credit rating OK.  ' || 'Rating: ' || TO_CHAR(rating));
  END IF;
END;
/


<<echo>>
DECLARE
  x  NUMBER := 5;
  
  PROCEDURE echo AS
    x  NUMBER := 0;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('x = ' || x);
 -- echo.x refers to the local variable x, not to the global variable x
    DBMS_OUTPUT.PUT_LINE('echo.x = ' || echo.x); 
  END;
 
BEGIN
  echo;
END;
/
/* output:
x = 0
echo.x = 0
*/



<<compute_ratio>>
<<another_label>>
DECLARE
  numerator   NUMBER := 22;
  denominator NUMBER := 7;
BEGIN
  <<another_label>>
  DECLARE
    denominator NUMBER := 0;
  BEGIN
  -- compute_ratio.denominator refers to the global variable (7)
    DBMS_OUTPUT.PUT_LINE('Ratio with compute_ratio.denominator = ');
    DBMS_OUTPUT.PUT_LINE(numerator/compute_ratio.denominator);
    
 -- another_label.denominator refers to the local variable (0)
    DBMS_OUTPUT.PUT_LINE('Ratio with another_label.denominator = ');
    DBMS_OUTPUT.PUT_LINE(numerator/another_label.denominator);
 
  EXCEPTION
    WHEN ZERO_DIVIDE THEN
      DBMS_OUTPUT.PUT_LINE('Divide-by-zero error: can''t divide '
        || numerator || ' by ' || denominator);
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unexpected error.');
-- Notice that aliases after the block delimiter END are not qualifiers.
-- They just help in making the code more readable.
  END another_label;
END compute_ratio;
/

/*
Assigning Values to Variables
---------------------------------------
After declaring a variable, you can assign a value to it in these ways:

- Use the assignment statement to assign it the value of an expression.

- Use the SELECT INTO or FETCH statement to assign it a value from a table.

- Pass it to a subprogram as an OUT or IN OUT parameter, and then assign 
  the value inside the subprogram.


Assigning Values to BOOLEAN Variables
---------------------------------------
The only values that you can assign to a BOOLEAN variable are TRUE, 
FALSE, and NULL.
*/

DECLARE
  done    BOOLEAN;              -- Initial value is NULL by default
  counter NUMBER := 0;
BEGIN
  done := FALSE;                -- Assign literal value
  WHILE done != TRUE            -- Compare to literal value
    LOOP
      counter := counter + 1;
      done := (counter > 500);  -- Assign value of BOOLEAN expression
    END LOOP;
END;
/

/*
Assigning LITERALS to variables
-------------------------------
*/
declare
  v_my_integer NUMBER;
  v_my_sci_not NUMBER;
begin
  v_my_integer := 100;
  v_my_sci_not := 2E5;  -- 2E5 meaning 2*10^5 = 200,000
end;
/

/*
BIND VARIABLES
---------------------------------------


Bind variable declaration

  SQL> VARIABLE  v_bind1  VARCHAR2(10);

VARIABLE is a command. If you issue the command

  SQL> VARIABLE ;

it will show all bind variables declared in the session. If you issue the command

  SQL> VARIABLE v_bind1;

it will show the definition of the bind variable specified

** RESTRICTIONS **
Restriction: If you are creating a bind variable of NUMBER datatype then you cannot 
specify the precision and scale.


Bind variable assignment out of a PL/SQL block

  SQL> EXEC :v_bind1 := 'Hello' ;

Bind variable assignment within a PL/SQL block

 BEGIN
  :v_bind1 := 'Bye!';
 END;
 /

Accessing the vale of a bind variable

  DBMS_OUTPUT.PUT_LINE(:v_bind1);

*/