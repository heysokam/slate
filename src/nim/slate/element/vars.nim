#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
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
# 0. Variable's name
const Name    * = 0
# 0.^1 Variable's Pragmas
const Pragmas * = ^1
# 2. Variable's Body  (aka Statement List)
const Body    * = 2


#_______________________________________
# @section Node Access: Variables
#_____________________________
proc get *(code :PNode; field :string) :PNode=
  case field
  of "name"    : return code.getName()
  of "type"    : return code.getType()
  of "body"    : return code[Body]
  of "pragmas" :
    let hasPragma = code[Name].kind == nkPragmaExpr
    if  hasPragma : return code[Name][Pragmas]
    else          : return newNodeI(nkEmpty, code.info)
  else: code.err &"Tried to access an unmapped field of {code.kind}: " & field


#_______________________________________
# @section Node Properties: Variables
#_____________________________
proc isMutable *(code :PNode; kind :Kind) :bool=
  ## @descr Returns true if the {@arg code} defines a mutable kind
  ensure code, Const, Let, Var, msg= &"Tried to check for mutability of a kind that doesn't support it:  {kind}"
  result = kind == Kind.Var

