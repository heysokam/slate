#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
type Code * = string
type Pos  * = range[0'u..uint.high]
type Loc  * = object
  start  *:source.Pos
  End    *:source.Pos
func From *(loc :source.Loc; src :source.Code) :string=  src[loc.start..loc.End]
func add *(A :var source.Loc; B :source.Loc) :void=  A.End = B.End
  ## @warning Assumes A and B are adjacent
