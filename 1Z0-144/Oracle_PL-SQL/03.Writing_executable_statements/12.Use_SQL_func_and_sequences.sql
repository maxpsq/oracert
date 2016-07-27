USE SQL FUNCTIONS in PL/SQL
===============================

PL/SQL supports direct access to many SQL built-in functions.

There is NO DIRECT SUPPORT for:

1. Aggregate (Group) Functions
2. Analytic functions
3. Model Functions ???
4. Data mining functions
5. Encoding and decoding functions
6. Object reference functions
7. XML functions

most of the functions above involve multiple rows which is a 
key indicator that is not working in PL/SQL.

In addition to the above list there are a few miscellaneous functions that
cannot be used including:
CUBE_TABLE
DATAOBJ_TO_PARTITION
LNNVL
NVL2
SYS_CONNECT_BY_PATH
SYS_TYPEID
WIDTH_BUCKET


SEQUENCES in PL/SQL
===============================
Prior to Oracle 11g R1 the only way to access a sequence was to 
use SQL SELECT .. INTO statement.

With 11g it's possile to access a sequence value wherever you can use 
a NUMBER expression

v_id := MYSEQ.NEXTVAL ;

Notice that accessing a SEQUENCE from PL/SQL improves performance  
avoiding context switches.

