# Explain the memory structures

## System Global Area (SGA) 
consists of memory structures which are implemented in  shared memory segments provided by the OS.  

- is allocated at instance startup and released at shutdown  
- within certain limits, the SGA and its components can be resized while the instance is running (either automatically or by DBA's instructon).  
- SGA is accessible to all _background_ and _foreground_ processes
- At a minimum, SGA will contain
     + the **database buffer cache** default pool [always]
     + the **log buffer** [always]
     + the **shared pool** [always]
     + a **Large pool** [optional]
     + a **Java pool** [optional]
     + a **Streams pool** [optional]
     + the **additional buffer cache** pools [optional]

### Database buffer cache
When executing SQL statements, the data blocks containing the records of interest, are first copied to the buffer cache and then eventual changes are applied to these copies. The blocks remain in the cache for some time afterards until the buffer they are occupying is needed for another block.  
Also when querying, the blocks are copied from the datafiles to the buffer cache. The projection of the relevent rows is then transfered to the session's PGA for further processing.

- the buffer cache is formatted at instance startup by the size of the BLOCK_SIZE. The larger is the buffer cache, the longer will take the instance to startup.

- the size of the buffer cache is critical for performance and it should be sized for caching all the frequently accessed blocks.

- an undersized buffer cache will cause intensive I/O activity for excessive block transfer from and to the datafiles.

- an oversized buffer cache is not bad but may lead to memory swap if larger then the available RAM.

- the buffer cache can be resized manually or automatically at any time.

### Log Buffer
is a small, short-term staging area for **change vectors** before they are written to **redo logs** on disk.

- it is written by **server processes**
- it is written out to **redo logs** on disk in batches made of transactions from many different sessions.
- writes on disk happens in _very nearly real time_
- writes on disk _on commits_ does happen in _actual real time_
- the writes are done by LGWR
- the log buffer size is determined bu the Oracle database and is determined is base on the number of CPUs on the server node.
- it cannot be resized without restarting the instance.
- when change vectors are put in the buffer at a higher rate than the LGWR write them out, all DMLs are ceased until the writer clear the log buffer.
- writes from buffer to redo logs are the fastest operation in the database. If those writes are the limiting factor, the only option is moving to a RAC where each instance has its own log buffer and its own LGWR.

**COMMIT**

- The session will hang until the COMMIT completes
- The _commit complete_ message is not returned to the session until
  - the data blocks in the cache have been changed
  - the _change vectors_ have been written to the _redo log_ on disk. 
- The change of data blocks and writing of the logs on disk will ensure transaction recovery.

### Shared pool

Shared pool is part of the SGA and contains _hundreds of structures_ all internally managed by the Oracle instance. We'll take a look at only four of them:
- must be properly sized to contain all the frequently used code and frequently needed object definitions, not so large that it caches statements that have only been executed once.
- an oversized shared pool will have a bad impact becaus it will take too long to search it.
- there is a minimum size under which statements will fail.
- Memory in the shared pool is allocated according to a Least Recently Used algorithm (LRU): when Oracle need space, it will overwrite the objecttah has not been used for the longest time.
- Since Oracle 9i the shared pool can be resized at any time.
- The resizing can be manual or (since 10g onward) automatic according to workload if the automatic mechanism has been enabled.

**Library cache**: stores recently executed code in its parsed form, ready for execution (it can be executed immediately).
- The algorithm used to find the code in the library cache is based on ASCII and it generates SQL_IDs.

**Data Dictionary cache (Row cache)**: it stores recently used object definitions (metadata from the Data Dictionary).
- enhances parses performance

**PL/SQL area**: contains procedures, functions, package procedures and functions, object type definitions and triggers.
- anonymous PL/SQL cannot be cached and reused and it must be compiled dynamically every time it is issued.

**Result cache** 
- SQL query results are stored in this result cache so that it is not necessary to re-execute the code. Any modification of the records in a table that is cached will invalidate the cached result.
- results of PL/SQL function are stored in the cache associated with the function name and the input parameter values.
- Use of the result cache is disabled by dafault
- Unlike other memory areas in the shared pool, result cache maximum size can be set by DBAs. 

### Large pool
 It is good practice to create the Large pool when using shared server processes or parallel execution servers (if no large pool is present they will use the shared pool, possibly causing bad contention).  
Other I/O operation may use this area like Recovery Manager when backing up to a tape device.

### Java pool
 it is used as heap space to instantiate Java objects. Notice it is not used for caching code. Java code is cached in the Library cache in the same way as PL/SQL code.

### Streams pool
The Streams technology involves extracting change vectors from redo logs and apply them to remote databases. The process that read from redo logs and the process that applies changes require memory. Since 10g onward the Streams pool can be resized at any time.

### Additional buffer cache pools
Additional buffer cache pools are memory areas formatted with specific block sizes, different from the block size set during the creation of the database.
They are used as the default database buffer cache.
### Shared I/O pool
Used for Securfile LOBs operations if NOCACHE (default) is used for the LOBs

- Oracle can adjust this area up to 4% of the buffer cache, default size is zero.

## Program Global Area (PGA)
non-sharable memory area associated with each _server process_.  
- PGA is private to the foreground or background process it serves.  
- The size of each PGA varies according to the process needs at any one time.  
- Oracle manage the allocation dynamically  
- The DBA can limit the total size of all PGAs  

# Execises

5. Issue the command `SHOW SGA` FROM SQL*Plus

        SQL> SHOW SGA

        Total System Global Area 5094195200 bytes                                       
        Fixed Size                  2413216 bytes                                       
        Variable Size             922750304 bytes                                       
        Database Buffers         4160749568 bytes                                       
        Redo Buffers                8282112 bytes                                       

6. Query the V$SGA_DYNAMIC_COMPONENTS

        set pagesize 2000
        set feedback off
        col component format a30
        SELECT component, current_size, min_size, max_size
          FROM v$sga_dynamic_components;
        
        COMPONENT                      CURRENT_SIZE   MIN_SIZE   MAX_SIZE               
        ------------------------------ ------------ ---------- ----------               
        shared pool                       872415232  872415232  872415232               
        large pool                         33554432   33554432  150994944               
        java pool                          16777216   16777216   16777216               
        streams pool                              0          0          0               
        DEFAULT buffer cache             3892314112 3892314112 4160749568               
        KEEP buffer cache                         0          0          0               
        RECYCLE buffer cache                      0          0          0               
        DEFAULT 2K buffer cache                   0          0          0               
        DEFAULT 4K buffer cache                   0          0          0               
        DEFAULT 8K buffer cache                   0          0          0               
        DEFAULT 16K buffer cache                  0          0          0               
        DEFAULT 32K buffer cache                  0          0          0               
        Shared IO Pool                    268435456          0  268435456               
        Data Transfer Cache                       0          0          0               
        ASM Buffer Cache                          0          0          0               

7. Determine how much memory has been, and is currently allocated to PGA

        SELECT name, value FROM v$pgastat 
         WHERE name in ('maximum PGA alloacted', 'total PGA allocated'); 

