#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps std
import std/strformat
# @deps *Slate
import ./types
import ./nimc as nim
import ./cfg
import ./tools


#_______________________________________
# @section Node Access: Error Management
#_____________________________
const echo = debugEcho
const DefaultErrorMsg = "Something went wrong."
#___________________
func err *(msg :string; pfx :string= cfg.Prefix) :void= raise newException(NodeAccessError, pfx&msg)
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}
proc err *(code :PNode; msg :string; pfx :string= cfg.Prefix) :void= err &"\n{code.treeRepr}\n{code.renderTree}\n{pfx}{msg}", pfx=""
  ## @descr Raises a {@link NodeAccessError} with a formatted {@arg msg}, with debugging information about the {@arg code}
proc err *(
    code : PNode;
    excp : typedesc[CatchableError];
    msg  : string;
    pfx  : string = cfg.Prefix;
  ) :void= raise newException( excp, &"\n{code.treeRepr}\n{code.renderTree}\n{pfx}{msg}" )
  ## @descr Raises the {@arg excp} with a formatted {@arg msg} and debugging information about the {@arg code}
#___________________
func check *(
    code : PNode;
    args : varargs[TNodeKind];
  ) :bool {.discardable.}=
  for kind in args:
    if code.kind == kind: return true
#___________________
func check *(
    code : PNode;
    list : set[TNodeKind];
  ) :bool {.discardable.}=
  for kind in list:
    if code.kind == kind: return true
#___________________
proc ensure *(
    code : PNode;
    args : varargs[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} kinds match the {@link TNodeKind} of {@arg code}
  if check(code, args): return true
  code.err msg&cfg.Sep&fmt"Node {code.kind} is not of type:  {args}."
#___________________
proc ensure *(
    code : PNode;
    list : set[TNodeKind];
    msg  : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  if check(code, list): return true
  code.err msg&cfg.Sep&fmt"Node {code.kind} is not of type:  {list}."
#___________________
proc ensure *(
    code  : PNode;
    kinds : varargs[Kind];
    msg   : string = DefaultErrorMsg,
  ) :bool {.discardable.}=
  ## @descr Raises a {@link NodeAccessError} when none of the {@arg args} {@link Kind}s match the {@link TNodeKind} of {@arg code}.
  for kind in kinds:
    case kind
    of Module:
      if check(code, nkIncludeStmt, nkImportStmt): return true else: continue
    of Proc:
      if check(code, nkProcDef): return true else: continue
    of Func:
      if check(code, nkFuncDef): return true else: continue
    of Return:
      if check(code, nkReturnStmt): return true else: continue
    of Call:
      if check(code, nim.SomeCall): return true else: continue
    of Const:
      if check(code, nkConstSection, nkConstDef): return true else: continue
    of Let:
      if check(code, nkLetSection, nkIdentDefs): return true else: continue
    of Var:
      if check(code, nkVarSection, nkIdentDefs): return true else: continue
    of Asgn:
      if check(code, nkAsgn): return true else: continue
    of Literal:
      if check(code, nim.SomeLit): return true else: continue
    of RawStr:
      if check(code, nkCallStrLit): return true else: continue
    of Pragma:
      if check(code, nkPragma): return true else: continue
    else: code.err &"Tried to access an unmapped Node kind:  {kind}"
  code.err msg&cfg.Sep&fmt"Node {code.kind} is not a valid kind:  {kinds}."
#___________________
proc ensure *(code :PNode; field :string) :void=  ensure code, field.toKind

