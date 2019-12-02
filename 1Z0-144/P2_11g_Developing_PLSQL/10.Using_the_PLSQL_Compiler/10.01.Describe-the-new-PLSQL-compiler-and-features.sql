/*

** Automatic subprogram inlining **
--------------------------------------
Is a feature that enable the compiler to copy teh body of a subprograms in the
code where it is called. This makes almost always program execution faster.

Subprogram inlining can be set to automatically applu during compilation by
setting PLSQL_OPTIMIZE_LEVEL (default 2) to level 3


ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 0;


PLSQL_OPTIMIZE_LEVEL = 0
Zero essentially turns off optimization. Code runs as in Oracle 9i 

PLSQL_OPTIMIZE_LEVEL = 1
The compiler will apply many optimizations to your code, such as eliminating 
unnecessary computations and exceptions. It will not, in general, change the 
order of your original source code.

PLSQL_OPTIMIZE_LEVEL = 2 (default) 
The most aggressive setting available prior to Oracle Database 11g. It will 
apply many modern optimization techniques beyond level 1, and some of those 
changes may result in moving source code relatively far from its original location.

PLSQL_OPTIMIZE_LEVEL = 3
New to Oracle Database 11g, this level of optimization adds inlining of nested or 
local subprograms. It may be of benefit in extreme cases


  PRAGMA INLINE
  

** PL/Scope **
--------------------
PL/Scope is a compiler-driven tool that collects and organizes data about 
user-defined identifiers from PL/SQL source code, and makes that information 
available through the 
USER_IDENTIFIERS
ALL_IDENTIFIERS
DBA_IDENTIFIERS
data dictionary views. 
PL/Scope makes it much easier to build automatic, sophisticated quality assurance 
and search processes for your applications.

Before compiling

ALTER SESSION SET plscope_settings='IDENTIFIERS:ALL'

You can see the value of PLSCOPE_SETTINGS for any particular program unit with
a query against USER_PLSQL_OBJECT_SETTINGS.


** PL/SQL Hierarchical profiler **
------------------------------------
Reports the program execution by subprogram invocations.
- SQL and PL/SQL times are reported separately
- It reports:
  * number of subprogram invocations
  * time spent in the subprogram's descendants
  * parent-child information


** PL/SQL Native compiler **
----------------------------
Withount native compilation, source is compiled into SYSTEM CODE which is stored 
in catalog and interpreted at runtime.
Oracle 11g generates native code directly (previusly, was translated to C and than
a C compiler was needed to generate the native code). Native code is stored into
the SYSTEM tablespace.





*/