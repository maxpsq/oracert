
create table data_type_test ( 
  number01    number(5,2),
  number02    number(5),
  number03    number(5,-2),
  timestamp01 timestamp,
  timestamp02 timestamp(5),
  char01      char(10),
  char02      char(10)
);


insert into data_type_test (number01) values (1234);  -- ERROR on PRECISION
insert into data_type_test (number01) values (123);   -- SUCCESS
insert into data_type_test (number01) values (1.12345);  -- SUCCESS (round on precision)
insert into data_type_test (number01) values (1.98765);  -- SUCCESS (round UP on precision)
insert into data_type_test (number01) values (1.1);  -- SUCCESS

select number01 from data_type_test where number01 is not null ;


insert into data_type_test (number02) values (123456);  -- ERROR on PRECISION
insert into data_type_test (number02) values (12345.123);  -- SUCCESS (round UP on precision)
insert into data_type_test (number02) values (123.82);  -- SUCCESS (round UP on precision)
insert into data_type_test (number02) values (123);  -- SUCCESS

select number02 from data_type_test where number02 is not null ;


insert into data_type_test (number03) values (123456);  -- SUCCESS (123500) round UP 456 -> 500
insert into data_type_test (number03) values (12345.123);  -- SUCCESS (12300)
insert into data_type_test (number03) values (123.82);  -- SUCCESS (inserts 100)
insert into data_type_test (number03) values (123);  -- SUCCESS (inserts 100)
insert into data_type_test (number03) values (975);  -- SUCCESS (inserts 1000)

select number03 from data_type_test where number03 is not null ;
