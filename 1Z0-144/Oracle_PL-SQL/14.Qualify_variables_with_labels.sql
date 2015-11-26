
/*
References to Identifiers
----------------------------------
When referencing an identifier, you use a name that is 
either simple, qualified, remote, or both qualified and remote.

The simple name of an identifier is the name in its declaration. For example:

DECLARE
  a INTEGER;  -- Declaration
BEGIN
  a := 1;     -- Reference with simple name
END;
/

If an identifier is declared in a named PL/SQL unit, you can (and sometimes 
must) reference it with its qualified name. The syntax (called dot notation) is:

unit_name.simple_identifier_name

If the identifier names an object on a remote database, you must reference it 
with its remote name. The syntax is:

simple_identifier_name@link_to_remote_database

You can create synonyms for remote schema objects, but you CANNOT create synonyms 
for objects declared in PL/SQL subprograms or packages

** NOTE **
You can reference identifiers declared in the packages STANDARD and DBMS_STANDARD 
without qualifying them with the package names, UNLESS you have declared a local 
identifier with the same name.


Scope and Visibility of Identifiers
-------------------------------------
The scope of an identifier is the region of a PL/SQL unit from which you can 
reference the identifier. The visibility of an identifier is the region of a PL/SQL 
unit from which you can reference the identifier without qualifying it. An identifier 
is LOCAL to the PL/SQL unit that declares it. If that unit has subunits, the identifier 
is GLOBAL to them.

If a subunit redeclares a global identifier, then inside the subunit, both identifiers 
are in scope, but only the local identifier is visible.

***
To reference the global identifier, the subunit must qualify it with the name of the 
unit that declared it. If that unit has no name, then the subunit cannot reference 
the global identifier.
***

A PL/SQL unit cannot reference identifiers declared in other units at the same level, 
because those identifiers are neither local nor global to the block.

You cannot declare the same identifier twice in the same PL/SQL unit. If you do, an 
error occurs when you reference the duplicate identifier.

*/

<<outer>>  -- label
DECLARE
  birthdate DATE := '09-AUG-70';
BEGIN
  DECLARE
    birthdate DATE := '29-SEP-70';
  BEGIN
    IF birthdate = outer.birthdate THEN    --> NOTICE this...
      DBMS_OUTPUT.PUT_LINE ('Same Birthday');
    ELSE
      DBMS_OUTPUT.PUT_LINE ('Different Birthday');
    END IF;
  END;
END;
/


CREATE OR REPLACE PROCEDURE check_credit (credit_limit NUMBER) AS
  rating NUMBER := 3;
  
  FUNCTION check_rating RETURN BOOLEAN IS
    rating  NUMBER := 1;
    over_limit  BOOLEAN;
  BEGIN
    IF check_credit.rating <= credit_limit THEN  -- reference global variable
      over_limit := FALSE;
    ELSE
      over_limit := TRUE;
      rating := credit_limit;                    -- reference local variable
    END IF;
    RETURN over_limit;
  END check_rating;
BEGIN
  IF check_rating THEN
    DBMS_OUTPUT.PUT_LINE
      ('Credit rating over limit (' || TO_CHAR(credit_limit) || ').  '
      || 'Rating: ' || TO_CHAR(rating));
  ELSE
    DBMS_OUTPUT.PUT_LINE
      ('Credit rating OK.  ' || 'Rating: ' || TO_CHAR(rating));
  END IF;
END;
/


<<echo>>
DECLARE
  x  NUMBER := 5;
  
  PROCEDURE echo AS
    x  NUMBER := 0;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('x = ' || x);
 -- echo.x refers to the local variable x, not to the global variable x
    DBMS_OUTPUT.PUT_LINE('echo.x = ' || echo.x); 
  END;
 
BEGIN
  echo;
END;
/
/* output:
x = 0
echo.x = 0
*/



<<compute_ratio>>
<<another_label>>
DECLARE
  numerator   NUMBER := 22;
  denominator NUMBER := 7;
BEGIN
  <<another_label>>
  DECLARE
    denominator NUMBER := 0;
  BEGIN
  -- compute_ratio.denominator refers to the global variable (7)
    DBMS_OUTPUT.PUT_LINE('Ratio with compute_ratio.denominator = ');
    DBMS_OUTPUT.PUT_LINE(numerator/compute_ratio.denominator);
    
 -- another_label.denominator refers to the local variable (0)
    DBMS_OUTPUT.PUT_LINE('Ratio with another_label.denominator = ');
    DBMS_OUTPUT.PUT_LINE(numerator/another_label.denominator);
 
  EXCEPTION
    WHEN ZERO_DIVIDE THEN
      DBMS_OUTPUT.PUT_LINE('Divide-by-zero error: can''t divide '
        || numerator || ' by ' || denominator);
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unexpected error.');
-- Notice that aliases after the block delimiter END are not qualifiers.
-- They just help in making the code more readable.
  END another_label;
END compute_ratio;
/
