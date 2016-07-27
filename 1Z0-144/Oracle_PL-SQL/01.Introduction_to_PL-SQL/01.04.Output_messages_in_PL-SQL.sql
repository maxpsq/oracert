/*


Using DBMS OUTPUT package
--------------------------------

The DBMS_OUTPUT package can be invoked only within a PL/SQL block. To see 
the output returned from this statement you have set the serveroutput on. 


You can do that by simply writing and executing 
*/
set serveroutput on;
declare
  v_var VARCHAR2(1000); 
BEGIN
  v_var := 'Good morning!';
  dbms_output.put_line(v_var);
END;
/


VARIABLE bindvar VARCHAR2(1000); 

BEGIN
  :bindvar := 'Good night!';
  dbms_output.put_line(:bindvar);
END;
/

/*
Using Print command
--------------------------------
Like DBMS_OUTPUT statement print command also displays the current value of the 
bind variable except that you can write this command in host environment rather 
than inside any PL/SQL block or section. Yes similar to variable command, print 
command does not require any PL/SQL block for execution.

you can specify the variable both with or without a leading colon
PRINT variable
PRINT :variable
*/
VARIABLE zzz VARCHAR2(1000) ;
PRINT zzz
PRINT :zzz

/*
PRINT is not meant to print messages to screen
*/
-- This will raise an ERROR !
PRINT 'hey!'  



VARIABLE v_bind1 VARCHAR2(1000) ;
EXEC :v_bind1 := 'A bad assignament'; -- ERROR ! We're not in PL/SQL scope
print :v_bind1


VARIABLE v_bind1 VARCHAR2(1000) ;
 -- ERROR ! We're not in PL/SQL scope, so you'll be asked to type in a value for v_bind1
select 'yet another bad assignament' into :v_bind1 from dual; 
print :v_bind1

VARIABLE v_bind1 VARCHAR2(1000) ;
begin
-- OK, we're in PL/SQL scope
  select 'a good assignament' into :v_bind1 from dual;  
end;
/
-- bind_vaiable with the leading colon
Print :v_bind1 
-- bind_vaiable without the leading colon
Print v_bind1    


Setting Autoprint parameter on
--------------------------------
The last way of displaying the current value of a bind variable is by setting a 
session based parameter AUTOPRINT on. Doing so will display you the value of all 
the BIND VARIABLES without the use of any specific commands such as Print or 
DBMS_OUTPUT which we just saw. 

set AUTOPRINT off
variable aa NUMBER;
EXEC :aa := 8 ;


SET AUTOPRINT ON;
variable bb NUMBER;
EXEC :bb := 8 ;

        BB
----------
         8



Setting the AUTOPRINT parameter ON has effects of printing out the final value of 
all variable to wich have been assigned a value within a PL/SQL block. 
The value returned for each bind variable is the last that has been assigned. In the
example below, the value 74 is not shown for :aa
*/

SET AUTOPRINT ON;
BEGIN
  :aa := 74 ;
  :bb := 21 ;
  :aa := 104 ;
END;
/

/*
      AA
--------
     104

      BB
--------
      21

      AA
--------
     104
*/

declare
  status pls_integer := 0;
  buf varchar2(32767);
  counter pls_integer := 0;
begin
  for i in 1 .. 10 loop
    dbms_output.put_line(i);
  end loop;
  while status < 1 loop
    dbms_output.get_line(buf, status);
    if (status = 0 ) then
      counter := counter + 1 ;
    end if;
  end loop;
  dbms_output.put_line(counter);
end;
/


declare
  writes  constant pls_integer := 10;
  required_lines   constant pls_integer := 2;
  lines   pls_integer ;
  loops   pls_integer := 0;
  v_Data      DBMS_OUTPUT.CHARARR;
  counter pls_integer := 0;
  
begin
  for i in 1 .. writes loop
    dbms_output.put_line(i);
  end loop;
  loop
    loops := loops + 1;
    lines := required_lines;
    -- lines:
    --  IN: number of lines you wish to get
    --  OUT: number of lines actually gotten: OUT is always greater then or equal to IN
    dbms_output.get_lines(v_Data, lines);
    counter := counter + lines;
    exit when lines < required_lines ;
  end loop;
  dbms_output.put_line(counter);
end;
/


DBMS_OUTPUT.DISABLE;
-- Call to GET*, PUT*, NEW_LINE are ignored if the package is disabled.

DBMS_OUTPUT.ENABLE (buffer_size IN INTEGER DEFAULT 20000);

DBMS_OUTPUT.GET_LINE (line    OUT VARCHAR2, status  OUT INTEGER);

DBMS_OUTPUT.GET_LINES (lines  OUT CHARARR, numlines IN OUT  INTEGER);

DBMS_OUTPUT.GET_LINES (lines  OUT  DBMSOUTPUT_LINESARRAY, numlines    IN OUT INTEGER);

DBMS_OUTPUT.NEW_LINE;

DBMS_OUTPUT.PUT (item IN VARCHAR2);

DBMS_OUTPUT.PUT_LINE ( item IN VARCHAR2);