/*

A wrapped program is treated within the database just as normal PL/SQL programs 
are treated.

Restrictions on and Limitations of Wrapping
-------------------------------------------
1. avoid placing passwords and other highly sensitive information (wrapping 
   is not enough secure)
2. You cannot wrap the source code in triggers
3. Wrapped code is upward-compatible only.
4. You cannot include SQL*Plus substitution variables inside code that must be wrapped.

You can only wrap package specifications and bodies, object type specifications 
and bodies, and standalone functions and procedures. If you try to wrap any other 
SQL code it will remain unchanged.


You can tell that e PL/SQL unit is WRAPPED by the presence of the WRAPPED keyword
in its header, such as in

    PACKAGE BODY package_name WRAPPED


wrap.exe
---------------
wrap.exe, is located in the bin directory

wrap iname=infile [oname=outfile]

infile(.sql)  outfile(.plb)



DBMS_DDL
-----------------
DBMS_DDL.WRAP: Returns a string containing an obfuscated version of your code.

DBMS_DDL.CREATE_WRAPPED: Compiles an obfuscated version of your code into the database

Both programs are overloaded to work with a single string and with arrays of 
strings based on the DBMS_SQL.VARCHAR2A and DBMS_SQL.VARCHAR2S


Notice that Wrapped code i smuch larger than the original source and wrapping 
requires a longer time to compile and generate the code.

*/