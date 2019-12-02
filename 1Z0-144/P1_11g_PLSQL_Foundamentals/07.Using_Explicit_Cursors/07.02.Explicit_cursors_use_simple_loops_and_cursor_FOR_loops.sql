
/*
The FETCH statement performs three operations:
1. retrieve the current row from the cursor
2. stores the column values of that row into the variable or record
3. advances the cursor to the next row
*/


set serveroutput on;
declare
  cursor c is
    select * from hr.employees 
     where manager_id > 200;
  r c%rowtype;   
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.first_name||' '||r.last_name);
  end loop;
  close c;
end;
/

/*
The simple way to retrieve the results from an explicit cursor is to use the
CURSOR FOR LOOP. Notice this construct will limit the control on the cursor compared
to the OPEN-FETCH-CLOSE approach.
*/
set serveroutput on
declare
  cursor c is
    select * from hr.employees 
     where manager_id > 200;
begin  
  for r in c loop
    dbms_output.put_line(r.first_name||' '||r.last_name);
  end loop;
end;
/

/* fetching into a variable list */
declare
cursor c is
select first_name, last_name
  from hr.employees ;
l_first_name    hr.employees.first_name%type;
l_last_name     hr.employees.last_name%type;
begin
  open c;
  loop
    fetch c into l_first_name, l_last_name;
    exit when c%notfound;
  end loop;
  close c;
end;
/

set serveroutput on;
declare
cursor c is
select sum(salary) as "sum(salary)"
  from hr.employees ;
  r  c%rowtype;
begin
  open c;
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r."sum(salary)");
  end loop;
  close c;
end;
/