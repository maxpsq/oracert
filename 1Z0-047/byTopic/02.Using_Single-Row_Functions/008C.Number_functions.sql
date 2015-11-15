/* NUMERIC FUNCTIONS */

/* FLOOR(n) 
Returns the largest integer equal to or less than n
*/
SELECT FLOOR(12), FLOOR(12.355143), FLOOR(12.355143), FLOOR(259.99), FLOOR(259.99), FLOOR(-4.1), FLOOR(-4.9)
 FROM DUAL;
 
/* CEIL(n) 
Returns the largest integer equal to or greater than n
*/
SELECT CEIL(12), CEIL(12.355143), CEIL(12.355143), CEIL(259.99), CEIL(259.99), CEIL(-4.1), CEIL(-4.9)
 FROM DUAL;
 
/* ROUND(n,i) 
NOTICE ROUND(n) --> ROUND(n,0)
*/
SELECT ROUND(12.999), ROUND(12.355143, 2), ROUND(12.355143, 4), ROUND(259.99,-1), ROUND(259.99,-2), ROUND(-4.355143,2), ROUND(-4.355143, 4)
 FROM DUAL;
 
/* TRUNC(n,i) 
"rounds" toward zero
NOTICE TRUNC(n) --> TRUNC(n,0)
*/
SELECT TRUNC(12.999), TRUNC(12.355143, 2), TRUNC(12.355143, 4), TRUNC(259.99,-1), TRUNC(259.99,-2), TRUNC(-4.355143,2), TRUNC(-4.355143, 4)
 FROM DUAL;
 
/* REMAINDER(n1,n2) 
Identifies the multiple of n2 that is nearest to n1, and returns 
the difference between those two values. It uses ROUND() for computation.
*/
SELECT REMAINDER(9,3)   -- =  9 -  9 =  0
     , 9 - 3 * ROUND(9/3)
     , REMAINDER(10,3)  -- = 10 -  9 =  1
     , 10 - 3 * ROUND(10/3)
     , REMAINDER(11,3)  -- = 11 - 12 = -1
     , 11 - 3 * ROUND(11/3)
 FROM DUAL;
 
SELECT REMAINDER(9.5,3)   -- =  9.5 -  9 =  0.5
     , 9.5 - 3 * ROUND(9.5/3)
     , REMAINDER(10.5,3)  -- = 10.5 - 12 =  1.5
     , 10.5 - 3 * ROUND(10.5/3)
     , REMAINDER(11.5,3)  -- = 11.5 - 12 = -0.5
     , 11.5 - 3 * ROUND(11.5/3)
 FROM DUAL;
 
SELECT REMAINDER(9,0)    -- ERROR !! DIVISOR IS EQUAL TO ZERO
 FROM DUAL;

-- the sign is taken from n1 
SELECT REMAINDER( 10, 3)   --  1
     , REMAINDER( 10,-3)   --  1
     , REMAINDER(-10, 3)   -- -1
     , REMAINDER(-10,-3)   -- -1
 FROM DUAL;

/* MOD(n1,n2) 
MOD returns the remainder of n2 divided by n1. Returns n2 if n1 is 0.
It uses FLOOR() for computation.
*/
SELECT MOD(9,3)    -- =  3 remainder 0
     , 9 - 3 * FLOOR(9/3)
     , MOD(10,3)   -- =  3 remainder 1
     , 10 - 3 * FLOOR(10/3)
     , MOD(11,3)   -- =  3 remainder 2
     , 11 - 3 * FLOOR(11/3)
 FROM DUAL;
 
SELECT MOD(9,0)    -- =  n1 = 9
     , MOD(10,0)   -- =  n1 = 10
     , MOD(11,0)   -- =  n1 = 11
 FROM DUAL;

-- the sign is taken from n1 
SELECT MOD( 10, 3)   --  1
     , MOD( 10,-3)   --  1
     , MOD(-10, 3)   -- -1
     , MOD(-10,-3)   -- -1
 FROM DUAL;
 
