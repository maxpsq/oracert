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


/*
GREATEST(e1, e2, ...,eN)
Returns the greatest value among all arguments
*/


/*
LEAST(e1, e2, ...,eN)
Returns the least value among all arguments
*/