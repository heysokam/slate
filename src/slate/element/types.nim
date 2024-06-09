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
proc isPtr *(code :PNode) :bool=
  ## @descr Returns true if the {@arg code} defines a ptr type
  result = code.kind == nkPtrTy

