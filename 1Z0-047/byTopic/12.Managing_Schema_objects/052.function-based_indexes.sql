/*
==============================================================
FUNCTION BASED INDEXES
==============================================================

- All functions must be specified with parentheses, even if they 
  have no parameters. Otherwise Oracle Database interprets them 
  as column names.

- Any user-defined function referenced in column_expression must 
  be declared as DETERMINISTIC.

*/
CREATE INDEX first_name_idx ON user_data (UPPER(first_name));

SELECT *
FROM   user_data
WHERE  UPPER(first_name) = 'JOHN2';


CREATE INDEX first_name_idx ON user_data (gender, UPPER(first_name), dob);

/*
Remember, function-based indexes require more effort to maintain 
than regular indexes, so having concatenated indexes in this manner 
may increase the incidence of index maintenance compared to a 
function-based index on a single column.
*/

/*
You create the following function-based index: 

CREATE INDEX ix_workweek ON fridge ( TO_CHAR(expiry_date, 'IW') )

If you now use a clause like 

WHERE TO_CHAR(expiry_date, 'IW') = '20'

you can see all products with an expiry date in workweek twenty 
using the index ix_workweek; the single quotes in the WHERE clause are 
included because the resulting expression is of type VARCHAR2. 
Avoid implicit conversions as much as possible; not because of the almost 
negligible conversion performance penalty but because you rely on Oracle 
to do it right in the background and it is considered bad style!



If you always look for things ending with a series of characters, such 
as LIKE '%ABC' you can use an index. Just create the index on 

CREATE INDEX ix_col_name_ling on (REVERSE( col_name ))  ;

and reverse the string you are looking for itself, and voilà, it works: 

WHERE REVERSE ( col_name ) LIKE 'CBA%'.

*** NOTICE ***
Don't mix up the example above with 

CREATE INDEX ix_col_name_ling on ( col_name ) REVERSE ;

that does almost the same thing but make the optimizer totally ignores 
Reverse Key Indexes when processing Range Predicates (eg. BETWEEN, <, >, <=, >=, LIKE etc.). 

*/