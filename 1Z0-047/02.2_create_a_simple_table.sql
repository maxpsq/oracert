
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


/******************************************************************************* 
                             Column data types 
*******************************************************************************/

--> * CHAR(n) * <--

-- defaults its size to 1 
create table chartab (c1  char);
insert into chartab(c1) values ('a');  -- Must success
insert into chartab(c1) values ('ab'); -- Must fail
drop table chartab;

-- Max size is 2000
create table chartab (c1  char(2000));
insert into chartab(c1) values ('ab'); -- Must success
select 'Columns has been filled upt to '||length(c1)||' chars' as msg 
  from chartab where length(c1) = 2000; 
drop table chartab1;
create table chartab (c1  char(2001));


--> * VARCHAR2(n) * <--
-- n -> 1 .. 4000
create table varchar2tab (c1  varchar2(20) ); 
insert into varchar2tab(c1) values ('a');  -- Must success
insert into varchar2tab(c1) values ('ab'); -- Must fail
drop table varchar2tab;


--> * NUMBER(n,m) * <--
-- precision (n) ranges from 1 to 38 
-- scale (m) ranges from -84 to 127 and defaults to 0 when n is specified
-- These are NOT the largest values !!
-- values range from 1.0 * 10^-130 to (but not including) 1.0 * 10^126
create table numtab (c1  number ); 
insert into numtab (c1) values (12345678901234567890123456789012345678);
insert into numtab (c1) values (123456789012345678901234567890123456789); 
insert into numtab (c1) values (12345678901234567890123456789012345678901234567890);
insert into numtab (c1) values (3.44);
select 'Trovato' from numtab where c1 = 3.44;
select 'Trovato' from numtab where c1 = 123456789012345678901234567890123456789;
drop table numtab;

create table numtab (c1  number(5) ); -- number(5,0)
insert into numtab (c1) values (12345);
insert into numtab (c1) values (123456); -- must fail
insert into numtab (c1) values (3.4); -- inserts 3
select 'Trovato' from numtab where c1 = 3.4;
select 'Trovato' from numtab where c1 = 3;
insert into numtab (c1) values (3.8); -- inserts 4
select 'Trovato' from numtab where c1 = 3.8;
select 'Trovato' from numtab where c1 = 4;
drop table numtab;

/* 

Negative scale has the effect of "increasing" the precision:
Notice the examples below: precision (n) defines the maximum number on digits
on the left of the "m" zeroes
*/
create table numtab (c1  number(5,-2) ); -- number(5,0)
insert into numtab (c1) values (3.4); -- inserts 0
insert into numtab (c1) values (44); -- inserts 0
insert into numtab (c1) values (128);  -- 100
insert into numtab (c1) values (12345);  -- 12300
insert into numtab (c1) values (123888); -- 123900
insert into numtab (c1) values (1238883); -- 1238900
insert into numtab (c1) values (12388834); -- must fail!!
insert into numtab (c1) values (3.8); -- inserts 4
select * from numtab;
drop table numtab;


--> * DATE * <--
-- contains year, month, day, hour, minute, second


--> * TIMESTAMP(n) * <--
-- extension od DATE with fractional second precision
-- fractional second precision (n) rangest from 1 to 9, default is 6

--> * TIMESTAMP(n) WITH TIMEZONE * <--
-- stores either a time zone region name or a time zone offset

--> * TIMESTAMP(n) WITH LOCAL TIMEZONE * <--
-- the timezone offset is not stored in the column but is displayed using 
-- the USER's local session time zone

--> * INTERVAL YEAR(n) TO MONTH * <--
-- stores a span of time defined in years and months.
-- the number of digits (n) used to define the year ranges from 0 to 9 and 
-- defaults to 2

--> * INTERVAL DAY(n1) TO SECOND(n2) * <--
-- stores a span of time defined in days, hours, minutes and seconds where
-- n1 is the precision for days and n2 is the precision for seconds.
-- n1 ranges from 0 to 9 and defaults to 2
-- n2 ranges from 0 t0 9 and defaults to 6 (it's the fractional value precision
-- for seconds). 
