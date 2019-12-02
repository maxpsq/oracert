/*
UTL_MAIL is not installed by default because of the SMTP_OUT_SERVER configuration 
requirement and the security exposure this involves. In installing UTL_MAIL, 
you should take steps to prevent the port defined by SMTP_OUT_SERVER being 
swamped by data transmissions.

This package is now an invoker's rights package and the invoking user will need 
the connect privilege granted in the access control list (ACL) assigned to the remote 
network host to which he wants to connect.

You must both install UTL_MAIL and define the SMTP_OUT_SERVER.

You define the SMTP_OUT_SERVER parameter in the init.ora rdbms initialization file. 
However, if SMTP_OUT_SERVER is not defined, this invokes a default of DB_DOMAIN 
which is guaranteed to be defined to perform appropriately.

**  Rules and Limits  **
Use UTL_MAIL only within the context of the ASCII and EBCDIC (Extended Binary-Coded Decimal Interchange Code) codes.


SEND Procedure
This procedure packages an email message into the appropriate format, locates SMTP 
information, and delivers the message to the SMTP server for forwarding to the 
recipients. It hides the SMTP API and exposes a one-line email facility for 
ease of use.

UTL_MAIL.SEND (
   sender      IN    VARCHAR2 CHARACTER SET ANY_CS,
   recipients  IN    VARCHAR2 CHARACTER SET ANY_CS,                -- COMMA SEPARATED
   cc          IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,   -- COMMA SEPARATED
   bcc         IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,   -- COMMA SEPARATED
   subject     IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   message     IN    VARCHAR2 CHARACTER SET ANY_CS,
   mime_type   IN    VARCHAR2 DEFAULT 'text/plain; charset=us-ascii',
   priority    IN    PLS_INTEGER DEFAULT 3,                        -- 1 (highest) .. 5 (lowest) 
   replyto     IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL);  -- Defines to whom the reply email is to be sent



SEND_ATTACH_RAW Procedure
This procedure is the SEND Procedure overloaded for RAW attachments.

UTL_MAIL.SEND_ATTACH_RAW (
   sender           IN    VARCHAR2 CHARACTER SET ANY_CS,
   recipients       IN    VARCHAR2 CHARACTER SET ANY_CS,
   cc               IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   bcc              IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   subject          IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   message          IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   mime_type        IN    VARCHAR2 DEFAULT CHARACTER SET ANY_CS
                              DEFAULT 'text/plain; charset=us-ascii',
   priority         IN    PLS_INTEGER DEFAULT 3,
   attachment       IN    RAW,
   att_inline       IN    BOOLEAN DEFAULT TRUE,  -- Specifies whether the attachment is viewable inline with the message body, default is TRUE
   att_mime_type    IN    VARCHAR2 CHARACTER SET ANY_CS 
                                           DEFAULT 'text/plain; charset=us-ascii', 
   att_filename     IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   replyto          IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL);   


SEND_ATTACH_VARCHAR2 Procedure
This procedure is the SEND Procedure overloaded for VARCHAR2 attachments.

UTL_MAIL.SEND_ATTACH_VARCHAR2 (
   sender            IN    VARCHAR2 CHARACTER SET ANY_CS,
   recipients        IN    VARCHAR2 CHARACTER SET ANY_CS,
   cc                IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   bcc               IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   subject           IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   message           IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL,
   mime_type         IN    VARCHAR2 CHARACTER SET ANY_CS 
                                           DEFAULT 'text/plain; charset=us-ascii',
   priority          IN    PLS_INTEGER DEFAULT 3,
   attachment        IN    VARCHAR2 CHARACTER SET ANY_CS, ,
   att_inline        IN    BOOLEAN DEFAULT TRUE,
   att_mime_type     IN    VARCHAR2 CHARACTER SET ANY_CS 
                                           DEFAULT 'text/plain; charset=us-ascii,
   att_filename      IN    VARCHAR2CHARACTER SET ANY_CS DEFAULT NULL,
   replyto           IN    VARCHAR2 CHARACTER SET ANY_CS DEFAULT NULL);
   
*/


