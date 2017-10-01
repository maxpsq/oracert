# Describe the Background processes

On Linux and Unix systems, all the Oracle processes runs as separete operating system processes, each with a unique process ID number (PID).  
On Windows, there is a single operating system process called ORACLE.EXE for the whole instance, and the Oracle processes run as separate threads within this one process.  
Since 12c is possible to run Linux/Unix instances in a multithreaded modes as on Windows. This is enabled by the THREADED_EXECUTION instance parameter.

### SMON, the System Monitor
- it _mounts_ a database by locating and validating the control file.
- it _opens_ a database by locating all datafiles and online redo log files.
- once the database is open and in use, SMON is responsible of various houskeeping tasks such as collating free space in datafiles.

### PMON, the Process Monitor
- PMON monitors all server processes and detects any problem with the sessions.
- if a user's session terminates abnormally (no logout) PMON will destroy the server process, return its PGA to the OS's free memory pool and roll back any incomplete transaction.

### DBWn, the Database Writer
- The sessions (server processes) do not as a general rule write do disk. They always write to the _database buffer cache_. An instance can have up to 100 DBWn called DBW0..DBW9, DBWa..DBWz, BW36..BW99. The default number is one database writer for eight CPUs, rounded up.
- DBWn writes dirty buffer from the database buffer cache to the datafiles
- It writes as few buffers as it can get away with, as rarely as possible, in order to reduce I/O.
- The algorithm will select buffers that have not been recently used
- Circumstances that forse DBWn to write are:
    - no free buffers
    - too many dirty buffers
    - three seconds timeout
    - a checkpoint request

**no free buffers**: a server process that needs to copy a block in memory needs to find a _free buffer_ that is a buffer that is neither dirty nor pinned (used by another session at that very moment).
- a dirty buffer cannot be overwritten in order to prevent data loss
- a pinned buffer cannot be written because the OS memory protection mecanism will not permit this.
If a server process takes to long to find a _free buffer_ it signals the DBWn to write some dirty buffers to disk. Once this is done, they will be cleaned and ready for use.  
**too many dirty buffers**: if "too many" (is defined by an internal threshold) dirty buffers are found, a few of them are written to disk.  
**three seconds timeout**: every three seconds DBWn will write a few buffers. This means that writes will happen even if the system is idle.  
**a checkpoint request**: on checkpoint requests _all_ dirty buffers are written to disk.

**incremental checkpoint** or **advancing the incremental checkpoint position** is the writing of buffers that happens for _no free buffers_, _too many dirty buffers_ and _three seconds timeout_ events. This is what can happen during normal running.

**full checkpoint** is the writing of all the dirty buffers to disk and happens when _closing the database_ on instance shutdown. Automatic checpoints occours only on shutdown, but can also be forced with

    ALTER SYSTEM CHECKPOINT;

**partial checkpoint** force DBWn to write all dirty buffers containing block from just one or more datafiles rather then the whole database. They happen when
 
- a datafile or a tablespace is taken offline
- a tablespace is put into backup mode
- a talespace is made read-only

### LGWR, the Log Writer
LGWR writes the content of the LOG buffer to the online redo log files (_flushing the log buffer_).  
When a session makes any change to blocks in the database buffer cache, before it (the server process, NdR) applies the change to the blocks it (again, the server process, NdR) writes out the change vector that it is about to apply to the log buffer.
LGWR will flush to redo logs when
- the session issues a COMMIT
- when Log buffer is 1/3 full
- when DBWn needs to write buffers to datafiles, it will signal LGWR to flush the Log buffers. This is to ensure that will always be possible to revert an uncommitted transaction. Generating UNDO data also generates change vectors	 and because these will be in the redo log files before the datafiles are updated, teh undo data needed to roll back the transaction can be reconstructed as needed.
- Because LGWR alwais write before DBWn, we can say there is a three seconds timeout also on LGWR.

### CKPT, the Checkpoint Process
The CKPT keeps track of where in the redo stream the incremental checkpoint position is. If necessary, instructs the DBWn to write out some dirty buffers in order to put the porition forward. The current checkpoint position is the point from which recovery must begin in the event of an instance crash.

- continually updates the controlfile with the current checkpoint position.

# Exercises

1.  Determine if the instance is part of a RAC database:

         SELECT parallel FROM v$instance;

    This will return `NO` for single-instance databases.

2. Determine if the database is protected against data-loss by a Data Guard standby database:

        SELECT protection_level FROM v$database;

   This will return `UNPROTECTED` if the database is needed unprotected

3. Determine whether Streams has been configured in the database:

        SELECT * FROM dba_streams_administrator;

    This will return no rows if Streams has never been configured.

4. Identify the phisical structures of the database:

        SELECT name, bytes FROM v$datafile;
        SELECT name, bytes FROM v$tempfile;
        SELECT member FROM v$logfile;
        SELECT * FROM v$controlfile;

