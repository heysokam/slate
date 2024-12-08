#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
#! @fileoverview Generate the Unit Tests file structure of the project
#_______________________________________________________________________|
# @deps std
from std/os import walkDirRec
from std/strutils import endsWith, replace
from std/strformat import fmt

#_______________________________________
# @section Configuration
#_____________________________
const dir            = "./src/slate"
const tests          = "./src/tests.zig"
const Extension_zig  = ".zig"
const Extension_test = ".test"&Extension_zig
const runner         = "./bin/.zig/zig test -femit-bin=./bin/tests --cache-dir ./bin/.cache/zig --global-cache-dir ./bin/.cache/zig "
const license        = """
//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
"""
const overview_tests = """
//! @fileoverview Cable Connector to all tests of the library
//____________________________________________________________|
"""
const overview_file = """
//! @fileoverview Unit Tests for {trg}
//____________________________________________________________|
"""
const DummyTest = """
test "TODO: {trg_relative} has no tests"
{{ try @import("std").testing.expect(false); }}
"""
const Imports = """
test {{
  @import("std").testing.refAllDecls(@This());
{result}}}
"""


#_______________________________________
# @section Entry Point
#_____________________________
when isMainModule:
  var result :string= ""
  #_______________________________________
  # Generate the test files when they dont exist
  for file in walkDirRec dir:
    # Skip existing unwanted files
    if file.endsWith Extension_test: continue
    let trg = file.replace(Extension_zig, Extension_test)
    if fileExists trg: continue
    # Generate the file and its import
    let trg_relative = trg.replace("./src/", "").replace("src/", "")
    trg.writeFile fmt( license & overview_file & DummyTest )
    result.add( fmt "  _= @import(\"{trg_relative}\");\n" )

  #_______________________________________
  # Generate the test file connector
  tests.writeFile fmt( license & overview_tests & Imports )

  #_______________________________________
  # Run the resulting tests
  exec runner&tests

