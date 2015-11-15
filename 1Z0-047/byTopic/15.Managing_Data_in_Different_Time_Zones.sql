/******************************************************************************* 
     Manage Data in Different Time Zones — Use Various Datetime Functions
*******************************************************************************/

/* 
DBTIMEZONE
Parameters: None.
Process: Returns the time zone for the database (which is the time zone of 
the location where the database is installed)
Output: Character.
*/
select dbtimezone from dual; 

/* 
SESSIONTIMEZONE
Parameters: None.
Process: Returns the time zone for the current session. The format of the output 
is dependent on the most recent execution of the ALTER SESSION statement. 
The options are: (a) time zone offset, (b) time zone regional name. The better 
choice is (b), time zone regional name, if you want the database to perform 
adjustments to support Standard Time and Daylight Saving Time changes automatically.
Output: Character.
*/
alter session set time_zone = 'Europe/Athens'; -- GMT +03:00
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI';
select sessiontimezone from dual;

/*
CURRENT_DATE
Parameters: None for CURRENT_DATE.
Process: Returns the current date within the session time zone.
Output: DATE datatype
*/
select current_date from dual; -- DATE ** according to the session timezone 


/*
CURRENT_TIMESTAMP(t)
Parameters: t = local time zone’s fractional second precision. 
            Ranges between 0 and 9. Optional; defaults to 6.
Process: Returns the current timestamp within the session time zone.
Output: TIMESTAMP WITH TIME ZONE datatype.
*/
select current_timestamp from dual; -- TIMESTAMP WITH TIME ZONE ** according to the session timezone 

/*
LOCALTIMESTAMP(t)
Parameters: t = local time zone’s fractional second precision. Ranges between
0 and 9. Optional; defaults to 6.
Process: Displays the user session’s local time, as opposed to the database 
time zone, which may be different. The value is displayed including year, month, 
day, hours, minutes, and seconds, including fractional seconds.
Output: A value of datatype TIMESTAMP.

The difference between this function and CURRENT_TIMESTAMP is that LOCALTIMESTAMP 
returns a TIMESTAMP value while CURRENT_TIMESTAMP returns a TIMESTAMP WITH TIME ZONE
value.
*/
select localtimestamp from dual; -- TIMESTAMP ** Users timestamp (NO TIME ZONE INFO)

/*
SYSTIMESTAMP 
Parameters: None.
Process: Returns the system date, including fractional seconds, of the operating 
system on which the database is installed. This is the TIMESTAMP equivalent to 
the SYSDATE function.
Output: The system date in the TIMESTAMP WITH TIME ZONE datatype.
*/
select systimestamp from dual; -- TIMESTAMP WITH TIME ZONE ** timezone according to the OS 

/*
NEW_TIME(d, t1, t2)
Parameters: d is a DATE datatype and is required. t1 and t2 are time zone
indications taken from Table 6-7.
Process: For a given value of d, NEW_TIME translates the time d according to the 
offset specified between t1 and t2. In other words, t1 is assumed to be the time 
zone in which d is recorded, so NEW_TIME will convert that time into the t2 time 
zone.
Output: A value in DATE datatype.
*/
SELECT NEW_TIME(current_date, 'AST', 'HST') FROM DUAL;

-- Converts a DATE to a TIMESTAMP
select to_timestamp(sysdate) from dual ;

/* 
FROM_TZ(ts, tz)
Parameters: ts is a TIMESTAMP value (required); tz is a time zone reference
(required).
Process: Transforms ts, a TIMESTAMP value, and tz, a character value representing 
the time zone, into a value of the datatype TIMESTAMP WITH TIME ZONE.
The second parameter, tz, can be in one of two formats: either the format of 
‘TZH:TZM’, where TZH and TZM are time zone hours and time zone minutes, as 
described in Table 6-4; or the format of a character expression that results in 
a string in the TZR with optional TZD format, also as described in Table 6-4.
Output: A value of the TIMESTAMP WITH TIME ZONE datatype.
*/
select FROM_TZ(localtimestamp,'GMT') from dual ;

select FROM_TZ(current_timestamp,'GMT') from dual ; -- ERROR it requires a TIMESTAMP type
select FROM_TZ(to_timestamp(sysdate),'CET') from dual ;
select FROM_TZ(to_timestamp(sysdate),'CET') from dual ;

select to_timestamp(sysdate) from dual ;
select to_timestamp_tz(sysdate) from dual ;

/* 
TO_TIMESTAMP_TZ(C: CHAR, format_mask: CHAR [, nls_params: CHAR]) 

Parameters: c is a character string (required). The format_model must define the 
format of c corresponding to TIMESTAMP WITH TIME ZONE format model elements—optional, 
the default requirement is that c must be in the TIMESTAMP format. The optional 
nls_parms value is the same parameter you saw earlier with the TO_NUMBER function.

Process: Transforms c into a value of TIMESTAMP WITH TIME ZONE, where format_model 
defines the format in which c stores the TIMESTAMP WITH TIME ZONE information. 
The time zone will default to that defined by the SESSION parameter.

Output: A value in the TIMESTAMP WITH TIME ZONE datatype.
*/
SELECT TO_TIMESTAMP_TZ('17-04-2013 16:45:30','DD-MM-RRRR HH24:MI:SS') AS "Time"
  FROM DUAL;

/* CAST(e AS d)
Parameters: e is an expression; d is a datatype.
Process: Converts e to d. Particularly useful for converting text representations 
of datetime information into datetime formats, particularly 
TIMESTAMP WITH LOCAL TIME ZONE.
Output: A value in the d datatype.
NOTICE: NLS_PARAMS matters!! (decimal point, dates, ecc...)
*/
SELECT CAST('19-GEN-10 11:35:30' AS TIMESTAMP WITH LOCAL TIME ZONE) "Converted LTZ"
FROM DUAL;

-- Not only for TIMESTAMP...
SELECT CAST('19' AS INTEGER) "Converted INT"
FROM DUAL;


/*
EXTRACT(fm FROM e) 
Parameters: fm is a format model element from Table 6-8 (required); e is a
datetime expression.


Process: Extracts the value indicated by fm from e, where fm is one of the 
following keywords: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_HOUR,
TIMEZONE_MINUTE, TIMEZONE_REGION, TIMEZONE_ABBR; and e is an expression 
representing a datetime datatype.

Output: Character if you extract TIMEZONE_REGION or TIMEZONE_ABBR data; 
numeric for all other extractions.


If YEAR or MONTH is requested, then expr must evaluate to an expression of 
datatype DATE, TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, 
or INTERVAL YEAR TO MONTH.

If DAY is requested, then expr must evaluate to an expression of datatype DATE, 
TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, 
or INTERVAL DAY TO SECOND.

If HOUR, MINUTE, or SECOND is requested, then expr must evaluate to an expression 
of datatype TIMESTAMP, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH LOCAL TIME ZONE, 
or INTERVAL DAY TO SECOND. 
DATE is not valid here, because Oracle Database treats it as ANSI DATE datatype,
which has no time fields.

If TIMEZONE_HOUR, TIMEZONE_MINUTE, TIMEZONE_ABBR, TIMEZONE_REGION, 
or TIMEZONE_OFFSET is requested, then expr must evaluate to an expression of 
datatype TIMESTAMP WITH TIME ZONE or TIMESTAMP WITH LOCAL TIME ZONE.

EXTRACT interprets expr as an ANSI datetime datatype. For example, EXTRACT treats 
DATE not as legacy Oracle DATE but as ANSI DATE, without time elements. 
Therefore, you can extract only YEAR, MONTH, and DAY from a DATE value. 
Likewise, you can extract TIMEZONE_HOUR and TIMEZONE_MINUTE only from 
the TIMESTAMP WITH TIME ZONE datatype.
*/

SELECT EXTRACT(YEAR FROM TO_TIMESTAMP('2009-10-11 12:13:14', 'RRRR-MM-DD HH24:MI:SS')) "Year"
FROM DUAL;

SELECT EXTRACT(MONTH FROM TO_TIMESTAMP('2009-10-11 12:13:14', 'RRRR-MM-DD HH24:MI:SS')) "Month"
FROM DUAL;

SELECT EXTRACT(DAY FROM TO_TIMESTAMP('2009-10-11 12:13:14', 'RRRR-MM-DD HH24:MI:SS')) "Day"
FROM DUAL;

SELECT EXTRACT(MINUTE FROM TO_TIMESTAMP('2009-10-11 12:13:14', 'RRRR-MM-DD HH24:MI:SS')) "Minute"
FROM DUAL;

SELECT EXTRACT(HOUR FROM TO_TIMESTAMP('2010-01-19 11:35:30', 'RRRR-MM-DD HH24:MI:SS')) "Hour"
FROM DUAL;

SELECT EXTRACT(TIMEZONE_HOUR FROM CAST('19-GEN-10 11:35:30.0' AS TIMESTAMP WITH TIME ZONE)) "TZ_Hour"
FROM DUAL; -- 2 (MEANING GMT +2)

SELECT EXTRACT(TIMEZONE_MINUTE FROM CAST('19-GEN-10 11:35:30.0' AS TIMESTAMP WITH TIME ZONE)) "TZ_Minute"
FROM DUAL; -- 0 (MEANING GMT +2 AND 0 MINUTES)

SELECT EXTRACT(TIMEZONE_REGION FROM CAST('19-GEN-10 11:35:30.0' AS TIMESTAMP WITH TIME ZONE)) "TZ_Region"
FROM DUAL; -- UNKNOWN ??

SELECT EXTRACT(TIMEZONE_REGION FROM CAST('19-GEN-10 11:35:30.0' AS TIMESTAMP WITH TIME ZONE)) "TZ_Region"
FROM DUAL; -- UNKNOWN ??

SELECT EXTRACT(TIMEZONE_ABBR FROM CAST('19-GEN-10 11:35:30.0' AS TIMESTAMP WITH TIME ZONE)) "TZ_Abbr"
FROM DUAL; -- UNK ??

/*    ** NOTICE WHAT APPENS ON DATES ** */
SELECT EXTRACT(MINUTE FROM to_date('2009-10-11 12:12:00','yyyy-mm-dd hh24:mi:ss')) "Minute"
FROM DUAL; ---> ERROR  "invalid extract field for extract source"
/*Cause:    The extract source does not contain the specified extract field. */






select * from V$TIMEZONE_NAMES where tzname like '%CET%';

/* 
SYS_EXTRACT_UTC(dtz: TIMESTAMP WITH TIME ZONE)
Parameters: dtz is any datetime value with a time zone included. 
Process: Extracts the UTC from a datetime value.
Output: A value of datatype TIMESTAMP.
Example: The sample that follows passes in a date of March 25, 2012, 9:55 A.M., 
as a TIMESTAMP converted value with an offset of –4 hours. The datetime value is 
normalized for UTC and the UTC time is displayed as output.
*/
SELECT SYS_EXTRACT_UTC(TIMESTAMP '2012-03-25 09:55:00 -04:00') "HQ"
FROM   DUAL;


/* expression AT TIME ZONE 

You're allowed to pass time zone names listen in the 
column TZNAME from V$TIMEZONE_NAMES

*/

SELECT DBTIMEZONE, SESSIONTIMEZONE FROM DUAL;

SELECT TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') "SRC" ,
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') AT TIME ZONE DBTIMEZONE "DB Time",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') AT TIME ZONE SESSIONTIMEZONE "Session Time",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') AT TIME ZONE 'America/Chicago' "Chicago",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') AT TIME ZONE '+04:00' "+04:00",
       TO_TIMESTAMP('2015-OTT-25 02:00:00','RRRR-MON-DD HH24:MI:SS') AT TIME ZONE 'CET' "CET"
FROM DUAL;

/* expression AT LOCAL 
expression converts the source data into the local time equivalent.
The AT LOCAL expression takes no value but simply converts the source 
value to whatever the session time zone indicates
*/

SELECT FROM_TZ(
         CAST( TO_DATE('1999-12-01 11:00:00','RRRR-MM-DD HH:MI:SS') AS TIMESTAMP), 
         'America/Los_Angeles'
   ) AT LOCAL "Central Europe Time"
FROM DUAL;
