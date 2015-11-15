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
