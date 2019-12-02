document

                              PL/SQL BLOCKS


  PL/SQL is made of three block structures:

  	DECLARATION BLOCK (optional)

  	EXECUTION BLOCK (mandatory)

  	EXCEPTION BLOCK (optional)

  Only the executable part is required. A block can have a label.

  <<label>>  -- (optional)
  declare    -- (optional)
    ...
  begin      -- (required)
    ...
  exception  -- (optional)
    ...
  end;       -- (required)

#
pause Press ENTER to continue

document

  KEYWORDS: ANONYMOUS BLOCK
  A block as the one shown above can be executed by many tools like SQL*Plus.
  The block will be executed only one time and it will not be stored in
  the database, and for that reason, it is called an anonymous block (even
  if it has a label).

  An anonymous block is compiled each time it is loaded into memory, and its
  compilation has three stages:

    1. Syntax checking: PL/SQL syntax is checked, and a parse tree is generated.
    2. Semantic checking: Type checking and further processing on the parse tree.
    3. Code generation: the compiled code is generated

  An anaonymous block cannot be invoked from other PL/SQL blocks.

#
pause Press ENTER to continue

document

  KEYWORDS: NEMED BLOCK
  Subprograms
  A PL/SQL subprogram is a named PL/SQL block that can be invoked repeatedly.
  If the subprogram has parameters, their values can differ for each invocation.
  PL/SQL has two types of subprograms, procedures and functions. A function
  returns a result. For more information about PL/SQL subprograms, see Chapter 8,
  "PL/SQL Subprograms."

#
pause Press ENTER to continue

document

  Packages
  A package is a schema object that groups logically related PL/SQL types, variables,
  constants, subprograms, cursors, and exceptions. A package is compiled and stored
  in the database, where many applications can share its contents. You can think
  of a package as an application.

  Triggers
  A trigger is a named PL/SQL unit that is stored in the database and run in response
  to an event that occurs in the database. You can specify the event, whether the
  trigger fires before or after the event, and whether the trigger runs for each
  event or for each row affected by the event.

#
pause Press ENTER to continue

document

  Blocks may be nested (up to 255 nested levels):

  declare
    ...   --> nesting is not admitted inside declaration blocks
  begin
    ...
    declare  --> we can nest within execution blocks
      ...
    begin
      ...
    exception
      ...
    end ;
  exception
    ...
    declare  --> we can nest within exception blocks
      ...
    begin
      ...
    exception
      ...
    end ;
  end;

#
pause Press ENTER to continue

document

  EXECUTION block
  ---------------------
  starts with the word BEGIN and terminates with the word END followed by a semicolon.
  IT MUST CONTAIN AT LEAST ONE STATEMENT.
  It may contains executable statements and call to functions and procedures.

  DECLARATION block
  ---------------------
  For an anonymous block, starts with the word DECLARE
  For a FUNCTION or PROCEDURE is delimited in between the routine signature and
  the outermost execution block (BEGIN .. END;)
  It may contain local variables and constants declaration, local routines
  declaration, cursor declaration

  EXCEPTION block
  ---------------------
  It contains the instructions for handling EXCEPTIONS. It starts with the word
  EXCEPTION and terminates with the word END; from the EXECUTION block that wraps
  it. Exceptions are trapped using

     WHEN exception1 THEN
        ..
     WHEN exception2 OR exception3 THEN
        ..

  The exception block can handle only errors raised within the EXECUTION BLOCK
  it belongs to during runtime. It’s not possible for an EXCEPTION block to trap
  exception raised at runtime within the DECLARATION block within the same PL/SQL
  block.

#
pause Press ENTER to continue

document

  FORWARD DECLARATION
  ==========================

  The code below will raise an error because of the invocation of procedure PR1
  inside PR2 before PR1 is declared

#
set echo on
DECLARE

  PROCEDURE PR2(MSG   VARCHAR2) IS
  BEGIN
    PR1(MSG);
    DBMS_OUTPUT.PUT_LINE('PR2 > '||MSG);
  END;

  PROCEDURE PR1(MSG   VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('PR1 > '||MSG);
  END;

BEGIN
  PR2('CIAO');
END;
/
set echo off
pause Press ENTER to continue

document

  The issue above can be avoided just declaring the signature of procedure PR1 before
  the implementation of PR2

#
set echo on
DECLARE

  PROCEDURE PR1(MSG   VARCHAR2); -- <= Adding PR1 before declaring PR2

  PROCEDURE PR2(MSG   VARCHAR2) IS
  BEGIN
    PR1(MSG);
    DBMS_OUTPUT.PUT_LINE('PR2 > '||MSG);
  END;

  PROCEDURE PR1(MSG   VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('PR1 > '||MSG);
  END;

BEGIN
  PR2('CIAO');
END;
/
set echo off
