/* 
A few OBJECT PRIVILEGEs

* REFERENCES *
the REFERENCES privilege can be granted on specific columns of a table. 
The REFERENCES privilege enables the grantee to use the table on which 
the grant is made as a parent key to any foreign keys that the grantee 
wishes to create in his or her own tables. This action is controlled with 
a special privilege because the presence of foreign keys restricts the 
data manipulation and table alterations that can be done to the parent 
key. A column-specific REFERENCES privilege restricts the grantee to 
using the named columns (which, of course, must include at least one 
primary or unique key of the parent table).

*/

CREATE ROLE TEST_ROLE ;
GRANT SELECT ON HR.EMPLOYEES TO TEST_ROLE ;
GRANT SELECT ON HR.EMPLOYEES TO OE ;

REVOKE SELECT ON HR.EMPLOYEES FROM TEST_ROLE, OE ;
