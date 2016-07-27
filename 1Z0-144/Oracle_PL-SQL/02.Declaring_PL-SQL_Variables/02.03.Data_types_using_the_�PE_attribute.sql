/*
================================================================================
Using the %TYPE Attribute
================================================================================
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
set serveroutput on;
DECLARE
  credit  PLS_INTEGER RANGE 1000..25000;
  debit   credit%TYPE;  -- inherits data type

  name1        VARCHAR2(20) default 'JoHn SmItH';
  upper_name1  name1%TYPE;  -- inherits data type but NOT the default value
  lower_name1  name1%TYPE;  -- inherits data type but NOT the default value
  init_name1   name1%TYPE;  -- inherits data type but NOT the default value
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

DECLARE
  name1   constant     VARCHAR2(20)  := 'JoHn SmItH';
  
  -- %TYPE cannot be used with CONSTANTS. It will raise a compilation error: 
  -- PLS-00206: %TYPE must be applied to a variable, column, field or attribute, not to "NAME1"
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

BEGIN
  DBMS_OUTPUT.PUT_LINE(:v_bind1);
END;
/

*/


/*
the RANGE constraint
-----------------------------
Note 1:
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

/*
Note 2:
in case you want to apply the NOT NULL contraint, it must follow the RANGE operator
*/
declare
   l_constrained1  PLS_INTEGER  RANGE 7..10  NOT NULL;
   l_constrained2  PLS_INTEGER  NOT NULL  RANGE 7..10 ; --> COMPILATION ERROR
begin
   NULL;
end ;
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
   subtype my_type  is pls_integer range  12 .. 15 not null ;
   l_sub_int    my_type  := 13 ;
   l_anc_int    l_sub_int%type ;   --> this will fail due to the NOT NULL constraint from SIMPLE_INTEGER
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

Best of luck wiht the 1Z0-144 exam! Are you by any chance testing your SQL and 
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
