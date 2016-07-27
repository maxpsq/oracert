/*
Conditional compilation
======================================
Conditional compilation lets you customize the functionality of a PL/SQL application without removing source text. For example, you can:

Use new features with the latest database release and disable them when running the application in an older database release.

Activate debugging or tracing statements in the development environment and hide them when running the application at a production site.


How Conditional Compilation Works
----------------------------------
Conditional compilation uses selection directives, which are similar to IF statements, to select source text for compilation. The condition in a selection directive usually includes an inquiry directive. Error directives raise user-defined errors. All conditional compilation directives are built from preprocessor control tokens and PL/SQL text.

Preprocessor Control Tokens
Selection Directives
Error Directives
Inquiry Directives
Static Expressions

Preprocessor Control Tokens
A preprocessor control token identifies code that is processed before the PL/SQL unit is compiled.

Syntax

$plsql_identifier
There cannot be space between $ and plsql_identifier. For information about plsql_identifier, see "Identifiers". The character $ can also appear inside plsql_identifier, but it has no special meaning there.

These preprocessor control tokens are reserved:

$IF
$THEN
$ELSE
$ELSIF
$ERROR

Selection Directives
A selection directive selects source text to compile.

Syntax

$IF boolean_static_expression $THEN
   text
[ $ELSIF boolean_static_expression $THEN
   text
]...
[ $ELSE
   text
$END
]

For the syntax of boolean_static_expression, see "BOOLEAN Static Expressions". The text can be anything, but typically, it is either a statement (see "statement ::=") or an error directive (explained in "Error Directives").

The selection directive evaluates the BOOLEAN static expressions in the order that they appear until either one expression has the value TRUE or the list of expressions is exhausted. If one expression has the value TRUE, its text is compiled, the remaining expressions are not evaluated, and their text is not analyzed. If no expression has the value TRUE, then if $ELSE is present, its text is compiled; otherwise, no text is compiled.


Error Directives
An error directive produces a user-defined error message during compilation.

Syntax

$ERROR varchar2_static_expression $END
It produces this compile-time error message, where string is the value of varchar2_static_expression:

PLS-00179: $ERROR: string
For the syntax of varchar2_static_expression, see "VARCHAR2 Static Expressions".

For an example of an error directive, see Example 2-58.

Inquiry Directives
An inquiry directive provides information about the compilation environment.

Syntax

$$name
For information about name, which is an unquoted PL/SQL identifier, see "Identifiers".

An inquiry directive typically appears in the boolean_static_expression of a selection directive, but it can appear anywhere that a variable or literal of its type can appear. Moreover, it can appear where regular PL/SQL allows only a literal (not a variable)— for example, to specify the size of a VARCHAR2 variable.

Predefined Inquiry Directives
The predefined inquiry directives are:

$$PLSQL_LINE

A PLS_INTEGER literal whose value is the number of the source line on which the directive appears in the current PL/SQL unit. An example of $$PLSQL_LINE in a selection directive is:

$IF $$PLSQL_LINE = 32 $THEN ...
$$PLSQL_UNIT

A VARCHAR2 literal that contains the name of the current PL/SQL unit. If the current PL/SQL unit is an anonymous block, $$PLSQL_UNIT contains a NULL value. An example of $$PLSQL_UNIT in a selection directive is:

$IF $$PLSQL_UNIT IS NULL $THEN ...
Because a selection directive needs a BOOLEAN static expression, you cannot use a VARCHAR2 comparison such as:

$IF $$PLSQL_UNIT = 'AWARD_BONUS' $THEN ...
$$plsql_compilation_parameter

The name plsql_compilation_parameter is a PL/SQL compilation parameter (for example, PLSCOPE_SETTINGS). For descriptions of these parameters, see Table 1-2.

Example 2-54, a SQL*Plus script, uses the predefined inquiry directives $$PLSQL_LINE and $$PLSQL_UNIT as ordinary PLS_INTEGER and VARCHAR2 literals, respectively, to show how their values are assigned.


Example 2-54 Predefined Inquiry Directives $$PLSQL_LINE and $$PLSQL_UNIT

SQL> CREATE OR REPLACE PROCEDURE p
  2  IS
  3    i PLS_INTEGER;
  4  BEGIN
  5    DBMS_OUTPUT.PUT_LINE('Inside p');
  6    i := $$PLSQL_LINE;
  7    DBMS_OUTPUT.PUT_LINE('i = ' || i);
  8    DBMS_OUTPUT.PUT_LINE('$$PLSQL_LINE = ' || $$PLSQL_LINE);
  9    DBMS_OUTPUT.PUT_LINE('$$PLSQL_UNIT = ' || $$PLSQL_UNIT);
 10  END;
 11  /
 Procedure created.
 
SQL> BEGIN
  2   p;
  3   DBMS_OUTPUT.PUT_LINE('Outside p');
  4   DBMS_OUTPUT.PUT_LINE('$$PLSQL_UNIT = ' || $$PLSQL_UNIT);
  5  END;
  6  /
  Result:

Inside p
i = 6
$$PLSQL_LINE = 8
$$PLSQL_UNIT = P
Outside p
$$PLSQL_UNIT =
 
PL/SQL procedure successfully completed.

Example 2-55 displays the current values of PL/SQL the compilation parameters.

Example 2-55 Displaying Values of PL/SQL Compilation Parameters

BEGIN
  DBMS_OUTPUT.PUT_LINE('$$PLSCOPE_SETTINGS = '     || $$PLSCOPE_SETTINGS);
  DBMS_OUTPUT.PUT_LINE('$$PLSQL_CCFLAGS = '        || $$PLSQL_CCFLAGS);
  DBMS_OUTPUT.PUT_LINE('$$PLSQL_CODE_TYPE = '      || $$PLSQL_CODE_TYPE);
  DBMS_OUTPUT.PUT_LINE('$$PLSQL_OPTIMIZE_LEVEL = ' || $$PLSQL_OPTIMIZE_LEVEL);
  DBMS_OUTPUT.PUT_LINE('$$PLSQL_WARNINGS = '       || $$PLSQL_WARNINGS);
  DBMS_OUTPUT.PUT_LINE('$$NLS_LENGTH_SEMANTICS = ' || $$NLS_LENGTH_SEMANTICS);
END;
/
Result:

$$PLSCOPE_SETTINGS =
$$PLSQL_CCFLAGS = 99
$$PLSQL_CODE_TYPE = INTERPRETED
$$PLSQL_OPTIMIZE_LEVEL = 2
$$PLSQL_WARNINGS = ENABLE:ALL
$$NLS_LENGTH_SEMANTICS = BYTE

Note:
In the SQL*Plus environment, you can display the current values of initialization parameters, including the PL/SQL compilation parameters, with the command SHOW PARAMETERS. For more information about the SHOW command and its PARAMETERS option, see SQL*Plus User's Guide and Reference.
Assigning Values to Inquiry Directives
You can assign values to inquiry directives with the PLSQL_CCFLAGS compilation parameter. For example:

ALTER SESSION SET PLSQL_CCFLAGS = 
  'name1:value1, name2:value2, ... namen:valuen'
Each value must be either a BOOLEAN literal (TRUE, FALSE, or NULL) or PLS_INTEGER literal. The data type of value determines the data type of name.

The same name can appear multiple times, with values of the same or different data types. Later assignments override earlier assignments. For example, this command sets the value of $$flag to 5 and its data type to PLS_INTEGER:

ALTER SESSION SET PLSQL_CCFLAGS = 'flag:TRUE, flag:5'
Oracle recommends against using PLSQL_CCFLAGS to assign values to predefined inquiry directives, including compilation parameters. To assign values to compilation parameters, Oracle recommends using the ALTER SESSION statement. For more information about the ALTER SESSION statement, see Oracle Database SQL Language Reference.

Example 2-56 uses PLSQL_CCFLAGS to assign a value to the user-defined inquiry directive $$Some_Flag and (though not recommended) to itself. Because later assignments override earlier assignments, the resulting value of $$Some_Flag is 2 and the resulting value of PLSQL_CCFLAGS is the value that it assigns to itself (99), not the value that the ALTER SESSION statement assigns to it ('Some_Flag:1, Some_Flag:2, PLSQL_CCFlags:99').


Example 2-56 PLSQL_CCFLAGS Assigns Value to Itself

ALTER SESSION SET
PLSQL_CCFlags = 'Some_Flag:1, Some_Flag:2, PLSQL_CCFlags:99'
/
BEGIN
  DBMS_OUTPUT.PUT_LINE($$Some_Flag);
  DBMS_OUTPUT.PUT_LINE($$PLSQL_CCFlags);
END;
/
Result:

2
99

Note:
The compile-time value of PLSQL_CCFLAGS is stored with the metadata of stored PL/SQL units, which means that you can reuse the value when you explicitly recompile the units. For more information, see "PL/SQL Units and Compilation Parameters".
For more information about PLSQL_CCFLAGS, see Oracle Database Reference.

Unresolvable Inquiry Directives
If an inquiry directive ($$name) cannot be resolved (that is, if its value cannot be determined) and the source text is not wrapped, then PL/SQL issues the warning PLW-6003 and substitutes NULL for the value of the unresolved inquiry directive. If the source text is wrapped, the warning message is disabled, so that the unresolved inquiry directive is not revealed. For information about wrapping PL/SQL source text, see Appendix A, "PL/SQL Source Text Wrapping".

Static Expressions
A static expression is an expression whose value can be determined at compile time—that is, it does not include character comparisons, variables, or function invocations. Static expressions are the only expressions that can appear in conditional compilation directives.

A static expression is an expression whose value can be determined at compilation time (that is, it does not include references to variables or functions). Static expressions are the only expressions that can appear in conditional compilation directives.

PLS_INTEGER Static Expressions
PLS_INTEGER static expressions are:

PLS_INTEGER literals

For information about literals, see "Literals".

PLS_INTEGER static constants

For information about static constants, see "Static Constants".

NULL

BOOLEAN Static Expressions
BOOLEAN static expressions are:

BOOLEAN literals (TRUE, FALSE, or NULL)

BOOLEAN static constants

For information about static constants, see "Static Constants".

Where x and y are PLS_INTEGER static expressions:

x > y
x < y
x >= y
x <= y
x = y
x <> y
For information about PLS_INTEGER static expressions, see "PLS_INTEGER Static Expressions".

Where x and y are BOOLEAN expressions:

NOT y
x AND y
x OR y
x > y
x >= y
x = y
x <= y
x <> y
For information about BOOLEAN expressions, see "BOOLEAN Expressions".

Where x is a static expression:

x IS NULL
x IS NOT NULL
For information about static expressions, see "Static Expressions".

VARCHAR2 Static Expressions
VARCHAR2 static expressions are:

String literal with maximum size of 32,767 bytes

For information about literals, see "Literals".

NULL

TO_CHAR(x), where x is a PLS_INTEGER static expression

For information about the TO_CHAR function, see Oracle Database SQL Language Reference.

TO_CHAR(x, f, n) where x is a PLS_INTEGER static expression and f and n are VARCHAR2 static expressions

For information about the TO_CHAR function, see Oracle Database SQL Language Reference.

x || y where x and y are VARCHAR2 or PLS_INTEGER static expressions

For information about PLS_INTEGER static expressions, see "PLS_INTEGER Static Expressions".


Static Constants
A static constant is declared in a package specification with this syntax:

constant_name CONSTANT data_type := static_expression;
The type of static_expression must be the same as data_type (either BOOLEAN or PLS_INTEGER).

The static constant must always be referenced as package_name.constant_name, even in the body of the package_name package.

If you use constant_name in the BOOLEAN expression in a conditional compilation directive in a PL/SQL unit, then the PL/SQL unit depends on the package package_name. If you alter the package specification, the dependent PL/SQL unit might become invalid and need recompilation (for information about the invalidation of dependent objects, see Oracle Database Advanced Application Developer's Guide).

If you use a package with static constants to control conditional compilation in multiple PL/SQL units, Oracle recommends that you create only the package specification, and dedicate it exclusively to controlling conditional compilation. This practice minimizes invalidations caused by altering the package specification.

To control conditional compilation in a single PL/SQL unit, you can set flags in the PLSQL_CCFLAGS compilation parameter. For information about this parameter, see "Assigning Values to Inquiry Directives" and Oracle Database Reference.

In Example 2-57, the package my_debug defines the static constants debug and trace to control debugging and tracing in multiple PL/SQL units. The procedure my_proc1 uses only debug, and the procedure my_proc2 uses only trace, but both procedures depend on the package. However, the recompiled code might not be different. For example, if you only change the value of debug to FALSE and then recompile the two procedures, the compiled code for my_proc1 changes, but the compiled code for my_proc2 does not.


CREATE PACKAGE my_debug IS
  debug CONSTANT BOOLEAN := TRUE;
  trace CONSTANT BOOLEAN := TRUE;
END my_debug;
/
 
CREATE PROCEDURE my_proc1 IS
BEGIN
  $IF my_debug.debug $THEN
    DBMS_OUTPUT.put_line('Debugging ON');
  $ELSE
    DBMS_OUTPUT.put_line('Debugging OFF');
  $END
END my_proc1;
/
 
CREATE PROCEDURE my_proc2 IS
BEGIN
  $IF my_debug.trace $THEN
    DBMS_OUTPUT.put_line('Tracing ON');
  $ELSE
    DBMS_OUTPUT.put_line('Tracing OFF');
  $END
END my_proc2;
/


DBMS_DB_VERSION Package
The DBMS_DB_VERSION package provides these static constants:

The PLS_INTEGER constant VERSION identifies the current Oracle Database version.

The PLS_INTEGER constant RELEASE identifies the current Oracle Database release number.

Each BOOLEAN constant of the form VER_LE_v has the value TRUE if the database version is less than or equal to v; otherwise, it has the value FALSE.

Each BOOLEAN constant of the form VER_LE_v_r has the value TRUE if the database version is less than or equal to v and release is less than or equal to r; otherwise, it has the value FALSE.

All constants representing Oracle Database 10g or earlier have the value FALSE.

For more information about the DBMS_DB_VERSION package, see Oracle Database PL/SQL Packages and Types Reference.

Conditional Compilation Examples
Example 2-58 generates an error message if the database version and release is less than Oracle Database 10g Release 2 ; otherwise, it displays a message saying that the version and release are supported and uses a COMMIT statement that became available at Oracle Database 10g Release 2 .

Example 2-58 Code for Checking Database Version

BEGIN
  $IF DBMS_DB_VERSION.VER_LE_10_1 $THEN  -- selection directive begins
    $ERROR 'unsupported database release' $END  -- error directive
  $ELSE
    DBMS_OUTPUT.PUT_LINE (
      'Release ' || DBMS_DB_VERSION.VERSION || '.' ||
      DBMS_DB_VERSION.RELEASE || ' is supported.'
    );
  -- This COMMIT syntax is newly supported in 10.2:
  COMMIT WRITE IMMEDIATE NOWAIT;
  $END  -- selection directive ends
END;
/

Result:
Release 11.1 is supported.

Example 2-59 sets the values of the user-defined inquiry directives $$my_debug and $$my_tracing and then uses conditional compilation:

In the specification of package my_pkg, to determine the base type of the subtype my_real (BINARY_DOUBLE is available only for Oracle Database versions 10g and later.)

In the body of package my_pkg, to compute the values of my_pi and my_e differently for different database versions

In the procedure circle_area, to compile some code only if the inquiry directive $$my_debug has the value TRUE.

Example 2-59 Compiling Different Code for Different Database Versions

ALTER SESSION SET PLSQL_CCFLAGS = 'my_debug:FALSE, my_tracing:FALSE';
 
CREATE OR REPLACE PACKAGE my_pkg AS
  SUBTYPE my_real IS
    $IF DBMS_DB_VERSION.VERSION < 10 $THEN
      NUMBER;
    $ELSE
      BINARY_DOUBLE;
    $END
  
  my_pi my_real;
  my_e  my_real;
END my_pkg;
/
 
CREATE OR REPLACE PACKAGE BODY my_pkg AS
BEGIN
  $IF DBMS_DB_VERSION.VERSION < 10 $THEN
    my_pi := 3.14159265358979323846264338327950288420;
    my_e  := 2.71828182845904523536028747135266249775;
  $ELSE
    my_pi := 3.14159265358979323846264338327950288420d;
    my_e  := 2.71828182845904523536028747135266249775d;
  $END
END my_pkg;
/
 

 CREATE OR REPLACE PROCEDURE circle_area(radius my_pkg.my_real) IS
  my_area       my_pkg.my_real;
  my_data_type  VARCHAR2(30);
BEGIN
  my_area := my_pkg.my_pi * (radius**2);
  
  DBMS_OUTPUT.PUT_LINE
    ('Radius: ' || TO_CHAR(radius) || ' Area: ' || TO_CHAR(my_area));
  
  $IF $$my_debug $THEN
    SELECT DATA_TYPE INTO my_data_type
    FROM USER_ARGUMENTS
    WHERE OBJECT_NAME = 'CIRCLE_AREA'
    AND ARGUMENT_NAME = 'RADIUS';
 
    DBMS_OUTPUT.PUT_LINE
      ('Data type of the RADIUS argument is: ' || my_data_type);
  $END
END;
/

CALL DBMS_PREPROCESSOR.PRINT_POST_PROCESSED_SOURCE
 ('PACKAGE', 'HR', 'MY_PKG');

 Result:

PACKAGE my_pkg AS
SUBTYPE my_real IS
BINARY_DOUBLE;
my_pi my_real;
my_e my_real;
END my_pkg;
 
Call completed.
Retrieving and Printing Post-Processed Source Text

The DBMS_PREPROCESSOR package provides subprograms that retrieve and print the source text of a PL/SQL unit in its post-processed form. For information about the DBMS_PREPROCESSOR package, see Oracle Database PL/SQL Packages and Types Reference.

Example 2-60 invokes the procedure DBMS_PREPROCESSOR.PRINT_POST_PROCESSED_SOURCE to print the post-processed form of my_pkg (from Example 2-59). Lines of code in Example 2-59 that are not included in the post-processed text appear as blank lines.

Example 2-60 Displaying Post-Processed Source Textsource text

CALL DBMS_PREPROCESSOR.PRINT_POST_PROCESSED_SOURCE (
  'PACKAGE', 'HR', 'MY_PKG'
);
Result:

PACKAGE my_pkg AS
SUBTYPE my_real IS
BINARY_DOUBLE;
my_pi my_real;
my_e my_real;
END my_pkg;

Conditional Compilation Directive Restrictions
A conditional compilation directive cannot appear in the specification of a schema-level user-defined type (created with the "CREATE TYPE Statement"). This type specification specifies the attribute structure of the type, which determines the attribute structure of dependent types and the column structure of dependent tables.

Caution:
Using a conditional compilation directive to change the attribute structure of a type can cause dependent objects to "go out of sync" or dependent tables to become inaccessible. Oracle recommends that you change the attribute structure of a type only with the "ALTER TYPE Statement". The ALTER TYPE statement propagates changes to dependent objects.
The SQL parser imposes these restrictions on the location of the first conditional compilation directive in a stored PL/SQL unit or anonymous block:

In a package specification, a package body, a type body, and in a schema-level subprogram with no formal parameters, the first conditional compilation directive cannot appear before the keyword IS or AS.

In a schema-level subprogram with at least one formal parameter, the first conditional compilation directive cannot appear before the left parenthesis that follows the subprogram name.

This example is correct:

CREATE OR REPLACE PROCEDURE my_proc (
  $IF $$xxx $THEN i IN PLS_INTEGER $ELSE i IN INTEGER $END
) IS BEGIN NULL; END my_proc;
/
In a trigger or an anonymous block, the first conditional compilation directive cannot appear before the keyword DECLARE or BEGIN, whichever comes first.

The SQL parser also imposes this restriction: If an anonymous block uses a placeholder, the placeholder cannot appear in a conditional compilation directive. For example:

BEGIN
  :n := 1; -- valid use of placeholder
  $IF ... $THEN
    :n := 1; -- invalid use of placeholder
$END

*/

