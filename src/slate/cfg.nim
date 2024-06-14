#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
## @fileoverview Slate Configuration

#_______________________________________
# @section CLI formatting
const Sep    *{.strdefine.}= "  "
const Prefix *{.strdefine.}= "*Slate" & Sep # TODO: Change functions to take 2 formatting parameters

#_______________________________________
# @section Syntax Rules: Keywords
const Keyword_DoWhile *{.strdefine.}= "doWhile"
  ## @descr Keyword searched to figure out if a SpecialCall can be considered a `doWhile` block

