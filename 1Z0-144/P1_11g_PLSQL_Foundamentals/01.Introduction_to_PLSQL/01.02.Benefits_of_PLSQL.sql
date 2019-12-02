document

                              BENEFITS OF PL/SQL

  Thight integration with SQL
  ========================================
  - You can execute DML, TCL, cursor control
  - PL/SQL can use existing SQL functions
  - PL/SQL supports SQl data types without need of conversion

#
pause Press ENTER to continue

document

  High Performance
  ========================================

  Bind Variables
  ----------------------------------------
  When you embed a SQL INSERT, UPDATE, DELETE, MERGE, or SELECT statement
  directly in your PL/SQL code, the PL/SQL compiler turns the variables in
  the WHERE and VALUES clauses into bind variables (for details, see
  "Resolution of Names in Static SQL Statements"). Oracle Database can
  reuse these SQL statements each time the same code runs, which improves
  performance.

  PL/SQL does not create bind variables automatically when you use dynamic
  SQL, but you can use them with dynamic SQL by specifying them explicitly
  (for details, see "EXECUTE IMMEDIATE Statement").

  Subprograms
  ----------------------------------------
  Because stored subprograms run in the database server, a single
  invocation over the network can start a large job. Reducing network traffic
  and improving response times. Stored subprograms are cached and shared among
  users, which lowers memory requirements and invocation overhead.


  Optimizer
  ----------------------------------------
  The PL/SQL compiler has an optimizer that can rearrange code for better
  performance. For more information about the optimizer, see "PL/SQL Optimizer".

#
