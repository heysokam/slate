#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
# @deps *Slate
import ../nimc as nim

#_______________________________________
# @section Statement List
#_____________________________
proc get *(code :PNode; id :SomeInteger) :PNode=  code[id]

