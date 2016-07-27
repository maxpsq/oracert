/*
Use_collections_methods

*/

/* FIRST and LAST */
set serveroutput on;
declare
   TYPE collection_aat is   TABLE OF varchar2(10) INDEX BY BINARY_INTEGER;
   TYPE collection_ntt is   TABLE OF varchar2(10);
   TYPE collection_vat is   VARRAY(5) of varchar2(10);
   
   collection_aa   collection_aat ;
   collection_nt   collection_ntt ;
   collection_va   collection_vat ;
begin
   dbms_output.put_line('====== UNINITIALIZED COLLECTIONs TEST ======');
   dbms_output.put_line('collection_aa.FIRST(*)='||collection_aa.first);
   dbms_output.put_line('collection_aa.LAST(*)='||collection_aa.last);
   begin
     dbms_output.put_line('collection_nt.FIRST='||collection_nt.first);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_nt.FIRST -> Collection is null');
   end;
   begin
     dbms_output.put_line('collection_nt.LAST='||collection_nt.LAST);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_nt.LAST -> Collection is null');
   end;
   begin
     dbms_output.put_line('collection_va.FIRST='||collection_va.first);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_va.FIRST -> Collection is null');
   end;
   begin
     dbms_output.put_line('collection_va.LAST='||collection_va.LAST);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_va.LAST -> Collection is null');
   end;
   dbms_output.put_line('======= EMPTY COLLECTIONs TEST =======');
   collection_nt  := collection_ntt();
   collection_va  := collection_vat();
   dbms_output.put_line('(*)collection_aa.FIRST='||collection_aa.first);
   dbms_output.put_line('(*)collection_aa.LAST='||collection_aa.last);
   dbms_output.put_line('collection_nt.FIRST='||collection_nt.first);
   dbms_output.put_line('collection_nt.LAST='||collection_nt.last);
   dbms_output.put_line('collection_va.FIRST='||collection_va.first);
   dbms_output.put_line('collection_va.LAST='||collection_va.last);

   dbms_output.put_line('======= NON EMPTY COLLECTIONs TEST =======');
   for i in 1.. 3 loop
   dbms_output.put_line('Containing '||i||' elements...');
   collection_aa(i) := lpad('A',i,'A');
   collection_nt.extend;
   collection_nt(collection_nt.FIRST) := lpad('N',i,'N');
   collection_va.extend;
   collection_va(collection_va.FIRST) := lpad('V',i,'V');
   dbms_output.put_line('(*)collection_aa.FIRST='||collection_aa.first);
   dbms_output.put_line('(*)collection_aa.LAST='||collection_aa.last);
   dbms_output.put_line('collection_nt.FIRST='||collection_nt.first);
   dbms_output.put_line('collection_nt.LAST='||collection_nt.last);
   dbms_output.put_line('collection_va.FIRST='||collection_va.first);
   dbms_output.put_line('collection_va.LAST='||collection_va.last);
   end loop;
end;
/

/* LIMIT */
set serveroutput on;
declare
   TYPE collection_aat is   TABLE OF varchar2(10) INDEX BY BINARY_INTEGER;
   TYPE collection_ntt is   TABLE OF varchar2(10);
   TYPE collection_vat is   VARRAY(5) of varchar2(10);
   
   collection_aa   collection_aat ;
   collection_nt   collection_ntt ;
   collection_va   collection_vat ;
begin
   dbms_output.put_line('====== UNINITIALIZED COLLECTIONs TEST ======');
   dbms_output.put_line('collection_aa.LIMIT(*)='||collection_aa.LIMIT);
   begin
     dbms_output.put_line('collection_nt.LIMIT='||collection_nt.LIMIT);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_nt.LIMIT -> Collection is null');
   end;
   begin
     dbms_output.put_line('collection_va.LIMIT='||collection_va.LIMIT);
   exception
     when collection_is_null THEN
       dbms_output.put_line('collection_va.LIMIT -> Collection is null');
   end;
   dbms_output.put_line('======= EMPTY COLLECTIONs TEST =======');
   collection_nt  := collection_ntt();
   collection_va  := collection_vat();
   dbms_output.put_line('(*)collection_aa.LIMIT='||collection_aa.LIMIT);
   dbms_output.put_line('collection_nt.LIMIT='||collection_nt.LIMIT);
   dbms_output.put_line('collection_va.LIMIT='||collection_va.LIMIT);

   dbms_output.put_line('======= NON EMPTY COLLECTIONs TEST =======');
   for i in 1.. 3 loop
   dbms_output.put_line('Containing '||i||' elements...');
   collection_aa(i) := lpad('A',i,'A');
   collection_nt.extend;
   collection_nt(collection_nt.FIRST) := lpad('N',i,'N');
   collection_va.extend;
   collection_va(collection_va.FIRST) := lpad('V',i,'V');
   dbms_output.put_line('(*)collection_aa.LIMIT='||collection_aa.LIMIT);
   dbms_output.put_line('collection_nt.LIMIT='||collection_nt.LIMIT);
   dbms_output.put_line('collection_va.LIMIT='||collection_va.LIMIT);
   end loop;
end;
/

/* TRIM 
TRIMming an associative array will produce a compile-time error
*/
set serveroutput on;
declare
   TYPE collection_aat is   TABLE OF varchar2(10) INDEX BY PLS_INTEGER;
   
   collection_aa   collection_aat ;
begin
   collection_aa.TRIM(1);
end;
/

set serveroutput on;
declare
   TYPE collection_ntt is   TABLE OF varchar2(10);
   TYPE collection_vat is   VARRAY(5) of varchar2(10);
   
   collection_nt   collection_ntt := collection_ntt('a', 'b', 'c', 'd');
   collection_va   collection_vat := collection_vat('a', 'b', 'c', 'd');
begin
   collection_nt.delete(4); -- deletes the 4th element (and leave a placeholder)
   collection_nt.TRIM(); -- removes the placeholder for the 4th element
   dbms_output.put_line('collection_nt.COUNT='||collection_nt.COUNT);
   dbms_output.put_line('collection_nt.LAST='||collection_nt.LAST);

   -- DELETE for VARRAYs takes NO ARGUMENTs and delete ALL elements
   collection_va.TRIM(); -- removes the 4th element
   dbms_output.put_line('collection_va.COUNT='||collection_va.COUNT);
   dbms_output.put_line('collection_va.LAST='||collection_va.LAST);
end;
/

/* NOT NULL constraint */
set serveroutput on;
declare
   TYPE collection_ntt is   TABLE OF varchar2(10) NOT NULL; 
   
   collection_nt   collection_ntt := collection_ntt('a', 'b', 'c', 'd');
begin
   collection_nt.delete(4); -- deletes the 4th element (and leave a placeholder)
   dbms_output.put_line('collection_nt.COUNT='||collection_nt.COUNT);
   dbms_output.put_line('collection_nt.LAST='||collection_nt.LAST);
   collection_nt(21):= null; -- attempts to set NULL as the 4th element, ERROR !!
   dbms_output.put_line('collection_nt.COUNT='||collection_nt.COUNT);
   dbms_output.put_line('collection_nt.LAST='||collection_nt.LAST);
end;
/
