

/* Restricting rows using HAVING */

-- set up
CREATE TABLE SHIP_CABINS (
  SHIP_CABIN_ID  NUMBER,
  SHIP_ID        NUMBER(7),
  ROOM_NUMBER    VARCHAR2(5 BYTE),
  ROOM_STYLE     VARCHAR2(10 BYTE),
  ROOM_TYPE      VARCHAR2(20 BYTE),
  WINDOW         VARCHAR2(10 BYTE),
  GUESTS         NUMBER(3),
  SQ_FT          NUMBER(6),
  BALCONY_SQ_FT  NUMBER(6)
);

INSERT INTO SHIP_CABINS SELECT 1,1,102,'Suite','Standard','Ocean',4,533,0 from dual;
INSERT INTO SHIP_CABINS SELECT 2,1,103,'Stateroom','Standard','Ocean',2,160,0 from dual;
INSERT INTO SHIP_CABINS SELECT 3,1,104,'Suite','Standard','None',4,533,0 from dual;
INSERT INTO SHIP_CABINS SELECT 4,1,105,'Stateroom','Standard','Ocean',3,205,0 from dual;
INSERT INTO SHIP_CABINS SELECT 5,1,106,'Suite','Standard','None',6,586,0 from dual;
INSERT INTO SHIP_CABINS SELECT 6,1,107,'Suite','Royal','Ocean',5,1524,0 from dual;
INSERT INTO SHIP_CABINS SELECT 7,1,108,'Stateroom','Large','None',2,211,0 from dual;
INSERT INTO SHIP_CABINS SELECT 8,1,109,'Stateroom','Standard','None',2,180,0 from dual;
INSERT INTO SHIP_CABINS SELECT 9,1,110,'Stateroom','Large','None',2,225,0 from dual;
INSERT INTO SHIP_CABINS SELECT 10,1,702,'Suite','Presidential','None',5,1142,0 from dual;
INSERT INTO SHIP_CABINS SELECT 11,1,703,'Suite','Royal','Ocean',5,1745,0 from dual;
INSERT INTO SHIP_CABINS SELECT 12,1,704,'Suite','Skyloft','Ocean',8,722,0 from dual;
commit ;

-- <- set up


SELECT room_style, room_type, AVG(SQ_FT)
  FROM SHIP_CABINS
 WHERE SHIP_ID = 1
 group by room_style, room_type
 having room_type  in  ( 'Standard', 'Large');
 
/* Excluding rows using HAVING */
SELECT room_style, room_type, AVG(SQ_FT)
  FROM SHIP_CABINS
 WHERE SHIP_ID = 1
 group by room_style, room_type
 having room_type   NOT in   ( 'Standard', 'Large');
 


-- tear down
drop table SHIP_CABINS purge ;

