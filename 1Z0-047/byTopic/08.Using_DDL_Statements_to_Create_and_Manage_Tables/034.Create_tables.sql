
/* Not enclosed in quotes (case insensitive) */
create table prova1 (c1  number);
insert into prova1 (c1) values (4);

select * from prova1 ; -- SUCCESS

select * from PROVA1 ; -- SUCCESS

select * from "PROVA1" ; -- SUCCESS (table name was created as uppercase)

select * from "prova1" ; -- ERROR (table name was created as uppercase)

drop table prova1 ;


/* Enclosed in quotes (case sensitive) */
create table "prova2" (c1  number);
insert into "prova2" (c1) values (4);

select * from prova2 ; -- ERROR (table name is searched as uppercase)

select * from PROVA2 ; -- ERROR (table name is searched as uppercase)

select * from "PROVA2" ; -- ERROR (table name is searched as uppercase)

select * from "prova2" ; -- SUCCESS (table name is searched as lowercase)

drop table "prova2" ;


/* Reserved words */

create table SELECT (c1  number);  -- ERROR

create table "SELECT" (c1  number); -- SUCCESS

select * from "SELECT" ; -- SUCCESS

select * from "select" ;  -- SUCCESS

select * from SELECT ;  -- ERROR (reserved word)

drop table "SELECT" ;



create table "into" (c1  number);

select * from "into" ; -- SUCCESS

select * from into ; -- ERROR (reserved word)

drop table "into" ;


/* Reserved non-letter as first characer */

create table 3ELECT (c1  number);  -- ERROR (invalid table name)

create table "3ELECT" (c1  number); -- SUCCESS

select * from "3ELECT" ; -- SUCCESS

select * from 3ELECT ;  -- ERROR

drop table "3ELECT" ;


/* Column types */

-- CHAR(n) defaults its size to 1
create table chartab (c1  char);
insert into chartab(c1) values ('a');  -- Must success
insert into chartab(c1) values ('ab'); -- Must fail

/* Not enclosed in quotes (case insensitive) */
create table prova1 (c1  number);
insert into prova1 (c1) values (4);

select * from prova1 ; -- SUCCESS

select * from PROVA1 ; -- SUCCESS

select * from "PROVA1" ; -- SUCCESS (table name was created as uppercase)

select * from "prova1" ; -- ERROR (table name was created as uppercase)

drop table prova1 ;


/* Enclosed in quotes (case sensitive) */
create table "prova2" (c1  number);
insert into "prova2" (c1) values (4);

select * from prova2 ; -- ERROR (table name is searched as uppercase)

select * from PROVA2 ; -- ERROR (table name is searched as uppercase)

select * from "PROVA2" ; -- ERROR (table name is searched as uppercase)

select * from "prova2" ; -- SUCCESS (table name is searched as lowercase)

drop table "prova2" ;


/* Reserved words */

create table SELECT (c1  number);  -- ERROR

create table "SELECT" (c1  number); -- SUCCESS

select * from "SELECT" ; -- SUCCESS

select * from "select" ;  -- SUCCESS

select * from SELECT ;  -- ERROR (reserved word)

drop table "SELECT" ;



create table "into" (c1  number);

select * from "into" ; -- SUCCESS

select * from into ; -- ERROR (reserved word)

drop table "into" ;


/* Reserved non-letter as first characer */

create table 3ELECT (c1  number);  -- ERROR (invalid table name)

create table "3ELECT" (c1  number); -- SUCCESS

select * from "3ELECT" ; -- SUCCESS

select * from 3ELECT ;  -- ERROR

drop table "3ELECT" ;



--==============================
--  INDEX-ORGANIZED TABLES (IOT)
--==============================

/*
https://oracle-base.com/articles/8i/index-organized-tables

Why Use Index Organized Tables
----------------------------------------
Accessing data via the primary key is quicker as the key and the data reside 
in the same structure. There is no need to read an index then read the table 
data in a separate structure.
Lack of duplication of the key columns in an index and table mean the total 
storage requirements are reduced.

Creation Of Index Organized Tables
----------------------------------------
To create an index organized table you must:

- Specify the primary key using a column or table constraint.
- Use the ORGANIZATION INDEX.

In addition you can:

- Use PCTTHRESHOLD to define the percentage of the block that is reserved for 
an IOT row. If the row exceeds this size the key columns (head piece) is stored 
as normal, but the non-key data (tail piece) is stored in an overflow table. 
A pointer is stored to locate the tail piece.

- Use OVERFLOW TABLESPACE to define the tablespace that the overflow data will 
be stored in.

- Use INCLUDING to define which non-key columns are stored with the key columns 
in the head piece, should overflow be necessary.

CREATE TABLE locations
(id           NUMBER(10)    NOT NULL,
 description  VARCHAR2(50)  NOT NULL,
 map          BLOB,
 CONSTRAINT pk_locations PRIMARY KEY (id)
)
ORGANIZATION INDEX 
TABLESPACE iot_tablespace
PCTTHRESHOLD 20
INCLUDING description            --> this will be placed in the 'tail piece' along with the PK
OVERFLOW TABLESPACE overflow_tablespace;

*/

