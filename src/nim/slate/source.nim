#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________


#_______________________________________
# @section Source Code
#_____________________________
type Code * = string


#_______________________________________
# @section Position
#_____________________________
type Pos * = range[0'u..uint.high]
template none *(_:typedesc[source.Pos]) :source.Pos=  source.Pos.high


#_______________________________________
# @section Location
#_____________________________
type Loc  * = object
  start  *:source.Pos=  source.Pos.none()
  End    *:source.Pos=  source.Pos.none()
func From *(loc :source.Loc; src :source.Code) :string=  src[loc.start..loc.End]
func add *(A :var source.Loc; B :source.Loc) :void=  A.End = B.End
  ## @warning Assumes A and B are adjacent

