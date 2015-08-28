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
n: make . match new lines
m: multiline, make ^ and $ to be assumed to be the beginning and end
   of lines within the string
x: ignores whitespace characters   

Note that if the match parameter text literals (Table 17-5) are used in a 
conflicting combination, such as ‘ic’, the last value will take precedence and 
any prior conflicting values will be ignored.
*/


/* REGEXP_SUBSTR(s1, pattern1, p1, n1, m1) */
SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+') AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2) AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('she sells sea shells down by the seashore', 'sh[[:alpha:]]+', 2, 2) AS THE_RESULT
FROM DUAL;          -- ????

SELECT REGEXP_SUBSTR('SHE SELLS SEA SHELLS DOWN BY THE SEASHORE', 'sh[[:alpha:]]+', 1, 2, 'i') AS THE_RESULT
FROM DUAL;          -- ????


/* REGEXP_INSTR(s1, pattern1, p1, n1, opt1, m1) */
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


/* REGEXP_REPLACE(s1, pattern1, rep1, p1, o1, m1) */

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




/* 
REGEXP_LIKE (s1, pattern1, m1) returns TRUE or FALSE 
best use in WHERE conditions or CHECK constraints
*/

select * from employees
 where REGEXP_LIKE(last_name, 'c.e', 'i');
