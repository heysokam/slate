#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# Base module used by all of the *Slate elements  |
#_________________________________________________|
import ../nimc

#_____________________________
# Node aliases
const SomeStrLit   * = {nkStrLit..nkTripleStrLit}
const SomeValueLit * = SomeStrLit   + {nkCharLit..nkFloat128Lit} ## Matches any value-based literal (without nil)
const SomeLit      * = SomeValueLit + {nkNilLit}                 ## Matches any literal (including nil)
#_____________________________
# Other types+aliases
const SlateObject  * = "__SlateObject__"  ## Placeholder TypeName for objects

#_____________________________
proc isPrivate *(sym :PNode; indent :int; err :typedesc[CatchableError]) :bool=
  ## Returns true if the given symbol is found to be private (aka doesn't have * in its postfix)
  if indent > 0: return false
  assert sym.kind in {nkIdent,nkPostfix}
  case sym.kind
  of nkIdent   : result = true
  of nkPostfix : result = sym[0].strValue != "*"
  else: raise newException(err, &"Tried to get find if symbol is private, but it has an unknown format.\n  {sym.kind}\n")

#_____________________________
proc getDotExprRec (code :PNode; idents :var seq[PNode]) :void=
  ## Recursive add ident nodes from a dotExpr, based on the given node.
  if code.kind == nkDotExpr:
    assert code[^1].kind == nkIdent
    idents.add code[^1]
    base.getDotExprRec(code[0], idents)
  elif code.kind == nkIdent:
    idents.add code
  else: assert false, code.treeRepr
#_____________________________
iterator dotExpr *(code :PNode) :PNode=
  ## Yields every node entry of a given dotExpr node
  assert code.kind == nkDotExpr, "The dotExpr iterator only accepts nkDotExpr nodes. The incorrect node is:\n  {sym.kind}\n"
  var idents :seq[PNode]
  base.getDotExprRec(code, idents)
  for id in countdown(idents.high, idents.low): yield idents[id]

