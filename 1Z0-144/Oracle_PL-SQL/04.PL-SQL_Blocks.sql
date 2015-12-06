/*
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


KEYWORDS: NEMED BLOCK
Subprograms
A PL/SQL subprogram is a named PL/SQL block that can be invoked repeatedly. 
If the subprogram has parameters, their values can differ for each invocation. 
PL/SQL has two types of subprograms, procedures and functions. A function 
returns a result. For more information about PL/SQL subprograms, see Chapter 8, 
"PL/SQL Subprograms."

Packages
A package is a schema object that groups logically related PL/SQL types, variables, 
constants, subprograms, cursors, and exceptions. A package is compiled and stored in 
the database, where many applications can share its contents. You can think of a package 
as an application.

Triggers
A trigger is a named PL/SQL unit that is stored in the database and run in response 
to an event that occurs in the database. You can specify the event, whether the trigger 
fires before or after the event, and whether the trigger runs for each event or for 
each row affected by the event.

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


EXECUTION block
---------------------
starts with the word BEGIN and terminates with the word END followed by a semicolon.
IT MUST CONTAIN AT LEAST ONE STATEMENT.
It may contains executable statements and call to functions and procedures.

DECLARATION block
---------------------
For an anonymour block, starts with the word DECLARE
For a FUNCTION or PROCEDURE is delimited in between the routine signature and the 
outermost execution block (BEGIN .. END;)
It may contain local variables and constants declaration, local routines declaration,
cursor declaration

EXCEPTION block
---------------------
It contains the instructions for handling EXCEPTIONS. It starts with the word EXCEPTION 
and terminates with the word END; from the EXECUTION block that wraps it.
Exceptions are trapped using 

   WHEN exception1 THEN
      ..
   WHEN exception2 THEN
      ..

The exception block can handle only errors raised within the EXECUTION BLOCK it belongs to 
during runtime. It's not possible for a EXCEPTION block to trap exception raised at 
runtime within the DECLARATION block within the same PL/SQL block.

*/


