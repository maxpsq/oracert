

/*

If a user-defined exception propagates beyond the block where it is declared, 
its name no longer exists
*/

begin
  declare
     my_exc   exception;
  begin 
    raise my_exc;
  end;
exception
  when my_exc then  --> out of scope: COMPILATION ERROR ! 
    null;
end;
/

begin
  declare
     my_exc   exception;
     pragma exception_init(my_exc, -20001);
  begin 
    raise my_exc;
  end;
exception
  when others then  --> how to handle a user defined exception out of it's scope
    if ( sqlcode = -20001 ) then
      null;
    else 
      raise;
    end if;    
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
/*
================================================================================
 RAISE_APPLICATION_ERROR( errcode, message [, FALSE|true] )
================================================================================

errcode  -20000 .. -20999
message  2014 bytes in size
TRUE: puts the error code on top of the error stack
FALSE (default) replaces the error stack with the errcode specified

*/