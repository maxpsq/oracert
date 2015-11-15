/*
POSIX CHARACTER CLASSES

[:alnum:] Alphanumeric characters. Includes letters and numbers. Omits punctuation marks.
[:alpha:] Alphabetic characters. Includes letters only.
[:blank:] Blank space characters.
[:cntrl:] Control (non-printing) characters.
[:digit:] Numeric characters.
[:graph:] All [:punct:], [:upper:], [:lower:], [:digit:] character classes combined.
[:lower:] Lowercase alphabetic characters.
[:print:] Printable characters.
[:punct:] Punctuation characters.
[:space:] Space (non-printing) characters.
[:upper:] Uppercase alphabetic characters.
[:xdigit:] Valid hexadecimal characters.

*/


/* NOT EQUALS braket expression [^...] */
SELECT REGEXP_REPLACE('aluminium', '[^am]', '.') AS THE_RESULT
FROM DUAL;          -- a..m....m


/* COLLATION CLASS [.....]
Specifies a collation element in accordance with the current locale.
Useful in situations where two or more characters are needed to specify a single 
collating element, such as in Czech, Welsh, and others, where ‘ch’ represents a 
single collating element. For example, to establish a range of letters 
from ‘a’ to ‘ch’, you would use [a..[.ch.]].
*/

SELECT REGEXP_REPLACE('puella', '[a-[.ch.]]', '.') AS THE_RESULT
FROM DUAL;          -- ????


/* EQUIVALENCE CLASS [=...=] */

SELECT REGEXP_REPLACE('perché', '[[=e=]]', '.') AS EQUIVALENCE_CLASS
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore',
                     '[[:alpha:]]+(shore)' ) THE_RESULT
FROM DUAL;


/* Regexp Match Parameter Text Literals 
c: case sensitive
i: case insensitive
n: make "." match new lines
m: multiline, make ^ and $ to be assumed to be the beginning and end
   of lines within the string
x: ignores whitespace characters

Note that if the match parameter text literals (Table 17-5) are used in a 
conflicting combination, such as ‘ic’, the last value will take precedence and 
any prior conflicting values will be ignored.

The default case sensitivity is determined by the value of the NLS_SORT parameter.
BINARY: case sensitive
OTHER VALUES: case insensitive
*/
select sys_context ('userenv', 'nls_sort') from sys.dual;

/*
REGEXP_SUBSTR(s1, pattern1, p1, n1, m1)
The default case sensitivity is determined by the value of the NLS_SORT parameter.
*/
SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+') AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2) AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2, 2) AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('SHE SELLS SEA SHELLS DOWN BY THE SEASHORE', 'sh[[:alpha:]]+', 1, 2, 'i') AS THE_RESULT
FROM DUAL;          -- ????


/*
REGEXP_INSTR(s1, pattern1, p1, n1, opt1, m1, s1)
The default case sensitivity is determined by the value of the NLS_SORT parameter.
*/
SELECT REGEXP_INSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+') AS THE_RESULT
FROM DUAL;          -- 1

SELECT REGEXP_INSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2) AS THE_RESULT
FROM DUAL;          -- 15

SELECT REGEXP_INSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2, 2) AS THE_RESULT
FROM DUAL;          -- 37

SELECT REGEXP_INSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 1, 2) AS THE_RESULT
FROM DUAL;          -- 15

-- opt1: either 0 or 1 (>1 acts like 1)
-- If opt1 = 1, then it returns the location of the first position after the pattern
SELECT REGEXP_INSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 1, 2, 1) AS THE_RESULT
FROM DUAL;          -- 21

SELECT REGEXP_INSTR('SHE SELLS SEA SHELLS DOWN BY THE SEASHORE', 'sh[[:alpha:]]+', 1, 2, 0, 'i') AS THE_RESULT
FROM DUAL;          -- 15

-- Subexpression (since Oracle 11gR1)
SELECT REGEXP_INSTR('1234567890', '(123)(4(56)(78))', 1, 1, 0, 'i', 1) FROM dual;
--                                  ^
SELECT REGEXP_INSTR('1234567890', '(123)(4(56)(78))', 1, 1, 0, 'i', 3) FROM dual;
--                                         ^

/* 
REGEXP_REPLACE(s1, pattern1, rep1, p1, o1, m1) 
The default case sensitivity is determined by the value of the NLS_SORT parameter.
*/

-- No sobstitution specified, occurrences are replaced with NULL
SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+') AS THE_RESULT
FROM DUAL;          --  sells sea  down by the sea  (occurrences are replaced with NULL)

SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', '***') AS THE_RESULT
FROM DUAL;          -- *** sells sea *** down by the sea***

-- p1: start position
SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', '***', 2) AS THE_RESULT
FROM DUAL;          -- she sells sea *** down by the sea***

-- o1: which occurrence to be replaced (defaults to 0 meaning all accurrences)
SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', '***', 1, 0) AS THE_RESULT
FROM DUAL;          -- *** sells sea *** down by the sea***   (ALL)

SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', '***', 1, 1) AS THE_RESULT
FROM DUAL;          -- *** sells sea shells down by the seashore   (FIRST)

SELECT REGEXP_REPLACE('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', '***', 1, 2) AS THE_RESULT
FROM DUAL;          -- she sells sea *** down by the seashore   (SECOND)

-- m1: regexp match parameters
SELECT REGEXP_REPLACE('SHE SELLS SEA SHELLS DOWN BY THE SEASHORE', 'sh[[:alpha:]]+', '***', 1, 0, 'i') AS THE_RESULT
FROM DUAL;          -- *** SELLS SEA *** DOWN BY THE SEA***


-- Using sub-expressions [enclosing in parentheses ()]
-- The default case sensitivity is determined by the value of the NLS_SORT parameter.

SELECT REGEXP_REPLACE('SocialSecurityNumber', '([A-Z])', ' \1', 2) AS hyphen_text
FROM   DUAL;

SELECT REGEXP_REPLACE('SocialSecurityNumber', '([A-Z])', ' \1', 2, 0, 'c') AS hyphen_text
FROM   DUAL;

alter session set nls_sort = 'BINARY';

SELECT REGEXP_REPLACE('SocialSecurityNumber', '([A-Z])', ' \1', 2) AS hyphen_text
FROM   DUAL;

/* 
REGEXP_LIKE (s1, pattern1, m1) returns TRUE or FALSE 
best use in WHERE conditions or CHECK constraints
*/

select * from hr.employees
 where REGEXP_LIKE(last_name, 'c.e', 'i');


CREATE TABLE EMAIL_LIST
(  EMAIL_LIST_ID    NUMBER(7)  PRIMARY KEY,
   EMAIL1           VARCHAR2(120),
   CONSTRAINT CK_EL_EMAIL1
     CHECK (
       REGEXP_LIKE (EMAIL1, '^([[:alnum:]]+)@[[:alnum:]]+.(com|net|org|edu|gov|mil)$')
     )
);


/*
REGEXP_COUNT(s1, pattern1, p1, m1) [since Oracle 11gR1]
*/

SELECT REGEXP_COUNT('SHE SELLS SEA SHELLS DOWN BY THE SEASHORE','S[EH]A')
  FROM dual;



select REGEXP_INSTR('David', '^(D|d).{3, }d$') 
  from dual;
  
select REGEXP_INSTR('Donald', '^(D|d).{3, }d$')
  from dual;
  
select REGEXP_INSTR('Do3a9d', '^(D|d).{3,}d$') as "Must be 0"
  from dual;
  
  
select REGEXP_INSTR('David', '^(D|d)[[:alpha:]]{3, }d$') as "Must be 1"
  from dual;
  
select REGEXP_INSTR('Donald', '^(D|d)[[:alpha:]]{3,}d$') as "Must be 1"
  from dual;
  
select REGEXP_INSTR('Do3a9d', '^(D|d)[[:alpha:]]{3,}d$') as "Must be 0"
  from dual;
  