#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
import std/strutils
import std/sequtils
# nimc dependencies
import ../nimc
# Element dependencies
import ./base
import ./error

# Elements
type Elem *{.pure.}= enum Symbol, Arg1
converter toInt *(d :Elem) :int= d.ord

type Argument     * = tuple[first:bool, last:bool, node:PNode, name:string]
type ArgumentType * = tuple[isPtr:bool, typ:string]


#_________________________________________________
# Function Calls
#_____________________________
proc getName *(code :PNode; indent :int= 0) :string=
  assert code.kind in [nkCall, nkCommand]
  code[Elem.Symbol].strValue

proc getArgCount *(code :PNode) :int=
  assert code.kind in [nkCall, nkCommand]
  if code.sons.len < 2: return 0
  assert code[Elem.Arg1].kind in nkCharLit..nkNilLit or code[Elem.Arg1].kind == nkIdent, code.treeRepr & "\n" & code.renderTree
  for id,child in code.pairs:
    if id == 0: continue  # First parameter is always the function name
    result.inc

iterator args *(code :PNode) :Argument=
  ## Iterates over the Arguments of a Call node, and yields them one by one
  assert code.kind in [nkCall, nkCommand]
  let argc = code.getArgCount()
  for id in 0..argc:
    if id == Elem.Symbol: continue # First entry is always the function name
    let arg = code[id]
    if arg.kind notin nkCharLit..nkNilLit and arg.kind != nkIdent: raise newException(CallsError,
      &"Declaring non-literal or non-identifier arguments for function calls is currently not supported.\nIts tree is:\n{arg.treeRepr}\nIts code is:\n{arg.renderTree}\n")
    let name =
      if   arg.kind == nkIdent:  arg.strValue
      elif arg.kind == nkNilLit: "NULL"
      elif arg.kind in nkCharLit..nkTripleStrLit: arg.strValue
      else: arg.sons[0..^2].mapIt( # Names of all entries in this arg, without the value(^1) or the type(^2)
        if it.kind == nkPtrTy : it[0].strValue # ptr MyType
        else                  : it.strValue    # MyType
        ).join(" ")
    yield (first : id == Elem.Arg1,
           last  : id == argc,
           node  : arg,
           name  : name )

