CREATE OR REPLACE PROCEDURE print (n INTEGER) IS
BEGIN
  IF n IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE(n);
  ELSE
    DBMS_OUTPUT.PUT_LINE('NULL');
  END IF;
END print;
/


/*
Create_user_defined_PLSQL_records
=================================================

Record Variables
-------------------
You can create a record variable in any of these ways:

1. Define a RECORD type and then declare a variable of that type.

2. Use %TYPE to declare a record variable of the same type as a 
   previously declared record variable.

3. Use %ROWTYPE to declare a record variable that represents either 
   a full or partial row of a database table or view.

For a record variable of a RECORD type, the initial value of each 
field is NULL unless you specify a different initial value for it 
when you define the type. For a record variable declared with %TYPE, 
each field inherits the initial value of its corresponding field in 
the referenced record.

RECORD Types
---------------
A RECORD type defined in a PL/SQL block is a local type. It is available 
only in the block, and is stored in the database only if the block is in 
a standalone or package subprogram. 

A RECORD type defined in a package specification is a public item. You 
can reference it from outside the package by qualifying it with the package 
name (package_name.type_name). It is stored in the database until you 
drop the package with the DROP PACKAGE statement. 

You cannot create a RECORD type at schema level. Therefore, a RECORD type 
CANNOT be an ADT attribute data type.

To define a RECORD type, specify its name and define its fields. To define 
a field, specify its name and data type. By default, the initial value of 
a field is NULL. You can specify the NOT NULL constraint for a field, in 
which case you must also specify a non-NULL initial value. Without 
the NOT NULL constraint, a non-NULL initial value is optional.
*/
set serveroutput on;
DECLARE
  TYPE DeptRecTyp IS RECORD (
    dept_id    NUMBER(4) NOT NULL := 10,
    dept_name  VARCHAR2(30) NOT NULL := 'Administration',
    mgr_id     NUMBER(6) := 200,
    loc_id     NUMBER(4)
  );
 
  dept_rec     DeptRecTyp;
  dept_rec_2   dept_rec%TYPE;  --> CONSTRAINTS and DEFAULT VALUES are inherited
BEGIN
  DBMS_OUTPUT.PUT_LINE('dept_rec:');
  DBMS_OUTPUT.PUT_LINE('---------');
  DBMS_OUTPUT.PUT_LINE('dept_id:   ' || dept_rec.dept_id);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || dept_rec.dept_name);
  DBMS_OUTPUT.PUT_LINE('mgr_id:    ' || dept_rec.mgr_id);
  DBMS_OUTPUT.PUT_LINE('loc_id:    ' || dept_rec.loc_id);
 
  DBMS_OUTPUT.PUT_LINE('-----------');
  DBMS_OUTPUT.PUT_LINE('dept_rec_2:');
  DBMS_OUTPUT.PUT_LINE('-----------');
  DBMS_OUTPUT.PUT_LINE('dept_id:   ' || dept_rec_2.dept_id);
  DBMS_OUTPUT.PUT_LINE('dept_name: ' || dept_rec_2.dept_name);
  DBMS_OUTPUT.PUT_LINE('mgr_id:    ' || dept_rec_2.mgr_id);
  DBMS_OUTPUT.PUT_LINE('loc_id:    ' || dept_rec_2.loc_id);
END;
/

/* Nested records */
DECLARE
  TYPE name_rec IS RECORD (
    first  hr.employees.first_name%TYPE,
    last   hr.employees.last_name%TYPE
  );
 
  TYPE contact IS RECORD (
    name  name_rec,                    -- nested record
    phone hr.employees.phone_number%TYPE
  );
 
  friend contact;
BEGIN
  friend.name.first := 'John';
  friend.name.last := 'Smith';
  friend.phone := '1-650-555-1234';
  
  DBMS_OUTPUT.PUT_LINE (
    friend.name.first  || ' ' ||
    friend.name.last   || ', ' ||
    friend.phone
  );
END;
/

/*
NOTE:
A RECORD type defined in a package specification is incompatible with an 
identically defined local RECORD type. See below
*/

CREATE OR REPLACE PACKAGE pkg AS
  TYPE rec_type IS RECORD (       -- package RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4)
  );
  PROCEDURE print_rec_type (rec rec_type);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_rec_type (rec rec_type) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(rec.f1);
    DBMS_OUTPUT.PUT_LINE(rec.f2);
  END; 
END pkg;
/


DECLARE
  TYPE rec_type IS RECORD (       -- local RECORD type
    f1 INTEGER,
    f2 VARCHAR2(4)
  );
  r1 pkg.rec_type;                -- package type
  r2     rec_type;                -- local type
 
BEGIN
  r1.f1 := 10; r1.f2 := 'abcd';
  r2.f1 := 25; r2.f2 := 'wxyz';
 
  pkg.print_rec_type(r1);  -- succeeds (package type)
  pkg.print_rec_type(r2);  -- fails (local type)
END;
/

/*
 pkg.print_rec_type(r2);  -- fails
  *
ERROR at line 14:
ORA-06550: line 14, column 3:
PLS-00306: wrong number or types of arguments in call to 'PRINT_REC_TYPE'
ORA-06550: line 14, column 3:
PL/SQL: Statement ignored
*/


-- tear down
drop package pkg ;

/*
%ROWTYPE Attribute
-----------------------
The %ROWTYPE attribute lets you declare a record variable that represents either 
a full or partial row of a database table or view. For every column of the full 
or partial row, the record has a field with the same name and data type. If the 
structure of the row changes, then the structure of the record changes accordingly.

The record fields do not inherit the constraints or initial values of the 
corresponding columns (see Example 5-39).

Record Variable that Always Represents Full Row
To declare a record variable that always represents a full row of a database table or view, use this syntax:

variable_name table_or_view_name%ROWTYPE;
For every column of the table or view, the record has a field with the same name and data type.

%ROWTYPE Variable Does Not Inherit Initial Values or Constraints
*/


CREATE TABLE t1 (
  c1 INTEGER DEFAULT 0 NOT NULL,
  c2 INTEGER DEFAULT 1 NOT NULL
);
 
DECLARE
  t1_row t1%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT('t1.c1 = '); print(t1_row.c1);
  DBMS_OUTPUT.PUT('t1.c2 = '); print(t1_row.c2);
END;
/

-- tear down
DROP TABLE t1 PURGE;

/*
Record Variable that Can Represent Partial Row
-------------------------------------------------
To declare a record variable that can represent a partial row of a database table 
or view, use this syntax:

  variable_name cursor%ROWTYPE;

A cursor is associated with a query. For every column that the query selects, the 
record variable must have a corresponding, type-compatible field. If the query 
selects every column of the table or view, then the variable represents a full 
row; otherwise, the variable represents a partial row. The cursor must be either 
an EXPLICIT CURSOR or a "strong" CURSOR VARIABLE [??].

*/
SET SERVEROUTPUT ON;
DECLARE
  CURSOR c IS  --> explicit cursor
    SELECT first_name, last_name, phone_number
    FROM HR.employees;
 
  friend   c%ROWTYPE;  --> 'friend' represents a partial row
BEGIN
  friend.first_name   := 'John';
  friend.last_name    := 'Smith';
  friend.phone_number := '1-650-555-1234';
  
  DBMS_OUTPUT.PUT_LINE (
    friend.first_name  || ' ' ||
    friend.last_name   || ', ' ||
    friend.phone_number
  );
END;
/


DECLARE
  CURSOR c2 IS
    SELECT employee_id, email, employees.manager_id, location_id
    FROM employees, departments
    WHERE employees.department_id = departments.department_id;
  
  join_rec c2%ROWTYPE;  -- includes columns from two tables
  
BEGIN
  NULL;
END;
/

/*
%ROWTYPE Attribute and Virtual Columns
----------------------------------------
If you use the %ROWTYPE attribute to define a record variable that represents a 
full row of a table that has a virtual column, then you cannot insert that record 
into the table. Instead, you must insert the individual record fields into the 
table, excluding the virtual column.

Example 5-42 creates a record variable that represents a full row of a table that 
has a virtual column, populates the record, and inserts the record into the table, 
causing ORA-54013.
*/

CREATE TABLE plch_departure (
  destination    VARCHAR2(100),
  departure_time DATE,
  delay          NUMBER(10),
  expected       GENERATED ALWAYS AS (departure_time + delay/24/60/60)
);

set SERVEROUTPUT ON 
DECLARE
 dep_rec   plch_departure%ROWTYPE; --> full record variable
BEGIN
  dep_rec.destination := 'X'; 
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay := 1500;
  
  INSERT INTO plch_departure VALUES dep_rec; --> ERROR: Attempted to insert values into a virtual column
END;
/

/*
Correct way of inserting rows on tables with virtual columns:

** NOTICE **
the virtual column in the record variable does not generate any value. Values
are generate only within the table row 
***
*/
DECLARE
  dep_rec      plch_departure%ROWTYPE; --> full record variable
  v_expected   plch_departure.expected%TYPE;
BEGIN
  dep_rec.destination := 'X'; 
  dep_rec.departure_time := SYSDATE;
  dep_rec.delay := 1500;
  
  dbms_output.put_line('expected='||dep_rec.expected);
 
  INSERT INTO plch_departure (destination, departure_time, delay)
  VALUES (dep_rec.destination, dep_rec.departure_time, dep_rec.delay);
  commit;
  select expected into v_expected from plch_departure where rownum = 1;
  dbms_output.put_line('expected='||v_expected);
END;
/

-- tear down
DROP TABLE plch_departure PURGE;

/*
Assigning Values to Record Variables

In this topic, record variable means either a record variable or a record 
component of a composite variable (for example, friend.name in Example 5-35).

** To any record variable, you can assign a value to each field individually.

** In some cases, you can assign the value of one record variable to another 
   record variable.

** If a record variable represents a full or partial row of a database table or 
   view, you can assign the represented row to the record variable.

Assigning One Record Variable to Another
------------------------------------------
You can assign the value of one record variable to another record variable only 
in these cases:

- The two variables have the same RECORD type (as in Example 5-44).
- The target variable is declared with a RECORD type, the source variable is 
  declared with %ROWTYPE, their fields match in number and order, and 
  corresponding fields have THE SAME data type (as in Example 5-45).
- For record components of composite variables, the types of the composite 
  variables need not match (see Example 5-46).


Example 5-44 Assigning Record to Another Record of Same RECORD Type
*/ 
DECLARE
  TYPE name_rec IS RECORD (
    first  hr.employees.first_name%TYPE DEFAULT 'John',
    last   hr.employees.last_name%TYPE DEFAULT 'Doe'
  );
 
  name1  name_rec; 
  name2  name_rec;
 
BEGIN
  name1.first := 'Jane'; name1.last := 'Smith'; 
  DBMS_OUTPUT.PUT_LINE('name1: ' || name1.first || ' ' || name1.last);
  name2 := name1; --> 'name1' and 'name2' have tha same type
  DBMS_OUTPUT.PUT_LINE('name2: ' || name2.first || ' ' || name2.last); 
END;
/


/*

Example 5-45 Assigning "%ROWTYPE record" to "RECORD Type record"
*/

DECLARE
  TYPE name_rec1 IS RECORD (
    first  hr.employees.first_name%TYPE DEFAULT 'John',
    last   hr.employees.last_name%TYPE DEFAULT 'Doe'
  );
 
  TYPE name_rec2 IS RECORD (
    first  varchar2(100),
    last   varchar2(100)
  );
 
  CURSOR c IS
    SELECT first_name, last_name
    FROM hr.employees;
 
  target1 name_rec1;
  target2 name_rec2;
  source c%ROWTYPE;
 
BEGIN
  source.first_name := 'Jane'; source.last_name := 'Smith';
 
  DBMS_OUTPUT.PUT_LINE (
    'source: ' || source.first_name || ' ' || source.last_name
  );
 
 target1 := source; -- the two variables have the same structure
 
 DBMS_OUTPUT.PUT_LINE (
   'target1: ' || target1.first || ' ' || target1.last
 );

 target2 := source; -- the two variables have compatible structures
 
 DBMS_OUTPUT.PUT_LINE (
   'target2: ' || target2.first || ' ' || target2.last
 );
END;
/

/*
the following example assigns the value of one nested record to another nested 
record. The nested records have the same RECORD type, but the records in which 
they are nested do not.
*/
DECLARE
  TYPE name_rec IS RECORD (
    first  hr.employees.first_name%TYPE,
    last   hr.employees.last_name%TYPE
  );
 
  TYPE phone_rec IS RECORD (
    name  name_rec,                    -- nested record
    phone hr.employees.phone_number%TYPE
  );
 
  TYPE email_rec IS RECORD (
    name  name_rec,                    -- nested record
    email hr.employees.email%TYPE
  );

  phone_contact phone_rec;
  email_contact email_rec;
 
BEGIN
  phone_contact.name.first := 'John';
  phone_contact.name.last := 'Smith';
  phone_contact.phone := '1-650-555-1234';
 
  email_contact.name := phone_contact.name;
  email_contact.email := (
    email_contact.name.first || '.' ||
    email_contact.name.last  || '@' ||
    'example.com' 
  );

  DBMS_OUTPUT.PUT_LINE (email_contact.email);
END;
/


/*
Assigning Full or Partial Rows to Record Variables
======================================================
If a record variable represents a full or partial row of a database table or view, 
you can assign the represented row to the record variable.

SELECT INTO Statement for Assigning Row to Record Variable
-----------------------------------------------------------
SELECT select_list INTO record_variable_name FROM table_or_view_name;

*** 
For each column in select_list, the record variable must have a corresponding, 
type-compatible field. 
*** 
The columns in select_list must appear in the same order as the record fields.

*/

DECLARE
  TYPE RecordTyp IS RECORD (
    last hr.employees.last_name%TYPE,
    id   hr.employees.employee_id%TYPE
  );
  rec1   RecordTyp;
BEGIN
  SELECT last_name, employee_id INTO rec1
  FROM hr.employees
  WHERE job_id = 'AD_PRES';

  DBMS_OUTPUT.PUT_LINE ('Employee #' || rec1.id || ' = ' || rec1.last);
END;
/

/*
FETCH Statement for Assigning Row to Record Variable
-------------------------------------------------------
The syntax of a simple FETCH statement is:

  FETCH cursor INTO record_variable_name;

A cursor is associated with a query. For every column that the query selects, 
the record variable must have a corresponding, type-compatible field. The cursor 
must be either an explicit cursor or a strong cursor variable.
*/


DECLARE
  TYPE EmpRecTyp IS RECORD (
    emp_id  hr.employees.employee_id%TYPE,
    salary  hr.employees.salary%TYPE
  );
  
  CURSOR desc_salary RETURN EmpRecTyp IS --> NOTICE the RETURN clause
    SELECT employee_id, salary
    FROM hr.employees
    ORDER BY salary DESC;
    
  highest_paid_emp       EmpRecTyp;
  next_highest_paid_emp  EmpRecTyp;
 
  FUNCTION nth_highest_salary (n INTEGER) RETURN EmpRecTyp IS
    emp_rec  EmpRecTyp;
  BEGIN
    OPEN desc_salary;
    FOR i IN 1..n LOOP
      FETCH desc_salary INTO emp_rec;
    END LOOP;
    CLOSE desc_salary;
    RETURN emp_rec;
  END nth_highest_salary;
 
BEGIN
  highest_paid_emp := nth_highest_salary(1);
  next_highest_paid_emp := nth_highest_salary(2);
 
  DBMS_OUTPUT.PUT_LINE(
    'Highest Paid: #' ||
    highest_paid_emp.emp_id || ', $' ||
    highest_paid_emp.salary 
  );
  DBMS_OUTPUT.PUT_LINE(
    'Next Highest Paid: #' ||
    next_highest_paid_emp.emp_id || ', $' ||
    next_highest_paid_emp.salary
  );
END;
/


/*
SQL Statements that Return Rows in PL/SQL Record Variables
------------------------------------------------------------------
The SQL statements INSERT, UPDATE, and DELETE have an optional RETURNING INTO clause that can return the affected row in a PL/SQL record variable. For information about this clause, see "RETURNING INTO Clause".

In Example 5-49, the UPDATE statement updates the salary of an employee and returns the name and new salary of the employee in a record variable.

Example 5-49 UPDATE Statement Assigns Values to Record Variable
*/

-- set up
create table employees as select * from hr.employees ;

DECLARE
  TYPE EmpRec IS RECORD (
    last_name  employees.last_name%TYPE,
    salary     employees.salary%TYPE
  );
  emp_info    EmpRec;
  old_salary  employees.salary%TYPE;
BEGIN
  SELECT salary INTO old_salary
   FROM employees
   WHERE employee_id = 100;
 
  UPDATE employees
    SET salary = salary * 1.1
    WHERE employee_id = 100
    RETURNING last_name, salary INTO emp_info; --> RETURNING INTO clause
 
  DBMS_OUTPUT.PUT_LINE (
    'Salary of ' || emp_info.last_name || ' raised from ' ||
    old_salary || ' to ' || emp_info.salary
  );
END;
/

drop table employees purge ;

/*
Assigning NULL to Record Variable
-----------------------------------
Assigning the value NULL to a record variable assigns the value NULL to each of 
its fields. This assignment is recursive; that is, if a field is a record, then 
its fields are also assigned the value NULL.
*/
DECLARE
  TYPE age_rec IS RECORD (
    years  INTEGER DEFAULT 35,
    months INTEGER DEFAULT 6
  );
 
  TYPE name_rec IS RECORD (
    first  hr.employees.first_name%TYPE DEFAULT 'John',
    last   hr.employees.last_name%TYPE DEFAULT 'Doe',
    age    age_rec
  );
 
  name  name_rec;
 
  PROCEDURE print_name AS
  BEGIN
    DBMS_OUTPUT.PUT(NVL(name.first, 'NULL') || ' '); 
    DBMS_OUTPUT.PUT(NVL(name.last,  'NULL') || ', ');
    DBMS_OUTPUT.PUT(NVL(TO_CHAR(name.age.years), 'NULL') || ' yrs ');
    DBMS_OUTPUT.PUT_LINE(NVL(TO_CHAR(name.age.months), 'NULL') || ' mos');
  END;
 
BEGIN
  print_name;
  name := NULL; -- recursively assigns NULL to all the fields of the record and nested recors too
  print_name;
END;
/

/*
Record Comparisons
==============================================
Records cannot be tested natively for nullity, equality, or inequality. 
These BOOLEAN expressions are illegal:

  My_Record IS NULL
  My_Record_1 = My_Record_2
  My_Record_1 > My_Record_2

You must write your own functions to implement such tests. 


Inserting Records into Tables
================================================
The PL/SQL extension to the SQL INSERT statement lets you insert a record into a 
table. The record must represent a row of the table. For more information, see 
"INSERT Statement Extension". For restrictions on inserting records into tables, 
see "Restrictions on Record Inserts and Updates".

To efficiently insert a collection of records into a table, put the INSERT 
statement inside a FORALL statement. For information about the FORALL statement, 
see "FORALL Statement".
*/

-- set up
CREATE TABLE schedule (
  week  NUMBER,
  Mon   VARCHAR2(10),
  Tue   VARCHAR2(10),
  Wed   VARCHAR2(10),
  Thu   VARCHAR2(10),
  Fri   VARCHAR2(10),
  Sat   VARCHAR2(10),
  Sun   VARCHAR2(10)
);
 
DECLARE
  default_week  schedule%ROWTYPE;
  i             NUMBER;
BEGIN
  default_week.Mon := '0800-1700';
  default_week.Tue := '0800-1700';
  default_week.Wed := '0800-1700';
  default_week.Thu := '0800-1700';
  default_week.Fri := '0800-1700';
  default_week.Sat := 'Day Off';
  default_week.Sun := 'Day Off';
 
  FOR i IN 1..6 LOOP
    default_week.week    := i;
    
    INSERT INTO schedule VALUES default_week;
  END LOOP;
END;
/

-- tear down
DROP TABLE schedule purge;


/*
Restrictions on Record Inserts and Updates
------------------------------------------------------------
These restrictions apply to record inserts and updates:

1. Record variables are allowed only in these places:

   - On the right side of the SET clause in an UPDATE statement
   - In the VALUES clause of an INSERT statement
   - In the INTO subclause of a RETURNING clause

   Record variables are not allowed in a SELECT list, WHERE clause, GROUP BY clause, 
   or ORDER BY clause.

2. The keyword ROW is allowed only on the left side of a SET clause.
   Also, you cannot use ROW with a subquery.

3. In an UPDATE statement, only one SET clause is allowed if ROW is used.

4. If the VALUES clause of an INSERT statement contains a record variable, no 
   other variable or value is allowed in the clause.

5. If the INTO subclause of a RETURNING clause contains a record variable, no 
   other variable or value is allowed in the subclause.

6. These are not supported:

   - Nested RECORD types
   - Functions that return a RECORD type
   - Record inserts and updates using the EXECUTE IMMEDIATE statement.
*/

