1. create a parameter file and (optionally) a password file
2. use the parameter file to build an instance in memory
3. issue the create database command. This will generate at the minimum
  - a controlfile
  - two online redo log files
  - one datafile for SYSTEM tablespace
  - one datafile for SYSAUX tablespace
  - the data dictionary
4. Run SQL scripts to create
  - the data dictionary views 
  - the supplied PL/SQL packages
5. Run the SQL scripts to generate the Enterprise Manager Database Express as well as any options the database requires, such as
  - Java
  - Other options (add to the list)
6. On Windows systems only, run oradim.exe to be assisted in creating the Windows service

Those steps can be run <i>interactively</i> from 
- SQL*Plus 
- a GUI tool called the Database Configuration Assistance (DBCA)   

Those steps can be run <i>automatically</i> using
- scripts (SQL*Plus)
- DBCA with a response file


DISPLAY, ORACLE_BASE, ORACLE_HOME, PATH

Always put $ORACLE_HOME/bin at the beginning of your PATH variable

This variables on Windows systems are defined as registry variables set by the Oracle Universal Installer (OUI)

Gloal Database Name	:	DB_NAME
???					:	DB_DOMAIN    Non è obbligatorio (page 28)
SID					:	ORACLE_SID

<b>Oracle Managed Files (OMF)</b>
Lets Oracle take control of naming all your database files and constructing suitable directory structures

Recovery related files section 
- lets you nominate a Fast Recovery Area to be used as a default location for backups and other files related to recovery (QUALI???)
- lets you activate the archive log mode of operation (but it can be enabled at any time subsequent to database creation)


Database Options step
- Some of the options selected by default must be deselected if your license does not include them


DB_BLOCK_SIZE is the only parameter that can never be changed. It is the block size on which the SYSTEM tablespace wil be formatted. It may be set to 2K, 4K, 8K (default), 16K, 32K (only on some OS)