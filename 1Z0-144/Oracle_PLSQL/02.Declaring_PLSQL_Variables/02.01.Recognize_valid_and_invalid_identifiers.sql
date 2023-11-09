
/*
=================================================================================
OBJECTIVE: Recognize valid and invalid identifiers
=================================================================================
Valid ordinary user-defined identifiers are bound to the same rules as database objects
They must 
  - be composed of characters from the database charactr set
  - begin with a letter 
  - contain letters, digits or the symbols $ _ #
  - not exceed 30 bytes in length

A valid ordinary user-defined identifier can be validated against the following
regular expression

^[A-Za-z][A-Za-z0-9$#_]{,29}$

*/

declare
  "new variable"   number;
  " trailing spaces "   number;
  "A+B=C"   number;
  "??????????"   number;
begin
  "new variable" := 2;
end;
/

/*
For quoted identifiers, all characters are allowed except
- double quotes
- new lines
- null character
*/
declare
  "4
  long"   number;
begin
  null;
end;
/
