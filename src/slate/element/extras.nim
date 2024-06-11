#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @fileoverview Syntax rules that are not natively defined by Nim
#__________________________________________________________________|
# @deps *Slate
import ../errors
import ../nimc as nim
import ./general
import ./pragmas


#_______________________________________
# @section Extras: Calls
#_____________________________
func isSpecialCall *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} meets the conditions to be a Special Call
  if code.kind != nkCall : return false  # Only Calls can be special calls
  if code.len < 2        : return false  # Calls without arguments cannot be special calls
  return true


#_______________________________________
# @section Extras: Objects
#_____________________________
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


#_______________________________________
# @section Extra Node Properties: Types
#_____________________________
proc isStubInherit *(code :PNode) :bool=
  ## @descr Returns true if the given {@arg code} meets all the conditions to be a stub inherit object type
  const (Name,Inherit,Type, Pragma,Body) = (0,1,^1, ^1,^1)
  code.kind == nkObjectTy and
  code[Inherit].kind == nkOfInherit and
  code[Inherit][Name].kind == nkIdent and
  code[Body].kind == nkEmpty
#___________________
proc isStub *(code :PNode) :bool=
  ## @descr
  ##  Returns true if the given {@arg code} meets all the conditions to be a stub object typedef
  ##  1. Code has to be an Object Typedef
  ##  2. Its name must be a pragma
  ##  3. Its first pragma must be "stub"
  ##  4. It must inherit from an indentifier `object of thing`
  ##  5. Its body must be empty
  const (Name,Inherit,Type, Pragma,Body) = (0,1,^1, ^1,^1)
  case code.kind
  of nkTypeDef  : return code[Type].kind == nkObjectTy and code[Name].hasStubPragma and code[Type].isStubInherit
  of nkObjectTy : return code.isStubInherit
  else: code.err "Tried to get the stub condition of an unmapped node kind."


#_______________________________________
# @section Extra Node Properties: Pragmas
#_____________________________
const FallThrough * = ["fallthrough", "fall_through"]
proc isFallthrough *(code :PNode) :bool=
  case code.kind
  of nkPragma     : pragmas.get(code, "name").strValue() in FallThrough
  of nkPragmaExpr : code.err "Found a node kind in isFallthrough, but support is not implemented yet."; false
  of nkStmtList   : code.err "Found a node kind in isFallthrough, but support is not implemented yet."; false
  else            : false

