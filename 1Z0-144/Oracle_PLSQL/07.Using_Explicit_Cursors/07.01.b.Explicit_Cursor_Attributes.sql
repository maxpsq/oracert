/*
Implicit cursors (aka SQL cursors) are constructed and managed automatically 
by PL/SQL when a Select or SQL DML statement is used within a PL/SQL block.
You can access the attributes of an implicit cursor but there is no mean you can
control them.

The attributes of an explicit cursor are referenced by the name of the cursor
followed by the attribute

my_cursor%ISOPEN
my_cursor%ROWCOUNT
my_cursor%FOUND
my_cursor%NOTFOUND


EXPLICIT CURSOR ATTRIBUTES (my_cursor%....)

*/
create table cursor_attributes_test(
dummy    number
);
insert into cursor_attributes_test
select level from dual connect by level < 10;
commit;



/*
Most of the explicit cursor attributes but %ISOPEN are accessible only 
after the cursor is opened
*/
set serveroutput on;
declare
  cursor c is 
    select * 
      from cursor_attributes_test;
begin
  begin
    prnt.p('ISOPEN (false)', c%isopen);
  exception
    when others then
      dbms_output.put_line('%isopen IS NOT accessible when the cursor is closed');
  end;    
  begin
    prnt.p('ROWCOUNT (0)', c%ROWCOUNT);
  exception
    when others then
      dbms_output.put_line('%ROWCOUNT IS NOT accessible when the cursor is closed');
  end;    
  begin
    prnt.p('FOUND (NULL)', c%FOUND);
  exception
    when others then
      dbms_output.put_line('%FOUND IS NOT accessible when the cursor is closed');
  end;    
  begin
    prnt.p('NOTFOUND (NULL)', c%NOTFOUND);
  exception
    when others then
      dbms_output.put_line('%NOTFOUND IS NOT accessible when the cursor is closed');
  end;    
end;
/

/*
After an explicit cursor is opened and before performing any fetching, the cursor 
attributes are expected to return these values.
*/
set serveroutput on;
declare
  cursor c is 
    select * 
      from cursor_attributes_test;
begin
  open c; -- opening the explicit cursor
  prnt.p('ISOPEN (true)', c%isopen);
  prnt.p('ROWCOUNT (0)', c%rowcount);
  prnt.p('FOUND (NULL)', c%found);
  prnt.p('NOTFOUND (NULL)', c%notfound);
  close c;
end;
/

/*
After fetching
*/
set serveroutput on;
declare
  cursor c is 
    select * 
      from cursor_attributes_test
      where rownum < 3;
  r c%rowtype;    
  counter   PLS_INTEGER := 0;
begin
  prnt.p('ISOPEN (false)', c%isopen);
  open c; -- opening the explicit cursor
  prnt.p('ROWCOUNT (0)', c%rowcount);    -- zero before any fetching attempt
  prnt.p('FOUND (NULL)', c%found);       -- NULL before any fetching attempt
  prnt.p('NOTFOUND (NULL)', c%notfound); -- NULL before any fetching attempt
  loop
    fetch c into r;
    prnt.p('ISOPEN (true)', c%isopen);
    prnt.p('FOUND (true, false on last iteration)', c%found); -- %FOUND is TRUE on each successful fetch
    prnt.p('NOTFOUND (false, true o last iteration)', c%notfound); -- %NOTFOUND is FALSE on each successful fetch
    exit when c%NOTFOUND;
    counter := counter +1 ;
    prnt.p('ROWCOUNT ('||counter||')', c%rowcount); -- %ROWCOUNT increases by 1 on each fetch
  end loop;
  close c;
  prnt.p('ISOPEN (false)', c%isopen);
end;
/

set serveroutput on;
declare
  cursor c is 
    select * 
      from cursor_attributes_test
      where rownum < 3;
  r c%rowtype;    
  counter   PLS_INTEGER := 0;
begin
  prnt.p('ISOPEN (false)', c%isopen);
  for r in c loop  -- FOR CURSOR LOOP: implicity opening the explicit cursor and fetching on each iteration
    prnt.p('ISOPEN (true)', c%isopen);
    prnt.p('FOUND (true)', c%found); -- %FOUND is TRUE on each iteration
    prnt.p('NOTFOUND (false)', c%notfound); -- %NOTFOUND is FALSE on each iteration
    counter := counter +1 ;
    prnt.p('ROWCOUNT ('||counter||')', c%rowcount); -- %ROWCOUNT increases by 1 on each fetch
  end loop;
  prnt.p('ISOPEN (false)', c%isopen);
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

