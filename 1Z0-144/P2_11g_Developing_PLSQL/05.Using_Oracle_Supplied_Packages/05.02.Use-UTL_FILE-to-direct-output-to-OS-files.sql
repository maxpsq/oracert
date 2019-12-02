/*
                          UTL_FILE PACKAGE

Security Model
----------------
The set of files and directories that are accessible to the user through UTL_FILE 
is controlled by a number of factors and database parameters. Foremost of these 
is the set of directory objects that have been granted to the user. 

Assuming the user has both READ and WRITE access to the directory object USER_DIR, 
the user can open a file located in the operating system directory described by 
USER_DIR, but not in subdirectories or parent directories of this directory.

Lastly, the client (text I/O) and server implementations are subject to operating 
system file permission checking.

UTL_FILE provides file access both on the "client side" and on the "server side". 

When run on the "server", UTL_FILE provides access to all operating system files 
that are accessible from the server. 

On the "client side", as in the case for Forms applications, UTL_FILE provides 
access to operating system files that are accessible from the client.

In the past, accessible directories for the UTL_FILE functions were specified in 
the initialization file using the UTL_FILE_DIR parameter. However, UTL_FILE_DIR 
access is no longer recommended. Oracle recommends that you instead use the 
directory object feature, which replaces UTL_FILE_DIR. 
Directory objects offer more flexibility and granular control to the UTL_FILE 
application administrator, can be maintained dynamically (that is, without shutting 
down the database), and are consistent with other Oracle tools. 

CREATE ANY DIRECTORY privilege is granted only to SYS and SYSTEM by default.

Usage of UTL_FILE_DIR:
alter system set utl_file_dir='/appl/mydir, /appl/mydir2, /appl/mydir3' scope = spfile;

bu the way, use the CREATE DIRECTORY feature instead of UTL_FILE_DIR for 
directory access verification.


================================================================================
FCLOSE Procedure
Closes a file

FCLOSE_ALL Procedure
This procedure closes all open file handles for the session. This should be used 
as an emergency cleanup procedure, for example, when a PL/SQL program exits on 
an exception.

FCOPY Procedure
Copies a contiguous portion of a file to a newly created file
UTL_FILE.FCOPY (
   src_location    IN VARCHAR2,
   src_filename    IN VARCHAR2,
   dest_location   IN VARCHAR2,
   dest_filename   IN VARCHAR2,
   start_line      IN BINARY_INTEGER DEFAULT 1,
   end_line        IN BINARY_INTEGER DEFAULT NULL); -- Line number at which to stop copying. The default is NULL, signifying end of file

FFLUSH Procedure
Physically writes all pending output to a file

FGETATTR Procedure
Reads and returns the attributes of a disk file
UTL_FILE.FGETATTR(
   location     IN VARCHAR2, 
   filename     IN VARCHAR2, 
   fexists      OUT BOOLEAN, 
   file_length  OUT NUMBER, 
   block_size   OUT BINARY_INTEGER);
   
FGETPOS Function
Returns the current relative offset position within a file, in bytes
UTL_FILE.FGETPOS (
   file IN FILE_TYPE)
 RETURN PLS_INTEGER;

FOPEN Function
This function opens a file. You can specify the maximum line size and have a maximum of 50 files open simultaneously
UTL_FILE.FOPEN (
   location     IN VARCHAR2,
   filename     IN VARCHAR2,
   open_mode    IN VARCHAR2,
   max_linesize IN BINARY_INTEGER DEFAULT 1024) 
  RETURN FILE_TYPE;
  
open_mode:
r -- read text
w -- write text
a -- append text
rb -- read byte mode
wb -- write byte mode
ab -- append byte mode
  
  
FOPEN_NCHAR Function
Opens a file in Unicode for input or output. You can specify the maximum line size and have a maximum of 50 files open simultaneously
UTL_FILE.FOPEN_NCHAR (
   location     IN VARCHAR2,
   filename     IN VARCHAR2,
   open_mode    IN VARCHAR2,
   max_linesize IN BINARY_INTEGER DEFAULT 1024) 
RETURN FILE_TYPE;

open_mode:
r -- read text
w -- write text
a -- append text
rb -- read byte mode
wb -- write byte mode
ab -- append byte mode
  

FREMOVE Procedure
Deletes a disk file, assuming that you have sufficient privileges

FRENAME Procedure
Renames an existing file to a new name, similar to the UNIX mv function

FSEEK Procedure
This procedure adjusts the file pointer forward or backward within the file by the number of bytes specified.
UTL_FILE.FSEEK (
   file             IN OUT  UTL_FILE.FILE_TYPE,
   absolute_offset  IN      PL_INTEGER DEFAULT NULL,
   relative_offset  IN      PLS_INTEGER DEFAULT NULL);

file:             File handle

absolute_offset: Absolute location to which to seek; default = NULL

relative_offset: Number of bytes to seek forward or backward; 
     positive = forward, negative integer = backward, zero = current position, default = NULL


GET_LINE Procedure
This procedure reads text from the open file identified by the file handle and 
places the text in the output buffer parameter. Text is read up to, but not 
including, the line terminator, or up to the end of the file, or up to the end 
of the len parameter. It cannot exceed the max_linesize specified in FOPEN.

UTL_FILE.GET_LINE (
   file        IN  FILE_TYPE,
   buffer      OUT VARCHAR2,
   len         IN  PLS_INTEGER DEFAULT NULL); -- It cannot exceed the max_linesize specified in FOPEN.


GET_LINE_NCHAR Procedure
Reads text in Unicode from an open file
If the file is opened by FOPEN instead of FOPEN_NCHAR, a CHARSETMISMATCH exception is raised.

GET_RAW Procedure
Reads a RAW string value from a file and adjusts the file pointer ahead by the number of bytes read

IS_OPEN Function
Determines if a file handle refers to an open file

NEW_LINE Procedure
Writes one or more operating system-specific line terminators to a file

PUT Procedure
PUT writes the text string stored in the buffer parameter to the open file identified 
by the file handle. The file must be open for write operations. No line terminator 
is appended by PUT; use NEW_LINE to terminate the line or use PUT_LINE to write a 
complete line with a line terminator. See also "PUT_NCHAR Procedure".
  
UTL_FILE.PUT (
   file      IN FILE_TYPE,
   buffer    IN VARCHAR2);
   
   
PUT_LINE Procedure
This procedure writes the text string stored in the buffer parameter to the open 
file identified by the file handle. The file must be open for write operations. 
PUT_LINE terminates the line with the platform-specific line terminator character 
or characters.

UTL_FILE.PUT_LINE (
   file      IN FILE_TYPE,
   buffer    IN VARCHAR2,
   autoflush IN BOOLEAN DEFAULT FALSE);

   
PUT_LINE_NCHAR Procedure
Writes a Unicode line to a file

PUT_NCHAR Procedure
Writes a Unicode string to a file

PUTF Procedure
This procedure is a formatted PUT procedure. It works like a limited printf().
UTL_FILE.PUTF (
   file    IN FILE_TYPE,
   format  IN VARCHAR2,
   [arg1   IN VARCHAR2  DEFAULT NULL,
   . . .  
   arg5    IN VARCHAR2  DEFAULT NULL]); 

file:       Active file handle returned by an FOPEN call

format:     Format string that can contain text as well as the formatting characters \n and %s

arg1..arg5  From one to five operational argument strings.
            Argument strings are substituted, in order, for the %s formatters in 
            the format string.
            If there are more formatters in the format parameter string than 
            there are arguments, then an empty string is substituted for each %s 
            for which there is no argument.


PUTF_NCHAR Procedure
A PUT_NCHAR procedure with formatting, and writes a Unicode string to a file, with formatting

PUT_RAW Procedure
Accepts as input a RAW data value and writes the value to the output buffer
*/