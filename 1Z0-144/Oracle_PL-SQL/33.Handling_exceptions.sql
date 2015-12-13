/* Handling Exceptions
============================

*/

begin
  null;
exception
  when ZERO_DIVIDE OR NO_DATA_FOUND
  then
     null;
end;


begin
  null;
exception                            --> Using the AND operator, causes a
  when ZERO_DIVIDE AND NO_DATA_FOUND --> compilation ERROR !!
  then
     null;
end;

set serveroutput on;
begin
  raise ZERO_DIVIDE ;
exception                            --> Using the AND operator, causes a
  when ZERO_DIVIDE    --> compilation ERROR !!
  then
     dbms_output.put_line('EXPR');
end;