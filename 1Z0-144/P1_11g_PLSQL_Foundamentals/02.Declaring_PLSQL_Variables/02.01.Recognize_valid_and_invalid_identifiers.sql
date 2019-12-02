document

=================================================================================
OBJECTIVE: Recognize valid and invalid identifiers
=================================================================================
Valid variable names are bound to the same rules as database objects.
They must
  - be composed of characters from the database charactr set
  - begin with a letter
  - contain a letters, digits or the symbols $ _ #
  - not exceed 30 characters (30 bytes) in length

A valid PL/SQL variable can be validated against the following regular expression

^[A-Za-z][A-Za-z0-9$#_]{,29}$

#
