
4.1 Create collections (nested table, array and associative arrays, PL SQL tables)
========================================================================================
Q. What is PL/SQL table?
A. A PL/SQL table is old gergon referring to associative arrays (aka INDEX-BY tables)

Q. Can I declare associative arrays at SCHEMA LEVEL ?
A. No, you cannot. You'll get: PLS-00355: use of pl/sql table not allowed in this 
   context.
   Notice also that associative arrays at SCHEMA LEVEL would have been theoretically 
   limited just to "INDEX BY VARCHAR(n)" because the INDEX BY clause supports BINARY_INTEGER 
   ad its subtypes that are actually PL/SQL types not available in the SQL context.

Q: What does "atomically null" means?
A: "Atomically null" refers to an uninitialized NESTED TABLE or VARRAY. 
   It cannot refer to associative arrays because they are automatically initialized 
   on declaration.

Q: What are the differences among issuing a CREATE OR REPLACE TYPE and ALTER TYPE on an 
   existing type?
A: 
