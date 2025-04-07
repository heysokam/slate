
#[
import std/macros
macro grammar *(lang :static[string]; body :untyped)=
  body.expectKind nnkStmtList
  echo `lang`
  dumptree: body

func macroTest=
  grammar "minim":
  # dumpTree:
    numeric        =
      digit        |
      digitLetters |
      underscore
]#

