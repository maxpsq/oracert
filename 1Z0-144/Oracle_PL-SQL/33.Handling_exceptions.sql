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
/

begin
  null;
exception                            --> Using the AND operator, causes a
  when ZERO_DIVIDE AND NO_DATA_FOUND --> compilation ERROR !!
  then
     null;
end;
/

/* 
Exception raised in declarative sections won't be trapped within the exception
handling section of thr same PL/SQL block.
They can be trapped by enclosing block thoug.
*/
set serveroutput on;
begin
  declare
    l_ratio  NUMBER := 23/0 ;  
  begin
    null ;
  exception
    when ZERO_DIVIDE
    then
       dbms_output.put_line(q'|Zero divide won't be trapped here|');
  end;
exception
  when ZERO_DIVIDE
  then
     dbms_output.put_line('TRAPPED!!');
end;
/