/*
During the user session, the user or an application can use the 
SET ROLE statement any number of times to change the roles currently 
enabled for the session. The user must already be granted the roles 
that are named in the SET ROLE statement.

SET ROLE clerk IDENTIFIED BY password; -- Using SET ROLE to Grant a Role and Specify a Password

SET ROLE NONE; -- Disable all roles

When a user logs on, Oracle Database enables all privileges granted 
explicitly to the user and all privileges in the default roles of the 
user.

ALTER USER jane DEFAULT ROLE payclerk, pettycash;

ALTER USER jane DEFAULT ROLE ALL;

Caution:
When you create a role (other than a global role or an application role), 
it is granted implicitly to you, and your set of default roles is updated 
to include the new role. Be aware that only 148 roles can be enabled for 
a user session. When aggregate roles, such as the DBA role, are granted to 
a user, the roles granted to the role are included in the number of roles 
the user has. For example, if a role has 20 roles granted to it and you 
grant that role to the user, then the user now has 21 additional roles. 
Therefore, when you grant new roles to a user, use the DEFAULT ROLE clause 
of the ALTER USER statement to ensure that not too many roles are specified 
as that user's default roles.
*/

/* 
--=====================================================================
-- GRANT and REVOKE 
--=====================================================================
A note on Syntax:

 GRANT privilege, privilege, ... TO   grantee, grantee, ... ;
REVOKE privilege, privilege, ... FROM grantee, grantee, ... ;

------------------------------------------------------------------------
https://docs.oracle.com/database/121/DBSEG/authorization.htm#DBSEG99974

When Do Grants and Revokes Take Effect?
Depending on what is granted or revoked, a grant or revoke takes effect 
at different times.

All grants and revokes of system and object privileges to anything (users, 
roles, and PUBLIC) take immediate effect.

All grants and revokes of roles to anything (users, other roles, PUBLIC) 
take effect only when a current user session issues a SET ROLE statement 
to reenable the role after the grant and revoke, or when a new user session 
is created after the grant or revoke.

You can see which roles are currently enabled by examining the 
SESSION_ROLES data dictionary view.
----------------------------------------------------------------------
*/

CREATE ROLE TEST_ROLE ;
GRANT SELECT ON HR.EMPLOYEES TO TEST_ROLE ;
GRANT SELECT ON HR.EMPLOYEES TO OE ;

REVOKE SELECT ON HR.EMPLOYEES FROM TEST_ROLE, OE ;

/*
--=====================================================================
-- ANY (SYSTEM PRIVILEGE)
--=====================================================================
Some SYSTEM PRIVILEGES include the keyword ANY.

CREATE ANY TABLE, is the ability to create a table in any user account 
anywhere in the database.

So don't get wrong !!
	SELECT ANY TABLE
	INSERT ANY TABLE

are SYSTEM privileges and NOT OBJECT privileges.

*/

--=====================================================================
-- WITH GRANT OPTION
--=====================================================================
/*
When a user is granted a role with the WITH GRANT OPTION clause, it is 
allowed to grant the same privilege to another user.

NOTICE: You cannot assign a privilege that includes the WITH GRANT OPTION 
to a ROLE.

If you consider the ramifications of granting "with grant option" to a 
role, the security exposure becomes obvious, and the reason why Oracle 
does not allow such a security hole.  

ORA-01926: cannot GRANT to a role WITH GRANT OPTION 
Cause: Role cannot have a privilege with the grant option.
Action: Perform the grant without the grant option.
*/

--=====================================================================
-- PUBLIC
--=====================================================================
/*
The PUBLIC account is a built-in user account in the Oracle database that 
represents all users. Any objects owned by PUBLIC are treated as though 
they are owned by all the users in the database, present and future.
The GRANT statement will work with the keyword PUBLIC in the place of a 
user account name. For example:

  GRANT CREATE ANY TABLE TO PUBLIC;

This statement grants the CREATE ANY TABLE privilege to every user in the 
database. 

  REVOKE CREATE ANY TABLE FROM PUBLIC;
  
------------------------------------------------------------------------
https://docs.oracle.com/database/121/DBSEG/authorization.htm#DBSEG40048

You can grant and revoke privileges and roles from the role PUBLIC. 
Because PUBLIC is accessible to every database user, all privileges and 
roles granted to PUBLIC are accessible to every database user. By default, 
PUBLIC does not have privileges granted to it.

Security administrators and database users should grant a privilege or role 
to PUBLIC only if every database user requires the privilege or role. This 
recommendation reinforces the general rule that, at any given time, each 
database user should have only the privileges required to accomplish the 
current group tasks successfully.

Revoking a privilege from the PUBLIC role can cause significant cascading 
effects. If any privilege related to a DML operation is revoked from PUBLIC 
(for example, SELECT ANY TABLE or UPDATE ON emp), then all procedures in the 
database, including functions and packages, must be reauthorized before they 
can be used again. Therefore, be careful when you grant and revoke DML-related 
privileges to or from PUBLIC.
*/

/*
--=====================================================================
  A few SYSTEM PRIVILEGEs 
--=====================================================================

The only system privilege which cannot be granted to a role is the 
UNLIMITED TABLESPACE grant

*/

/* 


--=====================================================================
  A few OBJECT PRIVILEGEs 
--=====================================================================

  REFERENCES 
-----------------------------------------------------------------------
the REFERENCES privilege can be granted on specific columns of a table. 
The REFERENCES privilege enables the grantee to use the table on which 
the grant is made as a parent key to any foreign keys that the grantee 
wishes to create in his or her own tables. This action is controlled with 
a special privilege because the presence of foreign keys restricts the 
data manipulation and table alterations that can be done to the parent 
key. A column-specific REFERENCES privilege restricts the grantee to 
using the named columns (which, of course, must include at least one 
primary or unique key of the parent table).

REFERENCES is applicable on a Table or Materialized View

Enables a user to create a foreign key dependency on a table or 
materialized view.
The REFERENCES privilege on a parent table implicitly grants SELECT 
privilege on the parent table.

A typical use is using a FOREIGN KEY on a table referencing a parent
table in another schema.

You cannot use the REFERENCES object privilege for a table to define 
the foreign key of a table if the privilege is received through a role.
*/

GRANT REFERENCES ON "FRED"."ITEMS" TO "BOB"

/*
Now BOB can reference the table FRED.ITEMS from any table within its 
schema.
*/

/*
--=====================================================================
--                    ABOUT ACCESS CONTROL
--=====================================================================

https://docs.oracle.com/database/121/DBSEG/authorization.htm#DBSEG40048

Assume that a user is:

Granted a role that has the CREATE VIEW system privilege

Directly granted a role that has the SELECT object privilege for the 
employees table

Directly granted the SELECT object privilege for the departments table

Given these directly and indirectly granted privileges:

The user can issue SELECT statements on both the employees and departments 
tables.

Although the user has both the CREATE VIEW and SELECT privilege for the 
employees table through a role, the user cannot create a view on the employees 
table, because the SELECT object privilege for the employees table was 
granted through a role.

The user can create a view on the departments table, because the user has 
the CREATE VIEW privilege through a role and the SELECT privilege for the 
departments table directly.
-----------------------------------------------------------------------
*/