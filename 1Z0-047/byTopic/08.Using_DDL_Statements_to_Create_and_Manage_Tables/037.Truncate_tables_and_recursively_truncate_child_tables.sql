/*
Recursively trunacate child tables
*/

/*
We have seen here on the blog how to erase the entire contents of a table almost 
instantaneously through the TRUNCATE. 
But if any referential constraints, ie constraints FOREIGN KEY that reference 
this table and that already has lines referencing the same, the TRUNCATE will 
fail, even if you have FOREIGN KEY ON DELETE CASCADE option.

This ON DELETE CASCADE option is to execute a DELETE in any row in the parent 
table, and if you have lines in the child table that references to, the 
DELETE will not fail, but the lines in the child table will also be deleted.

To execute TRUNCATE one the same way in children tables, the constraints FOREIGN 
KEY should have the ON DELETE CASCADE option. And for this we must add the 
CASCADE option at the end of TRUNCATE. Thus becoming:

TRUNCATE CASCADE table;

In this way the child table that references the parent table through FOREIGN KEY 
constraint with ON DELETE CASCADE option will also suffer TRUNCATE.
*/

create table trunc_table1 (
id  number primary key,
xid varchar2(10)
);

create table trunc_table2 (
parent_id  number,
xid varchar2(10),
constraint t2_fk foreign key (parent_id) references trunc_table1 (id) on delete cascade
);

insert into trunc_table1 (id,xid) values (1,'A');
insert into trunc_table1 (id,xid) values (2,'B');
insert into trunc_table1 (id,xid) values (3,'C');

insert into trunc_table2 (parent_id,xid) values (1,'A');
insert into trunc_table2 (parent_id,xid) values (1,'A');
insert into trunc_table2 (parent_id,xid) values (2,'B');
insert into trunc_table2 (parent_id,xid) values (2,'B');
insert into trunc_table2 (parent_id,xid) values (2,'B');
insert into trunc_table2 (parent_id,xid) values (3,'C');
insert into trunc_table2 (parent_id,xid) values (3,'C');
commit;

---

/* 
If we delete all rows from 'trunc_table1' all rows from 'trunc_table2' are
deleted by the 'on delete cascade' clause on the FK
*/
delete from trunc_table1 ;

select count(1) from trunc_table2;

rollback;

/*
Now we try to truncate the table
*/

truncate table trunc_table1;
-- Errore SQL: ORA-02266: La tabella referenziata da chiavi esterne abilitate dispone di chiavi uniche/primarie
-- 02266. 00000 -  "unique/primary keys in table referenced by enabled foreign keys"

/* 
NOTICE we need a ON DELETE CASCADE option on the FK constraint for the CASCADE
option to take effect
*/
truncate table trunc_table1 cascade;
-- Table truncated

select count(1) from trunc_table2;
-- 0 rows


/* tear down */
drop table trunc_table2;
drop table trunc_table1;