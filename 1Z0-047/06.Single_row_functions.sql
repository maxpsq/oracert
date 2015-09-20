/* CHARACTER FUNCTIONS */

/*
INITCAP(s)
lowarcase all chars and the uppercase the initial character of any word
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
 
 
/* DATE FUNCIONS */ 

/* ROUND(d,i) */
alter session set NLS_DATE_FORMAT='YYYY/MM/DD HH24:MI:SS' ;

select round(sysdate)
     , round(sysdate,'DD') 
     , round(sysdate,'HH') 
     , round(sysdate,'W') 
     , round(sysdate,'MM') 
     , round(sysdate,'RR') 
     , round(sysdate,'RRRR') 
     , round(sysdate,'YY') 
     , round(sysdate,'YYYY') 
  from dual ;
  
/* TRUNC(d,c) */  
select TRUNC(sysdate) -- defaults to DAY
     , TRUNC(sysdate,'DD') 
     , TRUNC(sysdate,'HH') 
     , TRUNC(sysdate,'W') 
     , TRUNC(sysdate,'MM') 
     , TRUNC(sysdate,'RR') 
     , TRUNC(sysdate,'RRRR') 
     , TRUNC(sysdate,'YY') 
     , TRUNC(sysdate,'YYYY') 
  from dual ;
  
alter session set NLS_DATE_FORMAT='DD-MON-YY' ;  
/* ADD_MONTHS */  
SELECT ADD_MONTHS('31-GEN-11',1),
       ADD_MONTHS('01-NOV-11',4),
       ADD_MONTHS('31-GEN-11',-2),
       ADD_MONTHS('01-NOV-11',-4)       
FROM DUAL;  


select MONTHS_BETWEEN('01-GEN-12', '01-FEB-12') from dual; --> -1  ** ATTENZIONE AI SEGNI !!
select MONTHS_BETWEEN('01-FEB-12', '01-GEN-12') from dual; --> +1  ** ATTENZIONE AI SEGNI !!


/* NUMTOYMINTERVAL(n, interval_unit) */
select NUMTOYMINTERVAL(27, 'MONTH') from dual; --> 2-3 means 2 years and 3 months

/* NUMTODSINTERVAL(n, interval_unit) */
select NUMTODSINTERVAL(36, 'HOUR') from dual; --> +01 12:00:00.000000 means 1 day and 12 hours


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
returns v2 if e is null, v1 otherwise
*/
select nvl2(0,1,2) from dual;
select nvl2(null,1,2) from dual;
select nvl2('x','A','B') from dual;
select nvl2('','A','B') from dual;

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

/* TIME ZONES */

/* time zone from the DB */
select dbtimezone from dual; 

/* time zone from the SESSION (depends on the ALTER SESSION statement, 
eventually implicitly issued by the client) */
alter session set time_zone = 'Europe/Athens'; -- GMT +03:00
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI';
select sessiontimezone from dual;

select current_date from dual; -- DATE ** according to the session timezone 
select current_timestamp from dual; -- TIMESTAMP WITH TIME ZONE ** according to the session timezone 

select localtimestamp from dual; -- TIMESTAMP ** Users timestamp (NO TIME ZONE INFO)

select sysdate from dual; -- OS DATE
select systimestamp from dual; -- TIMESTAMP WITH TIME ZONE ** timezone according to the OS 

SELECT NEW_TIME(current_date, 'AST', 'HST') FROM DUAL;

select to_timestamp(sysdate) from dual ;

/* FROM_TZ(ts: TIMESTAMP, tz: CHAR): TIMESTAMP WITH TIME ZONE */
select FROM_TZ(localtimestamp,'GMT') from dual ;

select FROM_TZ(current_timestamp,'GMT') from dual ; -- ERROR it requires a TIMESTAMP type
select FROM_TZ(to_timestamp(sysdate),'CET') from dual ;
select FROM_TZ(to_timestamp(sysdate),'CET') from dual ;

select to_timestamp(sysdate) from dual ;
select to_timestamp_tz(sysdate) from dual ;

/* TO_TIMESTAMP_TZ(C: CHAR, format_mask: CHAR [, nls_params: CHAR]) */
SELECT TO_TIMESTAMP_TZ('17-04-2013 16:45:30','DD-MM-RRRR HH24:MI:SS') AS "Time"
  FROM DUAL;

/* CAST(expr AS data_type) 
convert an expression to a given data type
NOTICE: NLS_PARAMS matters!! (decimal point, dates, ecc...)
*/
SELECT CAST('19-GEN-10 11:35:30' AS TIMESTAMP WITH LOCAL TIME ZONE) "Converted LTZ"
FROM DUAL;

-- Not only for TIMESTAMP...
SELECT CAST('19' AS INTEGER) "Converted INT"
FROM DUAL;


/* EXTRACT(fm FROM e) 

Process: Extracts the value indicated by fm from e, where fm is one of the 
following keywords: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, TIMEZONE_HOUR,
TIMEZONE_MINUTE, TIMEZONE_REGION, TIMEZONE_ABBR; and e is an expression 
representing a datetime datatype.

Output: Character if you extract TIMEZONE_REGION or TIMEZONE_ABBR data; 
numeric for all other extractions.
*/
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

/* SYS_EXTRACT_UTC(dtz: TIMESTAMP WITH TIME ZONE): TIMESTAMP 

*/
SELECT SYS_EXTRACT_UTC(TIMESTAMP '2012-03-25 09:55:00 -04:00') "HQ"
FROM   DUAL;


/* AT TIME ZONE */

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

/* AT LOCAL 
expression converts the source data into the local time equivalent.
The AT LOCAL expression takes no value but simply converts the source 
value to whatever the session time zone indicates
*/

SELECT FROM_TZ(
         CAST( TO_DATE('1999-12-01 11:00:00','RRRR-MM-DD HH:MI:SS') AS TIMESTAMP), 
         'America/Los_Angeles'
   ) AT LOCAL "East Coast Time"
FROM DUAL;
