/*
Pre-defined exception

Their names are accessible globally by the package STANDARD (where they are declared)

*/

/* 
Handling Exceptions
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
Handling INTERNALLY DEFINED EXCEPTION with no predefiend exception:
*/
declare
  ex_snapshot_too_old   exception;
  pragma exception_init(ex_snapshot_too_old, -1555);  -- caso 1 con EXCEPTION_INIT
begin
  null;
exception 
  when ex_snapshot_too_old then 
    null;
  when OTHERS then
    if SQLCODE = -1422 THEN  -- caso 2
      NULL;
    else 
      RAISE;
    end if;
end;
/