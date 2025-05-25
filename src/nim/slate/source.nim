#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
type Code * = string
type Pos  * = range[0'u..uint.high]
type Loc  * = object
  start  *:source.Pos
  End    *:source.Pos

