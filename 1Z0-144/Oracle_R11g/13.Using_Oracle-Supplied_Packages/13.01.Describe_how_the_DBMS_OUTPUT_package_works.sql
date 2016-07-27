/*
PUT_LINE sends messages to a buffer that have to be enabled by SET SERVEROUTPUT.


SET SERVEROUTPUT ON|OFF [SIZE 1000000];

The buffer line size limit is 327676 bytes
The default buffer size is 20000 and the maximum is unlimited

Buffered messages will never be displeyed until the end of PL/SQL blck the 
execution. Notice that messages sent to the buffer in a infinite loop, will
never be sent to the output.

It is also possoble to access the buffer from a different application using 
.get_line() or .get_lines()

DBMS_OUTPUT.ENABLE (buffer_size => NULL); -- SET SERVEROUTPUT ON|OFF [SIZE 1000000] (NULL=No limit)
DBMS_OUTPUT.DISABLE
DBMS_OUTPUT.PUT()
DBMS_OUTPUT.PUT_LINE()
DBMS_OUTPUT.NEW_LINE
DBMS_OUTPUT.GET_LINE
DBMS_OUTPUT.GET_LINES

Calls to procedures PUT, PUT_LINE, NEW_LINE, GET_LINE, and GET_LINES are ignored 
if the DBMS_OUTPUT package is not activated.
*/