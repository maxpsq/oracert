/*
Cursor in PL/SQl acts as pointers to a private SQl area that stores information 
about a specifis SQL statement.

The cursors defined in PL/SQL are "session cursors" that exists only in session 
memory. When the session ends, the cursor cease to exist.

Cursor attributes allows you to get information about session cursors and can be 
referenced via procedural statements but not through SQL statements.

There are two broad classes of session cursors:

** Implicit cursors (aka SQL cursors) are constructed and managed automatically 
by PL/SQL when a Select or SQL DML statement is used within a PL/SQL block.
You can access the attributes of an implicit cursor but there is no mean you can
control them.

In order to acces implicit cursor attributes the you need to use the "SQL%" keyword 
followed by the attribute name

** Explicit cursors are constructed and managed by user-code. They have a name 
and are associated with a query (SELECT statement). Thay can be Fetched using
OPEN / FETCH or inside a cursor FOR LOOP statement.

Using Explicit cursor is not possible to:
I

The attributes of an explicit cursor are referenced by the name of the cursor
followed by the attribute

cursor_name%ISOPEN

*/