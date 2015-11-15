/*
======================================================================
Flashback Version Queriy (FVQ)
======================================================================

SELECT columns
  FROM table
VERSIONS BETWEEN TIMESTAMP    timestamp1 AND timestamp2 ;

SELECT columns
  FROM table
VERSIONS BETWEEN SCN   scn1 AND scn2 ;

MINVALUE , MAXVALUE
Represents the lowest and highest value of SCN or TIMESTAMP
available for this operation.

SELECT columns
  FROM table
VERSIONS BETWEEN   TIMESTAMP|SCN    MINVALUE and MAXVALUE ;

PSEUDOCOLUMNS
-----------------
VERSIONS_STARTTIME | VERSIONS_STARTSCN – 
  Timestamp or SCN when the line was created. NULL if the line was
  criated before the interal specifierd in the VERSIONS BETWEEN clause
VERSIONS_ENDTIME | VERSIONS_ENDTSCN – 
  Timestamp or SCN when the line expired. 
  NULL if the line refers to an existing OR DELETED record
VERSIONS_XID – 
  Identifyes the transaction that created the line
VERSIONS_OPERATION – 
  The operation that created the line: I for INSERT, D for DELETE e U 
  for UPDATE
*/

-- set up...
create table track_changes (
  col1   NUMBER,
  col2   varchar(2),
  col3   varchar(2)
);

insert into track_changes
select level, 'A', 'B' from dual connect by level < 6 ;

commit;
-- test ...

select * from track_changes ; -- 5 rows selected

select track_changes.* , VERSIONS_STARTTIME, VERSIONS_STARTSCN, VERSIONS_ENDTIME, VERSIONS_ENDSCN, VERSIONS_XID, VERSIONS_OPERATION 
  from track_changes 
versions between scn MINVALUE and MAXVALUE; -- 5 rows selected

update track_changes set col2 = 'Z' where col1 = 3 ;

select track_changes.* , VERSIONS_STARTTIME, VERSIONS_STARTSCN, VERSIONS_ENDTIME, VERSIONS_ENDSCN, VERSIONS_XID, VERSIONS_OPERATION 
  from track_changes 
versions between scn MINVALUE and MAXVALUE; -- 5 rows selected (no committed changes)

commit ;

select track_changes.* , VERSIONS_STARTTIME, VERSIONS_STARTSCN, VERSIONS_ENDTIME, VERSIONS_ENDSCN, VERSIONS_XID, VERSIONS_OPERATION 
  from track_changes 
versions between scn MINVALUE and MAXVALUE
order by 1, VERSIONS_STARTSCN; -- 6 rows selected (committed changes)
/*
here'r record 3 after the initial insert
  3	A	B	14-NOV-15 23:30:32,000000000	11139923	null	                        null	    0A001900AA0A0000	I
  
and after the COMMIT following the UPDATE statement: The older version is ENDED
  3	A	B	14-NOV-15 23:30:32,000000000	11139923	14-NOV-15 23:34:46,000000000	11140022	02000B00870D0000	I
  3	Z	B	14-NOV-15 23:34:46,000000000	11140022	null                          null      0A001900AA0A0000	U  --> new version of the row
*/

delete from track_changes where col1 = 3;
commit;

select track_changes.* , VERSIONS_STARTTIME, VERSIONS_STARTSCN, VERSIONS_ENDTIME, VERSIONS_ENDSCN, VERSIONS_XID, VERSIONS_OPERATION 
  from track_changes 
versions between scn MINVALUE and MAXVALUE
order by 1, VERSIONS_STARTSCN; -- 7 rows selected (committed changes)

/*
3	Z	B	14-NOV-15 23:34:46,000000000	11140022	14-NOV-15 23:43:53,000000000	11140280	0A001900AA0A0000	U --> The formerly updated record END time is set
3	Z	B	14-NOV-15 23:43:53,000000000	11140280	null                      		null      04001B00C90A0000	D --> No longer existing (DELETED) record
*/

-- tear down...
drop table track_changes purge;




/*
Dictionary view FLASHBACK_TRANSACTION_QUERY
================================================================================
Flashback transaction query can be used to get extra information about the 
transactions listed by flashback version queries. The VERSIONS_XID column values 
from a flashback version query can be used to query the FLASHBACK_TRANSACTION_QUERY 
view.

*/

desc FLASHBACK_TRANSACTION_QUERY ;

Select undo_sql from FLASHBACK_TRANSACTION_QUERY 
WHERE  xid = HEXTORAW('04001200CA0A0000');