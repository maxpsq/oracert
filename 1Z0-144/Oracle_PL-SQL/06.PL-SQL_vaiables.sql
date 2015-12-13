
/*
=================================================================================
OBJECTIVE: Recognize valid and invalid identifiers
=================================================================================
Valid variable names are bound to the same rules as database objects
They must 
  - be composed of characters from the database charactr set
  - begin with a letter 
  - contain a letters, digits or the symbols $ _ #
  - not exceed 30 characters (30 bytes) in length

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


/*
the RANGE constraint
-----------------------------
Note:
The only base types for which you can specify a range of values are PLS_INTEGER 
and its subtypes (both predefined and user-defined).
*/
declare
   l_constrained  NUMBER(2)  RANGE  7..10 ; --> ERROR: it's not applied on PLS_INTEGER or its subtype
begin
   l_constrained := 9;
end ;
/


declare
   subtype my_type is simple_integer range 10..20 ;
   
   l_constrained_int  my_type := 10 ;

   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;   
  
begin
   l_constrained_int := 12 ;
   print('12',l_constrained_int); --> OK

   l_constrained_int := 4 ;
   print('4',l_constrained_int);  --> ERROR: out of range
   
end;
/

declare
   subtype my_type is pls_integer range 10..20 ;
   
   l_constrained_int  my_type ; --> This is NULL when defined. Range allows NULL numbers

   procedure print(msg varchar2, v number) is
   begin
      dbms_output.put_line(msg||': '||v);
   end ;   
  
begin
   l_constrained_int := 12 ;
   print('12',l_constrained_int); --> OK

end;
/

declare
   C_MIN  constant pls_integer := 10 ;
   C_MAX  constant pls_integer := 20 ;
   
   --> Numeric literals are required using RANGE
   --> Compilation ERROR !!!
   subtype my_type is simple_integer range C_MIN..C_MAX ; 
begin
   null;
end;
/


declare
   l_sub_int    SIMPLE_INTEGER := 8 ;
   l_anc_int    l_sub_int%type ;   --> thi will fail due to the NOT NULL constraint from SIMPLE_INTEGER
begin
   null;
end;
/

/*
From Steven Feuerstein book "Oracle PL/SQL Programming, 5th Ed." page 183:
"Be aware that an anchored subtype does not carry over the NOT NULL constraint 
to the variables it defines"
I cannot demonstrate that. I wrote an e-mail to Steven on 12 Dec 2015. Hope
he'll reply...
*/
declare
   subtype my_type  is pls_integer not null range  12 .. 15 ;
   l_sub_int    my_type  := 13 ;
   l_anc_int    l_sub_int%type ;   --> thi will fail due to the NOT NULL constraint from SIMPLE_INTEGER
begin
   null;
end;
/

/*
from Steven Feuerstein:

Massimo,

Here’s what I meant: 

The NOT NULL constraint from the column definition is not carried over to the 
subtype.

Best of luck wiht the 1X0-144 exam! Are you by any chance testing your SQL and 
PL/SQL knowledge at plsqlchallenge.oracle.com?

This code will run without an error:
*/
create table tst (n number not null)
/

declare
   subtype my_type  is tst.n%type  ;
   l_sub_int    my_type ;
begin
   null;
end;
/

