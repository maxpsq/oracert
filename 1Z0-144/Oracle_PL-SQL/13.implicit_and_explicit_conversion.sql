/*
IMPLICIT TYPE CONVERSION
=================================

- on INSERT and UPDATES values are converted o the data types of the affected colum.
- on SELECT statements values are converted from the type of the columns to the
  type of the target variable.
- Oracle adjusts precision and scale for numeric data typs to allow for maximum 
  capacity.
- When converting a TIMESTAMP to a DATE the fractional part is truncated.
- When comparing a DATE to a CHAR type, the CHAR type is converted to a DATE
- When a SQL function or operator is called with an argument of the wrong data type,
  Oracle implicitly converts the argument if possible.
- When making assignments the value at the right side of the equal sign (=) is converted
  to the type of the assignment target on the left side.
- during character concatenation, non-character data is converted to CHAR on NCHAR
- For arithmetic operations or comparisons between character or non-characterdata types,
  Oracle converts to NUMER, DATE or ROWID as appropriate.
- In arithmetic opertion involving only character data, oracle converts to a NUMBER.
- User-defined types cannot be IMPLICITLY converted

character data cannot be implicitly converted to a DATE unless it is in teh dafault date format specified
in the session.

character data cannot be implicitly converted to a number if it contains dollar sign or commas


EXPLICIT TYPE CONVERSION
=================================
It is Oracle's recommendation that you use explicit type conversion using conversion
functions for the following reasons:
- code is easier to read
- implicit data type convrsion can have negative impact on performance
- implicit conversion depends on the context in which it occours and may not work
  the same way in every case
- Algorithms for implicit conversion are subject to change across software releases
  and among Oracle products.

*/

alter session set NLS_TERRITORY='AMERICA';
alter session set NLS_NUMERIC_CHARACTERS='.,';
DECLARE
   a NUMBER;
BEGIN
   a := '123.400' || 999;  --> explicitely: to_number('123.400' || to_char(999) );
   dbms_output.put_line(a);
end ;
/

declare
  a   number;
begin
   a := 3 ** 3 ; -- 3^3
   dbms_output.put_line(a);
end;
/


