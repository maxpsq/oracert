
/*
Attempting to access a NON-EXISTENT subscript in a collection.

ASSOCIATIVE ARRAYS
*/
set serveroutput on;
declare
   subtype EAN_CODE       is varchar2(13);
   TYPE    ean_codes_aat is TABLE OF EAN_CODE index by PLS_INTEGER; 
   
   ec          EAN_CODE;
   ean_codes   ean_codes_aat ;
begin
   for i in 1..9 loop
     ean_codes(i) := 'a'||i ;
   end loop;
   dbms_output.put_line('ean_codes.FIRST='||ean_codes.FIRST);
   dbms_output.put_line('ean_codes.LAST='||ean_codes.LAST);
   begin
      ec := ean_codes(-12);
   exception
      when no_data_found then
         dbms_output.put_line('-12 - NO_DATA_FOUND');
   end;      
   begin
      ec := ean_codes(12);
   exception
      when no_data_found then
         dbms_output.put_line(' 12 - NO_DATA_FOUND');
   end;      
end;
/

declare
   subtype EAN_CODE       is varchar2(13);
   TYPE    ean_codes_ntt is TABLE OF EAN_CODE ; 
   
   ec          EAN_CODE;
   ean_codes   ean_codes_ntt := ean_codes_ntt();
begin
   for i in 1..9 loop
     ean_codes.EXTEND();
     ean_codes(i) := 'a'||i ;
   end loop;
   ean_codes.delete(5);
   dbms_output.put_line('ean_codes.FIRST='||ean_codes.FIRST);
   dbms_output.put_line('ean_codes.LAST='||ean_codes.LAST);
   begin
      ec := ean_codes(0);
   exception
      when SUBSCRIPT_OUTSIDE_LIMIT then
         dbms_output.put_line('  0 - SUBSCRIPT_OUTSIDE_LIMIT -> Valid limits ranges from 1 to 2^31 -1');
   end;      
   begin
      ec := ean_codes(5);
   exception
      when no_data_found then
         dbms_output.put_line('  5 - NO_DATA_FOUND -> 5 is in between FIRST and LAST but it was DELETED');
   end;      
   begin
      ec := ean_codes(12);
   exception
      when SUBSCRIPT_BEYOND_COUNT then
         dbms_output.put_line(' 12 - SUBSCRIPT_BEYOND_COUNT -> .LAST equals '||ean_codes.LAST);
   end;      
end;
/



declare
   subtype EAN_CODE      is varchar2(13);
   TYPE    ean_codes_vat is VARRAY(10) OF EAN_CODE ; 
   
   ec          EAN_CODE;
   ean_codes   ean_codes_vat := ean_codes_vat();
begin
   for i in 1..9 loop
     ean_codes.EXTEND();
     ean_codes(ean_codes.LAST) := 'a'||i ;
   end loop;
   dbms_output.put_line('ean_codes.FIRST='||ean_codes.FIRST);
   dbms_output.put_line('ean_codes.LAST='||ean_codes.LAST);
   begin
      ec := ean_codes(0);
   exception
      when SUBSCRIPT_OUTSIDE_LIMIT then
         dbms_output.put_line('  0 - SUBSCRIPT_OUTSIDE_LIMIT -> Valid limits ranges from 1 to 2^31 -1');
   end;      
   begin
      ec := ean_codes(10);
   exception
      when SUBSCRIPT_BEYOND_COUNT then
         dbms_output.put_line(' 10 - SUBSCRIPT_BEYOND_COUNT -> 10 FIRST='||ean_codes.FIRST||' and LAST='||ean_codes.LAST);
   end;      
   begin
      ec := ean_codes(12);
   exception
      when SUBSCRIPT_OUTSIDE_LIMIT then
         dbms_output.put_line(' 12 - SUBSCRIPT_OUTSIDE_LIMIT -> .LIMIT equals '||ean_codes.LIMIT);
   end;      
end;
/
