/*
Collection Constructors
Note:
This topic applies only to varrays and nested tables. Associative arrays do not have constructors. In this topic, collection means varray or nested table.
A collection constructor (constructor) is a system-defined function with the same name as a collection type, which returns a collection of that type. The syntax of a constructor invocation is:

collection_type ( [ value [, value ]... ] )
If the parameter list is empty, the constructor returns an empty collection. Otherwise, the constructor returns a collection that contains the specified values. For semantic details, see "collection_constructor".

You can assign the returned collection to a collection variable (of the same type) in the variable declaration and in the executable part of a block.

Example 5-7 invokes a constructor twice: to initialize the varray variable team to empty in its declaration, and to give it new values in the executable part of the block. The procedure print_team shows the initial and final values of team. To determine when team is empty, print_team uses the collection method COUNT, described in "Collection Methods". (For an example of a procedure that prints a varray that might be null, see Example 5-24.)


*/