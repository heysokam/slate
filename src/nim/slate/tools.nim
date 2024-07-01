#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
## @fileoverview General tools used by *Slate
#______________________________________________|
# @deps *Slate
import ./types


#_______________________________________
# @section Type Tools
#_____________________________
func toKind *(name :string) :Kind=
  ## @descr
  ##  Converts the given {@arg name} into a known slate.Kind
  ##  Raises a {@link NodeAccessError} when {@arg name} is not mapped to a kind
  case name
  of "empty"            : result = Kind.Empty
  of "proc","procedure" : result = Kind.Proc
  of "func","function"  : result = Kind.Func
  of "var"              : result = Kind.Var
  of "let"              : result = Kind.Let
  of "const"            : result = Kind.Const
  of "assign"           : result = Kind.Asgn
  of "literal"          : result = Kind.Literal
  of "return"           : result = Kind.Return
  of "include","import" : result = Kind.Module
  else: raise newException(KindError, "Tried to access and unmapped Node Kind:  " & name)

