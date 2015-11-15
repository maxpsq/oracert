
/*
SET UNUSED COLUMN

ALTER TABLE table SET UNUSED COLUMN column_name ;

ALTER TABLE table SET UNUSED COLUMN (column_name1, column_name2, ...) ;

** You will never be able to recover a column that is set to UNUSED

** Once a column is set to UNUSED, you can add new columns that have 
   the same name as any unused columns for the table.
*/


/*
 ALTER TABLE table_name DROP UNUSED COLUMNS;

 This statement will drop all unused columns that are associated 
 with the table and drop all associated idexes.
 */