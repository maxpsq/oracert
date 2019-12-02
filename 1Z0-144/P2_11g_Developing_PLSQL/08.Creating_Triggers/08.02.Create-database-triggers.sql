/*

DML TRIGGERS:  WHEN clause

use the WHEN clause to avoid the initial overhead of executing the executable
block of the trigger.

- the condition to be checked within the WHEN clause must be enclosed in praentheses
- references to NEW and OLD pseudo-records don't have to be prefixed witn ":"
  (the colon is required only within the executable block)
*/

-- set up
create table with_dml_trigger (c1  number, c2 number, c3 varchar2(100));

create or replace 
trigger trg01
before insert on with_dml_trigger
for each row
when ( NEW.c1 > 5 ) -- 1. Parentheses are required 
                    -- 2. Do not prefix NEW/OLD with a colon...
begin
  :NEW.c2 := 1;  -- ... the colon is required only within the executable section
end;
/

/*

DML TRIGGERS:  WHEN clause

use the WHEN clause to avoid the initial overhead of executing the executable
block of the trigger.

- the condition to be checked within the WHEN clause must be enclosed in praentheses
- references to NEW and OLD pseudo-records don't have to be prefixed witn ":"
  (the colon is required only within the executable block)
*/

-- set up
create table with_dml_trigger (c1  number, c2 number, c3 varchar2(100));


create or replace 
trigger trg01
before insert on with_dml_trigger
for each row
when ( NEW.c1 > 5 ) -- 1. Parentheses are required 
                    -- 2. Do not prefix NEW/OLD with a colon...
begin
  :NEW.c2 := 1;  -- ... the colon is required only within the executable section
end;
/

insert into with_dml_trigger
select level, 0, null from dual connect by level  < 10 ;
commit;


create or replace 
trigger trg01
before insert on with_dml_trigger
-- for each row -- The use of the WHEN clause is possible only with FOR EACH ROW clause
when ( NEW.c1 > 5 )
begin
  :NEW.c2 := 1;  -- ... the colon is required only within the executable section
end;
/

create or replace 
trigger trg01
before insert on with_dml_trigger
for each row
when ( trunc(NEW.c1) > 5 ) -- Only SQL functions are allowed within the WHEN clause
                           -- PL/SQL functions, pre-defined PL/SQL packager or user-defined functions are NOT allowed here
begin
  :NEW.c2 := 1; 
end;
/


create or replace 
trigger trg01
before insert on with_dml_trigger
for each row
when ( trunc(NEW.c1) > 5 ) -- Only SQL functions are allowed within the WHEN clause
                           -- PL/SQL functions, pre-defined PL/SQL packager or user-defined functions are NOT allowed here
begin
  :NEW.c2 := 1; 
end;
/



select * from with_dml_trigger;



/*
DML TRIGGERS: OLD/NEW pseudo-records
"pseudo" because they don't share all the properties with actual records.
They are comparable to record defined as %rowtype against the table to which 
the trigger is attached.


on INSERT triggers, OLD is defined but always contains an empty record
on DELETE triggers, NEW is defined but always contains an empty record
on UPDATE triggers, OLD refers the values of the row before the DML statement
                  , NEW refers the values the row will contain after the DML is performed
*/

set serveroutput on;

create or replace trigger tr02
before insert on with_dml_trigger
for each row
begin
  dbms_output.put_line('OLD.c1='||:old.c1); -- OLD is an empty record 
end;
/

insert into with_dml_trigger select 80 , 2, 'hey' from dual;

create or replace trigger tr03
after delete on with_dml_trigger
for each row
begin
  dbms_output.put_line('NEW.c1='||:new.c1); -- NEW is an empty record 
end;
/

delete from with_dml_trigger where c1 = 80;

/*
OLD and NEW can be aliased using the REFERENCING .. AS .. clause
*/
create or replace trigger tr04
after update on with_dml_trigger
referencing OLD AS theOldOne NEW AS theNewOne
for each row
begin
  dbms_output.put_line('OLD.c2='||:theOldOne.c2); 
  dbms_output.put_line('NEW.c2='||:theNewOne.c2); 
end;
/

create or replace trigger tr05
after update on with_dml_trigger
referencing OLD AS theOldOne
for each row
begin
  dbms_output.put_line('OLD (2).c2='||:theOldOne.c2); 
end;
/

update with_dml_trigger set c2 = c2 + 9 where c1 = 3;

select * from with_dml_trigger  where c1 = 3;


/*
DML triggers: operational directives
*/

create or replace trigger op_dir01
before insert or update or delete on with_dml_trigger
for each row
begin
  if deleting then
    dbms_output.put_line('deleting');
  elsif updating then
    dbms_output.put_line('updating');
  elsif inserting then
    dbms_output.put_line('inserting');
  end if;
end;
/

delete with_dml_trigger where c1 = 1 and rownum = 1;

update with_dml_trigger set c2=13 where c1 = 2 and rownum = 1;

insert into with_dml_trigger select 83 , 4, 'aa' from dual;

/*
MERGE statement can both UPDATE and DELETE
Run this merge statement multiple times to see what happens
*/
merge into with_dml_trigger a
using ( select 44 c1, 1 c2, 'merge' c3 from dual) b
on (a.c1 = b.c1)
when matched then
  UPDATE SET a.c2 = a.c2 + b.c2
  delete where a.c2 > 4 -- Notice only rows matching the ON clause AND the DELETE's WHERE clause criteria will be removed
when not matched then
  insert (a.c1, a.c2, a.c3) values (b.c1, b.c2, b.c3);


create or replace trigger op_dir02
before update on with_dml_trigger
for each row
begin
  if updating('c2') then -- the name of the column is case-INsensitive
    dbms_output.put_line('updating c2 !!');
  end if;
end;
/

update with_dml_trigger set c2 = 43 where c1 = 5;
update with_dml_trigger set c3 = 'c3' where c1 = 5;

rollback;

/*
operational directives can be called from within any PL/SQL block, not only within
DML triggers.
They will evaluate to TRUE only within a DML trigger or routine called from a
DML trigger.
*/

create or replace package opdir as
  procedure onInsertion;   
end;
/
create or replace package body opdir as
  procedure onInsertion is
  begin
    if inserting then
      dbms_output.put_line('insertion in package');
    end if;
  end;   
end;
/

create or replace trigger op_dir03
after insert or update or delete on with_dml_trigger
for each row
begin
  opdir.onInsertion;
end;
/

update with_dml_trigger set c3 = 'ddddd' where c1=8;
insert into with_dml_trigger select 103 , 4, 'aa' from dual;
commit;


/*
DML triggers: COMPOUND TRIGGERS

A coumpound trigger is some sort of a package containing many triggers. Notice the
actual triggers are those declared within BEFORE/AFTER clauses.

[BEFORE|AFTER] [STATEMENT|EACH ROW] IS 
..
END [BEFORE|AFTER] [STATEMENT|EACH ROW]; 
*/
create table incremented_values (value_inserted number, value_invcremented number); 

create or replace 
TRIGGER compounder
FOR UPDATE OR INSERT OR DELETE ON incremented_values 
COMPOUND TRIGGER

  v_global_var NUMBER := 1;
  
  BEFORE STATEMENT IS 
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Compound:BEFORE S:' || v_global_var);
    v_global_var := v_global_var + 1; 
  END BEFORE STATEMENT; -- You cannot just close using END here !!
  
  BEFORE EACH ROW IS 
  BEGIN
   DBMS_OUTPUT.PUT_LINE('Compound:BEFORE R:' || v_global_var);
   v_global_var := v_global_var + 1; 
  END BEFORE EACH ROW;
  
  AFTER EACH ROW IS 
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Compound:AFTER R:' || v_global_var);
    v_global_var := v_global_var + 1; 
  END AFTER EACH ROW;
  
  AFTER STATEMENT IS 
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Compound:AFTER S:' || v_global_var);
    v_global_var := v_global_var + 1; 
  END AFTER STATEMENT;
  
END;
/


-- The global variable is set back to 1 when the second statement executes.
-- This is because the global variable scopes within a compound trigger is bound
-- to the statement, not to the session.
BEGIN
  insert into incremented_values values(1,1);
  insert into incremented_values values(2,2);
END;
/


/*
DML Triggers: MUTATING TABLE ERROR

1. Ingeneral, a row-level trigger may not read or write the table from which it 
   has been fired. The restriction applies only to row-level triggers, however. 
   Statement-level triggers are free to both read and modify the triggering table; 
   this fact gives us a way to avoid the mutating table error.

2. If you make your trigger an autonomous transaction, then you will be able
   to query the contents of the firing table. 
   However, you will still ** not ** be allowed to modify the contents of the table.
*/


/*
ISTEAD OF triggers
Control the insertion, deletion, update on VIEWS

CREATE [OR REPLACE] TRIGGER trigger_name
INSTEAD OF operation
ON view_name
FOR EACH ROW
BEGIN
...code goes here...
END;


INSTEAD OF triggers cannot be compound and you need to create one for each event
on the same table

*/



CREATE OR REPLACE TRIGGER trg77
INSTEAD OF insert
ON with_dml_trigger --> ORA-25002: impossibile creare i trigger INSTEAD OF su tabelle
FOR EACH ROW
BEGIN
  dbms_output('hello!');
END;
/


select * from with_dml_trigger;

-- tear down
-- drop table with_dml_trigger purge;

