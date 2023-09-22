#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
import std/sequtils
# nimc dependencies
import ../nimc
# Element dependencies
import ./base
import ./error

# Elements
type Elem *{.pure.}= enum Symbol, Unused1, Generic, Args #[nkFormalParams]#, Pragma, Reserved1, Body #[nkStatements]#
converter toInt *(d :Elem) :int= d.ord
const Arg1 = 1 # Arg1 id number inside the node
const ArgT = ^2

type ArgType  * = tuple[isPtr:bool, isMut:bool, name:string]
type Argument * = tuple[first:bool, last:bool, node:PNode, typ:ArgType, name:string]

#_________________________________________________
# Properties
#_____________________________
proc isPrivate *(code :PNode; indent :int= 0) :bool=
  assert code.kind == nkProcDef
  if indent > 0: return true # All inner procs are private
  result = base.isPrivate(code[Elem.Symbol], indent, ProcDefError)
#_____________________________
proc hasPragma *(code :PNode) :bool=
  assert code.kind == nkProcDef
  result = code[Elem.Pragma].kind != nkEmpty


#_________________________________________________
# General
#_____________________________
proc getName *(code :PNode) :string=
  assert code.kind == nkProcDef
  let sym = code[Elem.Symbol]
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = sym.strValue
  of nkPostfix : result = sym[1].strValue
  else: raise newException(ProcDefError, &"Tried to get the name of a proc, but its symbol has an unknown format.\n  {sym.kind}\n")
#_____________________________
proc getRetT *(code :PNode) :string=
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams and params[0].kind == nkIdent
  params[0].strValue  # First parameter is always its return type
#_____________________________
proc getPragma *(code :PNode) :PNode=
  assert code.kind == nkProcDef and code[Elem.Pragma].kind == nkPragma
  code[Elem.Pragma]


#_________________________________________________
# Arguments
#_____________________________
# First entry is always the name
# Previous to last entry is always the type
# Last entry is always the default value
#_____________________________
proc getArgCount *(code :PNode) :int=
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams
  for id,param in params.pairs:
    if id == 0: continue  # First parameter is always its return type
    assert param.kind == nkIdentDefs
    result += (param.sons.len - 2) # The amount of arguments in this entry is len without (type) or (default value)
#_____________________________
proc getArgT *(code :PNode) :ArgType=
  assert code.kind == nkIdentDefs
  if code[ArgT].kind == nkEmpty: raise newException(ProcDefError, &"Declaring ProcDef arguments without type is currently not supported. The argument's code is:\n{code.renderTree}\n")
  assert code[ArgT].kind in [nkIdent,nkPtrTy,nkVarTy], "\n" & code.treeRepr & "\n" & code.renderTree
  result.isMut = code[ArgT].kind == nkVarTy
  result.isPtr = if result.isMut: code[ArgT][0].kind == nkPtrTy else: code[ArgT].kind == nkPtrTy
  if   result.isPtr and result.isMut : result.name = code[ArgT][0][0].strValue() # Access the nkVarTy.nkPtrTy value
  elif result.isPtr or  result.isMut : result.name = code[ArgT][0].strValue()    # Access the nkPtrTy or nkVarTy value
  else                               : result.name = code[ArgT].strValue()       # Second entry is always the argument type
#_____________________________
proc getArgName *(code :PNode; id :int= 0) :string=
  ## Gets the argument name of the given id entry of an nkIdentDefs block
  ## For arguments with 1 value,  like `(val :int; num: int)`, the id should always be 0
  ## For arguments with N values, like `(val :int; A,B,C :int)`, the id must point to the position of the sub-argument
  ## nkIdentDefs always have 3 entries (name,  type, value).
  ## Multi-arguments take the shape of (A,B,C, type, value).
  assert code.kind == nkIdentDefs and code[id].kind == nkIdent and id <= code.sons.len-2, code.treeRepr
  code[id].strValue()
#_____________________________
iterator args *(code :PNode) :Argument=
  ## Iterates over the Arguments of a ProcDef node, and yields them one by one
  assert code.kind == nkProcDef
  let params = code[Elem.Args]
  assert params.kind == nkFormalParams
  let argc   = code.getArgCount()
  let paramc = params.sons.len
  for paramID in 0..<paramc:
    if paramID == 0: continue  # First parameter is always the type of the proc
    assert params[paramID].kind == nkIdentDefs
    let typ  = params[paramID].getArgT()
    let subc = params[paramID].sons.len - 2
    for subID in 0..<subc:
      yield (first : paramID == 0,
             last  : paramID + subID == argc,
             node  : params[paramID],
             typ   : typ,
             name  : params[paramID][subID].strValue )

