

/*

ALTER VIEW

The ALTER VIEW statement is used to accomplish any of the following tasks:
- Create, modify, or drop constraints on a view (*).
- Recompile an invalid view.

(*) You can create constraints on a view in the same way you can create them 
on a table. HOWEVER: Oracle doesn’t enforce them without special configuration 
that’s available primarily to support certain data warehousing requirements. 
This subject is worth noting but not specifically addressed on the exam.
*/

ALTER VIEW my_view COMPILE ;