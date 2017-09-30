# Backup and Recovery Concepts

Identify the importance of checkpoints, redo log files, and archive log files

<b>Checkpointing</b> is the process of forcing the DBWn to write dirty buffers from the database buffer cache to the datafiles.

<b>Checkpoint position</b> is the point in the redo stream from which instance recovery must start following a crash  
1) is advanced by the DBWn (<i>incremental checkpointing</i>)

<b>Full checkpoint</b> all dirty buffers are written to disk  

+ happens:
  
	- on orderly shutdowns with NORMAL, IMMEDIATE, TRANSACTIONAL option  
	- on DBA's request ( alter system checkpoint )
	
<b>Partial checkpoint</b> is necessary and occours automatically as part of certain operations. It will affect different buffers depending on the operation  

- taking a tablespace offline: all blocks that are part of the tablepace  
- taking a datafile offline: all blocks that are part of the datafile  
- dropping a segment: all blocks that are part of the segment  
- truncating a table: all blocks that are part of the table  
   
   
   
<b>Instance recovery</b> is automatic and occours after any instance failure (instance crash).
  
+ In principle, is nothing more then using the contents of the online logfiles to rebuild the database buffer cache to the state it was in before the crash.  
+ It requires online redo logs.   
+ Consists in  
	* replaying all changes extracted from the online redo logs that refers to data blocks and undo blocks that had not been written to disk at the time of the crash for both committed and uncommitted transactions (<i>roll forward</i> phase).  
	* each redo record contains the block address and the <i>change vector</i>
   - during roll forward:
   		- each redo record is read
   		- the appropriate block is loaded from datafiles to the buffer chache
   		- the change is applyed to the block in the buffer cache
   		- the block is written back to disk	 

   
	- once this has been done, the database can be opened (and users can connect)
     If SMON cannot find at least one member of the online logfile group, the roll forward process won't be put in place and it will be impossible to open the database.
   - after the roll forward is complete, there will be uncommitted transactions in the database that will be rolled back (<i>rollback phase</i>)
   - The undo segments populated during the roll forward phase, will garantee the read-consistency to users that eventually hit blocks that need to be rolled back and haven't yet been 
+ It's automatic and invoked issuing a STARTUP command:
   - after mounting the control file and before opening the database, SMON checks the file headers of all datafiles and online redo log files. In case of instance failure, they are all out of sync (SCN ??) then SMON goes into the instance recovery routine.

+ Because LGWR always writes ahead of DBWn, and because it writes in real time on commit, there will always be enough information in the redo log stream to reconstruct any committed changes that had not been written to the datafiles and to roll back any uncommitted chnges that had been written to the datafiles.
+ This mechanism of redo and rollback makes absolutely impossible to corrupt an Oracle database so long as there has been no physical damage. 
   
<b>Database recovery</b> is a manually initiated process following damage to the disk-based structures that make up the database, and requires archive logfiles as well as online logfiles.

