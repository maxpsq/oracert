/*
Package State

The values of the variables, constants, and cursors that a package declares 
(in either its specification or body) comprise its package state. If a PL/SQL 
package declares ** at least one ** variable, constant, or cursor, then the package 
is stateful; otherwise, it is stateless.

Each session that references a package item has its own instantiation of that 
package. If the package is stateful, the instantiation includes its state. 
The package state persists for the life of a session, except in these situations:

- The package is SERIALLY_REUSABLE.

- The package body is recompiled.

  If the body of an instantiated, stateful package is recompiled (either 
  explicitly, with the "ALTER PACKAGE Statement", or implicitly), the next 
  invocation of a subprogram in the package causes Oracle Database to discard 
  the existing package state and raise the exception ORA-04068.

  After PL/SQL raises the exception, a reference to the package causes Oracle 
  Database to re-instantiate the package, which re-initializes it. Therefore, 
  previous changes to the package state are lost. (For information about 
  initialization, see "Package Instantiation and Initialization".)

- Any of the session's instantiated packages are invalidated and revalidated.

  All of a session's package instantiations (including package states) can be 
  lost if any of the session's instantiated packages are invalidated and 
  revalidated. For information about invalidation and revalidation of schema 
  objects, see Oracle Database Advanced Application Developer's Guide.

As of Oracle Database 11g Release 2 (11.2.0.2), Oracle Database treats a package 
as stateless if its state is constant for the life of a session (or longer). 
This is the case for a package whose items are all compile-time constants.

A compile-time constant is a constant whose value the PL/SQL compiler can 
determine at compilation time. A constant whose initial value is a literal is 
always a compile-time constant. A constant whose initial value is not a literal, 
but which the optimizer reduces to a literal, is also a compile-time constant. 

Whether the PL/SQL optimizer can reduce a nonliteral expression to a literal 
depends on optimization level. Therefore, a package that is stateless when 
compiled at one optimization level might be stateful when compiled at a different 
optimization level. For information about the optimizer, see "PL/SQL Optimizer".


SERIALLY_REUSABLE Packages
=============================
SERIALLY_REUSABLE packages let you design applications that manage memory better 
for scalability.

If a package is not SERIALLY_REUSABLE, its package state is stored in the user 
global area (UGA) for each user. Therefore, the amount of UGA memory needed increases 
linearly with the number of users, limiting scalability. The package state can
persist for the life of a session, locking UGA memory until the session ends.

The global memory for serialized packages is allocated in the SGA, not in the 
user’s UGA. This approach allows the package work area to be reused. Each time 
the package is reused, its package-level variables are initialized to their 
default values or to NULL, and its initialization section is re-executed.

**  Note  **
Trying to access a SERIALLY_REUSABLE package from a database trigger, or from a 
PL/SQL subprogram invoked by a SQL statement, raises an error.



*/