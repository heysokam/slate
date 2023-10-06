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
type TypeInfo * = object
  isPtr   *:bool
  isPriv  *:bool
  isRead  *:bool
  isObj   *:bool
  name    *:string


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
proc getType *(code :PNode; allowedMultiwords :openArray[string]= @[]) :TypeInfo=
  assert code.kind == nkTypeDef
  result.isPtr  = code[Elem.Type].kind == nkPtrTy
  result.isObj  = code[Elem.Type].kind == nkObjectTy
  result.isRead = code[Elem.Symbol].kind == nkPragmaExpr
  result.isPriv =
    if result.isRead : types.isPrivate(code[0])
    else             : types.isPrivate(code)
  if code[Elem.Type].kind == nkCommand: assert code[Elem.Type][0].strValue in allowedMultiwords,
    &"Failed to identify the TypeName of a multiword type node. Its tree is:\n{code.treeRepr}"
  result.name =
    if   result.isPtr                    : code[Elem.Type][0].strValue  # ptr case
    elif code[Elem.Type].kind == nkIdent : code[Elem.Type].strValue     # single type case
    # 2x worded type case
    elif code[Elem.Type].kind == nkCommand and code[Elem.Type][1].kind == nkIdent:
      code[Elem.Type][0].strValue & " " & code[Elem.Type][1].strValue
    # 3x worded type case
    elif code[Elem.Type].kind == nkCommand and code[Elem.Type][1].kind == nkCommand and code[Elem.Type][1][1].kind == nkIdent:
      code[Elem.Type][0].strValue & " " & code[Elem.Type][1][0].strValue & " " & code[Elem.Type][1][1].strValue
    # 4x worded type case
    elif code[Elem.Type].kind == nkCommand and code[Elem.Type][1].kind == nkCommand and code[Elem.Type][1][1].kind == nkCommand and code[Elem.Type][1][1][1].kind == nkIdent:
      code[Elem.Type][0].strValue & " " & code[Elem.Type][1][0].strValue & " " & code[Elem.Type][1][1][0].strValue  & " " & code[Elem.Type][1][1][1].strValue
    else:""
  if result.isObj: result.name = SlateObject
  assert result.name != "", &"Failed to identify the TypeName of a type node. Its tree is:\n{code.treeRepr}"

