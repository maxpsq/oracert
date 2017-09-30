/*
Lexical Units
======================================
The lexical units of PL/SQL are its smallest individual 
components—delimiters, identifiers, literals, and comments.

- Delimiters
- Identifiers
- Literals
- Comments
- Whitespace Characters Between Lexical Units


Delimiters
------------
A delimiter is a character, or character combination, that 
has a special meaning in PL/SQL. Do not embed any others characters 
(including whitespace characters) inside a delimiter.


Delimiter	Meaning
+			Addition operator

:=		Assignment operator

=>		Association operator

%			Attribute indicator

'			Character string delimiter

.			Component indicator

||		Concatenation operator

/			Division operator

**		Exponentiation operator

(			Expression or list delimiter (begin)

)			Expression or list delimiter (end)

:			Host variable indicator
Host variables are the key to communication between your host program and Oracle. 
Typically, a precompiler program inputs data from a host variable to Oracle, and 
Oracle outputs data to a host variable in the program. Oracle stores input data 
in database columns, and stores output data in program host variables.

,			Item separator

<<		Label delimiter (begin)

>>		Label delimiter (end)

/*		Multiline comment delimiter (begin)

*/		Multiline comment delimiter (end)

*			Multiplication operator

"			Quoted identifier delimiter

..		Range operator

=			Relational operator (equal)

<>		Relational operator (not equal)

!=		Relational operator (not equal)

~=		Relational operator (not equal)

^=		Relational operator (not equal)

<			Relational operator (less than)

>			Relational operator (greater than)

<=		Relational operator (less than or equal)

>=		Relational operator (greater than or equal)

@			Remote access indicator

--		Single-line comment indicator

;			Statement terminator

-			Subtraction or negation operator




Identifiers
--------------------
Identifiers name PL/SQL elements, which include:

Constants
Cursors
Exceptions
Keywords
Labels
Packages
Reserved words
Subprograms
Types
Variables

You must separate adjacent identifiers by one or more whitespace characters or a
punctuation character.
PL/SQL is case-insensitive for identifiers. For example, the identifiers lastname, 
LastName, and LASTNAME are the same.

Quoted User-Defined Identifiers
----------------------------
A quoted user-defined identifier is enclosed in double quotation marks. Between 
the double quotation marks, any characters from the database character set are 
allowed except double quotation marks, new line characters, and null characters. 
For example, these identifiers are acceptable:

"X+Y"
"last name"
"on/off switch"
"employee(s)"
"*** header info ***"

The representation of the quoted identifier in the database character set cannot 
exceed 30 bytes (excluding the double quotation marks).

A quoted user-defined identifier is case-sensitive, with one exception: If a quoted 
user-defined identifier, without its enclosing double quotation marks, is a valid 
ordinary user-defined identifier, then the double quotation marks are optional in 
references to the identifier, and if you omit them, then the identifier is case-insensitive.

In Example 2-1, the quoted user-defined identifier "HELLO", without its enclosing 
double quotation marks, is a valid ordinary user-defined identifier. Therefore, 
the reference Hello is valid.

*/

DECLARE
  "HELLO" varchar2(10) := 'hello';
BEGIN
  DBMS_Output.Put_Line(Hello);  --> Valid
END;
/

-- here the reference "Hello" is invalid, because the double quotation marks make the identifier case-sensitive.
DECLARE
  "HELLO" varchar2(10) := 'hello';
BEGIN
  DBMS_Output.Put_Line("Hello");  --> Invalid
END;
/

/*
It is not recommended, but you can use a reserved word as a quoted user-defined 
identifier. Because a reserved word is not a valid ordinary user-defined identifier, 
you must always enclose the identifier in double quotation marks, and it is always 
case-sensitive.
*/


DECLARE
  "BEGIN" varchar2(15) := 'UPPERCASE';
  "Begin" varchar2(15) := 'Initial Capital';
  "begin" varchar2(15) := 'lowercase';
BEGIN
  DBMS_Output.Put_Line("BEGIN");
  DBMS_Output.Put_Line("Begin");
  DBMS_Output.Put_Line("begin");
END;
/

DECLARE
  "HELLO" varchar2(10) := 'hello';  -- HELLO is not a reserved word
  "BEGIN" varchar2(10) := 'begin';  -- BEGIN is a reserved word
BEGIN
  DBMS_Output.Put_Line(Hello);      -- Double quotation marks are optional
  DBMS_Output.Put_Line(BEGIN);      -- Double quotation marks are required
end;
/

DECLARE
  "HELLO" varchar2(10) := 'hello';  -- HELLO is not a reserved word
  "BEGIN" varchar2(10) := 'begin';  -- BEGIN is a reserved word
BEGIN
  DBMS_Output.Put_Line(Hello);      -- Identifier is case-insensitive
  DBMS_Output.Put_Line("Begin");    -- Identifier is case-sensitive
END;
/


/*
LITERALS
A literal is a value that is neither represented by an identifier nor 
calculated from other values. For example, 123 is an integer literal 
and 'abc' is a character literal, but 1+2 is not a literal.

PL/SQL literals include all SQL literals (described in Oracle Database 
SQL Language Reference) and BOOLEAN literals (which SQL does not have). 
A BOOLEAN literal is the predefined logical value TRUE, FALSE, or NULL. 
NULL represents an unknown value.


PL/SQL has no line-continuation character that means "this string continues on the next source line." If you continue a string on the next source line, then the string includes a line-break character.
*/

BEGIN
  DBMS_OUTPUT.PUT_LINE('This string breaks
here.');
END;
/



BEGIN
  DBMS_OUTPUT.PUT_LINE('This string breaks
                      here.');
END;
/


/*
- A character literal with zero characters has the value NULL and is called 
  a null string.
  However, this NULL value is not the BOOLEAN value NULL.

- An ordinary character literal is composed of characters in 
  the database character set. For information about the database character set, 
  see Oracle Database Globalization Support Guide.

- A national character literal is composed of characters in the 
  national character set. For information about the national character set, 
  see Oracle Database Globalization Support Guide.
  
*/

/*
Comments
--------------------
The PL/SQL compiler ignores comments. Their purpose is to help other application 
developers understand your source text. Typically, you use comments to describe 
the purpose and use of each code segment. You can also disable obsolete or 
unfinished pieces of code by turning them into comments.

A single-line comment begins with -- and extends to the end of the line.

A multiline comment begins with /*, ends with */ /*, and can span multiple lines.
*/

/*
Whitespace Characters Between Lexical Units
--------------------------------------------
You can put whitespace characters between lexical units, which often makes your 
source text easier to read, as Example 2-8 shows.
*/

DECLARE
  x    NUMBER := 10;
  y    NUMBER := 5;
  max  NUMBER;
BEGIN
  IF x>y THEN max:=x;ELSE max:=y;END IF;  -- correct but hard to read
  
  -- Easier to read:
  
  IF x > y THEN
    max:=x;
  ELSE
    max:=y;
  END IF;
END;
/
