#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps slate.nimc
import ../nimc
# @deps slate.element
import ./base
import ./error


#_________________________________________________
# @section Named Access
#_____________________________
# Types
type Elem *{.pure.}= enum Symbol, Generics, Type
converter toInt *(d :Elem) :int= d.ord
#_____________________________
# Properties
proc isTypeKind  (code :PNode; kind :TNodeKind) :bool=  code[Elem.Type].kind == kind
proc isProc     *(code :PNode) :bool=  code.isTypeKind(nkProcTy)
proc isPtr      *(code :PNode) :bool=  code.isTypeKind(nkPtrTy)
proc isObj      *(code :PNode) :bool=  code.isTypeKind(nkObjectTy)
proc isArr      *(code :PNode) :bool=  code.kind == nkIdentDefs and code[1].kind == nkBracketExpr and code[1][0].strValue == "array"
proc isReadonly *(code :PNode) :bool=  code[Elem.Symbol].kind == nkPragmaExpr  # TODO: Shouldn't be hardcoded to a pragma!
proc isPrivate *(code :PNode) :bool=
  assert code.kind in {nkTypeDef, nkIdentDefs, nkPragmaExpr}, &"\n{code.treeRepr}"
  result = base.isPrivate(code[Elem.Symbol], 0, TypeDefError)
proc isPriv *(code :PNode) :bool=
    if code.isReadonly : types.isPrivate(code[0])
    else               : types.isPrivate(code)
#_____________________________
# Members
# proc name (code :PNode) :string=
#   assert code.kind in {nkTypeDef,nkIdentDefs}, &"\n{code.treeRepr}"
#___________________
proc procRetT  *(code :PNode) :PNode=
  # Alias for un-confusing property access
  const Params     = 0
  const ReturnType = 0
  # Error check
  assert code[Elem.Type].kind == nkProcTy
  assert code[Elem.Type][Params].kind == nkFormalParams
  assert code[Elem.Type][Params][ReturnType].kind == nkIdent
  # Return the result
  result = code[Elem.Type][Params][ReturnType]
#___________________
proc procArgs *(code :PNode) :seq[PNode]=
  # Alias for un-confusing property access
  const Params     = 0
  const ReturnType = 0
  # Error check
  assert code[Elem.Type].kind == nkProcTy
  # Return the result
  for id,arg in code[Elem.Type][Params].pairs:
    if id == ReturnType: continue
    result.add arg


#_________________________________________________
# Types
#_____________________________
type TypeInfo * = object
  isPtr   *:bool
  isPriv  *:bool
  isRead  *:bool
  isObj   *:bool
  isArr   *:bool
  isProc  *:bool
  name    *:string


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
  assert code.kind in {nkTypeDef,nkIdentDefs}, &"\n{code.treeRepr}"
  result.isPtr  = code.isPtr
  result.isObj  = code.isObj
  result.isArr  = code.isArr
  result.isRead = code.isReadonly
  result.isProc = code.isProc
  result.isPriv =
    if result.isRead : types.isPrivate(code[0])
    else             : types.isPrivate(code)
  if code[Elem.Type].kind == nkCommand: assert code[Elem.Type][0].strValue in allowedMultiwords,
    &"Failed to identify the TypeName of a multiword type node. Its tree is:\n{code.treeRepr}"
  result.name =
    if   result.isPtr                    : code[Elem.Type][0].strValue  # ptr case
    elif result.isArr                    : code[0].renderTree
    elif result.isProc                   : code[2].renderTree
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

