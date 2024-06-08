#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps *Slate
import ../errors
import ../nimc as nim


#_______________________________________
# @section AST Node Fields
#_____________________________
# 0. Name of the Affix  ( aka. the operator itself )
const Name * = 0
# 1. Body of the Prefix
const PrefixBody = 1
const InfixLeft  = 1
const InfixRight = 2


#_______________________________________
# @section Affixes: Common Tools
#_____________________________
func getName (code :PNode) :PNode= code[Name]


#_______________________________________
# @section Prefixes
#_____________________________
proc getPrefix *(code :PNode; field :string) :PNode=
  case field
  of "name": return affixes.getName(code)
  of "body": return code[PrefixBody]
  else: code.err "Tried to access an unmapped field of Prefix nodes:  " & field


#_______________________________________
# @section Infixes
#_____________________________
proc getInfix *(code :PNode; field :string) :PNode=
  case field
  of "name"  : return affixes.getName(code)
  of "left"  : return code[InfixLeft]
  of "right" : return code[InfixRight]
  else: code.err "Tried to access an unmapped field of Prefix nodes:  " & field

