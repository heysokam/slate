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
# 2. Variable's Body  (aka Statement List)
const Body * = 2

#_______________________________________
# @section Node Access: Variables
#_____________________________
proc get *(code :PNode; field :string) :PNode=
  case field
  of "name" : return code.getName()
  of "type" : return code.getType()
  of "body" : return code[Body]
  else: code.err &"Tried to access an unmapped field of {code.kind}: " & field

