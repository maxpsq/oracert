/*
OVERLOADING
*/
create or replace package overloading as

  function func1(aNum in number) return number;

  function func1(aNum in number, bNum in number) return number;
  
end;
/

create or replace package body overloading as

  function func1(aNum in number) return number is
  begin
    return 3 * aNum;
  end;

  function func1(aNum in number, bNum in number) return number is
  begin
    return bNum * aNum;
  end;

end;
/

set serveroutput on;
begin
  dbms_output.put_line(overloading.func1(2));
  dbms_output.put_line(overloading.func1(2,8));
end;
/

/**
In order to overload functions, the signature must change in types or number of 
arguments.

Here I have two identical signatures. As a consequence, this will give a COMPILATION
error.
*/

create or replace package overloading as  -- COMPILE ERROR !!!!

  function func3(aNum in number) return number;

  function func3(aNum in number) return number;
  
end;
/


/*
Starting with Oracle Database 10g, you can overload two subprograms if their 
formal parameters differ only in numeric datatype. Before getting into the 
details, let’s look at an example. Consider the following block:
*/

DECLARE
  PROCEDURE proc1 (n IN PLS_INTEGER) IS 
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('pls_integer version'); 
  END;
  
  PROCEDURE proc1 (n IN NUMBER) IS 
  BEGIN
    DBMS_OUTPUT.PUT_LINE ('number version'); 
  END;
BEGIN
  proc1 (1.1);
  proc1 (1); 
END;
/

/*
When I try to run this code in Oracle9i Database, I get an error:
ORA-06550: line 14, column 4:
PLS-00307: too many declarations of 'PROC1' match this call

When I run this same block in Oracle Database 10g and Oracle Database 11g, 
however, I see the following results:

number version
pls_integer version

The PL/SQL compiler is now able to distinguish between the two calls. Notice 
that it called the “number version” when I passed a noninteger value. That’s 
because PL/SQL looks for numeric parameters that match the value, and it follows 
this order of precedence in establishing the match: 
it starts with: 
 1) PLS_INTEGER or BINARY_INTEGER
 2) NUMBER
 3) BINARY_FLOAT
 4) BINARY_DOUBLE
 
It will use the first overloaded program that matches the actual argument values passed.

**/

create or replace package overloading as

  function func3(aNum in pls_integer) return number;

  function func3(aNum in number) return number;
  
end;
/

create or replace package body overloading as

  function func3(aNum in pls_integer) return number is
  begin
    return 3 * aNum;
  end;

  function func3(aNum in number) return number is
  begin
    return 2 * aNum;
  end;

end;
/

set serveroutput on;
declare
  my_number  NUMBER := 2;
  my_integer PLS_INTEGER := 2;
  my_natural NATURAL := 2;
begin
  dbms_output.put_line(overloading.func3(my_number));  -- 4
  dbms_output.put_line(overloading.func3(my_integer)); -- 6
  dbms_output.put_line(overloading.func3(my_natural)); -- 6
  dbms_output.put_line(overloading.func3(2)); -- 6
end;
/



create or replace package overloading as

  function func3(aNum in number) return number;
  
  function func3(aNum in natural) return number; -- (*) 

  function func3(aNum in PLS_INTEGER) return number; -- (*)
  
  -- (*) same subtype: won't raise any compile time error, though
end;
/

create or replace package body overloading as

  function func3(aNum in number) return number is
  begin
    return 2 * aNum;
  end;

  function func3(aNum in natural) return number is
  begin
    return 3 * aNum;
  end;

  function func3(aNum in PLS_INTEGER) return number is
  begin
    return 4 * aNum;
  end;

end;
/

set serveroutput on;
declare
  my_number  NUMBER := 2;
  my_integer PLS_INTEGER := 2;
  my_natural NATURAL := 2;
begin
  dbms_output.put_line(overloading.func3(my_number)); --> this executes successfully
  dbms_output.put_line(overloading.func3(my_integer)); --> this raises an error: PLS-00307: too many declarations of 'FUNC3' match this call
  dbms_output.put_line(overloading.func3(my_natural));
  dbms_output.put_line(overloading.func3(2));
end;
/


/*
Overloaded programs with parameter lists that differ only by name must be 
called using named notation.
*/

create or replace package overloading2 as

  function func(par1 in varchar2) return varchar2;
  
  function func(par2 in varchar2) return varchar2;

end;
/

create or replace package body overloading2 as

  function func(par1 in varchar2) return varchar2
  is
  begin
    return par1||par1||par1;
  end;
  
  function func(par2 in varchar2) return varchar2
  is
  begin
    return par2;
  end;

end;
/

begin
  dbms_output.put_line(overloading2.func('a')); -- PLS-00307: too many declarations of 'FUNC' match this call
  dbms_output.put_line(overloading2.func('b'));
end;
/

begin
  dbms_output.put_line(overloading2.func(par1 => 'a')); -- SUCCESS !
  dbms_output.put_line(overloading2.func(par2 => 'b'));
end;
/


/* =============================================================================
Using FORWARD DECLARATION
============================================================================= 

You cannot make forward declarations of a variable or cursor. This technique 
works only with modules (procedures and functions).

The definition for a forwardly declared program must be contained in the 
declaration section of the same PL/SQL block (anonymous block, procedure, 
function, or package body) in which you code the forward declaration.

*/

