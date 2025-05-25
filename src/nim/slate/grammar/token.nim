#:______________________________________________________________________
#  grammar  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________

type Id *{.pure.} = enum ident, Char
type List * = seq[token.Id]

