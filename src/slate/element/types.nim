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
const Name    = 0
const Inherit = 1
const Type    = ^1
const Pragma  = ^1
const Body    = ^1


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
  if code.kind notin nim.SomeType : return false
  if   code.kind == kind          : result = true
  elif code.kind == nkTypeDef     : result = code[Type].isKind(kind)
  else: code.err "Tried to find if a node is a type, but found an unmapped node kind."
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
##[
# TODO: Remove
type Elem *{.pure.}= enum Symbol, Generics, Type
converter toInt *(d :Elem) :int= d.ord
#_____________________________
# TODO: Proc Type access
proc procRetT  *(code :PNode) :PNode=
  # Alias for un-confusing property access
  const Params     = 0
  const ReturnType = 0
  # Error check
  assert code[Elem.Type].kind == nkProcTy
  assert code[Elem.Type][Params].kind == nkFormalParams
  assert code[Elem.Type][Params][ReturnType].kind == nkIdent
  # Return the result
  result = code[Elem.Type][Params][ReturnType]
#___________________
proc procArgs *(code :PNode) :seq[PNode]=
  # Alias for un-confusing property access
  const Params     = 0
  const ReturnType = 0
  # Error check
  assert code[Elem.Type].kind == nkProcTy
  # Return the result
  for id,arg in code[Elem.Type][Params].pairs:
    if id == ReturnType: continue
    result.add arg
]##

