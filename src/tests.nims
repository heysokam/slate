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
//! @fileoverview Unit Tests for {trg_relative}
//____________________________________________________________|
"""
const Tools = """

//______________________________________
// @section Helper Tools for tests files
//____________________________
const t = @This();
pub const cstr = []const u8;
pub const ok   = @import("std").testing.expect;
pub const info = @import("std").debug.print;
const Prefix = "[slate.test] ";
pub fn fail   (comptime fmt :cstr, args :anytype) !void {{ t.info(t.Prefix ++ "| FAIL | " ++ fmt, args); return error.slate_FailedTest; }}
pub fn echo   (msg :cstr) void {{ @import("std").debug.print("{{s}}\n", .{{msg}}); }}
pub fn eq     (result :anytype, expected :anytype) !void {{ try @import("std").testing.expectEqual(expected, result); }}
pub fn eq_str (result :anytype, expected :anytype) !void {{ try @import("std").testing.expectEqualStrings(expected, result); }}
"""
const DummyTest = """
test "[TODO]"
{{ @import("std").debug.print("[slate.tests] TODO: {trg_relative} has no tests.\n", .{{}}); }}
"""
const Imports = """

//______________________________________
// @section List of Tests
//____________________________
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
    # Find the target names for the file
    let trg          = file.replace(Extension_zig, Extension_test)
    let trg_relative = trg.replace("./src/", "").replace("src/", "")
    # Generate the import for the test connector
    result.add( fmt "  _= @import(\"{trg_relative}\");\n" )
    # Generate the file
    if fileExists trg: continue
    trg.writeFile fmt( license & overview_file & DummyTest )

  #_______________________________________
  # Generate the test file connector
  tests.writeFile fmt( license & overview_tests & Tools & Imports )

  #_______________________________________
  # Run the resulting tests
  exec runner&tests

