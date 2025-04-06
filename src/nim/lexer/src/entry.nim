#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps Lex
import ./chars
import ./lex

proc run(_:void):void=
  const tst = "proc main *() :i32= return 0"
  const all = Ch.toString(Ch.ascii)
  # echo all
  var L = Lex.create(tst)
  L.process()
  echo "................\n", L.res

  L = Lex.create(all)
  L.process()
  echo "................\n", L.res

  L.destroy()

when isMainModule: run()
