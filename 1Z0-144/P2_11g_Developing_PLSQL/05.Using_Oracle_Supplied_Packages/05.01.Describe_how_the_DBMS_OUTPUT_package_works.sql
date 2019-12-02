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


declare
  status pls_integer := 0;
  buf varchar2(32767);
  counter pls_integer := 0;
begin
  for i in 1 .. 10 loop
    dbms_output.put_line(i);
  end loop;
  while status < 1 loop
    dbms_output.get_line(buf, status);
    if (status = 0 ) then
      counter := counter + 1 ;
    end if;
  end loop;
  dbms_output.put_line(counter);
end;
/


declare
  writes  constant pls_integer := 10;
  required_lines   constant pls_integer := 2;
  lines   pls_integer ;
  loops   pls_integer := 0;
  v_Data      DBMS_OUTPUT.CHARARR;
  counter pls_integer := 0;

begin
  for i in 1 .. writes loop
    dbms_output.put_line(i);
  end loop;
  loop
    loops := loops + 1;
    lines := required_lines;
    -- lines:
    --  IN: number of lines you wish to get
    --  OUT: number of lines actually gotten: OUT is always greater then or equal to IN
    dbms_output.get_lines(v_Data, lines);
    counter := counter + lines;
    exit when lines < required_lines ;
  end loop;
  dbms_output.put_line(counter);
end;
/


DBMS_OUTPUT.DISABLE;
-- Call to GET*, PUT*, NEW_LINE are ignored if the package is disabled.

DBMS_OUTPUT.ENABLE (buffer_size IN INTEGER DEFAULT 20000);

DBMS_OUTPUT.GET_LINE (line    OUT VARCHAR2, status  OUT INTEGER);

DBMS_OUTPUT.GET_LINES (lines  OUT CHARARR, numlines IN OUT  INTEGER);

DBMS_OUTPUT.GET_LINES (lines  OUT  DBMSOUTPUT_LINESARRAY, numlines    IN OUT INTEGER);

DBMS_OUTPUT.NEW_LINE;

DBMS_OUTPUT.PUT (item IN VARCHAR2);

DBMS_OUTPUT.PUT_LINE ( item IN VARCHAR2);
