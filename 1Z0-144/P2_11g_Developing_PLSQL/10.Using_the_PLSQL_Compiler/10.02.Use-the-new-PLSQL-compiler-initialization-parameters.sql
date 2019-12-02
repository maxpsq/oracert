/*
PLSCOPE_SETTINGS
---------------------
IDENTIFIERS:NONE (default)
IDENTIFIERS:ALL

Can be set on SESSION, SYSTEM or per-library (ALTER COMPILE) basis. The current
setting of PLSCOPE_SETTINGS per-library unit can be attained bu querying the
*_PLSQL_OBJECT_SETTINGS views.

Collected identifiers are accessible by the views

*_IDENTIFIERS



PLSQL_CODE_TYPE
--------------------
INTERPRETED (default)
NATIVE

When this value is changed it has no effects on objects that have alredy been 
compiled.

The value of this parameter is stored permanently with each program unit. If
a PL/SQL unit is AUTOMATICALLY recompiled, the use of the previous setting of
PLSQL_CODE_TYPE is mantained.

To mantain the use of this setting on explicit recompilation, use

ALTER PROCEDURE procname COMPILE REUSE SETTINGS;


PLSQL_OPTIMIZE_LEVEL
----------------------

0: mantains the avaluation order of Oracle 9i and earlier releases. Also removes
the semantic identity of PLS_INTEGER and BINARY_INTEGER and restores the earlier
rules for evaluation of integer expressions. Using level 0 will forfait most
of the performance gains introduced by oracle 10g

1: applies many optimizations including
  - elimination of unnecessary computations
  - elimination of unnecessary exceptions
generally does not move source code out of its original source order


2: (default) applies a wide range of optimizations beyond those of level 1 including
changes which may move source relatively far from its original location

3: Applies many optimizations beyond those of level 2, automatically including
techniques not specifically requested.


*/