/**
SQLCODE
In an exception handler, the SQLCODE function returns the numeric code of the exception being handled. 
Outside an exception handler, SQLCODE returns 0.


For an internally defined exception, the numeric code is the number of the 
associated Oracle Database error. This number is negative except for the error 
"no data found", whose numeric code is +100.

For a user-defined exception, the numeric code is either +1 (default) or the error 
code associated with the exception by the EXCEPTION_INIT pragma.

*/


set serveroutput on;
declare
  aaa varchar2(2000);
  ex_my_exception    exception;
begin
  dbms_output.put_line(sqlcode);   --  0 : out of an exception handling block
  begin
    dbms_output.put_line(sqlcode);  --  0 : out of an exception handling block
    raise too_many_rows;  -- raises ORA-01422
  exception
    when others then
      begin
        dbms_output.put_line(sqlcode);  -- -1422 (exception handling block 1)
        select first_name into aaa from hr.employees where last_name = 'xsd'; -- raises no data found
      exception
        when others then
          dbms_output.put_line(sqlcode);  --  100 (exception handling block 2)
          select dummy into aaa from dual;
          begin
            dbms_output.put_line(sqlcode);  --  100 (still in exception handling block 2, even if enclosed in a begin .. end)
            raise ex_my_exception ;
          exception
            when others then
              dbms_output.put_line(sqlcode);  --  1 (exception handling block 3, user-defined exception without PRAGMA returns +1)
          end;  
      end;
      dbms_output.put_line(sqlcode);  -- -1422 (back to exception handling block 1)
  end;
  dbms_output.put_line(sqlcode);  --  0 : out of an exception handling block
end;
/


/*
A SQL statement cannot invoke SQLCODE.
*/

select sqlcode from dual; -- ERROR


/*
================================================================================
SQLERRM
The SQLERRM function returns the error message associated with an error code.
================================================================================

SQLERRM(-6511): ORA-06511: PL/SQL: cursor already open

-- Positive numbers
SQLERRM(0)          --> ORA-00000: normal or successful completion
SQLERRM(100)        --> ORA-01403: no data found
SQLERRM(positive)   --> ORA-01403: non-ORACLE exception
*/


set serveroutput on;
declare
  aaa varchar2(2000);
  ex_my_exception    exception;
  ex_my_exception_pragma   exception;
  pragma exception_init(ex_my_exception_pragma, -20111);
begin
  dbms_output.put_line(sqlerrm);   --  ORA-0000: normal, successful completion : out of an exception handling block
  begin
    dbms_output.put_line(sqlerrm);  -- ORA-0000: normal, successful completion : out of an exception handling block
    raise too_many_rows;  -- raises ORA-01422
  exception
    when others then
      begin
        dbms_output.put_line(sqlerrm);  -- ORA-01422: Estrazione esatta riporta numero di righe maggiore di quello richiesto
                                        -- (exception handling block 1)
        select first_name into aaa from hr.employees where last_name = 'xsd'; -- raises no data found
      exception
        when others then
          dbms_output.put_line(sqlerrm);  -- ORA-01403: nessun dato trovato
                                          -- ORA-01422: Estrazione esatta riporta numero di righe maggiore di quello richiesto
                                          -- here we get 2 messages within exception handling block 2 
                                          -- sorted since the most recent the older
          select dummy into aaa from dual;
          begin
            dbms_output.put_line(sqlerrm);  -- ORA-01403: nessun dato trovato
                                            -- ORA-01422: Estrazione esatta riporta numero di righe maggiore di quello richiesto
                                            -- here we still are in exception handling block 2, even if enclosed in a begin .. end
                                            -- and get 2 messages sorted since the most recent the older
            raise ex_my_exception ;
          exception
            when others then
              dbms_output.put_line(sqlerrm);  -- User-Defined Exception
                                              -- (exception handling block 3, user-defined exception without PRAGMA returns +1)
                                              -- Notice the previusly raised messages are lost when a User defined exception
                                              -- without error code associated occours.
          end;  
          begin
            raise ex_my_exception_pragma ;
          exception
            when others then
              dbms_output.put_line(sqlerrm);  -- User-Defined Exception
                                              -- ORA-20111:
                                              -- ORA-01403: nessun dato trovato
                                              -- ORA-01422: Estrazione esatta riporta numero di righe maggiore di quello richiesto
                                              -- (exception handling block 3, user-defined exception without PRAGMA returns +1)
                                              -- Notice the previusly raised messages are lost when a User defined exception occours
          end;  
      end;
      dbms_output.put_line(sqlerrm);  -- ORA-01422: Estrazione esatta riporta numero di righe maggiore di quello richiesto
                                      -- (back to exception handling block 1)
  end;
  dbms_output.put_line(sqlerrm);  --  ORA-0000: normal, successful completion
                                  --  out of an exception handling block
end;
/
