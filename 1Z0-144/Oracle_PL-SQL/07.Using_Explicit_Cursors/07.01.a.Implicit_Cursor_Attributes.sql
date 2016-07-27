/*
Implicit cursors (aka SQL cursors) are constructed and managed automatically 
by PL/SQL when a Select or SQL DML statement is used within a PL/SQL block.
You can access the attributes of an implicit cursor but there is no mean you can
control them.

In order to acces implicit cursor attributes, you need to use the "SQL%" keyword 
followed by the attribute name

SQL%ISOPEN
SQL%ROWCOUNT
SQL%FOUND
SQL%NOTFOUND


IMPLICIT CURSOR ATTRIBUTES (SQL%....)

*/
create table cursor_attributes_test(
dummy    number
);
insert into cursor_attributes_test
select level from dual connect by level < 10;
commit;



/*
Before any SQL statement(*) is executed in the session, cursor attributes yelds 
NULL except ISOPEN that yields FALSE.
(*) any SQL statement like ROLLBACK, COMMIT, Select, any DML, DCL, TCL, etc... 
*/
set serveroutput on;
begin
  prnt.p('ISOPEN (false)', sql%isopen);
  prnt.p('ROWCOUNT (null)', sql%rowcount);
  prnt.p('FOUND (null)', sql%found);
  prnt.p('NOTFOUND (null)', sql%notfound);
end;
/

-- DISCONNECT end RE-CONNECT
set serveroutput on;
begin
  rollback; -- First SQL statement
  prnt.p('ISOPEN (false)', sql%isopen);
  prnt.p('ROWCOUNT (0)', sql%rowcount);
  prnt.p('FOUND (false)', sql%found);
  prnt.p('NOTFOUND (true)', sql%notfound);
end;
/

/*

SQL%ISOPEN is always false after the termination of the SQL statement because
the PL/SQL engine closes all the implicit cursors automaticly.

In practice SQL%ISOPEN always return FALSE for implicit cursors.

*/
begin
  update cursor_attributes_test
     set dummy = dummy
   where dummy < 3 ; 
  prnt.p('ROWCOUNT (2)', sql%rowcount);
  prnt.p('ISOPEN (false)', sql%isopen); 
  prnt.p('FOUND (true)', sql%found);
  prnt.p('NOTFOUND (false)', sql%notfound);
  rollback;
end;
/

/* A not-matching statement: %ROWCOUNT=0 and %FOUND=false and %NOTFOUND=true */
begin
  update cursor_attributes_test
     set dummy = dummy
   where dummy > 13 ; 
  rollback;
  prnt.p('ROWCOUNT (0)', sql%rowcount);
  prnt.p('ISOPEN (false)', sql%isopen);
  prnt.p('FOUND (false)', sql%found);
  prnt.p('NOTFOUND (true)', sql%notfound);
end;
/


drop table cursor_attributes_test purge;





create or replace 
package prnt as

  procedure p(msg  varchar2, v  varchar2);

  procedure p(msg  varchar2, b  boolean);

  procedure p(msg  varchar2, n  number);

end;
/
create or replace 
package body prnt as

   NULL_C    constant  varchar2(10) := '<NULL>';

   procedure p(msg  varchar2, v  varchar2) is
   begin
     dbms_output.put_line(msg||'='||nvl(v,NULL_C));
   end;
   
   procedure p(msg  varchar2, b  boolean) is
     v    varchar2(32767);
   begin
     if    ( b = true) then
       v:='true';
     elsif ( b = false) then
       v:='false';
     else
       v:=NULL;
     end if;
     p(msg,v);
   end;

   procedure p(msg  varchar2, n  number) is
   begin
     p(msg,to_char(n));
   end;

end;
/

