#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
# @deps *Slate
import ../errors
import ../nimc as nim
import ./general


#_______________________________________
# @section AST Node Fields
#_____________________________
proc getArgs (code :PNode) :PNode=
  ## @desc Returns the {@arg code} call PNode with its identifier removed, preserving only its arguments
  result = nim.newNodeI(code.kind, code.info)
  result.sons =
    if code.sons.len > 1: code.sons[1..^1]
    else: @[]

#_______________________________________
# @section Calls
#_____________________________
const UnknownID :int= int.high
proc get *(code :PNode; field :string; id :SomeInteger= UnknownID) :PNode=
  case field
  of "name"     : return code.getName()
  of "args"     : return code.getArgs()
  of "arg"      :
    if id == UnknownID: code.err "Tried to access an Argument of a Call node, but its ID was not passed."
    if code.len < id+1: code.err "Tried to access an Argument of a Call node, but the ID passed does not exist:  " & $id
    return code[id+1]
  else: code.err "Tried to access an unmapped field of Call nodes:  " & field

