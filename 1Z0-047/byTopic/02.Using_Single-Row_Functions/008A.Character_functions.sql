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
-- "BOTH" is de deafault
select TRIM('-' FROM '-----A STRING----') AS RESULT FROM DUAL; -- 'A STRING'
select TRIM(' ' FROM '     A STRING    ') AS RESULT FROM DUAL; -- 'A STRING'
-- "BOTH" and " " are the defaults
select TRIM('     A STRING    ') AS RESULT FROM DUAL;  -- 'A STRING'

-- ERROR !!! only 1 character
select TRIM('-+' FROM '-----A STRING----') AS RESULT FROM DUAL; 

-- ERROR !! FROM must follow trim_char (if specified)
select TRIM(FROM '     A STRING    ') AS RESULT FROM DUAL; 

-- Returns NULL !!
select TRIM(LEADING null FROM '     A STRING    ') AS RESULT FROM DUAL; 
select TRIM(TRAILING null FROM '     A STRING    ') AS RESULT FROM DUAL; 
select TRIM(BOTH null FROM '     A STRING    ') AS RESULT FROM DUAL; 


/* INSTR(s1, s2, pos, n) 
If pos is negative, the search in s1 for occurrences of s2 starts 
at the end of the string and moves backward.
*/
select instr('mississippi','is') from dual;  -- 2
select instr('mississippi','is',3) from dual;  -- 5
select instr('mississippi','is',1,2) from dual;  -- 5
/* If pos is negative, the search in s1 for occurrences of s2 starts 
at the end of the string and moves backward. 
NOTICE THE POSITION RETURNED REFERS ALWAYS TO LEFT TO RIGHT DIRECTION */
select instr('mississippi','is',-1) from dual;  -- 5
select instr('mississippi','is',-1,2) from dual;  -- 2
-- ALWAYS Returns 0 when pos=0
select instr('mississippi','is',0,2) from dual;  -- 0
-- ERROR: argument n must be greater then 0, otherwise is considered out of range
select instr('mississippi','is',1,0) from dual;  -- ERROR
select instr('mississippi','is',1,-1) from dual;  -- ERROR

/* SUBSTR(s1,pos,len)*/

select substr('supercalifragilisticexpialidocious',6) from dual; -- califragilisticexpialidocious
select substr('supercalifragilisticexpialidocious',6,4) from dual; -- cali
/* if pos is negative, search start from the end of the string and moves backward*/
select substr('supercalifragilisticexpialidocious',-6) from dual;  -- ocious
select substr('supercalifragilisticexpialidocious',-6,4) from dual; -- ocio
/* pos=0 is the same as pos=1 */
select substr('supercalifragilisticexpialidocious',0) from dual; -- supercalifragilisticexpialidocious
/* argument 'len' must be greter then 0, otherwise NULL is returned */
select substr('supercalifragilisticexpialidocious',6,0) from dual; -- NULL
select substr('supercalifragilisticexpialidocious',6,-1) from dual; -- NULL

/* SOUNDEX(s)
Translates a source string into its SOUNDEX code the first letter remains unchanged
*/
select soundex('worthington') from dual;
select soundex('rage') from dual;



