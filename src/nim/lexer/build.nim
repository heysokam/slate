#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import confy
import ./info

let lex = Program.new("entry.nim",
  trg     = "lex",
  version = version(info.version)
  ).build().run()

