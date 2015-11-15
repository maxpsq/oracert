
/*******************************************************************************
                        CONVERSION FUNCTIONS
 ******************************************************************************/
 
 /*
 TO_NUMBER(e1, format_model, nls_parms)
 ' nls_currency = ''USD'' nls_numeric_characters = '',.'' '
*/
-- Currency is set to EUR/€
select to_number('$123,23','$999D99') from dual; -- 123
select to_number('€123,23','L999D00') from dual; -- 123
select to_number('$123','L999') from dual; -- ERROR: $ is not the local currency
select to_number('$123.23','L999D99',' nls_currency = ''$''  nls_numeric_characters = ''.,'' ') from dual; 

select to_char(123,'999C') from dual;

/* TO_CHAR() */
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

