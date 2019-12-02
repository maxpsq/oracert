/*
Create a DISABLED trigger
-----------------------------------------
You can create a trigger and prevent it to fire adding teh DISABLE clause in the
CREATE TRIGGER command.

CREATE TRIGGER trigger_name 
... 
DISABLE --> just before DECLARE/BEGIN 
BEGIN
  ...
END;

Notice the DISABLE claus won't be added to the trigger source inside the DB


The trigger will then be:
1. created
2. compiled
3. validated

*/

CREATE TABLE TEST1 (DUMMY VARCHAR2(9));

CREATE OR REPLACE TRIGGER TRXX 
BEFORE INSERT ON TEST1
DISABLE   --> LAST CLAUSE
BEGIN
  DBMS_OUTPUT.PUT_LINE('INSERTING RECORDS...');
END;
/

set serveroutput on;
INSERT INTO TEST1 VALUES ('A');

ALTER TRIGGER TRXX ENABLE;

INSERT INTO TEST1 VALUES ('B');

COMMIT;


/* 
ALTER TRIGGER trigger_name DISABLE|ENABLE;
*/

/* Compile a trigger
ALTER TRIGGER trigger_name COMPILE [DEBUG] compiler_parameter [REUSE SETTINGS];
*/

/* Renaming a trigger */
ALTER TRIGGER trigger_name RENAME TO trigger2;

/* Dropping a trigger */
DROP TRIGGER trigger_name;




SELECT * FROM USER_TRIGGERS;

/* 
View the status of a trigger 
------------------------------------
You cannot get to know if a trigger is VALID or INVALID from the *_TRIGGER views.
You need to inquiry the *_OBJECTS views to get this information.
*/
SELECT * FROM USER_OBJECTS;

-- TEAR DOWN 
DROP TABLE TEST1 PURGE;

