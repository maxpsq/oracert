/* CHARACTER FUNCTIONS */

/*
INITCAP(s)
lowercase all chars and the uppercase the initial character of any word
What defines word boundaries?
a word is a sequence of chars and digits
*/

select initcap('hello,hello.HELLO') from dual ;
select initcap('michael o''brian') from dual ;
select initcap('it''s all right, i''m ok') from dual ;
select initcap('a''a,a.a:a-a_a#a°a!è?é[q2s@z') from dual ;


/* LTRIM(s1,s2) RTRIM(s1,s2)
Remove occurences of s2 characters from s1
*/

select ltrim('   hello') from dual;
select ltrim('...hello','.') from dual;
select ltrim('.:.:::.hello.:.:::.','.:') as result from dual;
select rtrim('.:.:::.hello.:.:::.','.:') as result from dual;

/* TRIM(trim_info trim_char FROM source) 
Removes all occurrences of the single char specified by trim_char
*/
select TRIM(LEADING '-' FROM '-----A STRING----') AS RESULT FROM DUAL;
select TRIM(TRAILING '-' FROM '-----A STRING----') AS RESULT FROM DUAL;
select TRIM(BOTH '-' FROM '-----A STRING----') AS RESULT FROM DUAL; -- 'A STRING'
select TRIM('-' FROM '-----A STRING----') AS RESULT FROM DUAL; -- 'A STRING'
select TRIM(' ' FROM '     A STRING    ') AS RESULT FROM DUAL; -- 'A STRING'
select TRIM('     A STRING    ') AS RESULT FROM DUAL;  -- 'A STRING'
-- ERROR !!! only 1 character
select TRIM('-+' FROM '-----A STRING----') AS RESULT FROM DUAL; 
-- ERROR !! FROM must follow trim_char (if specified)
select TRIM(FROM '     A STRING    ') AS RESULT FROM DUAL; 


/* INSTR(s1, s2, pos, n) 
If pos is negative, the search in s1 for occurrences of s2 starts 
at the end of the string and moves backward.
*/
select instr('mississippi','is') from dual;  -- 2
select instr('mississippi','is',3) from dual;  -- 5
select instr('mississippi','is',1,2) from dual;  -- 5
/* If pos is negative, the search in s1 for occurrences of s2 starts 
at the end of the string and moves backward. */
select instr('mississippi','is',-1) from dual;  -- 5
select instr('mississippi','is',-1,2) from dual;  -- 2
-- Returms 0 when pos=0
select instr('mississippi','is',0,2) from dual;  -- 0

/* SUBSTR(s1,pos,len)*/

select substr('supercalifragilisticexpialidocious',6) from dual; -- califragilisticexpialidocious
select substr('supercalifragilisticexpialidocious',6,4) from dual; -- cali
/* if pos is negative, search start from the end of the string and moves backward*/
select substr('supercalifragilisticexpialidocious',-6) from dual;  -- ocious
select substr('supercalifragilisticexpialidocious',-6,4) from dual; -- ocio


/* SOUNDEX(s)
Translates a source string into its SOUNDEX code
the forst lettere remains unchanged
*/
select soundex('worthington') from dual;
select soundex('rage') from dual;



/* NUMERIC FUNCTIONS */

/* FLOOR(n) 
Returns the largest integer equal to or less than n
*/
SELECT FLOOR(12.355143), FLOOR(12.355143), FLOOR(259.99), FLOOR(259.99)
 FROM DUAL;
 
/* ROUND(n,i) */
SELECT ROUND(12.355143, 2), ROUND(12.355143, 4), ROUND(259.99,-1), ROUND(259.99,-2)
 FROM DUAL;
 
/* TRUNC(n,i) 
"rounds" toward zero
*/
SELECT TRUNC(12.355143, 2), TRUNC(12.355143, 4), TRUNC(259.99,-1), TRUNC(259.99,-2)
 FROM DUAL;
 
/* REMAINDER(n1,n2) 
Identifies the multiple of n2 that is nearest to n1, and returns 
the difference between those two values. It uses ROUND() for computation.
*/
SELECT REMAINDER(9,3), REMAINDER(10,3), REMAINDER(11,3)
 FROM DUAL;
 
/* MOD(n1,n2) 
Identifies the multiple of n2 that is nearest to n1, and returns 
the difference between those two values. It uses FLOOR() for computation.
*/
SELECT MOD(9,3), MOD(10,3), MOD(11,3)
 FROM DUAL;
 
 
/***********************************************************************************************
                                       DATE FUNCIONS 
 ***********************************************************************************************/

/* 
SYSDATE 
Parameters: None
will return the date and time of the operating system on which the server resides.
*/

/* 
ROUND(d,i) 
Parameters: d is a date (required); i is a format model (optional).
*/
alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS' ;

select sysdate as now
     , round(sysdate) -- defaults to "DD"
     , round(sysdate,'DD') 
     , round(sysdate,'HH') 
     , round(sysdate,'W') 
     , round(sysdate,'MM') 
     , round(sysdate,'RR') 
     , round(sysdate,'RRRR') 
     , round(sysdate,'YY') 
     , round(sysdate,'YYYY') 
  from dual ;
  
/* 
TRUNC(d,i) 
Parameters: d is a date (required); i is a format model (optional).
Process: Performs the same task as ROUND for dates, except TRUNC always rounds down.
*/  
select sysdate as now
     , TRUNC(sysdate) -- defaults to "DD"
     , TRUNC(sysdate,'DD') 
     , TRUNC(sysdate,'HH') 
     , TRUNC(sysdate,'W') 
     , TRUNC(sysdate,'MM') 
     , TRUNC(sysdate,'RR') 
     , TRUNC(sysdate,'RRRR') 
     , TRUNC(sysdate,'YY') 
     , TRUNC(sysdate,'YYYY') 
  from dual ;

alter session set NLS_DATE_FORMAT='DD-MON-RR' ;

/*
NEXT_DAY(d, c)
Parameters: d is a date, required; c is a text reference to a day of the week,
required.
Process: Returns a valid date representing the first occurrence of the c day
following the date represented in d.
*/

SELECT NEXT_DAY('31-MAG-11','Sabato')
  FROM DUAL;

/*
LAST_DAY(d)
Parameters: d is a date, required.
Process: Returns the last day of the month in which d falls.
*/

SELECT LAST_DAY('14-FEB-11'), LAST_DAY('20-FEB-12')
  FROM DUAL;


/* 
ADD_MONTHS(d, n)
Parameters: d is a date, required; n is a whole number, required.
Process: Adds n months to d, and returns a valid date value for the result.
*/
SELECT ADD_MONTHS('31-GEN-11',1),  -- 28-FEB-11
       ADD_MONTHS('01-NOV-11',4),  -- 01-MAR-12
       ADD_MONTHS('31-GEN-11',-2), -- 30-NOV-11
       ADD_MONTHS('01-NOV-11',-4)  -- 01-LUG-11
FROM DUAL;  

/*
MONTHS_BETWEEN(d1, d2)
Parameters: d1 and d2 are dates, required.
Process: Determines the number of months between the two dates. The result 
does not round off automatically—if the result is a partial month, 
MONTHS_BETWEEN shows a real number result. Whole months are counted according 
to the calendar months involved—if the time spans, say, a February that 
has 29 days, then the one month time span for that time period will be 29 days. 

The first parameter is expected to be the greater value; the second is expected 
to be the lesser. But that’s not required, and as you can see from these examples, 
either approach works, but notice the sign of the result—if the second parameter 
is the greater value, the result is a negative number.
*/
select MONTHS_BETWEEN('01-GEN-12', '01-FEB-12') from dual; --> -1  ** ATTENZIONE AI SEGNI !!
select MONTHS_BETWEEN('01-FEB-12', '01-GEN-12') from dual; --> +1  ** ATTENZIONE AI SEGNI !!
select MONTHS_BETWEEN('10-AGO-14', '10-LUG-14') from dual; --> +1  ** ATTENZIONE AI SEGNI !!
SELECT MONTHS_BETWEEN('12-GIU-14', '03-OTT-13') FROM DUAL; --> 8.29032258064516129032258064516129032258

/* 
NUMTOYMINTERVAL(n, interval_unit) 
Parameters: n = number (required). 
            interval_unit = one of the following values: ‘YEAR’ or ‘MONTH’.
Process: Transform the number n into a value that represents the interval_unit amount of time.
Output: A value in the INTERVAL YEAR TO MONTH datatype.
*/
select NUMTOYMINTERVAL(27, 'MONTH') from dual; --> 2-3 means 2 years and 3 months

/* 
NUMTODSINTERVAL(n, interval_unit) 
Parameters: n = number (required). 
            interval_unit = one of the following: ‘DAY’, ‘HOUR’, ‘MINUTE’, or ‘SECOND’.
Process: Converts the numeric value into an interval of time according to the
value of interval_unit.
Output: A value of the datatype INTERVAL DAY TO SECOND.
*/
select NUMTODSINTERVAL(36, 'HOUR') from dual; --> +01 12:00:00.000000 means 1 day and 12 hours

/***********************************************************************************
                               OTHER FUNCTIONS
 ***********************************************************************************/

/* CASE */
SELECT CASE 'option1'
       WHEN 'option1' THEN 'found it'
       WHEN 'option2' THEN 'did not find it'
       END
  FROM   DUAL;

SELECT CASE 'option1'
       WHEN 'option1' THEN 'found it'
       WHEN 'option2' THEN 'did not find it'
       END AS "Answer" --> just an alias
  FROM   DUAL;
  
SELECT CASE 'option3'
       WHEN 'option1' THEN 'found it'
       WHEN 'option2' THEN 'did not find it'
       ELSE 'DEFAULT'
       END
  FROM   DUAL;

  
/* NULLIF(e1,e2) 
If e1 = e2 returns NULL, else returns e1
e1 and e2 must be the same data type*
*/

select nullif(3,3) from dual;
select nullif(3,1) from dual;
select nullif('b','c') from dual;
select nullif('b',1) from dual; -- ERROR!! iconsistent data type
select nullif(1,'b') from dual; -- ERROR!! iconsistent data type
-- (*) the data type is determined by the first argument:
select nullif(3,null) from dual; -- this works!!
select nullif('b',null) from dual; -- this works!!
-- ERROR!! iconsistent data type (null has no data type)...
select nullif(null,'b') from dual; 
select nullif(null,3) from dual;
-- ...but notice this returns NULL ('' -> NULL AS STRING)
select nullif('','b') from dual;


/* NVL2(e,v1,v2)
returns "v2" if "e" is null, "v1" otherwise
*/
select nvl2(0,1,2) from dual;
select nvl2(null,1,2) from dual;
select nvl2('x','A','B') from dual;
select nvl2('','A','B') from dual;
-- Notice the data type returned by this function is determined by "v1"
select nvl2(null,'A','B') from dual; -- varchar2
select nvl2('',1,2) from dual; -- Number
select nvl2(null,1,'B') from dual; -- ERROR invalid number
select nvl2(null,'A',2) from dual; -- '2' (as varchar2, by implicit conversion)


/*******************************************************************************
                        CONVERSION FUNCTIONS
 ******************************************************************************/

select to_char(sysdate,'E') from dual; -- era format code not valid with this calendar
select to_char(sysdate,'EE') from dual; -- era format code not valid with this calendar
select to_char(systimestamp,'DD') from dual;
select to_char(systimestamp,'X') from dual; -- local radix character (,)

/*
Returns a value in the short date format. Makes the appearance of the date components 
(day name, month number, and so forth) depend on the NLS_TERRITORY and NLS_LANGUAGE parameters. 
For example, in the AMERICAN_AMERICA locale, this is equivalent to specifying the format 'MM/DD/RRRR'. 
In the ENGLISH_UNITED_KINGDOM locale, it is equivalent to specifying the format 'DD/MM/RRRR'.

Restriction: You can specify this format only with the TS element, separated by white space.
*/
select to_char(sysdate,'DS') from dual;

/*
Returns a value in the long date format, which is an extention of Oracle Database's 
DATE format (the current value of the NLS_DATE_FORMAT parameter). Makes the appearance 
of the date components (day name, month number, and so forth) depend on the 
NLS_TERRITORY and NLS_LANGUAGE parameters. For example, in the AMERICAN_AMERICA locale, 
this is equivalent to specifying the format 'fmDay, Month dd, yyyy'. 
In the GERMAN_GERMANY locale, it is equivalent to specifying the format 'fmDay, dd. Month yyyy'.

Restriction: You can specify this format only with the TS element, separated by white space.
*/

select to_char(sysdate,'DL') from dual;

/******************************************************************************* 
     Manage Data in Different Time Zones—Use Various Datetime Functions
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

-- Cxonverts a DATE to a TIMESTAMP
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
timestamp expression.

Process: Extracts the value indicated by fm from e, where fm is one of the 
following keywords: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_HOUR,
TIMEZONE_MINUTE, TIMEZONE_REGION, TIMEZONE_ABBR; and e is an expression 
representing a datetime datatype.

Output: Character if you extract TIMEZONE_REGION or TIMEZONE_ABBR data; 
numeric for all other extractions.
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

select * from V$TIMEZONE_NAMES where tzname like '%Rome%';

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


/* expression AT TIME ZONE */

SELECT DBTIMEZONE, SESSIONTIMEZONE FROM DUAL;

SELECT TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS') "SRC",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE DBTIMEZONE "DB Time",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE SESSIONTIMEZONE "Session Time",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE 'America/Chicago' "Chicago",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE '+04:00' "+04:00",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE 'CET' "CET",
       TO_TIMESTAMP('2012-MAG-24 02:00:00','RRRR-MON-DD HH24:MI:SS')
       AT TIME ZONE 'CEST' "CEST"
FROM DUAL;

/* expression AT LOCAL 
expression converts the source data into the local time equivalent.
The AT LOCAL expression takes no value but simply converts the source 
value to whatever the session time zone indicates
*/

SELECT FROM_TZ(
         CAST( TO_DATE('1999-12-01 11:00:00','RRRR-MM-DD HH:MI:SS') AS TIMESTAMP), 
         'America/Los_Angeles'
   ) AT LOCAL "East Coast Time"
FROM DUAL;
