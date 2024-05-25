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
const First * = 0  ## TODO: Change this name to something more accurate
# 0. Pragma's Name  (aka its key)
const Name  * = 0
# 1. Pragma's Body  (aka its properties)
const Body  * = 1

#_______________________________________
# @section Node Access: Variables
#_____________________________
proc get *(code :PNode; field :string) :PNode=
  ensure code, nkPragma
  if code[First].kind != nkExprColonExpr and code[First].len != 2:
    code.err &"Only {{.key:val.}} pragmas are currently supported."
  case field
  of "name" : return code[First].getName()
  of "body" : return code[First][Body]
  else: code.err &"Tried to access an unmapped field of {code.kind}: " & field

