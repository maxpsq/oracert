/*

CREATE [OR REPLACE] TRIGGER trigger name
{BEFORE | AFTER | ISTEAD OF} { DDL event} ON {DATABASE | SCHEMA}
[WHEN (...)]
DECLARE
  Variable declarations 
BEGIN
 ...some code...
END;

Event                     Fires when...
ALTER                     Any database object is altered using the SQL ALTER command
ANALYZE                   Any database object is analyzed using the SQL ANALYZE command 
ASSOCIATE STATISTICS      Statistics are associated with a database object
AUDIT                     Auditing is turned on using the SQL AUDIT command
COMMENT                   Comments are applied to a database object  
CREATE                    Any database object is created using the SQL CREATE command
DDL                       Any of the events listed here occur
DISASSOCIATE STATISTICS   Statistics are disassociated from a database object
DROP                      Any database object is dropped using the SQL DROP command 
GRANT                     Privileges are granted using the SQL GRANT command
NOAUDIT                   Auditing is turned off using the SQL NOAUDIT command
RENAME                    A database object is renamed using the SQL RENAME command 
REVOKE                    Privileges are revoked using the SQL REVOKE command
TRUNCATE                  A table is truncated using the SQL TRUNCATE command



Function
ORA_CLIENT_IP_ADDRESS
ORA_DATABASE_NAME
ORA_DES_ENCRYPTED_PASSWORD
ORA_DICT_OBJ_NAME
ORA_DICT_OBJ_NAME_LIST
ORA_DICT_OBJ_OWNER 
ORA_DICT_OBJ_OWNER_LIST
ORA_DICT_OBJ_TYPE 
ORA_GRANTEE
ORA_INSTANCE_NUM 
ORA_IS_ALTER_COLUMN
ORA_IS_CREATING_NESTED_TABLE
ORA_IS_DROP_COLUMN 
ORA_LOGIN_USER 
ORA_PARTITION_POS 
ORA_PRIVILEGE_LIST
ORA_REVOKEE
ORA_SQL_TXT
ORA_SYSEVENT 
ORA_WITH_GRANT_OPTION








*/


CREATE OR REPLACE TRIGGER town_crier
AFTER CREATE ON SCHEMA
BEGIN
  DBMS_OUTPUT.PUT_LINE('I believe you have created a '||ORA_DICT_OBJ_TYPE||' called '||ORA_DICT_OBJ_NAME);
END;
/


SET SERVEROUTPUT ON;

create table tab1 (col1 number);

CREATE FUNCTION a_function RETURN BOOLEAN AS
BEGIN
  RETURN(TRUE);
END;
/

-- Text displayed using the DBMS_OUTPUT within DDL triggers will not display 
-- until you successfully execute a PL/SQL block,
begin
  null;
end;
/


/*
AFTER event TRIGGERS and Oracle Data Dictionary
Remember that changes made to the schema ARE NOT YET visible within AFTER event
TRIGGERS. 

That means that if you try to access the dictionary from an AFTER event TRIGGER,
the information in the Dictionary view reflects the state of the object
before the DDL command was run. 
*/



-- tear down
drop table tab1 purge;
drop function a_function;
drop trigger town_crier;


/*
INSTEAD OF CREATE trigger

CREATE is the ONLY "DDL event" available for INSTEAD OF triggers.

Notice you can define ISTEAD OF triggers for DML operations (see ch. 16)
*/
create or replace trigger instof_create01
instead of create on database
when ( ora_dict_obj_type = 'TABLE' )
begin
  null;
end;
/

drop trigger instof_create01;

