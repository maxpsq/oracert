/*

Schema SYS
--------------------------------------------
All of the base tables and views for the database's DATA DICTIONARY are stored 
in the schema SYS. These base tables and views are critical for the operation 
of Oracle. To maintain the integrity of the data dictionary, tables in the SYS 
schema are manipulated only by Oracle; they should never be modified by any user 
or database administrator, and no one should create any tables in the schema of 
the user SYS. 
The DBA should change the password for SYS immediately after database creation!!! 


Schema SYSTEM
--------------------------------------------
The SYSTEM username creates additional tables and views that display administrative 
information, and internal tables and views used by Oracle tools. Never create in the 
SYSTEM schema tables of interest to individual users. 
SYSTEM is a little bit "weaker" user than SYS, for example, it has no access to so 
called X$ tables (the very internal structure tables of Oracle). 



Cache the Data Dictionary for Fast Access
--------------------------------------------
Much of the data dictionary information is kept in the SGA in the dictionary cache, 
because Oracle constantly accesses the data dictionary during database operation to 
validate user access and to verify the state of schema objects. All information is 
stored in memory using the least recently used (LRU) algorithm.
Parsing information is typically kept in the caches. The COMMENTS columns describing 
the tables and their columns are not cached unless they are accessed frequently.

*/