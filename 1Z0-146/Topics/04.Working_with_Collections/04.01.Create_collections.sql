/*
Workng with conposite data types
=======================================

Number of Elements
  if the number of elements is specified, it is the maximum number of elements in the 
  collection. If the number of elements is unspecified, the maximum number of elements 
  in the collection is the upper limit of the index type.

Dense or Sparse
  A dense collection has no gaps between elements—every element between the first and 
  last element is defined and has a value (the value can be NULL unless the element has 
  a NOT NULL constraint). A sparse collection has gaps between elements.

Uninitialized Status: 
  an EMPTY COLLECTION exists but has no elements. To add elements 
  to an empty collection, invoke the EXTEND method (described in "EXTEND Collection Method").

  A NULL COLLECTION (also called an atomically null collection) does not exist. To change a 
  null collection to an existing collection, you must initialize it, either by making it empty 
  or by assigning a non-NULL value to it (for details, see "Collection Constructors" and 
  "Assigning Values to Collection Variables"). You cannot use the EXTEND method to initialize 
  a null collection.

Where Defined

A collection type defined in a PL/SQL block is a local type. It is available only in the block, 
and is stored in the database only if the block is in a standalone or package subprogram. 

A collection type defined in a package specification is a public item. You can reference it 
from outside the package by qualifying it with the package name (package_name.type_name). 
It is stored in the database until you drop the package. 

A collection type defined at schema level is a standalone type. You create it with the 
"CREATE TYPE Statement". It is stored in the database until you drop it with the "DROP TYPE Statement".

*/

declare
  subtype employee_rt  is  hr.employees%rowtype ;
  employee1   employee_rt ;
  employee2   employee_rt ;
begin
   if ( employee1 = employee2 ) then -- COMPILATION ERROR LS-00306: wrong number or types of arguments in call to '='
     null;
   end if;
exception
   when others then
      raise;
end;
/