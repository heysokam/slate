#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps *Slate
import ../types
import ../errors
import ../nimc as nim


#_______________________________________
# @section Node Access: General Fields
#_____________________________
proc getName *(code :PNode) :PNode=
  const (Name, PublName, Pragma) = (0, 1, 0)
  let name = code[Name]
  if   name.kind == nkIdent      : return code[Name]
  elif name.kind == nkPostFix    : return code[Name][PublName]
  elif name.kind == nkPragmaExpr : return code[Pragma].getName()
  else: code.err &"Something went wrong when accessing the Name of a {code.kind}. The name field is:  " & $code[Name].kind
#___________________
proc getType *(code :PNode) :PNode=
  const TypeSlotKinds = {nkIdent, nkEmpty, nkCommand, nkPtrTy}  # Kinds that contain a valid type at slot [Type]
  const (Type,ArrayType) = (1,2)
  if   code.kind in {nkIdent,nkEmpty}   : return code
  elif code[Type].kind in TypeSlotKinds : return code[Type]
  elif code[Type].kind == nkBracketExpr : return code[Type][ArrayType].getType()
  else: code.err &"Something went wrong when accessing the Type of a {code.kind}. The type field is:  " & $code[Type].kind


#_______________________________________
# @section Node Access: General Kinds
#_____________________________
proc isPublic *(code :PNode) :bool=
  ## @descr Returns true if the name of the {@arg code} is marked as public
  const (Name, Publ) = (0, 0)
  code[Name].kind != nkIdent and code[Name][Publ].strValue == "*"
#___________________
proc isPersist *(
    code   : PNode;
    indent : SomeInteger;
    crash  : bool = true;
  ) :bool=
  ## @descr
  ##  Returns true if the {@arg code} is marked with the persist pragma.
  ##  Crashes the compiler on unexpected behavior when {@arg crash} is active or is omitted  (default: true)
  const (Name,Pragma) = (0,1)
  if code.kind notin {nkConstDef, nkIdentDefs, nkPragmaExpr}:  # TODO: Do other things need the {.persist.} pragma?
    if crash: code.err "Tried to get the persist pragma for an unmapped kind."
    return false
  if indent < 1: return false
  let name = code[Name]
  if name.kind notin {nkIdent, nkPostfix, nkPragmaExpr}:
    if crash: name.err "Tried to get the persist pragma from an unmapped name node kind."
    return false
  return name.kind == nkPragmaExpr and
         name[Pragma][Name].kind != nkEmpty and
         name[Pragma][Name].strValue == "persist"
#___________________
proc isMutable *(code :PNode; kind :Kind) :bool=
  ## @descr Returns true if the {@arg code} defines a mutable kind
  ensure code, Const, Let, Var, msg= &"Tried to check for mutability of a kind that doesn't support it:  {kind}"
  result = kind == Kind.Var
#___________________
proc isPtr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines a ptr type
  result = code.kind == nkPtrTy
#___________________
proc isArr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines an array type
  const TypeSlotKinds = {nkIdentDefs, nkConstDef}  # Kinds that contain a valid type at slot [Type]
  const NameSlotKinds = {nkBracketExpr, nkPtrTy}   # Kinds that contain a valid type at slot [Name]
  const (Name,Type) = (0,1)
  if   code.kind == nkIdent       : result = code.strValue == "array"
  elif code.kind in nim.SomeLit   : result = false
  elif code.kind == nkCommand     : result = false  # Commands are considered literals (multi-word types)
  elif code.kind in TypeSlotKinds : result = code[Type].isArr()
  elif code.kind in NameSlotKinds : result = code[Name].isArr()
  else: code.err &"Tried to check if a node is an array, but found an unmapped kind:  {code.kind}"

