#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
type Code * = string
type Pos  * = range[0'u..uint.high]
type Loc  * = object
  start  *:source.Pos
  End    *:source.Pos

