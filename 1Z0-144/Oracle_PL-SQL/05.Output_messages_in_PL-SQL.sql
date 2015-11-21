/*


Using DBMS OUTPUT package
--------------------------------

The DBMS_OUTPUT package can be invoked only within a PL/SQL block. To see t
he output returned from this statement you have set the serveroutput on. 
You can do that by simply writing and executing 

SET SERVEROUTPUT ON ;
BEGIN
  :v_bind1 := 'RebellionRider';
  DBMS_OUTPUT.PUT_LINE(:v_bind1);
END;
/


SET SERVEROUTPUT ON|OFF ;
SET SERVEROUTPUT  1|0 ;



Using Print command
--------------------------------
Like DBMS_OUTPUT statement print command also displays the current value of the 
bind variable except that you can write this command in host environment rather 
than inside any PL/SQL block or section. Yes similar to variable command, print 
command does not require any PL/SQL block for execution.


SQL> Print :v_bind1 ;  -- :bind_variable

SQL> Print v_bind1 ;   -- bind_vaiable without the leading colon


Setting Autoprint parameter on
--------------------------------
The last way of displaying the current value of a bind variable is by setting a 
session based parameter AUTOPRINT on. Doing so will display you the value of all 
the BIND VARIABLES without the use of any specific commands such as Print or 
DBMS_OUTPUT which we just saw. 

SQL> variable aa NUMBER;
SQL> EXEC aa := 8 ;
SQL>

SQL> SET AUTOPRINT ON;
SQL> variable bb NUMBER;
SQL> EXEC bb := 8 ;

        BB
----------
         8

SQL>

Setting the AUTOPRINT parameter ON has effects of printing out the final value of 
all variable to wich have been assigned a value within a PL/SQL block. 
The value returned for each bind variable is the last that has been assigned. In the
example below, the value 74 is not shown for :aa

SQL> SET AUTOPRINT ON;
SQL> BEGIN
  1    aa := 74 ;
  2    bb := 21 ;
  2    aa := 104 ;
  3  END;
  4  /

      BB
--------
      21

      AA
--------
     104
*/