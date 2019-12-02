/*
A SELECT FOR UPDATE locks the rows at the precise moment that they are selected
(cursor opening). The FOR UPDATE clause guaratees nobody else can change the rows
from your cursor until you end the transaction (either by COMMIT or ROLLBACK).

Here some important aspects about the SELECT FOR UPDATE command:

** BY DEFAULT, SELECT FOR UPDATE will wait until all the rows are released by other 
locks issued by other sessions before its execution. This behaviour can be changed 
using NO WAIT, WAIT, SKIP LOCKED clauses.

** The FOR UPDATE clause locks all the rows retrieved from the SELECT statement
during the OPEN operation.

** The rows are UNLOCKED when you end the transaction (COMMIT or ROLLBACK)

** Once a COMMIT or ROLLBACK occours (even implicitly), you cannot fetch any more 
rows from the FOR UPDATE cursor.

** When SELECT FOR UPDATE queryes more tables, it locks only the rows whose columns
appear in the FOR UPDATE clause (see the examples below for further details)

** Only one FOR UPDATE clause may appear in a WHERE CURRENT OF clause of an UPDATE
or DELETE statement.

*/

/*
SELECT ... FOR UPDATE / SELECT ... FOR UPDATE OF
*/
set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/


declare
cursor c is
select FIRST_NAME 
  from hr.employees e
  inner join hr.departments d
    on e.department_id = d.department_id
  FOR UPDATE;  --> both employees and departments are locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/

declare
cursor c is
select FIRST_NAME 
  from hr.employees e
  inner join hr.departments d
    on e.department_id = d.department_id
  FOR UPDATE OF e.salary;  --> rows from employees are locked, row from departments are not
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/


declare
cursor c is
select FIRST_NAME 
  from hr.employees e
  inner join hr.departments d
    on e.department_id = d.department_id
  FOR UPDATE OF E.SALARY, d.department_name;  -- both employees and departments are locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/

/*
Releasing rows with COMMIT or ROLLBACK
*/
-- COMMIt
set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
    commit; --> After commit, the secontìd fetch will fail !!! 01002. 00000 -  "fetch out of sequence"
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/

-- ROLLBACK
set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
    rollback; --> After ROLLBACK, the secontìd fetch will fail !!! 01002. 00000 -  "fetch out of sequence"
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/




-- IMPLICIT COMMIT
create table DUMMY_TAB (dummy  NUMBER(3));

set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.FIRST_NAME);
    execute immediate 'ALTER TABLE DUMMY_TAB modify dummy NUMBER(5)'; --> this issues an implicit commit
  end loop;
  dbms_lock.sleep(20);
  close c;
  rollback;
end;
/

drop table DUMMY_TAB purge;

/*
WHERE CURRENT OF

A CURRENT OF clause of an UPDATE or DELETE statement can referer only to one 
FOR UPDATE CURSOR.
The WHERE CURRENT OF clause is an extension of the WHERE clause of UPDATE/DELETE
statements that restricts the statement tu the current row of the FOR UPDATE cursor.

*/

set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees e
 where e.manager_id > 200 
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    UPDATE HR.EMPLOYEES E SET E.FIRST_NAME = '<UNKNOWN>' 
    WHERE CURRENT OF c ;
  end loop;
  close c;
  rollback;
end;
/

set serveroutput on;
declare
cursor c is
select FIRST_NAME 
  from hr.employees e
 where e.manager_id > 200 
  FOR UPDATE; --> hr.employees is locked
  r  c%rowtype;
begin
  for r in c loop
    UPDATE HR.EMPLOYEES E SET E.FIRST_NAME = '<UNKNOWN>' 
    WHERE CURRENT OF c ;
  end loop;
  rollback;
end;
/

