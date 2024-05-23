#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strutils
# nimc dependencies
import ../nimc

const Conditions = 0..^2

proc getWhileCondition *(code :PNode) :string=
  assert code.kind == nkWhileStmt
  report code
  assert code.sons.len <= 2, "While loops with multiple conditions are currently not supported."
  for entry in code.sons[Conditions]: # Skip body of the while loop
    discard

