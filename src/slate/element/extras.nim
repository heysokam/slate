#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @fileoverview Syntax rules that are not natively defined by Nim
#__________________________________________________________________|
# @deps *Slate
import ../nimc as nim
import ./general


#_______________________________________
# @section Extra Tools
#_____________________________
func isSpecialCall *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} meets the conditions to be a Special Call
  if code.kind != nkCall : return false  # Only Calls can be special calls
  if code.len < 2        : return false  # Calls without arguments cannot be special calls
  return true
#___________________
const ValidUnionInfixes = [".:"]
proc isUnion *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} describes a Union initializer special case
  if not code.isSpecialCall: return false  # Only Special Calls are supported for Union initializer syntax
  const (Arg0,InfixName) = (1,0)
  if code[Arg0].kind == nkInfix and
     code[Arg0].getName.strValue in ValidUnionInfixes:
    return true
#___________________
const ValidObjConstrSymbols = ["_"]
proc isObjConstr *(code :PNode; skipObjConstr :bool= false) :bool=
  ## @descr Returns true if the {@arg code} describes an object constructor
  const (Arg0,) = (1,)
  if not skipObjConstr and
     code.kind == nkObjConstr : return true
  if not code.isSpecialCall   : return false  # Only Special Calls are supported for Object constructor syntax
  if code[Arg0].kind == nkIdent and
     code[Arg0].strValue in ValidObjConstrSymbols:
    return true  # StructType(_) special case

