#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# *Slate dependencies
import ../nimc

#_______________________________________
type AffixKind * = enum Prefix, Infix, Postfix
type Affix * = object
  kind  *:AffixKind
  fix   *:string
  left  *:string
  right *:string

#_______________________________________
proc getPrefix *(code :PNode) :Affix=
  assert code.kind == nkPrefix and code[1].kind != nkEmpty
  result = Affix(
    kind  : Prefix,
    fix   : code[0].strValue,
    right : code[1].strValue,
    )
#_______________________________________
proc getSideString *(side :PNode) :string=
  # TODO: Probably remove
  case side.kind
  of nkEmpty : ""
  of nkInfix : &"{side[1].getSideString()} {side[0].strValue} {side[2].getSideString()}"
  else       : side.strValue

proc getInfix *(code :PNode) :Affix=
  assert code.kind == nkInfix
  result = Affix(
    kind  : Infix,
    fix   : code[0].strValue,
    left  : code[1].renderTree,
    right : code[2].renderTree    )
#_______________________________________
proc getPostfix *(code :PNode) :Affix=
  ## WARNING: Nim parser interprets no postfixes, other than `*` for visibility
  ## https://nim-lang.org/docs/macros.html#callsslashexpressions-postfix-operator-call
  assert code.kind == nkPostfix and code[1].kind != nkEmpty
  result = Affix(
    kind  : Postfix,
    fix   : code[0].strValue,
    left  : code[1].strValue,
    )
