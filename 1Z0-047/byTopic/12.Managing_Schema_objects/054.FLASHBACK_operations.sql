
/*******************************************************************************
   FLASHBACK OPERATIONS
*******************************************************************************/

/* 
FLASHBACK TABLE 
========================================
*/
CREATE TABLE REC_TAB (GREETING  VARCHAR2(20));
INSERT INTO REC_TAB VALUES ('HELLO');
COMMIT;
DROP TABLE REC_TAB;
FLASHBACK TABLE REC_TAB TO BEFORE DROP;
select * from REC_TAB;
DROP TABLE REC_TAB;
FLASHBACK TABLE REC_TAB TO BEFORE DROP RENAME TO REC_TAB2;
select * from REC_TAB2;
DROP TABLE REC_TAB2;
PURGE TABLE REC_TAB2;  -- removes the dropped table from RECYCLEBIN

/* 
Recovering table in time 
========================================
*/
-- ENABLE FLASHBACK OPERATIONS TO RESTORE AN EXISTING TABLE TO AN OLDER STATE
CREATE TABLE REC_TAB (GREETING  VARCHAR2(20)) ENABLE ROW MOVEMENT; 
-- or even 'ALTER TABLE REC_TAB ENABLE ROW MOVEMENT;' on an existing table
INSERT INTO REC_TAB VALUES ('HELLO');
COMMIT;
execute dbms_lock.sleep(15);
DELETE FROM REC_TAB;
COMMIT;
execute dbms_lock.sleep(15);
FLASHBACK TABLE REC_TAB TO TIMESTAMP SYSTIMESTAMP - INTERVAL '0 00:00:20' DAY TO SECOND ;
select ORA_ROWSCN, greeting from REC_TAB;
DROP TABLE REC_TAB;

/* 
RESTORE POINTS 
========================================
*/

CREATE TABLE REC_TAB (GREETING  VARCHAR2(20)) ENABLE ROW MOVEMENT; 
-- or even 'ALTER TABLE REC_TAB ENABLE ROW MOVEMENT;' on an existing table
INSERT INTO REC_TAB VALUES ('HELLO');
COMMIT;
CREATE RESTORE POINT point_01;

execute dbms_lock.sleep(15);

DELETE FROM REC_TAB;
COMMIT;
execute dbms_lock.sleep(15);
FLASHBACK TABLE REC_TAB TO RESTORE POINT point_01;
select ORA_ROWSCN, greeting from REC_TAB;

DROP TABLE REC_TAB;
DROP RESTORE POINT point_01;



/*
FLASHBACK TABLE

https://oracle-base.com/articles/10g/flashback-10g#flashback_transaction_query

The FLASHBACK TABLE command allows point in time recovery of individual tables 
subject to the following requirements.

* You must have either the FLASHBACK ANY TABLE system privilege or have FLASHBACK 
  object privilege on the table.
* You must have SELECT, INSERT, DELETE, and ALTER privileges on the table.
* There must be enough information in the undo tablespace to complete the operation.
* Row movement must be enabled on the table (ALTER TABLE tablename ENABLE ROW MOVEMENT;)

*/

-- set up...
CREATE TABLE flashback_table_test (
  id  NUMBER(10)
);

ALTER TABLE flashback_table_test ENABLE ROW MOVEMENT;

insert into flashback_table_test ( select level from dual connect by level < 4);
commit;

-- test...

SELECT current_scn FROM v$database; -- 11347160

select * from flashback_table_test ;

update flashback_table_test set id = id * 10 ;
commit;

select * from flashback_table_test ;

flashback table flashback_table_test to scn 11347160 ;

select * from flashback_table_test ;

--tear down...

drop table flashback_table_test purge ;
