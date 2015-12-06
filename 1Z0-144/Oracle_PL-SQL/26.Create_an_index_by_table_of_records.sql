/*
Create an index by table of records
==================================================
An INDEX BY TABLE or INDEX BY TABLE OF RECORDS is a legacy name
from an ASSOCIATIVE ARRAY.

An ASSOCIATIVE ARRAY is a key/value pairs, where each key is
a unique index that acts as a locator to access the associated
value.

The data type of the index can be either
  - PLS_INTEGER
  - string type

** NOTICE ** PLS_INTEGER and BINARY_INTEGER data types are IDENTICAL !!
http://docs.oracle.com/cd/E11882_01/appdev.112/e25519/datatypes.htm#LNPLS319
*/
DECLARE
    TYPE type01 IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;    -- OK
    TYPE type02 IS TABLE OF PLS_INTEGER INDEX BY BINARY_INTEGER; -- OK
    TYPE type04 IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(4);    -- OK
BEGIN
  NULL;
END;
/
/*
Values are sorted by the index value rather in wich they were added
to the collection.

For this reason, string type indexes are affected by NLS_SORT and NLS_COMP
parameters.

Like a database table, an associative array:
	- Is empty (but not null) until you populate it
	- Can hold an unspecified number of elements, which you can access 
	  without knowing their positions

Unlike a database table, an associative array:
	- Does not need disk space or network operations
	- Cannot be manipulated with DML statements

*/
set serveroutput on;

DECLARE
  -- Associative array indexed by string:
  
  TYPE population IS TABLE OF NUMBER  -- Associative array type
    INDEX BY VARCHAR2(64);            --  indexed by string
  
  city_population  population;        -- Associative array variable
  i  VARCHAR2(64);                    -- Scalar variable
  
BEGIN
  -- Add elements (key-value pairs) to associative array:
 
  city_population('Smallville')  := 2000;
  city_population('Midland')     := 750000;
  city_population('Megalopolis') := 1000000;
 
  -- Change value associated with key 'Smallville':
 
  city_population('Smallville') := 2001;
 
  -- Print associative array:
 
  i := city_population.FIRST;  -- Get first element of array
 
  WHILE i IS NOT NULL LOOP
    DBMS_Output.PUT_LINE
      ('Population of ' || i || ' is ' || city_population(i));
    i := city_population.NEXT(i);  -- Get next element of array
  END LOOP;
  
  -- Collection methods
  DBMS_Output.NEW_LINE;
  DBMS_Output.PUT_LINE('First='||city_population.FIRST); 
  DBMS_Output.PUT_LINE('Second='||city_population.NEXT(city_population.FIRST)); 
  DBMS_Output.PUT_LINE('Last='||city_population.LAST); 
END;
/

SET SERVEROUTPUT ON;
DECLARE
  TYPE sum_multiples IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  n  PLS_INTEGER := 5;   -- number of multiples to sum for display
  sn PLS_INTEGER := 10;  -- number of multiples to sum
  m  PLS_INTEGER := 3;   -- multiple

  FUNCTION get_sum_multiples (
    multiple IN PLS_INTEGER,
    num      IN PLS_INTEGER
  ) RETURN sum_multiples
  IS
    s sum_multiples;
  BEGIN
    FOR i IN 1..num LOOP
      s(i) := multiple * ((i * (i + 1)) / 2);  -- sum of multiples
    END LOOP;
    RETURN s;
  END get_sum_multiples;

BEGIN
  DBMS_OUTPUT.PUT_LINE (
    'Sum of the first ' || TO_CHAR(n) || ' multiples of ' ||
    TO_CHAR(m) || ' is ' || TO_CHAR(get_sum_multiples (m, sn)(n)) --> (n) represents the index of the array returned by get_sum_multiples()
  );
END;
/

/*
Declaring Associative Array Constants
-----------------------------------------
When declaring an associative array constant, you must create a function that 
populates the associative array with its initial value and then invoke the 
function in the constant declaration.
*/

CREATE OR REPLACE PACKAGE My_Types AUTHID DEFINER IS
  TYPE My_AA IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
  FUNCTION Init_My_AA RETURN My_AA;
END My_Types;
/
CREATE OR REPLACE PACKAGE BODY My_Types IS
  FUNCTION Init_My_AA RETURN My_AA IS
    Ret My_AA;
  BEGIN
    Ret(-10) := '-ten';
    Ret(0) := 'zero';
    Ret(1) := 'one';
    Ret(2) := 'two';
    Ret(3) := 'three';
    Ret(4) := 'four';
    Ret(9) := 'nine';
    RETURN Ret;
  END Init_My_AA;
END My_Types;
/
SET SERVEROUTPUT ON;
DECLARE
  v CONSTANT My_Types.My_AA := My_Types.Init_My_AA();
BEGIN
  DECLARE
    Idx PLS_INTEGER := v.FIRST();
  BEGIN
    WHILE Idx IS NOT NULL LOOP
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(Idx, '999')||LPAD(v(Idx), 7));
      Idx := v.NEXT(Idx);
    END LOOP;
  END;
END;
/

-- tear down
DROP PACKAGE My_Types ;

/*
Changing NLS Parameter Values After Populating Associative Arrays
The initialization parameters NLS_SORT and NLS_COMP determine the storage order 
of string indexes of an associative array. If you change the value of either 
parameter after populating an associative array indexed by string, then the 
collection methods FIRST, LAST, NEXT, and PRIOR (described in "Collection Methods") 
might return unexpected values or raise exceptions. If you must change these 
parameter values during your session, restore their original values before 
operating on associative arrays indexed by string.

Indexes of Data Types Other Than VARCHAR2
In the declaration of an associative array indexed by string, the string type 
must be VARCHAR2 or one of its subtypes. However, you can populate the associative 
array with indexes of any data type that the TO_CHAR function can convert to 
VARCHAR2. (For information about TO_CHAR, see Oracle Database SQL Language Reference.)

If your indexes have data types other than VARCHAR2 and its subtypes, ensure that 
these indexes remain consistent and unique if the values of initialization 
parameters change. For example:

- Do not use TO_CHAR(SYSDATE) as an index: if the value of NLS_DATE_FORMAT 
  changes, then the value of (TO_CHAR(SYSDATE)) might also change.

- Do not use different NVARCHAR2 indexes that might be converted to the same 
  VARCHAR2 value.

- Do not use CHAR or VARCHAR2 indexes that differ only in case, accented 
  characters, or punctuation characters.

If the value of NLS_SORT ends in _CI (case-insensitive comparisons) 
or _AI (accent- and case-insensitive comparisons), then indexes that differ 
only in case, accented characters, or punctuation characters might be converted 
to the same value.

Passing Associative Arrays to Remote Databases
-----------------------------------------------
If you pass an associative array as a parameter to a remote database, and the 
local and the remote databases have different NLS_SORT or NLS_COMP values, then:

The collection method FIRST, LAST, NEXT or PRIOR (described in "Collection Methods") 
might return unexpected values or raise exceptions.

Indexes that are unique on the local database might not be unique on the remote 
database, raising the predefined exception VALUE_ERROR.


Appropriate Uses for Associative Arrays
-----------------------------------------
An associative array is appropriate for:

- A relatively small lookup table, which can be constructed in memory each time 
  you invoke the subprogram or initialize the package that declares it

- Passing collections to and from the database server

Declare formal subprogram parameters of associative array types. With Oracle 
Call Interface (OCI) or an Oracle precompiler, bind the host arrays to the 
corresponding actual parameters. PL/SQL automatically converts between host 
arrays and associative arrays indexed by PLS_INTEGER.

** Note **
You cannot declare an associative array type at schema level. Therefore, to pass 
an associative array variable as a parameter to a standalone subprogram, you must 
declare the type of that variable in a package specification. Doing so makes the 
type available to both the invoked subprogram (which declares a formal parameter 
of that type) and the invoking subprogram or anonymous block (which declares and 
passes the variable of that type). See Example 10-2.

** Tip **
The most efficient way to pass collections to and from the database server is to 
use associative arrays with the FORALL statement or BULK COLLECT clause. For 
details, see "FORALL Statement" and "BULK COLLECT Clause".


An associative array is intended for temporary data storage. To make an 
associative array persistent for the life of a database session, declare it in a 
package specification and populate it in the package body.
*/