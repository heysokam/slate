#:______________________________________________________________________
#  grammar  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
import confy
import ./info

let lex = Program.new("entry.nim",
  trg     = "fuzz",
  version = version(info.version)
  ).build().run()

