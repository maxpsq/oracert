
/*
Make use of the INTO clause to hold the values returned by a SQL statement
==========================================================================

The INTO clause is used to direct the result of a SELECT statement into 
variables when only and only one row is returned.

In case of NO DATA FOUND, the content of the destination variable won't change.

In case on NO ROWS or MORE THEN ON ROW, an exception is raised.

If there is need to assign a large quantity of table data, a SELECT INTO with
BULK COLLECT may be used.
*/
set serveroutput on;
declare
  v_dummy   CHAR(1) := 'Z' ;
begin
  Select dummy into v_dummy 
    from dual where dummy = 'm';
exception
  when no_data_found then
    dbms_output.put_line('v_dummy='||v_dummy);
end;
/

/*
Procedura PL/SQL completata correttamente.
v_dummy=Z
*/