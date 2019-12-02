/*
To CREATE or REPLECE a PROCEDURE
- in your own schema, you must have the CREATE PROCEDURE system privilege
- in another user's schema, you must have the CREATE ANY PROCEDURE system privilege.

You can DROP a procedure when either of this conditions is met:
- the procedure is in your own schema and you have the CREATE PROCEDURE system privilege
- you have the DROP ANY PROCEDURE system privilege.

You can ALTER a PROCEDURE when either of this conditions is met: 
- the procedure is in your own schema 
- you have ALTER ANY PROCEDURE system privilege.



ALTER PROCEDURE procedure_name COMPILE [ DEBUG ] [ compiler_parameter_clause ] [ [ REUSE ] [ SETTINGS ] ]

COMPILE 

Specify COMPILE to recompile the procedure. The COMPILE keyword is required. the database recompiles the procedure regardless of whether it is valid or invalid.

the database first recompiles objects upon which the procedure depends, if any of those objects are invalid.

the database also invalidates any local objects that depend upon the procedure, such as procedures that call the recompiled procedure or package bodies that define procedures that call the recompiled procedure.

If the database recompiles the procedure successfully, then the procedure becomes valid. If recompiling the procedure results in compilation errors, then the database returns an error and the procedure remains invalid. You can see the associated compiler error messages with the SQL*Plus command SHOW ERRORS.

During recompilation, the database drops all persistent compiler switch settings, retrieves them again from the session, and stores them at the end of compilation. To avoid this process, specify the REUSE SETTINGS clause.


DEBUG

Specify DEBUG to instruct the PL/SQL compiler to generate and store the code for use by the PL/SQL debugger. Specifying this clause is the same as specifying PLSQL_DEBUG = TRUE in the compiler_parameters_clause.

COMPILE_PARAMETER_CLAUSE

Use this clause to specify a value for one of the PL/SQL persistent compiler parameters. The value of these initialization parameters at the time of compilation is stored with the unit's metadata. You can learn the value of such a parameter by querying the appropriate *_PLSQL_OBJECT_SETTINGS view. The PL/SQL persistent parameters are PLSQL_OPTIMIZE_LEVEL, PLSQL_CODE_TYPE, PLSQL_DEBUG, PLSQL_WARNINGS, PLSQL_CCFLAGS, and NLS_LENGTH_SEMANTICS.

You can specify each parameter only once in each statement. Each setting is valid only for the current library unit being compiled and does not affect other compilations in this session or system. To affect the entire session or system, you must set a value for the parameter using the ALTER SESSION or ALTER SYSTEM statement.

If you omit any parameter from this clause and you specify REUSE SETTINGS, then if a value was specified for the parameter in an earlier compilation of this library unit, the database uses that earlier value. If you omit any parameter and either you do not specify REUSE SETTINGS or no value has been specified for the parameter in an earlier compilation, then the database obtains the value for that parameter from the session environment.

Restriction on the compiler_parameters_clause  
You cannot set a value for the PLSQL_DEBUG parameter if you also specify DEBUG, because both clauses set the PLSQL_DEBUG parameter, and you can specify a value for each parameter only once.


REUSE SETTINGS

Specify REUSE SETTINGS to prevent Oracle from dropping and reacquiring compiler switch settings. With this clause, Oracle preserves the existing settings and uses them for the recompilation of any parameters for which values are not specified elsewhere in this statement.

For backward compatibility, the database sets the persistently stored value of the PLSQL_COMPILER_FLAGS initialization parameter to reflect the values of the PLSQL_CODE_TYPE and PLSQL_DEBUG parameters that result from this statement.

*/
