#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# std dependencies
import std/strformat
# nimc dependencies
import ../nimc
# Element dependencies
import ./base
import ./error


type Elem *{.pure.}= enum Symbol, Generics, Type
converter toInt *(d :Elem) :int= d.ord
type TypeInfo * = tuple[isPtr:bool, isPriv:bool, isRead:bool, name:string]


#_________________________________________________
# Properties
#_____________________________
proc isPrivate *(code :PNode) :bool=
  assert code.kind in [nkTypeDef, nkPragmaExpr], code.treeRepr
  result = base.isPrivate(code[Elem.Symbol], 0, TypeDefError)


#_________________________________________________
# General
#_____________________________
proc getName *(code :PNode) :string=
  assert code.kind == nkTypeDef
  let sym = code[Elem.Symbol] 
  result =
    if   sym.kind == nkPragmaExpr : sym[0][^1].strValue
    elif sym.kind == nkPostFix    : sym[^1].strValue
    elif sym.kind == nkIdent      : sym.strValue
    else:""
  assert result != "", &"Failed to identify the name of a type node. Its tree is:\n{code.treeRepr}"
#_____________________________
proc getType *(code :PNode) :TypeInfo=
  assert code.kind == nkTypeDef
  result.isPtr  = code[Elem.Type].kind == nkPtrTy
  result.isRead = code[Elem.Symbol].kind == nkPragmaExpr
  result.isPriv =
    if result.isRead : types.isPrivate(code[0])
    else             : types.isPrivate(code)
  result.name =
    if   result.isPtr                    : code[Elem.Type][0].strValue
    elif code[Elem.Type].kind == nkIdent : code[Elem.Type].strValue
    else:""
  assert result.name != "", &"Failed to identify the TypeName of a type node. Its tree is:\n{code.treeRepr}"

