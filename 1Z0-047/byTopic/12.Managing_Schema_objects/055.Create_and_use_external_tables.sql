-- ============================================================
--                  External tables
-- ============================================================
/*
External tables are created using the SQL 
CREATE TABLE...ORGANIZATION EXTERNAL statement. 

When you create an external table, you specify the following attributes:

- TYPE: specifies the type of external table. The two available types 
  are the ORACLE_LOADER type and the ORACLE_DATAPUMP type. Each type of 
  external table is supported by its own access driver.

  A) The ORACLE_LOADER access driver is the default. It can perform only 
  data loads, and the data must come from text datafiles. Loads from 
  external tables to internal tables are done by reading from the external 
  tables' text-only datafiles.

  B) The ORACLE_DATAPUMP access driver can perform both loads and unloads. 
  The data must come from binary dump files. Loads to internal tables from 
  external tables are done by fetching from the binary dump files. Unloads 
  from internal tables to external tables are done by populating the external 
  tables' binary dump files.

- DEFAULT DIRECTORY: specifies the default location of files that are read 
  or written by external tables. The location is specified with a directory 
  object, not a directory path. See Location of Datafiles and Output Files 
  for more information.

- ACCESS PARAMETERS: describe the external data source and implements the 
  type of external table that was specified. Each type of external table has 
  its own access driver that provides access parameters unique to that type 
  of external table. See Access Parameters.

- LOCATION: specifies the location of the external data. The location is 
  specified as a list of directory objects and filenames. If the directory 
  object is not specified, then the default directory object is used as the 
  file location.

SQL> CREATE TABLE emp_load
  2    (employee_number      CHAR(5),
  3     employee_dob         CHAR(20),
  4     employee_last_name   CHAR(20),
  5     employee_first_name  CHAR(15),
  6     employee_middle_name CHAR(15),
  7     employee_hire_date   DATE)
  8  ORGANIZATION EXTERNAL
  9    (TYPE ORACLE_LOADER
 10     DEFAULT DIRECTORY def_dir1    --> This is optional
 11     ACCESS PARAMETERS
 12       (RECORDS DELIMITED BY NEWLINE
 13        FIELDS (employee_number      CHAR(2),
 14                employee_dob         CHAR(20),
 15                employee_last_name   CHAR(18),
 16                employee_first_name  CHAR(11),
 17                employee_middle_name CHAR(11),
 18                employee_hire_date   CHAR(10) date_format DATE mask "mm/dd/yyyy"
 19               )
 20       )
 21     LOCATION ('info1.dat', 'info2.dat', 'info3.dat') --> you can specify many source files
 22    ) NO PARALLEL | PARALLEL 3 ;


Location of Datafiles and Output Files
------------------------------------------
The access driver runs inside the database server. This is different 
from SQL*Loader, which is a client program that sends the data to be 
loaded over to the server. This difference has the following implications:

- The server must have access to any files to be loaded by the access driver.

- The server must create and write the output files created by the access 
  driver: the log file, bad file, and discard file, as well as any dump files 
  created by the ORACLE_DATAPUMP access driver.

The access driver does not allow you to specify a complete specification for 
files. This is because the server may have access to files that you do not, 
and allowing you to read this data would affect security. Similarly, you might 
overwrite a file that you normally would not have privileges to delete.

Instead, you are required to specify directory objects as the locations from 
which to read files and write files. A directory object maps a name to a 
directory name on the file system. For example, the following statement creates 
a directory object named ext_tab_dir that is mapped to a directory 
located at /usr/apps/datafiles.


CREATE DIRECTORY ext_tab_dir AS '/usr/apps/datafiles';


Directory objects can be created by DBAs or by any user with 
the CREATE ANY DIRECTORY privilege.

After a directory is created, the user creating the directory object needs 
to grant READ and WRITE privileges on the directory to other users. 
These privileges must be explicitly granted, rather than assigned through 
the use of roles. For example, to allow the server to read files on behalf 
of user scott in the directory named by ext_tab_dir, the user who created 
the directory object must execute the following command:

GRANT READ, WRITE ON DIRECTORY ext_tab_dir TO scott;

The DEFAULT DIRECTORY clause, which specifies the default directory to 
use for all input and output files that do not explicitly name a directory 
object.

The LOCATION clause, which lists all of the datafiles for the external table. 
The files are named in the form directory:file. The directory portion is 
optional. If it is missing, the default directory is used as the directory 
for the file.
 20       )
 21     LOCATION ('ext_tab_dir:info1.dat', 'ext_tab_dir:info2.dat', 'ext_tab_dir:info3.dat') --> you can specify many source files
 22    );

*/