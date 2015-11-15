/*
============================================================================
                            MULTITABLE INSERTS
============================================================================
Multitable inserts allow a single INSERT INTO .. SELECT statement to conditionally, 
or non-conditionally, insert into multiple tables. This statement reduces table 
scans and PL/SQL code necessary for performing multiple conditional inserts compared t
o previous versions. It's main use is for the ETL process in data warehouses where 
it can be parallelized and/or convert non-relational data into a relational format.



Multitable inserts don't support the RETURNING INTO clause.


Unconditional multitable INSERT
---------------------------------------
Unconditional multitable INSERT statements process each of the INSERT 
statement’s one or more INTO clauses without condition, for all rows 
returned by the subquery.

  INSERT ALL
    INTO tab1 VALUES (col_list1) 
    INTO tab2 VALUES (col_list2) 
    INTO tab3 VALUES (col_list3) 
    ...
  subquery;

* The keyword ALL is required in an unconditional multitable INSERT. 
Note, however, that while the presence of the keyword ALL is indicative 
of a multitable INSERT, it doesn’t necessarily indicate the unconditional 
multitable INSERT, as you’ll see in the next section.

* Each INTO may have its own VALUES clause.

* Each VALUES list is optional; if omitted, the select list from the subquery 
will be used.



PIVOTING data using MULTITABLE INSERTS
---------------------------------------
You can use a conditional multitable INSERT statement to transform data from a 
spreadsheet structure to a rows-and-columns structure. This section describes t
he technique.

INSERT ALL
  WHEN OCEAN IS NOT NULL THEN
    INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT)
    VALUES (ROOM_TYPE, 'OCEAN', OCEAN)
  WHEN BALCONY IS NOT NULL THEN
    INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT)
    VALUES (ROOM_TYPE, 'BALCONY', BALCONY)
  WHEN NO_WINDOW IS NOT NULL THEN
    INTO SHIP_CABIN_STATISTICS (ROOM_TYPE, WINDOW_TYPE, SQ_FT)
    VALUES (ROOM_TYPE, 'NO WINDOW', NO_WINDOW)
SELECT ROWNUM RN, ROOM_TYPE, OCEAN, BALCONY, NO_WINDOW
  FROM SHIP_CABIN_GRID;

Note that this “pivot” technique is different from SQL operations that use the 
keyword PIVOT or UNPIVOT.What we’ve described here is a technique that uses the 
conditional multitable INSERT to pivot data



Conditional multitable INSERT (ALL/FIRST)
------------------------------------------
Conditional multitable INSERT statements use WHEN conditions before INTO 
clauses to determine if the given INTO clause (or clauses) will execute for 
a given row returned by the subquery.


INSERT option
  WHEN expression THEN
    INTO tab1 VALUES (col_list1) 
  WHEN expression THEN
    INTO tab2 VALUES (col_list2) 
  ...
  ELSE
    INTO tab3 VALUES (col_list3)
subquery;


* The option is one of two keywords: ALL or FIRST.
* ALL is the default and may be omitted.

here are several restrictions with multi-table inserts. The online documentation lists the following:

we cannot have views or materialized views as targets;
we cannot use remote tables as targets;
we cannot load more than 999 columns (all INTO clause combined);
we cannot parallel insert in RAC environments;
we cannot parallel insert into an IOT or a table with a bitmap index;
we cannot use plan stability (outlines) for multi-table insert statements;
we cannot use TABLE collection expressions; and
we cannot use a sequence in the source query.



USING SEQUENCES in MULTITABLE INSERTS
----------------------------------------
Sequence generators do not behave consistently in a multitable INSERT statement. 
If you try to use a sequence generator within the subquery, you’ll get a syntax 
error. If you try to include one within the expression list of the INTO statement, 
you may or may not get the functionality you wish—the NEXTVAL function will not 
advance as you might expect it to. The reason: a multitable insert is treated as 
a single SQL statement. Therefore, if you reference NEXTVAL with a sequence generator, 
Oracle’s documentation warns that NEXTVAL will be incremented once in accordance
with the sequence generator’s parameters and stay that way for the duration of a 
pass through the multitable insert. In other words, a conditional INSERT with a 
single INTO, one that invokes a single sequence generator once with a NEXTVAL, will 
increment the sequence once for each row returned by the subquery—regardless of 
whether or not the WHEN condition is true. 

    INSERT
      WHEN (TO_CHAR(DATE_ENTERED,'RRRR') <= '2009') THEN
        INTO INVOICES_ARCHIVED (INVOICE_ID, INVOICE_DATE)
        VALUES (SEQ_INV_NUM.NEXTVAL, DATE_ENTERED)
    SELECT INV_NO, DATE_ENTERED 
      FROM WO_INV;

The sequence generator in line 4 will increment for each row returned by
the subquery, regardless of whether the WHEN condition is true or not. 


*/