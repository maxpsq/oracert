/*
$IF    .. $THEN
$ELSIF .. $THEN
$ELSE  .. $THEN
$END              NOTICE it's ** not 'END IF' ** and there is ** no semicolon **
*/

ALTER SESSION SET PLSQL_CCFLAGS = 'oe_debug:true, oe_trace_level:3';

create or replace PROCEDURE calculate_totals IS
BEGIN
  $IF $$oe_debug AND $$oe_trace_level >= 5 $THEN
    DBMS_OUTPUT.PUT_LINE ('Tracing at level 5 or higher'); 
  $END
  NULL;
END calculate_totals;
/


set serveroutput on;
begin
  calculate_totals;
end;
/


/*
Inquiry Directives
================================================================================
The syntax for an inquiry directive is as follows:

$$identifier

where identifier is a valid PL/SQL identifier that can represent any of the 
following:
• Compilation environment settings: the values found in the 
  USER_PLSQL_OBJECT_SETTINGS data dictionary view.
  Run DESC USER_PLSQL_OBJECT_SETTINGS to see their values
• Your own custom-named directive: defined with the ALTER...SET PLSQL_CCFLAGS 
  command, described in a later section.
• Implicitly defined directives: $$PLSQL_LINE and $$PLSQL_UNIT, providing you 
  with the line number and program name.
  
Inquiry directives are designed for use within conditional compilation clauses, 
but they can also be used in other places in your PL/SQL code.

I can use inquiry directives in places in my code where a variable is not allowed. 
Here are two examples:
*/

select * from USER_PLSQL_OBJECT_SETTINGS;


ALTER SESSION SET PLSQL_CCFLAGS = 'MAX_VARCHAR2_SIZE:1000, DEF_APP_ERR_CODE:-20001';

DECLARE
  l_big_string VARCHAR2($$MAX_VARCHAR2_SIZE);
  l_default_app_err EXCEPTION;
  PRAGMA EXCEPTION_INIT (l_default_app_err, $$DEF_APP_ERR_CODE); 
BEGIN
  NULL;
END;
/

/* NOT setting the two inquiry directives, will lead to compilation errors.
It's like the undefined directives are be replaced with empty strings.
*/
ALTER SESSION SET PLSQL_CCFLAGS = '';
DECLARE
  l_big_string VARCHAR2($$MAX_VARCHAR2_SIZE);
  l_default_app_err EXCEPTION;
  PRAGMA EXCEPTION_INIT (l_default_app_err, $$DEF_APP_ERR_CODE); 
BEGIN
  NULL;
END;
/

ALTER SESSION SET PLSQL_CCFLAGS = '';
DECLARE
  l_big_string VARCHAR2($$MAX_VARCHAR2_SIZE);
  l_default_app_err EXCEPTION;
  PRAGMA EXCEPTION_INIT (l_default_app_err, $$DEF_APP_ERR_CODE); 
BEGIN
  NULL;
END;
/

/*

$ERROR .. $END directive

Use the $ERROR directive to cause the current compilation to fail and return 
the error message provided.
*/
CREATE OR REPLACE PROCEDURE long_compilation IS
BEGIN
  $IF $$plsql_optimize_level != 1 $THEN
    $ERROR 'This program must be compiled with optimization level = 1' $END 
  $END
  NULL;
END long_compilation;
/



/*
DBMS_DB_VERSION package

DBMS_DB_VERSION.VERSION     major version -> 11 for Oracle 11gR2
DBMS_DB_VERSION.RELEASE     release -> 2 for Oracle 11gR2 
DBMS_DB_VERSION.VER_LE_9    Boolean Less Equal (TRUE/FALSE)
DBMS_DB_VERSION.VER_LE_9_1 
DBMS_DB_VERSION.VER_LE_9_2 
DBMS_DB_VERSION.VER_LE_10
DBMS_DB_VERSION.VER_LE_10_1 
DBMS_DB_VERSION.VER_LE_10_2 
DBMS_DB_VERSION.VER_LE_11
DBMS_DB_VERSION.VER_LE_11_1 
DBMS_DB_VERSION.VER_LE_11_2
DBMS_DB_VERSION.VER_LE_12
DBMS_DB_VERSION.VER_LE_12_1

you can write expressions that include references to as-yet undefined constants 
in the DBMS_DB_VERSION package. As long as they are not evaluated, as in the case 
below, they will not cause any errors. Here is an example:
*/

-- VER_LE_13_1 is not yet defined on 12cR1 but this will not be evalueted 
-- because the former condition is true and we're using a ELSIF
BEGIN
$IF DBMS_DB_VERSION.VER_LE_11 $THEN
  dbms_output.put_line('Hello 11.1');
$ELSIF DBMS_DB_VERSION.VER_LE_12_1 $THEN
  dbms_output.put_line('Hello 12.1');
$ELSIF DBMS_DB_VERSION.VER_LE_13_1 $THEN 
  dbms_output.put_line('Hello 13.1');
$END
END;
/



