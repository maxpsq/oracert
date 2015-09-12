/*
11. Managing Schema Objects
*/

CREATE TABLE my_table1 ( id1  number, id2  number, quantity    NUMBER );
CREATE TABLE my_table2 ( id1  number, id2  number, quantity    NUMBER );

/******************************************************************************* 
  Adding a column to a table
*******************************************************************************/

ALTER TABLE my_table1 ADD
   new_column   NUMBER(10)  -- COLUMN NAME AND TYPE
   DEFAULT 0                -- DEFAULT
   NOT NULL ;               -- CONSTRAINT
   

ALTER TABLE my_table1 ADD
   ( new_column1  NUMBER(10)    -- COLUMN NAME AND TYPE
     DEFAULT 0                  -- DEFAULT
     NOT NULL                   -- CONSTRAINT
   , new_column2  NUMBER(10)    -- COLUMN NAME AND TYPE
     DEFAULT 0                  -- DEFAULT
     NOT NULL                   -- CONSTRAINT
   , new_column3  VARCHAR2(10)  -- COLUMN NAME AND TYPE
     NOT NULL                   -- CONSTRAINT
   , new_column4  VARCHAR2(10)  -- COLUMN NAME AND TYPE
     NOT NULL                   -- CONSTRAINT
   , new_column5  VARCHAR2(10)  -- COLUMN NAME AND TYPE
     NOT NULL                   -- CONSTRAINT
   , new_column6  VARCHAR2(10)  -- COLUMN NAME AND TYPE
     NOT NULL                   -- CONSTRAINT
   );


/******************************************************************************* 
  Modifying a column in a table 
*******************************************************************************/

ALTER TABLE my_table1 MODIFY ( quantity    NUMBER(3,0) );
ALTER TABLE my_table1 MODIFY ( quantity    DEFAULT 0 );
ALTER TABLE my_table1 MODIFY ( quantity    NOT NULL );
-- that's the same as above
ALTER TABLE my_table1 MODIFY ( quantity    CONSTRAINT nn_quantity NOT NULL );

-- All in one step
ALTER TABLE my_table1 MODIFY ( quantity    NUMBER(5,0)   DEFAULT 1   NULL);

/*******************************************************************************
  MODIFYING not empty columns
*******************************************************************************/
-- REMEMBER: automatic datatype conversion is NEVER supported
-- BUT THERE ARE A FEW EXCEPTIONS

-- 1. DATE TO TIMESTAMP
CREATE TABLE test1 (today   DATE);
insert into test1 values (SYSDATE);
commit;
alter table test1 modify ( today TIMESTAMP ); -- Successful
desc test1;
drop table test1;

-- 2. TIMESTAMP TO DATE
CREATE TABLE test1 (today   TIMESTAMP);
insert into test1 values (SYSTIMESTAMP);
commit;
alter table test1 modify ( today DATE ); -- Successful
desc test1;
drop table test1;

-- Diminishing a VARCHAR2 column in size
CREATE TABLE test1 (str   varchar2(20));
insert into test1 values ('Hello');
commit;
alter table test1 modify ( str varchar2(10) ); -- Successful
desc test1;
alter table test1 modify ( str varchar2(3) );  -- Errore SQL: ORA-01441: impossibile ridurre la lunghezza della colonna poiché alcuni valori hanno dimensioni eccessive
desc test1;
drop table test1;

-- Diminishing a NUMBER column in precision or scale
-- It's allowed only to augment precision or scale, not to reduce.
CREATE TABLE test1 (ratio   number(7,3));
insert into test1 values (3.14);
commit;
alter table test1 modify ( ratio number(8,3) ); -- Successful
desc test1;
-- Now I'm trying to set the column as it was at the time of table creation:
alter table test1 modify ( ratio number(7,3) ); -- Errore SQL: ORA-01440: la colonna da modificare deve essere vuota per diminuirne precisione o scala
desc test1;
drop table test1;


/******************************************************************************* 
  RENAMING a column in a table 
*******************************************************************************/
-- It's as simple as that...
ALTER TABLE my_table1 RENAME COLUMN quantity TO amount;


/******************************************************************************* 
  Dropping a column from a table 
*******************************************************************************/

-- Version 1: DROP COLUMN keywords are required when no parentheses are used
ALTER TABLE my_table1 DROP COLUMN new_column ;

-- Version 2: DROP keyword and columns list enclosed in parentheses
ALTER TABLE my_table1 DROP ( new_column1 ) ;
ALTER TABLE my_table1 DROP ( new_column2, new_column3) ;

-- There are restrictions on constraints. Using "CASCADE CONSTRAINTS" it will 
-- also drop the constraint, whatever it is (Primary Key or Foreign key)
ALTER TABLE ORDER_RETURNS DROP COLUMN CRUISE_ORDER_DATE CASCADE CONSTRAINTS;


ALTER TABLE my_table1 SET UNUSED COLUMN new_column4 ;
ALTER TABLE my_table1 SET UNUSED ( new_column5, new_column6 );
ALTER TABLE my_table1 DROP UNUSED COLUMNS ;


/******************************************************************************* 
  Add constraints
*******************************************************************************/
-- PRIMARY KEY (IN-LINE)
ALTER TABLE my_table1 MODIFY id1 PRIMARY KEY;
ALTER TABLE my_table1 drop PRIMARY KEY;

-- PRIMARY KEY (IN-LINE)
ALTER TABLE my_table1 MODIFY id1 CONSTRAINT AA_PK PRIMARY KEY;
ALTER TABLE my_table1 drop PRIMARY KEY;

ALTER TABLE my_table1 ADD PRIMARY KEY (id1, id2);
ALTER TABLE my_table1 drop PRIMARY KEY;

-- PRIMARY KEY (OUT-OF-LINE, composite)
ALTER TABLE my_table1 ADD CONSTRAINT AA_PK PRIMARY KEY (id1, id2);
ALTER TABLE my_table1 drop PRIMARY KEY;

-- UNIQUE (IN-LINE)
ALTER TABLE my_table1 MODIFY id1 CONSTRAINT AA_UQ UNIQUE;   -- **** CHECK IT ON THE DB ****
ALTER TABLE my_table1 drop UNIQUE (id1);

-- UNIQUE (OUT-OF-LINE, composite)
ALTER TABLE my_table1 ADD UNIQUE (id1, id2);
ALTER TABLE my_table1 drop UNIQUE (id1, id2);

-- NULL/NOT NULL
ALTER TABLE my_table1 MODIFY id1 NOT NULL;
ALTER TABLE my_table1 MODIFY id1     NULL; -- Drop the constraint

-- NULL/NOT NULL
ALTER TABLE my_table1 MODIFY id1 CONSTRAINT nn_id1 NOT NULL;
ALTER TABLE my_table1 MODIFY id1                       NULL; -- Drop the constraint

-- CHECK (IN-LINE)
ALTER TABLE my_table1 MODIFY id1                   CHECK ( id1 > 0 );
ALTER TABLE my_table1 MODIFY id1 CONSTRAINT ck_id1 CHECK ( id1 > 1 );
ALTER TABLE my_table1 DROP CONSTRAINT ck_id1;

-- CHECK (OUT-OF-LINE)
ALTER TABLE my_table1 ADD CONSTRAINT CK_ID2 CHECK ( id2 > 0 );
ALTER TABLE my_table1 ADD                   CHECK ( id2 > 1 );
ALTER TABLE my_table1 DROP CONSTRAINT ck_id2;

-- FOREIGN KEY
ALTER TABLE my_table1 MODIFY id1 CONSTRAINT AA_PK PRIMARY KEY;
ALTER TABLE my_table2 MODIFY id1 CONSTRAINT BB_PK PRIMARY KEY;

ALTER TABLE my_table1 
  ADD CONSTRAINT AA_FK 
      FOREIGN KEY (id1) 
      REFERENCES my_table2 (id1);

-- CASCADE IS NOT NECESSARY HERE. 
-- IT WILL DROP DEPENDANT CONSTRAINT (EG. PKs AND RELATED FKs)
ALTER TABLE my_table1 DROP CONSTRAINT AA_FK CASCADE; 
ALTER TABLE my_table1 DROP PRIMARY KEY;
ALTER TABLE my_table2 DROP PRIMARY KEY;

/*
DISABLING/ENABLING a constraint

ALTER TABLE my_table1 ENABLE VALIDATE PRIMARY KEY;

ALTER TABLE my_table1 ENABLE NOVALIDATE PRIMARY KEY;

Disables the constraint. If the constraint has an associated index, the index is dropped. 
ALTER TABLE my_table1 DISABLE VALIDATE PRIMARY KEY;

ALTER TABLE my_table1 DISABLE NOVALIDATE PRIMARY KEY;

*/
ALTER TABLE my_table1 ADD CONSTRAINT AA_PK PRIMARY KEY (id1, id2);
ALTER TABLE my_table1 DISABLE PRIMARY KEY;
ALTER TABLE my_table1 ENABLE PRIMARY KEY;

ALTER TABLE my_table1 ADD UNIQUE (id1, id2);
ALTER TABLE my_table1 DISABLE UNIQUE (id1, id2);
ALTER TABLE my_table1 ENABLE UNIQUE (id1, id2);

ALTER TABLE my_table1 ADD CONSTRAINT CK_ID2 CHECK ( id2 > 0 );
ALTER TABLE my_table1 DISABLE CONSTRAINT CK_ID2;
ALTER TABLE my_table1 ENABLE CONSTRAINT CK_ID2;

/* TEAR DOWN script */
DROP TABLE my_table1 ;
DROP TABLE my_table2 ;
