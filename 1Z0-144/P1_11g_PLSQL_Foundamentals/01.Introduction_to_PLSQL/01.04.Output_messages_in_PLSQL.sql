set define off
set feedback off

document

  Using DBMS_OUTPUT package
  =========================
  The DBMS_OUTPUT package can be invoked only within a PL/SQL block. To see
  the output returned from this statement you have set the serveroutput on.

  You can do that by simply writing and executing

#

set serveroutput on

set echo on
declare
  v_var VARCHAR2(1000);
BEGIN
  v_var := 'Good morning!';
  dbms_output.put_line(v_var);
END;
/

pause Press ENTER to continue

VARIABLE bindvar VARCHAR2(1000);
BEGIN
  :bindvar := 'Good night!';
  dbms_output.put_line(:bindvar);
END;
/

pause Press ENTER to continue

document

  Using PRINT command
  ===================
  Like DBMS_OUTPUT statement, PRINT command also displays the current value of
  the bind variable except that you can write this command in host environment
  rather than inside any PL/SQL block or section.
  PRINT command does not require any PL/SQL block for execution.

  you can specify the variable both with or without a leading colon
    PRINT variable
    PRINT :variable

#

VARIABLE zzz VARCHAR2(1000) ;
begin
  select 'This is the value of :zzz' into :zzz from dual;
end;
/
PRINT zzz
PRINT :zzz


pause Press ENTER to continue

document

 PRINT is not meant to print messages to screen.
 Next call to PRINT will raise an ERROR!

#

PRINT 'hey!'

pause Press ENTER to continue

document

  Setting AUTOPRINT parameter on
  ==============================
  The last way of displaying the current value of a bind variable is by setting
  a session based parameter AUTOPRINT ON. Doing so will display you the value of
  all the BIND VARIABLES without the use of any specific commands such as Print
  or DBMS_OUTPUT which we just saw.

#

set AUTOPRINT off
variable aa NUMBER;
EXEC :aa := 8 ;


SET AUTOPRINT ON;
variable bb NUMBER;
EXEC :bb := 8 ;

pause Press ENTER to continue

document

  Setting the AUTOPRINT parameter ON has effects of printing out the final value
  of all variable to wich have been assigned a value within a PL/SQL block.
  The value returned for each bind variable is the last that has been assigned.
  In the example below, the value 74 is not shown for :aa

#

set AUTOPRINT on
BEGIN
  :aa := 74 ;
  :bb := 21 ;
  :aa := 104 ;
END;
/
