#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
# @deps *Slate
import ../types
import ../errors
import ../nimc as nim


#_______________________________________
# @section AST Node Fields
#_____________________________
# 0. Name
const Name     * = 0
const Publ     * = 0
const PublName * = 1
# 1. Term Rewriting (only for macros/templates)
const TermRewrite * = 1
# 2. Generics
const Generics * = 2
# 3. Args
const Args * = 3
const RetT * = 0
# 4. Pragmas
const Pragmas * = 4
# 5. Reserved
const Reserved * = 5 # Field reserved for the future
# 6. Proc's Body  (aka Statement List)
const Body * = 6
#___________________
proc getArgs (code :PNode) :PNode=
  ## @desc Returns the {@arg code} call PNode with its identifier removed, preserving only its arguments
  let args = code[Args]
  result = nim.newNodeI(args.kind, args.info)
  result.sons =
    if args.sons.len > 1: args.sons[1..^1]
    else: @[]

#_______________________________________
# @section Procs
#_____________________________
proc get *(code :PNode; field :string; id :SomeInteger= UnknownID) :PNode=
  # Access the requested field
  case field
  of "name"     : return code.getName()
  of "generics" : return code[Generics]
  of "returnT"  : return code[Args][RetT]
  of "args"     : return procs.getArgs(code)
  of "arg"      :
    if id == UnknownID: code.err "Tried to access an Argument of a nkProcDef, but its ID was not passed."
    return code[Args][id]
  of "pragmas"  : return code[Pragmas]
  of "pragma"   :
    if id == UnknownID: code.err "Tried to access a Pragma of a nkProcDef, but its ID was not passed."
    return code[Pragmas][id]
  of "body"     : return code[Body]
  else: code.err "Tried to access an unmapped field of nkProcDef:  " & field


#_______________________________________
# @section Node Properties: Procs
#_____________________________
proc hasPragma *(code :PNode) :bool=
  if code.kind != nkProcDef: code.err "Tried to find if a proc has a pragma, but the node passed is not a proc."
  result = code[Pragmas].kind != nkEmpty

