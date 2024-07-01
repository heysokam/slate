#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
# @deps *Slate
import ../nimc as nim

#_______________________________________
# @section Statement List
#_____________________________
proc get *(code :PNode; id :SomeInteger) :PNode=  code[id]

