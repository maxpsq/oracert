/*
Varrays (Variable-Size Arrays)
---------------------------------
A varray (variable-size array) is an array whose number of 
elements can vary from zero (empty) to the declared maximum 
size. To access an element of a varray variable, use the 
syntax variable_name(index). The lower bound of index is 1; 
the upper bound is the current number of elements. The upper 
bound changes as you add or delete elements, but it cannot 
exceed the maximum size. When you store and retrieve a varray 
from the database, its indexes and element order remain stable.

Figure 5-1shows a varray variable named Grades, which has 
maximum size 10 and contains seven elements. Grades(n) references 
the nth element of Grades. The upper bound of Grades is 7, and 
it cannot exceed 10.

Figure 5-1 Varray of Maximum Size 10 with 7 Elements

Description of Figure 5-1 follows
Description of "Figure 5-1 Varray of Maximum Size 10 with 7 Elements"

The database stores a varray variable as a single object. If a 
varray variable is less than 4 KB, it resides inside the table 
of which it is a column; otherwise, it resides outside the table 
but in the same tablespace.

An uninitialized varray variable is a null collection. You must 
initialize it, either by making it empty or by assigning a non-NULL 
value to it. For details, see "Collection Constructors" and 
"Assigning Values to Collection Variables".

Example 5-4 defines a local VARRAY type, declares a variable of that 
type (initializing it with a constructor), and defines a procedure 
that prints the varray. The example invokes the procedure three times: 
After initializing the variable, after changing the values of two 
elements individually, and after using a constructor to the change 
the values of all elements. (For an example of a procedure that prints 
a varray that might be null or empty, see Example 5-24.)

Example 5-4 Varray (Variable-Size Array)
*/
DECLARE
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);  -- VARRAY type
 
  -- varray variable initialized with constructor:
 
  team Foursome := Foursome('John', 'Mary', 'Alberto', 'Juanita');
 
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN 1..4 LOOP
      DBMS_OUTPUT.PUT_LINE(i || '.' || team(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
  
BEGIN 
  print_team('2001 Team:');
 
  team(3) := 'Pierre';  -- Change values of two elements
  team(4) := 'Yvonne';
  print_team('2005 Team:');
 
  -- Invoke constructor to assign new values to varray variable:
 
  team := Foursome('Arun', 'Amitha', 'Allan', 'Mae');
  print_team('2009 Team:');
END;
/

/*
Appropriate Uses for Varrays
A varray is appropriate when:

- You know the maximum number of elements.
- You usually access the elements sequentially.
Because you must store or retrieve all elements at the same time, a varray 
might be impractical for large numbers of elements.




Oracle SQL reference Varrays
http://docs.oracle.com/cd/E11882_01/server.112/e41084/sql_elements001.htm#SQLRF51007
-----------------------------------
An array is an ordered set of data elements. All elements of a 
given array are of the same data type. Each element has an index, 
which is a number corresponding to the position of the element in 
the array.

The number of elements in an array is the size of the array. Oracle 
arrays are of variable size, which is why they are called varrays. 
You must specify a maximum size when you declare the varray.

When you declare a varray, it does not allocate space. It defines a 
type, which you can use as:

- The data type of a column of a relational table
- An object type attribute
- A PL/SQL variable, parameter, or function return type

Oracle normally stores an array object either in line (as part of 
the row data) or out of line (in a LOB), depending on its size. 
However, if you specify separate storage characteristics for a varray, 
then Oracle stores it out of line, regardless of its size. Refer to 
the varray_col_properties of CREATE TABLE for more information about 
varray storage.




SQL's CREATE TABLE command varray_col_properties
http://docs.oracle.com/cd/E11882_01/server.112/e41084/statements_7002.htm#i2143624
--------------------------------------------------
The varray_col_properties let you specify separate storage characteristics 
for the LOB in which a varray will be stored. If varray_item is a multilevel 
collection, then the database stores all collection items nested within 
varray_item in the same LOB in which varray_item is stored.

For a nonpartitioned table—when specified in the physical_properties clause 
without any of the partitioning clauses—this clause specifies the storage 
attributes of the LOB data segments of the varray.

For a partitioned table specified at the table level—when specified in the 
physical_properties clause along with one of the partitioning clauses—this 
clause specifies the default storage attributes for the varray LOB data segments 
associated with each partition (or its subpartitions, if any).

For an individual partition of a partitioned table—when specified as part of a 
table_partition_description—this clause specifies the storage attributes of the 
varray LOB data segments of that partition or the default storage attributes of 
the varray LOB data segments of any subpartitions of this partition. 
A partition-level varray_col_properties overrides a table-level varray_col_properties.

For an individual subpartition of a partitioned table—when specified 
as part of subpartition_by_hash or subpartition_by_list—this clause 
specifies the storage attributes of the varray data segments of this 
subpartition. A subpartition-level varray_col_properties overrides 
both partition-level and table-level varray_col_properties.

*/
/*
Nested Tables
=================
In the database, a nested table is a column type that stores an 
unspecified number of rows in no particular order. When you retrieve 
a nested table value from the database into a PL/SQL nested table 
variable, PL/SQL gives the rows consecutive indexes, starting at 1. 
Using these indexes, you can access the individual rows of the nested 
table variable. The syntax is variable_name(index). The indexes and 
row order of a nested table might not remain stable as you store and 
retrieve the nested table from the database.

The amount of memory that a nested table variable occupies can increase 
or decrease dynamically, as you add or delete elements.

An uninitialized nested table variable is a null collection. You must 
initialize it, either by making it empty or by assigning a non-NULL 
value to it. For details, see "Collection Constructors" and "Assigning 
Values to Collection Variables".

Example 5-5 defines a local nested table type, declares a variable of 
that type (initializing it with a constructor), and defines a procedure 
that prints the nested table. (The procedure uses the collection methods 
FIRST and LAST, described in "Collection Methods".) The example invokes 
the procedure three times: After initializing the variable, after changing 
the value of one element, and after using a constructor to the change the 
values of all elements. After the second constructor invocation, the nested 
table has only two elements. Referencing element 3 would raise error ORA-06533.


*/

DECLARE
  TYPE Roster IS TABLE OF VARCHAR2(15);  -- nested table type
 
  -- nested table variable initialized with constructor:
 
  names Roster := Roster('D Caruso', 'J Hamil', 'D Piro', 'R Singh');
 
  PROCEDURE print_names (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    FOR i IN names.FIRST .. names.LAST LOOP  -- For first to last element
      DBMS_OUTPUT.PUT_LINE(names(i));
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE('---');
  END;
  
BEGIN 
  print_names('Initial Values:');
 
  names(3) := 'P Perez';  -- Change value of one element
  print_names('Current Values:');
 
  names := Roster('A Jansen', 'B Gupta');  -- Change entire table
  print_names('Current Values:');
END;
/

/*
Example 5-6 defines a standalone nested table type, nt_type, and a standalone 
procedure to print a variable of that type, print_nt. (The procedure uses the 
collection methods FIRST and LAST, described in "Collection Methods".) An 
anonymous block declares a variable of type nt_type, initializing it to empty 
with a constructor, and invokes print_nt twice: After initializing the variable 
and after using a constructor to the change the values of all elements.


*/

CREATE OR REPLACE TYPE nt_type IS TABLE OF NUMBER;
/

CREATE OR REPLACE PROCEDURE print_nt (nt nt_type) IS
  i  NUMBER;
BEGIN
  i := nt.FIRST;
 
  IF i IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('nt is empty');
  ELSE
    WHILE i IS NOT NULL LOOP
      DBMS_OUTPUT.PUT('nt.(' || i || ') = '); print(nt(i));
      i := nt.NEXT(i);
    END LOOP;
  END IF;
 
  DBMS_OUTPUT.PUT_LINE('---');
END print_nt;
/

DECLARE
  nt nt_type := nt_type();  -- nested table variable initialized to empty
BEGIN
  print_nt(nt);
  nt := nt_type(90, 9, 29, 58);
  print_nt(nt);
END;
/

/*
Important Differences Between Nested Tables and Arrays
-------------------------------------------------------
Conceptually, a nested table is like a one-dimensional array with an 
arbitrary number of elements. However, a nested table differs from an 
array in these important ways:

An array has a declared number of elements, but a nested table does not. 
The size of a nested table can increase dynamically.

An array is always dense. A nested array is dense initially, but it can 
become sparse, because you can delete elements from it.

Figure 5-2 shows the important differences between a nested table and 
an array.

http://docs.oracle.com/cd/E11882_01/appdev.112/e25519/composites.htm#LNPLS99927


Appropriate Uses for Nested Tables
-------------------------------------
A nested table is appropriate when:

- The number of elements is not set.
- Index values are not consecutive.
- You must delete or update some elements, but not all elements simultaneously.
- Nested table data is stored in a separate store table, a system-generated 
  database table. When you access a nested table, the database joins the nested 
  table with its store table. This makes nested tables suitable for queries and 
  updates that affect only some elements of the collection.
- You would create a separate lookup table, with multiple entries for each row 
  of the main table, and access it through join queries.


*/

/*
Collection Constructors

** This topic applies only to varrays and nested tables. 
Associative arrays do not have constructors. In this topic, 
collection means varray or nested table.
**

A collection constructor (constructor) is a system-defined 
function with the same name as a collection type, which returns 
a collection of that type. The syntax of a constructor invocation is:

collection_type ( [ value [, value ]... ] )

If the parameter list is empty, the constructor returns an empty 
collection. Otherwise, the constructor returns a collection that contains 
the specified values. For semantic details, see "collection_constructor".

You can assign the returned collection to a collection variable (of the 
same type) in the variable declaration and in the executable part of a block.

Example 5-7 invokes a constructor twice: to initialize the varray variable 
team to empty in its declaration, and to give it new values in the executable 
part of the block. The procedure print_team shows the initial and final 
values of team. To determine when team is empty, print_team uses the collection 
method COUNT, described in "Collection Methods". (For an example of a procedure 
that prints a varray that might be null, see Example 5-24.)


Assigning Values to Collection Variables
You can assign a value to a collection variable in these ways:

Invoke a constructor to create a collection and assign it to the collection variable, as explained in "Collection Constructors".

Use the assignment statement (described in "Assignment Statement") to assign it the value of another existing collection variable.

Pass it to a subprogram as an OUT or IN OUT parameter, and then assign the value inside the subprogram.

To assign a value to a scalar element of a collection variable, reference the element as collection_variable_name(index) and assign it a value as instructed in "Assigning Values to Variables".

Topics

Data Type Compatibility
Assigning Null Values to Varray or Nested Table Variables
Assigning Set Operation Results to Nested Table Variables
See Also:
"BULK COLLECT Clause"

Data Type Compatibility
---------------------------
You can assign a collection to a collection variable only if they have the same data type. Having the same element type is not enough.

In Example 5-8, VARRAY types triplet and trio have the same element type, VARCHAR(15). Collection variables group1 and group2 have the same data type, triplet, but collection variable group3 has the data type trio. The assignment of group1 to group2 succeeds, but the assignment of group1 to group3 fails.

Example 5-8 Data Type Compatibility for Collection Assignment

DECLARE
  TYPE triplet IS VARRAY(3) OF VARCHAR2(15);
  TYPE trio    IS VARRAY(3) OF VARCHAR2(15);
 
  group1 triplet := triplet('Jones', 'Wong', 'Marceau');
  group2 triplet;
  group3 trio;
BEGIN
  group2 := group1;  -- succeeds
  group3 := group1;  -- fails
END;
/
Result:

ERROR at line 10:
ORA-06550: line 10, column 13:
PLS-00382: expression is of wrong type
ORA-06550: line 10, column 3:
PL/SQL: Statement ignored

Assigning Null Values to Varray or Nested Table Variables
--------
To a varray or nested table variable, you can assign the value NULL or a null collection of the same data type. Either assignment makes the variable null.

Example 5-7 initializes the nested table variable dname_tab to a non-null value; assigns a null collection to it, making it null; and re-initializes it to a different non-null value.

Example 5-9 Assigning Null Value to Nested Table Variable

DECLARE
  TYPE dnames_tab IS TABLE OF VARCHAR2(30);
 
  dept_names dnames_tab := dnames_tab(
    'Shipping','Sales','Finance','Payroll');  -- Initialized to non-null value
 
  empty_set dnames_tab;  -- Not initialized, therefore null
 
  PROCEDURE print_dept_names_status IS
  BEGIN
    IF dept_names IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('dept_names is null.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('dept_names is not null.');
    END IF;
  END  print_dept_names_status;
 
BEGIN
  print_dept_names_status;
  dept_names := empty_set;  -- Assign null collection to dept_names.
  print_dept_names_status;
  dept_names := dnames_tab (
    'Shipping','Sales','Finance','Payroll');  -- Re-initialize dept_names
  print_dept_names_status;
END;
/
Result:

dept_names is not null.
dept_names is null.
dept_names is not null.
Assigning Set Operation Results to Nested Table Variables
To a nested table variable, you can assign the result of a SQL MULTISET operation or SQL SET function invocation.

The SQL MULTISET operators combine two nested tables into a single nested table. The elements of the two nested tables must have comparable data types. For information about the MULTISET operators, see Oracle Database SQL Language Reference.

The SQL SET function takes a nested table argument and returns a nested table of the same data type whose elements are distinct (the function eliminates duplicate elements). For information about the SET function, see Oracle Database SQL Language Reference.

Example 5-10 assigns the results of several MULTISET operations and one SET function invocation of the nested table variable answer, using the procedure print_nested_table to print answer after each assignment. The procedure use the collection methods FIRST and LAST, described in "Collection Methods".

Example 5-10 Assigning Set Operation Results to Nested Table Variable

DECLARE
  TYPE nested_typ IS TABLE OF NUMBER;
 
  nt1    nested_typ := nested_typ(1,2,3);
  nt2    nested_typ := nested_typ(3,2,1);
  nt3    nested_typ := nested_typ(2,3,1,3);
  nt4    nested_typ := nested_typ(1,2,4);
  answer nested_typ;
 
  PROCEDURE print_nested_table (nt nested_typ) IS
    output VARCHAR2(128);
  BEGIN
    IF nt IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Result: null set');
    ELSIF nt.COUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Result: empty set');
    ELSE
      FOR i IN nt.FIRST .. nt.LAST LOOP  -- For first to last element
        output := output || nt(i) || ' ';
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('Result: ' || output);
    END IF;
  END print_nested_table;
 
BEGIN
  answer := nt1 MULTISET UNION nt4;
  print_nested_table(answer);
  answer := nt1 MULTISET UNION nt3;
  print_nested_table(answer);
  answer := nt1 MULTISET UNION DISTINCT nt3;
  print_nested_table(answer);
  answer := nt2 MULTISET INTERSECT nt3;
  print_nested_table(answer);
  answer := nt2 MULTISET INTERSECT DISTINCT nt3;
  print_nested_table(answer);
  answer := SET(nt3);
  print_nested_table(answer);
  answer := nt3 MULTISET EXCEPT nt2;
  print_nested_table(answer);
  answer := nt3 MULTISET EXCEPT DISTINCT nt2;
  print_nested_table(answer);
END;
/
Result:

Result: 1 2 3 1 2 4
Result: 1 2 3 2 3 1 3
Result: 1 2 3
Result: 3 2 1
Result: 3 2 1
Result: 2 3 1
Result: 3
Result: empty set
Multidimensional Collections
Although a collection has only one dimension, you can model a multidimensional collection with a collection whose elements are collections.

In Example 5-11, nva is a two-dimensional varray—a varray of varrays of integers.

Example 5-11 Two-Dimensional Varray (Varray of Varrays)

DECLARE
  TYPE t1 IS VARRAY(10) OF INTEGER;  -- varray of integer
  va t1 := t1(2,3,5);

  TYPE nt1 IS VARRAY(10) OF t1;      -- varray of varray of integer
  nva nt1 := nt1(va, t1(55,6,73), t1(2,4), va);

  i INTEGER;
  va1 t1;
BEGIN
  i := nva(2)(3);
  DBMS_OUTPUT.PUT_LINE('i = ' || i);

  nva.EXTEND;
  nva(5) := t1(56, 32);          -- replace inner varray elements
  nva(4) := t1(45,43,67,43345);  -- replace an inner integer element
  nva(4)(4) := 1;                -- replace 43345 with 1

  nva(4).EXTEND;    -- add element to 4th varray element
  nva(4)(5) := 89;  -- store integer 89 there
END;
/
Result:

i = 73
In Example 5-12, ntb1 is a nested table of nested tables of strings, and ntb2 is a nested table of varrays of integers.

Example 5-12 Nested Tables of Nested Tables and Varrays of Integers

DECLARE
  TYPE tb1 IS TABLE OF VARCHAR2(20);  -- nested table of strings
  vtb1 tb1 := tb1('one', 'three');

  TYPE ntb1 IS TABLE OF tb1; -- nested table of nested tables of strings
  vntb1 ntb1 := ntb1(vtb1);

  TYPE tv1 IS VARRAY(10) OF INTEGER;  -- varray of integers
  TYPE ntb2 IS TABLE OF tv1;          -- nested table of varrays of integers
  vntb2 ntb2 := ntb2(tv1(3,5), tv1(5,7,3));

BEGIN
  vntb1.EXTEND;
  vntb1(2) := vntb1(1);
  vntb1.DELETE(1);     -- delete first element of vntb1
  vntb1(2).DELETE(1);  -- delete first string from second table in nested table
END;
/
In Example 5-13, aa1 is an associative array of associative arrays, and ntb2 is a nested table of varrays of strings.

Example 5-13 Nested Tables of Associative Arrays and Varrays of Strings

DECLARE
  TYPE tb1 IS TABLE OF INTEGER INDEX BY PLS_INTEGER;  -- associative arrays
  v4 tb1;
  v5 tb1;

  TYPE aa1 IS TABLE OF tb1 INDEX BY PLS_INTEGER;  -- associative array of
  v2 aa1;                                         --  associative arrays

  TYPE va1 IS VARRAY(10) OF VARCHAR2(20);  -- varray of strings
  v1 va1 := va1('hello', 'world');

  TYPE ntb2 IS TABLE OF va1 INDEX BY PLS_INTEGER;  -- associative array of varrays
  v3 ntb2;

BEGIN
  v4(1)   := 34;     -- populate associative array
  v4(2)   := 46456;
  v4(456) := 343;

  v2(23) := v4;  -- populate associative array of associative arrays

  v3(34) := va1(33, 456, 656, 343);  -- populate associative array varrays

  v2(35) := v5;      -- assign empty associative array to v2(35)
  v2(35)(2) := 78;
END;
/
Collection Comparisons
You cannot compare associative array variables to the value NULL or to each other.

Except for Comparing Nested Tables for Equality and Inequality, you cannot natively compare two collection variables with relational operators (listed in Table 2-5). This restriction also applies to implicit comparisons. For example, a collection variable cannot appear in a DISTINCT, GROUP BY, or ORDER BY clause.

To determine if one collection variable is less than another (for example), you must define what less than means in that context and write a function that returns TRUE or FALSE. For information about writing functions, see Chapter 8, "PL/SQL Subprograms."

Topics

Comparing Varray and Nested Table Variables to NULL
Comparing Nested Tables for Equality and Inequality
Comparing Nested Tables with SQL Multiset Conditions
Comparing Varray and Nested Table Variables to NULL
You can compare varray and nested table variables to the value NULL with the "IS [NOT] NULL Operator", but not with the relational operators equal (=) and not equal (<>, !=, ~=, or ^=).

Example 5-14 compares a varray variable and a nested table variable to NULL correctly.

Example 5-14 Comparing Varray and Nested Table Variables to NULL

DECLARE  
  TYPE Foursome IS VARRAY(4) OF VARCHAR2(15);  -- VARRAY type
  team Foursome;                               -- varray variable
  
  TYPE Roster IS TABLE OF VARCHAR2(15);        -- nested table type
  names Roster := Roster('Adams', 'Patel');    -- nested table variable
  
BEGIN
  IF team IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('team IS NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('team IS NOT NULL');
  END IF;
 
  IF names IS NOT NULL THEN
    DBMS_OUTPUT.PUT_LINE('names IS NOT NULL');
  ELSE
    DBMS_OUTPUT.PUT_LINE('names IS NULL');
  END IF;
END;
/
Result:

team IS NULL
names IS NOT NULL
Comparing Nested Tables for Equality and Inequality
If two nested table variables have the same nested table type, and that nested table type does not have elements of a record type, then you can compare the two variables for equality or inequality with the relational operators equal (=) and not equal (<>, !=, ~=, ^=). Two nested table variables are equal if and only if they have the same set of elements (in any order).

See Also:
"Record Comparisons"
Example 5-15 compares nested table variables for equality and inequality with relational operators.

Example 5-15 Comparing Nested Tables for Equality and Inequality

DECLARE
  TYPE dnames_tab IS TABLE OF VARCHAR2(30); -- element type is not record type

  dept_names1 dnames_tab :=
    dnames_tab('Shipping','Sales','Finance','Payroll');

  dept_names2 dnames_tab :=
    dnames_tab('Sales','Finance','Shipping','Payroll');

  dept_names3 dnames_tab :=
    dnames_tab('Sales','Finance','Payroll');

BEGIN
  IF dept_names1 = dept_names2 THEN
    DBMS_OUTPUT.PUT_LINE('dept_names1 = dept_names2');
  END IF;

  IF dept_names2 != dept_names3 THEN
    DBMS_OUTPUT.PUT_LINE('dept_names2 != dept_names3');
  END IF;
END;
/
Result:

dept_names1 = dept_names2
dept_names2 != dept_names3
Comparing Nested Tables with SQL Multiset Conditions
You can compare nested table variables, and test some of their properties, with SQL multiset conditions (described in Oracle Database SQL Language Reference).

Example 5-16 uses the SQL multiset conditions and two SQL functions that take nested table variable arguments, CARDINALITY (described in Oracle Database SQL Language Reference) and SET (described in Oracle Database SQL Language Reference).

Example 5-16 Comparing Nested Tables with SQL Multiset Conditions

DECLARE
  TYPE nested_typ IS TABLE OF NUMBER;
  nt1 nested_typ := nested_typ(1,2,3);
  nt2 nested_typ := nested_typ(3,2,1);
  nt3 nested_typ := nested_typ(2,3,1,3);
  nt4 nested_typ := nested_typ(1,2,4);
 
  PROCEDURE testify (
    truth BOOLEAN := NULL,
    quantity NUMBER := NULL
  ) IS
  BEGIN
    IF truth IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE (
        CASE truth
           WHEN TRUE THEN 'True'
           WHEN FALSE THEN 'False'
        END
      );
    END IF;
    IF quantity IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(quantity);
    END IF;
  END;
BEGIN
  testify(truth => (nt1 IN (nt2,nt3,nt4)));        -- condition
  testify(truth => (nt1 SUBMULTISET OF nt3));      -- condition
  testify(truth => (nt1 NOT SUBMULTISET OF nt4));  -- condition
  testify(truth => (4 MEMBER OF nt1));             -- condition
  testify(truth => (nt3 IS A SET));                -- condition
  testify(truth => (nt3 IS NOT A SET));            -- condition
  testify(truth => (nt1 IS EMPTY));                -- condition
  testify(quantity => (CARDINALITY(nt3)));         -- function
  testify(quantity => (CARDINALITY(SET(nt3))));    -- 2 functions
END;
/
Result:

True
True
True
False
False
True
False
4
3
Collection Methods
A collection method is a PL/SQL subprogram—either a function that returns information about a collection or a procedure that operates on a collection. Collection methods make collections easier to use and your applications easier to maintain. Table 5-2 summarizes the collection methods.

Note:
With a null collection, EXISTS is the only collection method that does not raise the predefined exception COLLECTION_IS_NULL.
Table 5-2 Collection Methods

Method	Type	Description
DELETE

Procedure

Deletes elements from collection.

TRIM

Procedure

Deletes elements from end of varray or nested table.

EXTEND

Procedure

Adds elements to end of varray or nested table.

EXISTS

Function

Returns TRUE if and only if specified element of varray or nested table exists.

FIRST

Function

Returns first index in collection.

LAST

Function

Returns last index in collection.

COUNT

Function

Returns number of elements in collection.

LIMIT

Function

Returns maximum number of elements that collection can have.

PRIOR

Function

Returns index that precedes specified index.

NEXT

Function

Returns index that succeeds specified index.


The basic syntax of a collection method invocation is:

collection_name.method
For detailed syntax, see "Collection Method Invocation".

A collection method invocation can appear anywhere that an invocation of a PL/SQL subprogram of its type (function or procedure) can appear, except in a SQL statement. (For general information about PL/SQL subprograms, see Chapter 8, "PL/SQL Subprograms.")

In a subprogram, a collection parameter assumes the properties of the argument bound to it. You can apply collection methods to such parameters. For varray parameters, the value of LIMIT is always derived from the parameter type definition, regardless of the parameter mode.

Topics

DELETE Collection Method
TRIM Collection Method
EXTEND Collection Method
EXISTS Collection Method
FIRST and LAST Collection Methods
COUNT Collection Method
LIMIT Collection Method
PRIOR and NEXT Collection Methods
DELETE Collection Method
DELETE is a procedure that deletes elements from a collection. This method has these forms:

DELETE deletes all elements from a collection of any type.

This operation immediately frees the memory allocated to the deleted elements.

From an associative array or nested table (but not a varray):

DELETE(n) deletes the element whose index is n, if that element exists; otherwise, it does nothing.

DELETE(m,n) deletes all elements whose indexes are in the range m..n, if both m and n exist and m <= n; otherwise, it does nothing.

For these two forms of DELETE, PL/SQL keeps placeholders for the deleted elements. Therefore, the deleted elements are included in the internal size of the collection, and you can restore a deleted element by assigning a valid value to it.

Example 5-17 declares a nested table variable, initializing it with six elements; deletes and then restores the second element; deletes a range of elements and then restores one of them; and then deletes all elements. The restored elements occupy the same memory as the corresponding deleted elements. The procedure print_nt prints the nested table variable after initialization and after each DELETE operation. The type nt_type and procedure print_nt are defined in Example 5-6.

Example 5-17 DELETE Method with Nested Table

DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);
 
  nt.DELETE(2);     -- Delete second element
  print_nt(nt);
 
  nt(2) := 2222;    -- Restore second element
  print_nt(nt);
 
  nt.DELETE(2, 4);  -- Delete range of elements
  print_nt(nt);
 
  nt(3) := 3333;    -- Restore third element
  print_nt(nt);
 
  nt.DELETE;        -- Delete all elements
  print_nt(nt);
END;
/
Result:

nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 44
nt.(5) = 55
nt.(6) = 66
---
nt.(1) = 11
nt.(3) = 33
nt.(4) = 44
nt.(5) = 55
nt.(6) = 66
---
nt.(1) = 11
nt.(2) = 2222
nt.(3) = 33
nt.(4) = 44
nt.(5) = 55
nt.(6) = 66
---
nt.(1) = 11
nt.(5) = 55
nt.(6) = 66
---
nt.(1) = 11
nt.(3) = 3333
nt.(5) = 55
nt.(6) = 66
---
nt is empty
---
Example 5-18 populates an associative array indexed by string and deletes all elements, which frees the memory allocated to them. Next, the example replaces the deleted elements—that is, adds new elements that have the same indexes as the deleted elements. The new replacement elements do not occupy the same memory as the corresponding deleted elements. Finally, the example deletes one element and then a range of elements. The procedure print_aa_str shows the effects of the operations.

Example 5-18 DELETE Method with Associative Array Indexed by String

DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str  aa_type_str;
 
  PROCEDURE print_aa_str IS
    i  VARCHAR2(10);
  BEGIN
    i := aa_str.FIRST;
 
    IF i IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('aa_str is empty');
    ELSE
      WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT('aa_str.(' || i || ') = '); print(aa_str(i));
        i := aa_str.NEXT(i);
      END LOOP;
    END IF;
 
    DBMS_OUTPUT.PUT_LINE('---');
  END print_aa_str;
 
BEGIN
  aa_str('M') := 13;
  aa_str('Z') := 26;
  aa_str('C') := 3;
  print_aa_str;
 
  aa_str.DELETE;  -- Delete all elements
  print_aa_str;
 
  aa_str('M') := 13;   -- Replace deleted element with same value
  aa_str('Z') := 260;  -- Replace deleted element with new value
  aa_str('C') := 30;   -- Replace deleted element with new value
  aa_str('W') := 23;   -- Add new element
  aa_str('J') := 10;   -- Add new element
  aa_str('N') := 14;   -- Add new element
  aa_str('P') := 16;   -- Add new element
  aa_str('W') := 23;   -- Add new element
  aa_str('J') := 10;   -- Add new element
  print_aa_str;
 
  aa_str.DELETE('C');      -- Delete one element
  print_aa_str;
 
  aa_str.DELETE('N','W');  -- Delete range of elements
  print_aa_str;
 
  aa_str.DELETE('Z','M');  -- Does nothing
  print_aa_str;
END;
/
Result:

aa_str.(C) = 3
aa_str.(M) = 13
aa_str.(Z) = 26
---
aa_str is empty
---
aa_str.(C) = 30
aa_str.(J) = 10
aa_str.(M) = 13
aa_str.(N) = 14
aa_str.(P) = 16
aa_str.(W) = 23
aa_str.(Z) = 260
---
aa_str.(J) = 10
aa_str.(M) = 13
aa_str.(N) = 14
aa_str.(P) = 16
aa_str.(W) = 23
aa_str.(Z) = 260
---
aa_str.(J) = 10
aa_str.(M) = 13
aa_str.(Z) = 260
---
aa_str.(J) = 10
aa_str.(M) = 13
aa_str.(Z) = 260
---
TRIM Collection Method
TRIM is a procedure that deletes elements from the end of a varray or nested table. This method has these forms:

TRIM removes one element from the end of the collection, if the collection has at least one element; otherwise, it raises the predefined exception SUBSCRIPT_BEYOND_COUNT.

TRIM(n) removes n elements from the end of the collection, if there are at least n elements at the end; otherwise, it raises the predefined exception SUBSCRIPT_BEYOND_COUNT.

TRIM operates on the internal size of a collection. That is, if DELETE deletes an element but keeps a placeholder for it, then TRIM considers the element to exist. Therefore, TRIM can delete a deleted element.

PL/SQL does not keep placeholders for trimmed elements. Therefore, trimmed elements are not included in the internal size of the collection, and you cannot restore a trimmed element by assigning a valid value to it.

Caution:
Do not depend on interaction between TRIM and DELETE. Treat nested tables like either fixed-size arrays (and use only DELETE) or stacks (and use only TRIM and EXTEND).
Example 5-19 declares a nested table variable, initializing it with six elements; trims the last element; deletes the fourth element; and then trims the last two elements—one of which is the deleted fourth element. The procedure print_nt prints the nested table variable after initialization and after the TRIM and DELETE operations. The type nt_type and procedure print_nt are defined in Example 5-6.

Example 5-19 TRIM Method with Nested Table

DECLARE
  nt nt_type := nt_type(11, 22, 33, 44, 55, 66);
BEGIN
  print_nt(nt);

  nt.TRIM;       -- Trim last element
  print_nt(nt);

  nt.DELETE(4);  -- Delete fourth element
  print_nt(nt);

  nt.TRIM(2);    -- Trim last two elements
  print_nt(nt);
END;
/
Result:

nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 44
nt.(5) = 55
nt.(6) = 66
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 44
nt.(5) = 55
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(5) = 55
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
---
EXTEND Collection Method
EXTEND is a procedure that adds elements to the end of a varray or nested table. The collection can be empty, but not null. (To make a collection empty or add elements to a null collection, use a constructor. For more information, see "Collection Constructors".)

The EXTEND method has these forms:

EXTEND appends one null element to the collection.

EXTEND(n) appends n null elements to the collection.

EXTEND(n,i) appends n copies of the ith element to the collection.

Note:
EXTEND(n,i) is the only form that you can use for a collection whose elements have the NOT NULL constraint.
EXTEND operates on the internal size of a collection. That is, if DELETE deletes an element but keeps a placeholder for it, then EXTEND considers the element to exist.

Example 5-20 declares a nested table variable, initializing it with three elements; appends two copies of the first element; deletes the fifth (last) element; and then appends one null element. Because EXTEND considers the deleted fifth element to exist, the appended null element is the sixth element. The procedure print_nt prints the nested table variable after initialization and after the EXTEND and DELETE operations. The type nt_type and procedure print_nt are defined in Example 5-6.

Example 5-20 EXTEND Method with Nested Table

DECLARE
  nt nt_type := nt_type(11, 22, 33);
BEGIN
  print_nt(nt);
 
  nt.EXTEND(2,1);  -- Append two copies of first element
  print_nt(nt);
 
  nt.DELETE(5);    -- Delete fifth element
  print_nt(nt);
 
  nt.EXTEND;       -- Append one null element
  print_nt(nt);
END;
/
Result:

nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 11
nt.(5) = 11
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 11
---
nt.(1) = 11
nt.(2) = 22
nt.(3) = 33
nt.(4) = 11
nt.(6) = NULL
---
EXISTS Collection Method
EXISTS is a function that tells you whether the specified element of a varray or nested table exists.

EXISTS(n) returns TRUE if the nth element of the collection exists and FALSE otherwise. If n is out of range, EXISTS returns FALSE instead of raising the predefined exception SUBSCRIPT_OUTSIDE_LIMIT.

For a deleted element, EXISTS(n) returns FALSE, even if DELETE kept a placeholder for it.

Example 5-21 initializes a nested table with four elements, deletes the second element, and prints either the value or status of elements 1 through 6.

Example 5-21 EXISTS Method with Nested Table

DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1,3,5,7);
BEGIN
  n.DELETE(2); -- Delete second element
 
  FOR i IN 1..6 LOOP
    IF n.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') = ' || n(i));
    ELSE
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/
Result:

n(1) = 1
n(2) does not exist
n(3) = 5
n(4) = 7
n(5) does not exist
n(6) does not exist
FIRST and LAST Collection Methods
FIRST and LAST are functions. If the collection has at least one element, FIRST and LAST return the indexes of the first and last elements, respectively (ignoring deleted elements, even if DELETE kept placeholders for them). If the collection has only one element, FIRST and LAST return the same index. If the collection is empty, FIRST and LAST return NULL.

Topics

FIRST and LAST Methods for Associative Array
FIRST and LAST Methods for Varray
FIRST and LAST Methods for Nested Table
FIRST and LAST Methods for Associative Array
For an associative array indexed by PLS_INTEGER, the first and last elements are those with the smallest and largest indexes, respectively.

Example 5-22 shows the values of FIRST and LAST for an associative array indexed by PLS_INTEGER, deletes the first and last elements, and shows the values of FIRST and LAST again.

Example 5-22 FIRST and LAST Values for Associative Array Indexed by PLS_INTEGER

DECLARE
  TYPE aa_type_int IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa_int  aa_type_int;
 
  PROCEDURE print_first_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('FIRST = ' || aa_int.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST = ' || aa_int.LAST);
  END print_first_and_last;
 
BEGIN
  aa_int(1) := 3;
  aa_int(2) := 6;
  aa_int(3) := 9;
  aa_int(4) := 12;
 
  DBMS_OUTPUT.PUT_LINE('Before deletions:');
  print_first_and_last;
 
  aa_int.DELETE(1);
  aa_int.DELETE(4);
 
  DBMS_OUTPUT.PUT_LINE('After deletions:');
  print_first_and_last;
END;
/
Result:

Before deletions:
FIRST = 1
LAST = 4
After deletions:
FIRST = 2
LAST = 3
For an associative array indexed by string, the first and last elements are those with the lowest and highest key values, respectively. Key values are in sorted order (for more information, see "NLS Parameter Values Affect Associative Arrays Indexed by String").

Example 5-23 shows the values of FIRST and LAST for an associative array indexed by string, deletes the first and last elements, and shows the values of FIRST and LAST again.

Example 5-23 FIRST and LAST Values for Associative Array Indexed by String

DECLARE
  TYPE aa_type_str IS TABLE OF INTEGER INDEX BY VARCHAR2(10);
  aa_str  aa_type_str;
 
  PROCEDURE print_first_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('FIRST = ' || aa_str.FIRST);
    DBMS_OUTPUT.PUT_LINE('LAST = ' || aa_str.LAST);
  END print_first_and_last;
 
BEGIN
  aa_str('Z') := 26;
  aa_str('A') := 1;
  aa_str('K') := 11;
  aa_str('R') := 18;
 
  DBMS_OUTPUT.PUT_LINE('Before deletions:');
  print_first_and_last;
 
  aa_str.DELETE('A');
  aa_str.DELETE('Z');
 
  DBMS_OUTPUT.PUT_LINE('After deletions:');
  print_first_and_last;
END;
/
Result:

Before deletions:
FIRST = A
LAST = Z
After deletions:
FIRST = K
LAST = R
FIRST and LAST Methods for Varray
For a varray that is not empty, FIRST always returns 1. For every varray, LAST always equals COUNT (see Example 5-26).

Example 5-24 prints the varray team using a FOR LOOP statement with the bounds team.FIRST and team.LAST. Because a varray is always dense, team(i) inside the loop always exists.

Example 5-24 Printing Varray with FIRST and LAST in FOR LOOP

DECLARE
  TYPE team_type IS VARRAY(4) OF VARCHAR2(15);
  team team_type;
 
  PROCEDURE print_team (heading VARCHAR2)
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    IF team IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Has no members');
    ELSE
      FOR i IN team.FIRST..team.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || team(i));
      END LOOP;
    END IF;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
  
BEGIN 
  print_team('Team Status:');
 
  team := team_type();  -- Team is funded, but nobody is on it.
  print_team('Team Status:');
 
  team := team_type('John', 'Mary');  -- Put 2 members on team.
  print_team('Initial Team:');
 
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae');  -- Change team.
  print_team('New Team:');
END;
/
Result:

Team Status:
Does not exist
---
Team Status:
Has no members
---
Initial Team:
1. John
2. Mary
---
New Team:
1. Arun
2. Amitha
3. Allan
4. Mae
---
FIRST and LAST Methods for Nested Table
For a nested table, LAST equals COUNT unless you delete elements from its middle, in which case LAST is larger than COUNT (see Example 5-27).

Example 5-25 prints the nested table team using a FOR LOOP statement with the bounds team.FIRST and team.LAST. Because a nested table can be sparse, the FOR LOOP statement prints team(i) only if team.EXISTS(i) is TRUE.

Example 5-25 Printing Nested Table with FIRST and LAST in FOR LOOP

DECLARE
  TYPE team_type IS TABLE OF VARCHAR2(15);
  team team_type;
 
  PROCEDURE print_team (heading VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(heading);
 
    IF team IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Does not exist');
    ELSIF team.FIRST IS NULL THEN
      DBMS_OUTPUT.PUT_LINE('Has no members');
    ELSE
      FOR i IN team.FIRST..team.LAST LOOP
        DBMS_OUTPUT.PUT(i || '. ');
        IF team.EXISTS(i) THEN
          DBMS_OUTPUT.PUT_LINE(team(i));
        ELSE
          DBMS_OUTPUT.PUT_LINE('(to be hired)');
        END IF;
      END LOOP;
    END IF;
 
    DBMS_OUTPUT.PUT_LINE('---'); 
  END;
  
BEGIN 
  print_team('Team Status:');
 
  team := team_type();  -- Team is funded, but nobody is on it.
  print_team('Team Status:');
 
  team := team_type('Arun', 'Amitha', 'Allan', 'Mae');  -- Add members.
  print_team('Initial Team:');
 
  team.DELETE(2,3);  -- Remove 2nd and 3rd members.
  print_team('Current Team:');
END;
/
Result:

Team Status:
Does not exist
---
Team Status:
Has no members
---
Initial Team:
1. Arun
2. Amitha
3. Allan
4. Mae
---
Current Team:
1. Arun
2. (to be hired)
3. (to be hired)
4. Mae
---
COUNT Collection Method
COUNT is a function that returns the number of elements in the collection (ignoring deleted elements, even if DELETE kept placeholders for them).

Topics

COUNT Method for Varray
COUNT Method for Nested Table
COUNT Method for Varray
For a varray, COUNT always equals LAST. If you increase or decrease the size of a varray (with the EXTEND or TRIM method), the value of COUNT changes.

Example 5-26 shows the values of COUNT and LAST for a varray after initialization with four elements, after EXTEND(3), and after TRIM(5).

Example 5-26 COUNT and LAST Values for Varray

DECLARE
  TYPE NumList IS VARRAY(10) OF INTEGER;
  n NumList := NumList(1,3,5,7);
 
  PROCEDURE print_count_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT('n.COUNT = ' || n.COUNT || ', ');
    DBMS_OUTPUT.PUT_LINE('n.LAST = ' || n.LAST);
  END  print_count_and_last;
 
BEGIN
  print_count_and_last;
 
  n.EXTEND(3);
  print_count_and_last;
 
  n.TRIM(5);
  print_count_and_last;
END;
/
Result:

n.COUNT = 4, n.LAST = 4
n.COUNT = 7, n.LAST = 7
n.COUNT = 2, n.LAST = 2
COUNT Method for Nested Table
For a nested table, COUNT equals LAST unless you delete elements from the middle of the nested table, in which case COUNT is smaller than LAST.

Example 5-27 shows the values of COUNT and LAST for a nested table after initialization with four elements, after deleting the third element, and after adding two null elements to the end. Finally, the example prints the status of elements 1 through 8.

Example 5-27 COUNT and LAST Values for Nested Table

DECLARE
  TYPE NumList IS TABLE OF INTEGER;
  n NumList := NumList(1,3,5,7);
 
  PROCEDURE print_count_and_last IS
  BEGIN
    DBMS_OUTPUT.PUT('n.COUNT = ' || n.COUNT || ', ');
    DBMS_OUTPUT.PUT_LINE('n.LAST = ' || n.LAST);
  END  print_count_and_last;
 
BEGIN
  print_count_and_last;
 
  n.DELETE(3);  -- Delete third element
  print_count_and_last;
 
  n.EXTEND(2);  -- Add two null elements to end
  print_count_and_last;
 
  FOR i IN 1..8 LOOP
    IF n.EXISTS(i) THEN
      IF n(i) IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('n(' || i || ') = ' || n(i));
      ELSE
        DBMS_OUTPUT.PUT_LINE('n(' || i || ') = NULL');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('n(' || i || ') does not exist');
    END IF;
  END LOOP;
END;
/
Result:

n.COUNT = 4, n.LAST = 4
n.COUNT = 3, n.LAST = 4
n.COUNT = 5, n.LAST = 6
n(1) = 1
n(2) = 3
n(3) does not exist
n(4) = 7
n(5) = NULL
n(6) = NULL
n(7) does not exist
n(8) does not exist
LIMIT Collection Method
LIMIT is a function that returns the maximum number of elements that the collection can have. If the collection has no maximum number of elements, LIMIT returns NULL. Only a varray has a maximum size.

Example 5-28 and prints the values of LIMIT and COUNT for an associative array with four elements, a varray with two elements, and a nested table with three elements.

Example 5-28 LIMIT and COUNT Values for Different Collection Types

DECLARE
  TYPE aa_type IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
  aa aa_type;                          -- associative array
 
  TYPE va_type IS VARRAY(4) OF INTEGER;
  va  va_type := va_type(2,4);   -- varray
 
  TYPE nt_type IS TABLE OF INTEGER;
  nt  nt_type := nt_type(1,3,5);  -- nested table
 
BEGIN
  aa(1):=3; aa(2):=6; aa(3):=9; aa(4):= 12;
  DBMS_OUTPUT.PUT('aa.COUNT = '); print(aa.COUNT);
  DBMS_OUTPUT.PUT('aa.LIMIT = '); print(aa.LIMIT);
 
  DBMS_OUTPUT.PUT('va.COUNT = '); print(va.COUNT);
  DBMS_OUTPUT.PUT('va.LIMIT = '); print(va.LIMIT);
 
  DBMS_OUTPUT.PUT('nt.COUNT = '); print(nt.COUNT);
  DBMS_OUTPUT.PUT('nt.LIMIT = '); print(nt.LIMIT);
END;
/
Result:

aa.COUNT = 4
aa.LIMIT = NULL
va.COUNT = 2
va.LIMIT = 4
nt.COUNT = 3
nt.LIMIT = NULL
PRIOR and NEXT Collection Methods
PRIOR and NEXT are functions that let you move backward and forward in the collection (ignoring deleted elements, even if DELETE kept placeholders for them). These methods are useful for traversing sparse collections.

Given an index:

PRIOR returns the index of the preceding existing element of the collection, if one exists. Otherwise, PRIOR returns NULL.

For any collection c, c.PRIOR(c.FIRST) returns NULL.

NEXT returns the index of the succeeding existing element of the collection, if one exists. Otherwise, NEXT returns NULL.

For any collection c, c.NEXT(c.LAST) returns NULL.

The given index need not exist. However, if the collection c is a varray, and the index exceeds c.LIMIT, then:

c.PRIOR(index) returns c.LAST.
c.NEXT(index) returns NULL.
For example:

DECLARE
  TYPE Arr_Type IS VARRAY(10) OF NUMBER;
  v_Numbers Arr_Type := Arr_Type();
BEGIN
  v_Numbers.EXTEND(4);
 
  v_Numbers (1) := 10;
  v_Numbers (2) := 20;
  v_Numbers (3) := 30;
  v_Numbers (4) := 40;
 
  DBMS_OUTPUT.PUT_LINE(NVL(v_Numbers.prior (3400), -1));
  DBMS_OUTPUT.PUT_LINE(NVL(v_Numbers.next (3400), -1));
END;
/
Result:

4
-1
Example 5-29 initializes a nested table with six elements, deletes the fourth element, and then shows the values of PRIOR and NEXT for elements 1 through 7. Elements 4 and 7 do not exist. Element 2 exists, despite its null value.

Example 5-29 PRIOR and NEXT Methods

DECLARE
  TYPE nt_type IS TABLE OF NUMBER;
  nt nt_type := nt_type(18, NULL, 36, 45, 54, 63);
 
BEGIN
  nt.DELETE(4);
  DBMS_OUTPUT.PUT_LINE('nt(4) was deleted.');
 
  FOR i IN 1..7 LOOP
    DBMS_OUTPUT.PUT('nt.PRIOR(' || i || ') = '); print(nt.PRIOR(i));
    DBMS_OUTPUT.PUT('nt.NEXT(' || i || ')  = '); print(nt.NEXT(i));
  END LOOP;
END;
/
Result:

nt(4) was deleted.
nt.PRIOR(1) = NULL
nt.NEXT(1)  = 2
nt.PRIOR(2) = 1
nt.NEXT(2)  = 3
nt.PRIOR(3) = 2
nt.NEXT(3)  = 5
nt.PRIOR(4) = 3
nt.NEXT(4)  = 5
nt.PRIOR(5) = 3
nt.NEXT(5)  = 6
nt.PRIOR(6) = 5
nt.NEXT(6)  = NULL
nt.PRIOR(7) = 6
nt.NEXT(7)  = NULL
For an associative array indexed by string, the prior and next indexes are determined by key values, which are in sorted order (for more information, see "NLS Parameter Values Affect Associative Arrays Indexed by String"). Example 5-1 uses FIRST, NEXT, and a WHILE LOOP statement to print the elements of an associative array.

Example 5-30 prints the elements of a sparse nested table from first to last, using FIRST and NEXT, and from last to first, using LAST and PRIOR.

Example 5-30 Printing Elements of Sparse Nested Table

DECLARE
  TYPE NumList IS TABLE OF NUMBER;
  n NumList := NumList(1, 2, NULL, NULL, 5, NULL, 7, 8, 9, NULL);
  idx INTEGER;
 
BEGIN
  DBMS_OUTPUT.PUT_LINE('First to last:');
  idx := n.FIRST;
  WHILE idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT('n(' || idx || ') = ');
    print(n(idx));
    idx := n.NEXT(idx);
  END LOOP;
    
  DBMS_OUTPUT.PUT_LINE('--------------');
 
  DBMS_OUTPUT.PUT_LINE('Last to first:');
  idx := n.LAST;
  WHILE idx IS NOT NULL LOOP
    DBMS_OUTPUT.PUT('n(' || idx || ') = ');
    print(n(idx));
    idx := n.PRIOR(idx);
  END LOOP;
END;
/
Result:

First to last:
n(1) = 1
n(2) = 2
n(3) = NULL
n(4) = NULL
n(5) = 5
n(6) = NULL
n(7) = 7
n(8) = 8
n(9) = 9
n(10) = NULL
--------------
Last to first:
n(10) = NULL
n(9) = 9
n(8) = 8
n(7) = 7
n(6) = NULL
n(5) = 5
n(4) = NULL
n(3) = NULL
n(2) = 2
n(1) = 1
Collection Types Defined in Package Specifications
A collection type defined in a package specification is incompatible with an identically defined local or standalone collection type.

Note:
The examples in this topic define packages and procedures, which are explained in Chapter 10, "PL/SQL Packages" and Chapter 8, "PL/SQL Subprograms," respectively.
In Example 5-31, the package specification and the anonymous block define the collection type NumList identically. The package defines a procedure, print_numlist, which has a NumList parameter. The anonymous block declares the variable n1 of the type pkg.NumList (defined in the package) and the variable n2 of the type NumList (defined in the block). The anonymous block can pass n1 to print_numlist, but it cannot pass n2 to print_numlist.

Example 5-31 Identically Defined Package and Local Collection Types

CREATE OR REPLACE PACKAGE pkg AS
  TYPE NumList IS TABLE OF NUMBER;
  PROCEDURE print_numlist (nums NumList);
END pkg;
/
CREATE OR REPLACE PACKAGE BODY pkg AS
  PROCEDURE print_numlist (nums NumList) IS
  BEGIN
    FOR i IN nums.FIRST..nums.LAST LOOP
      DBMS_OUTPUT.PUT_LINE(nums(i));
    END LOOP;
  END;
END pkg;
/
DECLARE
  TYPE NumList IS TABLE OF NUMBER;  -- local type identical to package type
  n1 pkg.NumList := pkg.NumList(2,4);  -- package type
  n2     NumList :=     NumList(6,8);  -- local type
BEGIN
  pkg.print_numlist(n1);  -- succeeds
  pkg.print_numlist(n2);  -- fails
END;
/
Result:

  pkg.print_numlist(n2);  -- fails
  *
ERROR at line 7:
ORA-06550: line 7, column 3:
PLS-00306: wrong number or types of arguments in call to 'PRINT_NUMLIST'
ORA-06550: line 7, column 3:
PL/SQL: Statement ignored
Example 5-32 defines a standalone collection type NumList that is identical to the collection type NumList defined in the package specification in Example 5-31. The anonymous block declares the variable n1 of the type pkg.NumList (defined in the package) and the variable n2 of the standalone type NumList. The anonymous block can pass n1 to print_numlist, but it cannot pass n2 to print_numlist.

Example 5-32 Identically Defined Package and Standalone Collection Types

CREATE OR REPLACE TYPE NumList IS TABLE OF NUMBER;
  -- standalone collection type identical to package type
/
DECLARE
  n1 pkg.NumList := pkg.NumList(2,4);  -- package type
  n2     NumList :=     NumList(6,8);  -- standalone type
 
BEGIN
  pkg.print_numlist(n1);  -- succeeds
  pkg.print_numlist(n2);  -- fails
END;
/
Result:

  pkg.print_numlist(n2);  -- fails
  *
ERROR at line 7:
ORA-06550: line 7, column 3:
PLS-00306: wrong number or types of arguments in call to 'PRINT_NUMLIST'
ORA-06550: line 7, column 3:
PL/SQL: Statement ignored

*/