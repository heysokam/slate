#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps *Slate
import ../types
import ../errors
import ../nimc as nim
import ./general


#_______________________________________
# @section AST Node Fields
#_____________________________
const Name    = 0
const Inherit = 1
const Type    = ^1
const Pragma  = ^1
const Body    = ^1
const Proc    = (
  Params  : 0,
  ReturnT : 0,
  First   : 1,
  Last    : ^1,
  ) # << Proc = ( ... )


#_______________________________________
# @section Types Node Access
#_____________________________
proc get *(code :PNode; field :string) :PNode=
  case field
  of "name"   : return code.getName()
  of "type"   : return code[Type]
  of "pragma" :
    let hasPragma = code[Name].kind == nkPragmaExpr
    if  hasPragma : return code[Name][Pragma]
    else          : return newNodeI(nkEmpty, code.info)
  else: code.err "Tried to access an unmapped field of Typedef nodes:  " & field


#_______________________________________
# @section Node Properties: Types
#_____________________________
proc isKind *(code :PNode; kind :TNodeKind) :bool=
  if code.kind == nkTypeDef : return code[Type].isKind(kind) # Recurse for Typedef
  if code.kind == kind      : return true
#_____________________________
proc isPtr *(code :PNode) :bool=  code.isKind(nkPtrTy)
  ## @descr Returns true if the {@arg code} defines a ptr type
proc isObj *(code :PNode) :bool=  code.isKind(nkObjectTy)
  ## @descr Returns true if the {@arg code} defines an object type
proc isProc *(code :PNode) :bool=  code.isKind(nkProcTy)
  ## @descr Returns true if the {@arg code} defines a proc type


#_______________________________________
# @section Proc Types Node Access
#_____________________________
proc getProcRetT (code :PNode) :PNode=
  let typ = case code.kind
    of nkTypeDef : code[Type]
    of nkProcTy  : code
    else         : code.err "Tried to get the Return Type of a proc type, but the node passed is not a proc."; nil
  result = typ[Proc.Params][Proc.ReturnT]
#___________________
proc getProcArgs (code :PNode) :PNode=
  let typ = case code.kind
    of nkTypeDef : code[Type]
    of nkProcTy  : code
    else         : code.err "Tried to get the Args of a proc type, but the node passed is not a proc."; nil
  result = nim.newNodeI(typ[Proc.Params].kind, code.info)
  for arg in typ[Proc.Params].sons[Proc.First..Proc.Last]:
    result.add arg
#___________________
proc getProc *(code :PNode; field :string; id :SomeInteger= UnknownID) :PNode=
  case field
  of "name"    : return code.getName()
  of "returnT" : return code.getProcRetT()
  of "args"    : return code.getProcArgs()
  of "arg"      :
    if id == UnknownID: code.err "Tried to access an Argument of a nkProcDef, but its ID was not passed."
    return code.getProcArgs()[id]
  else: code.err "Tried to access an unmapped field of Typedef nodes:  " & field

