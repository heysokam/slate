#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# nimc dependencies
import ../nimc
import ./base
import ./error

# Elements
type Elem *{.pure.}= enum Name
converter toInt *(d :Elem) :int= d.ord
const VarType  = ^2
const VarValue = ^1
type VariableType * = tuple[isPtr:bool, isArr:bool, arrSize,name:string]

#_________________________________________________
# General
#_____________________________
proc isPrivate *(code :PNode; indent :int) :bool=
  assert code.kind in [nkConstDef, nkIdentDefs]
  if indent > 0: return false
  let sym = code[Elem.Name]
  assert sym.kind in {nkIdent,nkPostfix}
  return base.isPrivate(sym, indent, VarDefError)
#_____________________________
proc getName *(code :PNode) :string=
  assert code.kind in [nkConstDef, nkIdentDefs]
  let sym = code[Elem.Name]
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = sym.strValue
  of nkPostfix : result = sym[1].strValue
  else: raise newException(VarDefError, &"Tried to get the name of a variable, but its symbol has an unknown format.\n  {sym.kind}\n")
#_____________________________
proc getType *(code :PNode) :VariableType=
  assert code.kind in [nkConstDef, nkIdentDefs]
  result.isPtr = code[VarType].kind == nkPtrTy
  result.isArr = code[VarType].kind == nkBracketExpr and code[VarType][0].strValue == "array"
  if result.isArr:
    result.arrSize =
      if   code[VarType][1].kind == nkIdent: code[VarType][1].strValue
      elif code[VarType][1].kind == nkInfix:
        &"{code[VarType][1][1].strValue} {code[VarType][1][0].strValue} {code[VarType][1][2].strValue}"
      else:"" # TODO: Better infix resolution
    if result.arrSize == "": raise newException(VarDefError, &"Tried to get the size of an array variable, but its size has an unknown format.\n{code[VarType][1].treeRepr}\n")
    result.name    = code[VarType][2].strValue
  elif result.isPtr : result.name = code[VarType][0].strValue # ptr MyType
  else              : result.name = code[VarType].strValue    # MyType
#_____________________________
proc getValue *(code :PNode) :string=
  assert code.kind in [nkConstDef, nkIdentDefs]
  code[VarValue].strValue

