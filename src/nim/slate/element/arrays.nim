#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps *Slate
import ../errors
import ../nimc as nim
import ./general


#_______________________________________
# @section AST Node Fields
#_____________________________
const Name = 0
const Type = 1

#_______________________________________
# @section AST Node Filters
#_____________________________
const TypeSlotKinds = {nkIdentDefs, nkConstDef}          # Kinds that contain a valid type at slot [Type]
const NameSlotKinds = {nkBracketExpr, nkPtrTy, nkVarTy}  # Kinds that contain a valid type at slot [Name]


#_______________________________________
# @section Node Properties: Arrays
#_____________________________
proc isArrAccess *(code :PNode) :bool= code.kind == nkBracketExpr and code.len == 2
  ## @descr Returns true if the {@arg code} defines an array access
#___________________
proc isArr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines an array type
  if   code.isArrAccess           : result = false
  elif code.isDeref               : result = false
  elif code.kind in nim.SomeLit   : result = false
  elif code.kind == nkCommand     : result = false  # Commands are considered literals (multi-word types)
  elif code.kind == nkIdent       : result = code.strValue == "array"
  elif code.kind in TypeSlotKinds : result = code[Type].isArr()
  elif code.kind in NameSlotKinds : result = code[Name].isArr()
  else: code.err "Tried to check if a node is an array, but found an unmapped kind."

