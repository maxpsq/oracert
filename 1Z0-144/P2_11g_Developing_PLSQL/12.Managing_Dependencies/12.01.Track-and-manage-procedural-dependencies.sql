/*

*/

select * from user_dependencies;

select * from all_dependencies;

select * from dba_dependencies;



begin deptree_fill('TABLE', USER, 'DUAl'); end;

select * from DEPTREE;

select * from IDEPTREE; -- Indented version of DEPTREE


/*
Object invalidation
-----------------------

COARSE-GRAINED INVALIDATION
Any DDL statement that changes an object will invalidate all its dependants

FINE-GRAINED INVALIDATION
A DDL statement that changes an object invalidates only dependants that relies 
on the attributes of the referenced that have been changed 
- or -
the compiled metadata of the dependant is no longer correct for the changed 
referenced attribute.


When a LOCAL subprogram is compiled with dependencies on a remote subprogram, the
compilation timestamp of the remote subprogram is stored in the object code of the
LOCAL subprogram.
ANY time the LOCAL subprogram is executed, the compilation timestamp of
the remote subprogram will be compared to the timestamp saved in the local
subprogram. If the remote timestaps is higher then the local timestamp, an
error will be raised.
If the local subprogram is executed a second time, it will be automatically 
recompiled and the timestamps of remote dependants will be saved locally.

NOTICE this behaviour may be changed setting the parameter

REMOTE_DEPENDENCIES_MODE = { TIMESTAMP | SIGNATURE } via ALTER SESSION or ALTER SYSTEM

*/

/*
Issuing a CREATE OR REPLACE VIEW will not invalidate its dependants 
if the new %ROWTYPE matches the old one.
*/