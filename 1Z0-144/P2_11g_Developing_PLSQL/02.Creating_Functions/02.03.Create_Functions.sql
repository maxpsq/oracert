

CREATE OR REPLACE FUNCTION MyFunc RETURN NUMBER IS
BEGIN
  RETURN 0;
END;
/

SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE(MyFunc);
END;
/

/*
Function can contain more than a RETURN statement. The execution stops when 
the firtst RETURN is met
*/
CREATE OR REPLACE FUNCTION MyFunc RETURN NUMBER IS
  dummy  NUMBER := 4;
BEGIN
  RETURN 0;
  dummy := dummy + 1;
  RETURN 1;
END;
/

SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE(MyFunc);
END;
/

/*
During execution, if no RETURN statement is met by reaching the end of the 
function body, an ERROR wil be raised:
"PL/SQL: Function returned without value"
*/
CREATE OR REPLACE FUNCTION MyFunc RETURN NUMBER IS
  dummy  NUMBER := 4;
BEGIN
  dummy := dummy + 1;
  if ( dummy > 9 ) then
    RETURN dummy;
  end if;
END;
/

SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE(MyFunc);  -- ERROR
END;
/

/* RETURN STATEMENT CAN BE PUT even in the EXCEPTION BLOCK*/
CREATE OR REPLACE FUNCTION MyFunc RETURN NUMBER IS
  dummy  NUMBER := 4;
BEGIN
  RAISE NO_DATA_FOUND;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/

SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE(MyFunc);  -- ERROR
END;
/

/* 
Notice a function not containing any RETURN statement can be successfully compiled ... 
*/
CREATE OR REPLACE FUNCTION MyFunc RETURN NUMBER IS
  dummy  NUMBER := 4;
BEGIN
  dummy := dummy + 1;
END;
/

/*
... but will raise a RUNTIME ERROR during execution
"PL/SQL: Function returned without value"
*/
SET SERVEROUTPUT ON;
BEGIN
  DBMS_OUTPUT.PUT_LINE(MyFunc);  -- ERROR
END;
/

/* 
When called from SQL, a function must accept/return SQL compatible data types
NUMBER / NUMBER are SQL NATIVE types
*/
CREATE OR REPLACE FUNCTION doubling(a_number NUMBER) RETURN NUMBER IS
BEGIN
  return a_number * 2 ;
END;
/


SELECT doubling(8) from dual;

/*
PLS_INTEGER / PLS_INTEGER are SQL COMPTIBLES types
*/
CREATE OR REPLACE FUNCTION doubling(a_number PLS_INTEGER) RETURN PLS_INTEGER IS
BEGIN
  return a_number * 2 ;
END;
/

SELECT doubling(8) from dual;
