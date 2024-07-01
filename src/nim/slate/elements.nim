#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
## @fileoverview Cable connector to all Element modules
#_______________________________________________________|
import ./element/general   ; export general
import ./element/statement ; export statement
import ./element/procs     ; export procs
import ./element/vars      ; export vars
import ./element/pragmas   ; export pragmas
import ./element/calls     ; export calls
import ./element/affixes   ; export affixes
import ./element/types     ; export types
import ./element/arrays    ; export arrays


#_______________________________________
# @note
#  To have access to the Slate syntax rules extensions:
#  1. Compile with -d:useExtras
#  2. or import this module explicitly in the files where you need it
when defined(useExtras):
  import ./element/extras ; export extras
#_______________________________________

