#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
# @deps std
import std/strutils

#_______________________________________
const Sep * = ". "
const Spc * = " "
#_______________________________________
func `*` *(ident :int; tab :string) :string=
  ## Returns the given `tab` string concatenated `ident` times
  for id in 0..<ident: result.add tab
#_______________________________________
func firstUpper *(s :string) :string=  result = s; result[0] = result[0].toUpperAscii()
  ## Returns the string with its first character converted to Uppercase

