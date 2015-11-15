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

