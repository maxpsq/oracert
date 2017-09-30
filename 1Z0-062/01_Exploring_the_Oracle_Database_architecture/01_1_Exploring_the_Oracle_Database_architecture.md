# Exploring the Oracle Database architecture

<b>User process</b>: Process running on the <i>user's machine</i>.  
- It requests to connect to the Database instance.  
- It generates SQL statements  


<b>Server process</b>: process in the <i>Instance</i> that serves the user process' SQL statements. Server processes are classified as <b>Foreground process</b> because they're not vital for the instance existence.  
- Each <i>server process</i> has a <i>PGA</i>

<b>User session</b>:  
- is made up by a <b>user process</b> connecting to a <b>server process</b>.  
- The connection uses Oracle proprietary Oracle Net protocol.  
- the user/server split implements the <i>client-server architecture</i>

<b>Background processes</b>: processes that make up the instance.  
- They're present and running all time since the instance startup.  
- The most of them are completely self-administering, although in some cases it is possible for the DBA to influence the number of them and their operation.  
- background processes also have a PGA  



<b>System Global Area (SGA)</b> consists of memory structures which are implemented in  shared memory segments provided by the OS.  
- is allocated at instance startup and released at shutdown  
- within certain limits, the SGA and its components can be resized while the instance is running (either automatically or by DBA's instructon).  
- SGA is accessible to all <i>background</i> and <i>foreground</i> processes

<b>Program Global Area (PGA)</b>: non-sharable memory area associated with each <i>server process</i>.  
- PGA is private to the foreground or background process it serves.  
- The size of each PGA varies according to the process needs at any one time.  
- Oracle manage the allocation dynamically  
- The DBA can limit the total size of all PGAs  

### Distributed systems architectures

They offer various possibilities of grouping instances and databases

- <b>Real Application Cluster (RAC)</b>: multiple instances open one database.
- <b>Streams</b>: multiple Oracle servers propagate transactions between each other.
- <b>Oracle Data Guard</b>: a primary database updates one or more standby databases in order to keep them all synchronized.


## Exercises

1.  Determine if the instance is part of a RAC database:

         SELECT parallel FROM v$instance;

    This will return <code>NO</code> for single-instance databases.

2. Determine if the database is protected against data-loss by a Data Guard standby database:

        SELECT protection_level FROM v$database;

    This will return UNPROTECTED if the database is needed unprotected.

 3. Determine whether Streams has been configured inz the database:

        SELECT * FROM dba_streams_administrator;

    This will return no rows if Streams has never been configured.

4. Identify the phisical structures of the database:

        SELECT name, bytes FROM v$datafile;
        SELECT name, bytes FROM v$tempfile;
        SELECT member FROM v$logfile;
        SELECT * FROM v$controlfile;
