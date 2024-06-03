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
# proc getName *(code :PNode; indent :int= 0) :string=
#   assert code.kind in [nkCall, nkCommand]
#   code[Elem.Symbol].strValue

const ValidCallArgs = SomeLit+{nkIdent, nkCall, nkCommand, nkInfix, nkCast, nkObjConstr, nkDotExpr, nkBracketExpr, nkIfExpr}
# proc getArgCount *(code :PNode) :int=
#   assert code.kind in [nkCall, nkCommand]
#   if code.sons.len < 2: return 0
#   assert code[Elem.Arg1].kind in ValidCallArgs,
#     &"\n{code.treeRepr}\n{code.renderTree}\n"
#   for id,child in code.pairs:
#     if id == 0: continue  # First parameter is always the function name
#     result.inc

proc getInfixValue (arg :PNode) :string=
  proc getSideValue (side :PNode) :string=
    case side.kind
    of nkInfix               : result = side.getInfixValue()
    of nkIdent, SomeValueLit : result = side.strValue
    of nkCall, nkCommand     : result = side.renderTree
    of nkBracketExpr         : result = side.renderTree
    of nkDotExpr             : result = base.dotExpr(side).toSeq.mapIt(it.strValue).join(".")
    else                     : raise newException(CallsError,
      &"Failed to find the code for an InfixValue side.\nIts tree is:\n{side.treeRepr}\nIts code is:\n{side.renderTree}\n")
  &"{arg[1].getSideValue()} {arg[0].strValue} {arg[2].getSideValue()}"

iterator args *(code :PNode) :Argument=
  ## Iterates over the Arguments of a Call node, and yields them one by one
  assert code.kind in [nkCall, nkCommand]
  let argc = code.getArgCount()
  for id in 0..argc:
    if id == Elem.Symbol: continue # First entry is always the function name
    let arg = code[id]
    if arg.kind notin ValidCallArgs: raise newException(CallsError,
      &"Currently supported node types for function call arguments are {ValidCallArgs}. Found a node of a different kind.\nIts tree is:\n{arg.treeRepr}\nIts code is:\n{arg.renderTree}\n")
    # if arg.kind in [nkCall, nkCommand] and arg.len > 2: raise newException(CallsError,
    #   &"Multi-identifier command/call arguments for function calls is currently not supported.\nIts tree is:\n{arg.treeRepr}\nIts code is:\n{arg.renderTree}\n")
    let name =
      if   arg.kind == nkIdent                    : arg.strValue
      elif arg.kind == nkNilLit                   : "nil"
      elif arg.kind in SomeValueLit               : arg.strValue
      elif arg.kind in {nkCall, nkCommand}        : arg[0].renderTree
      elif arg.kind == nkInfix                    : arg.getInfixValue()
      elif arg.kind == nkObjConstr                : arg[0].renderTree
      elif arg.kind in {nkDotExpr, nkBracketExpr} : arg.renderTree
      elif arg.kind in {nkIfExpr}                 : arg.renderTree
      else: arg.sons[0..^2].mapIt( # Names of all entries in this arg, without the value(^1) or the type(^2)
        if it.kind == nkPtrTy : it[0].strValue # ptr MyType
        else                  : it.strValue    # MyType
        ).join(" ")
    yield (first : id == Elem.Arg1,
           last  : id == argc,
           node  : arg,
           name  : name )

