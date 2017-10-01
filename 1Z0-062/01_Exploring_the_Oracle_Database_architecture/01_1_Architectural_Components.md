# List the architectural components of an Oracle Database


#### User process 
Process running on the _user's machine_.

- It requests to connect to the Database instance.  
- It generates SQL statements that sends to the [server process](#server-process)


#### Server process <a id="server-process"></a>
process in the _Instance_ that serves the user process' SQL statements. Server processes are classified as **Foreground process** because they're not vital for the instance existence.

- Each _server process_ has a _PGA_.

#### User session  
- is made up by a **user process** connecting to a [server process](#server-process)
.  
- The connection uses Oracle proprietary Oracle Net protocol.  
- the user/server split implements the _client-server architecture_

#### Background processes 
processes that make up the instance.

- They're present and running all time since the instance startup to shutdown.  
- The most of them are completely self-administering, although in some cases it is possible for the DBA to influence the number of them and their operation.  
- background processes also have a PGA


## Distributed systems architectures

They offer various possibilities of grouping instances and databases

- **Real Application Cluster (RAC)**: multiple instances open one database.
- **Streams**: multiple Oracle servers propagate transactions between each other. The Streams technology involves extracting change vectors from redo logs and apply them to remote databases.
- **Oracle Data Guard**: a primary database updates one or more standby databases in order to keep them all synchronized.

## Exercises

1.  Determine if the instance is part of a RAC database:

         SELECT parallel FROM v$instance;

    This will return `NO` for single-instance databases.

1. Determine if the database is protected against data-loss by a Data Guard standby database:

        SELECT protection_level FROM v$database;

   This will return `UNPROTECTED` if the database is needed unprotected

1. Determine whether Streams has been configured in the database:

        SELECT * FROM dba_streams_administrator;

    This will return no rows if Streams has never been configured.

1. Identify the phisical structures of the database:

        SELECT name, bytes FROM v$datafile;
        SELECT name, bytes FROM v$tempfile;
        SELECT member FROM v$logfile;
        SELECT * FROM v$controlfile;
