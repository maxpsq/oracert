/*

You get an unhandled exception when there is no exception block written to catch
and handle that specific exception.

When a subprogram exits with an unhandled exception, any output parameters 
passed by value will retain the value passed to the subprogram: any internal change
in the subprogram wil be lost.

Any changes made by a PL/SQL program to the DATABASE before raising an unhandled 
exception will not get rolled back.
*/