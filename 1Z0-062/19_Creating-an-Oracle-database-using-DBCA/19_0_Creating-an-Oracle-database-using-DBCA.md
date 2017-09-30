# Creating an Oracle Database using DBCA

## Terminology

### Instance

- it's transient and it can be started and stopped 
- It's made of memory structures (RAM) and processes (CPU)
- Creating an instance is creating memory structures and running the processes.
- An instance is defined by an instance parameter file that defines how the instance should be built in memory and the behavior of background processes.
- After an instance has been built it is said to be in "no mount" mode. The database may not have been created at this point

### Instance modes
- MOUNT mode: the instance has successfully connected to the control file
- OPEN mode: the instance is connected to all the available online redo log files and all the available datafiles


### Data Dictionary
 
- is a set of objects within the database
- describes all phisical and logical structures in the database
- i create by running a set of scripts that resides in $HORACLE_HOME/rdbms/admin and have a "cat" prefix 

###Data dictionary creation files
Are the SQL scripts containing the instructions to create the Data Dictionary.
 
+ catalog.sql and catproc.sql should always be run after database creation
+ other optional scripts can be run right after database creation
+ other optional scripts may be run subsequently

### Database

- It's persistent
- It's composed of files on disk
- Creating a database is made by the instance as a once-off operation
- The database creation process involves creating the bare minimum of physical structures needed to support the data dictionary and then creating the data dictionary within them.
- The instance can open and close the database. The database is not accessible without the instance.

### Oracle Database Server
 is a Database and an Instance. The two are separated but connected.

### Controlfile
- contains the database name (must be the same value contained in DB_NAME parameter)
- contains pointers to the online redo log files and the datafiles
- contains a mapping of datafiles to tablespaces

### Parameters
All parameters either specifid by <b>parameter file</b> or set implicitly have defaults, except for DB_NAME parameter. 

DB_NAME parameter names the database to which the instance will connect. It may be changed later, but it will require downtime. This name is also embedded in the control file. In case of mismatch in this names, the database will not mount.



### Relations between logical and physical structures
Relations between logical and physical structures are guarenteed by the controlfile and the data dictionary

+ controlfile => datafiles
+ datafiles => SYSTEM tablespace => Data dictionary
+ Data dictionary => Database objects => Segments and position within the segments

### Creating a database

1. create the instance
2. create the database
3. create the data dictionary
4. make the database usable
