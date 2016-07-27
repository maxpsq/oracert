

set serveroutput on;
declare
  cursor c( mgr_id in hr.employees.manager_id%type ) is
    select * from hr.employees 
     where manager_id > mgr_id ;
  r c%rowtype;   
begin
  open c(200);
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.first_name||' '||r.last_name);
  end loop;
  close c;
  dbms_output.put_line(lpad('=',30,'='));
  open c(148);
  loop
    fetch c into r;
    exit when c%notfound;
    dbms_output.put_line(r.first_name||' '||r.last_name);
  end loop;
  close c;
end;
/
