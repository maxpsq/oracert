

CREATE TABLE test_visible_invisible (
  id     number,
  col2   number(1)  INVISIBLE  DEFAULT 2  NOT NULL,
  col3   number(1),
  col4   number(1)
);

-- Notice the INSERT statements will succede despite the fact we are NOT specifying
-- the column list AND we are passing only one value.
INSERT INTO test_visible_invisible VALUES (1,3,4);

-- We are getting an error "TOO MANY VALUES"
INSERT INTO test_visible_invisible VALUES (2,2,3,4);

-- This will work
INSERT INTO test_visible_invisible(id,col2,col3,col4) VALUES (2,2,3,4);

INSERT INTO test_visible_invisible VALUES (3,3,4);
COMMIT;

-- COL2 is not returned
SELECT * FROM test_visible_invisible ;

DESC test_visible_invisible ;

-- COL2 is returned
SELECT col2 FROM test_visible_invisible ;

-- SQL*Plus only hows INVISIBLE COLUMNS in DESC command.
SET COLINVISIBLE ON 

DESC test_visible_invisible ;

alter table test_visible_invisible modify col2 visible;

-- Notice once an INVISIBLE column is restored to VISIBLE, it apperas
-- as the last column in the table.
SELECT * FROM test_visible_invisible ;

/* tear down */
drop table test_visible_invisible;


