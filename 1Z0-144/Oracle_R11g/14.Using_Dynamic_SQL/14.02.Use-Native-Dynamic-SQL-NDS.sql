/*
Dynamic SQL method 2 (INSERT, UPDATE, DELETE, MERGE) ** NO SELECT **

EXECUTE IMMEDIATE .. USING fixed number of bind variables

*/
create table to_be_updated (dummy number);
insert into to_be_updated select level from dual connect by level < 10;
commit;

SET SERVEROUTPUT ON;
declare
  v_sql_GOOD    VARCHAR2(4000);
  v_sql_BAD    VARCHAR2(4000);

  FUNCTION qry(stmt in VARCHAR2, lo IN NUMBER, hi IN NUMBER) RETURN NUMBER IS
  BEGIN
    EXECUTE IMMEDIATE stmt USING lo, hi ;
    return sql%rowcount;
  END;

begin
  v_sql_GOOD := 'UPDATE to_be_updated a SET a.dummy = a.dummy * 2 WHERE a.dummy BETWEEN :lo AND :hi';
  DBMS_OUTPUT.PUT_LINE( 'GOOD 1: '||qry( v_sql_GOOD, 7, 9) ); 
  DBMS_OUTPUT.PUT_LINE( 'GOOD 2: '||qry( v_sql_GOOD, 1, NULL) ); 
  
  -- You cannot pass NULL to a bind variable because it needs to have a TYPE defined...
  EXECUTE IMMEDIATE v_sql_GOOD USING 1, NULL ;
  DBMS_OUTPUT.PUT_LINE( 'NULL: '|| sql%rowcount ); 
  -- .. using CAST will work
  EXECUTE IMMEDIATE v_sql_GOOD USING 1, cast(NULL as NUMBER);
  DBMS_OUTPUT.PUT_LINE( 'CAST: '|| sql%rowcount ); 
  -- Passing NULL as argument to a procdure, will be fine
  DBMS_OUTPUT.PUT_LINE( 'NULL to ROUTINE: '||qry( v_sql_GOOD, 1, NULL) ); 
end;
/
ROLLBACK;


/*
Method 2 in conjunction with RETURNING clause 
RETURNING target variable must be specified as [OUT|IN OUT] within the USING clause
*/
SET SERVEROUTPUT ON;
declare
  v_sql_GOOD    VARCHAR2(4000);
  v_sql_BAD    VARCHAR2(4000);

  FUNCTION qry(stmt in VARCHAR2, dm IN NUMBER) RETURN NUMBER IS
    res  NUMBER;
  BEGIN
    EXECUTE IMMEDIATE stmt USING dm, OUT res ;
    return res;
  END;

begin
  v_sql_GOOD := 'UPDATE to_be_updated a SET a.dummy = a.dummy * a.dummy WHERE a.dummy = :dm RETURNING a.dummy INTO :new_dummy';
  DBMS_OUTPUT.PUT_LINE( 'GOOD: '||qry( v_sql_GOOD, 4 )); 
end;
/



/*
Dynamic SQL method 3 (SINGLE ROW)

EXECUTE IMMEDIATE .. INTO .. USING

*/

SET SERVEROUTPUT ON;
declare
  v_sql_GOOD    VARCHAR2(4000);
  v_sql_BAD    VARCHAR2(4000);

  FUNCTION qry(stmt in VARCHAR2, lo IN DATE, hi IN DATE) RETURN NUMBER IS
    hits  NUMBER;
  BEGIN
    EXECUTE IMMEDIATE stmt INTO hits USING lo, hi ;
    return hits;
  END;

begin
  v_sql_GOOD := 'SELECT COUNT(1) FROM HR.EMPLOYEES WHERE hire_date between :lo AND :hi';
  v_sql_BAD := 'SELECT COUNT(1) FROM HR.EMPLOYEES WHERE hire_date between :lo AND :hi ;'; -- SEMICOLON AT THE END OF SQL STMT
  DBMS_OUTPUT.PUT_LINE( 'GOOD: '||qry( v_sql_GOOD, '13-ago-97', '11-lug-98') ); 
  DBMS_OUTPUT.PUT_LINE( 'BAD:  '||qry( v_sql_BAD , '13-ago-97', '11-lug-98') ); 
end;
/


/*
Dynamic SQL method 3 (MULTIPLE ROWS)

1. EXECUTE IMMEDIATE .. BULK COLLECT INTO .. USING

2. OPEN .. FOR .. USING

*/

declare
  stmt VARCHAR2(4000);
  TYPE employees_nt IS TABLE OF HR.EMPLOYEES%ROWTYPE;
  my_employees  employees_nt;
  rec  HR.EMPLOYEES%ROWTYPE;
  cv  SYS_REFCURSOR;
  
  procedure print_collection( coll IN employees_nt) is
  begin
    if coll.COUNT > 0 then
      for i in coll.first .. coll.last loop
        dbms_output.put_line(coll(i).last_name);
      end loop;
    end if;
  end;
begin
  stmt := 'SELECT * FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = :dpt';
  
  EXECUTE IMMEDIATE stmt BULK COLLECT INTO my_employees USING 90;
  
  print_collection(my_employees);
  
  dbms_output.put_line(lpad('=',30,'='));
  
  open cv for stmt using 90;
  -- fetching through a loop
  loop
    fetch cv into rec;
    exit when cv%notfound;
    dbms_output.put_line(rec.last_name);
  end loop;  
  close cv;

  dbms_output.put_line(lpad('=',30,'='));
  
  open cv for stmt using 90;
  -- fetching by BULK COLLECT
  fetch cv bulk collect into my_employees;
  print_collection(my_employees);
  close cv;
end;
/


/*
Binding vaiables
================================================================================

Only values can be bind! in case you try to bing column names, schema names, object
names or objct types it won't be possible to check for the correct syntax of the
SQL or PL/SQL string.
You must use string concatenation instead:
*/


create table to_be_dropped (dummy  varchar2(1));

declare
  PROCEDURE DROP_STMT(OBJ_TYPE IN VARCHAR2, OBJ_NAME IN VARCHAR2) IS
    v_sql    VARCHAR2(4000);
  BEGIN
    v_sql := 'DROP :obj_type :obj_name'; -- 03290. 00000 -  "Invalid truncate command - missing CLUSTER or TABLE keyword"
    EXECUTE IMMEDIATE v_sql USING 'TABLE', 'to_be_dropped' ;
  END;
begin
  DROP_STMT( 'TABLE', 'to_be_dropped'); 
end;
/

declare
  PROCEDURE DROP_STMT(OBJ_TYPE IN VARCHAR2, OBJ_NAME IN VARCHAR2) IS
    v_sql    VARCHAR2(4000);
  BEGIN
    v_sql := 'DROP '||obj_type||' '||obj_name ; -- SUCCESS!
    EXECUTE IMMEDIATE v_sql ;
  END;
begin
  DROP_STMT( 'TABLE', 'to_be_dropped'); 
end;
/

