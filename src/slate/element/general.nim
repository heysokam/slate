#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps *Slate
import ../errors
import ../nimc as nim


#_______________________________________
# @section Node Access: General Fields
#_____________________________
proc getName *(code :PNode) :PNode=
  const (Name, PublName, Pragma) = (0, 1, 0)
  if code.kind == nkIdent: return code
  let name = code[Name]
  if   name.kind == nkIdent      : return code[Name]
  elif name.kind == nkDotExpr    : return code[Name]
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
  elif code.kind == nkBracketExpr       : return code[ArrayType].getType()
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
proc isReadonly *(code :PNode) :bool=
  case code.kind
  of nkIdent: return false
  of nkPragmaExpr:
    const (Name,Pragma) = (0,1)
    return code.kind == nkPragmaExpr and
           code[Pragma][Name].kind != nkEmpty and
           code[Pragma][Name].strValue == "readonly"
  of nkIdentDefs:
    const (Type,Value,LastArg) = (^2,^1,^3)
    for id,arg in code.sons[0..LastArg].pairs:
      if arg.isReadonly: return true
  else: code.err "Tried to find readonly condition of an ummapped node kind."
#___________________
proc hasStubPragma *(code :PNode) :bool=
  ## @descr Returns true if the given {@arg code} meets all the conditions to be a name that contains a `stub` pragma
  const (Name,Pragma) = (0,1)
  code.kind == nkPragmaExpr and
  code[Pragma].kind == nkPragma and
  code[Pragma][Name].kind == nkIdent and
  code[Pragma][Name].strValue == "stub"
#___________________
proc isDeref *(code :PNode) :bool=  code.kind == nkBracketExpr and code.len == 1
  ## @descr Returns true if the {@arg code} defines a pointer dereference


#_______________________________________
# @section DotExpr
#_____________________________
proc getDotExprRec (code :PNode; idents :var seq[PNode]) :void=
  ## @descr Recursive add ident nodes from {@arg code} dotExpr into the {@arg idents} list
  if code.kind == nkDotExpr:
    const (Next,Name) = (0,^1)
    if code[Name].kind != nkIdent: code.err &"The dotExpr.getDotExprRec recursive function found a kind that it doesn't understand:  {code[Name].kind}"
    idents.add code[Name]
    code[Next].getDotExprRec(idents)
  elif code.kind == nkIdent:
    idents.add code
  else: code.err "The dotExpr.getDotExprRec recursive function reached a not-mapped or unreachable case."
#_____________________________
iterator dotExpr *(code :PNode) :PNode=
  ## @descr Yields every node entry of the {@arg code} dotExpr node
  if code.kind != nkDotExpr: code.err "The dotExpr iterator only accepts nkDotExpr nodes."
  var idents :seq[PNode]
  code.getDotExprRec(idents)
  for id in countdown(idents.high, idents.low): yield idents[id]

