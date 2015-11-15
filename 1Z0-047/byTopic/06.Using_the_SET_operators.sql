
/*
UNION
-----
!! since UNION does not include duplicates, the sort is implicit in order to remove them !!

*/

/*
ABOUT SET OPERATORS
-----------------------
When a set operator pairs two SELECT statements, the datatypes of the columns in the column 
list in the first SELECT must be similar – but not identical – to the datatypes of the 
columns in the column list of the second SELECT. For example, 

SELECT JOB_ID FROM JOBS 
 UNION 
SELECT JOB_NUMBER FROM JOBS 

expects both the JOB_ID and the JOB_NUMBER columns to be of the same general datatype – probably 
a numeric value in this case – but they don’t have the be the precise numeric datatype. 
One could be NUMBER and another could be FLOAT, for example.
*/