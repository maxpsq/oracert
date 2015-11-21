/*
PL/SQL is made of three block structures:

	DECLARATION BLOCK (optional)

	EXECUTION BLOCK (mandatory)

	EXCEPTION BLOCK (optional)



declare
  ...
begin
  ...
exception
  ...
end;

A structure as the one shown above is called a anonymous block

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


