//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Cable Connector to all tests of the library
//____________________________________________________________|

//______________________________________
// @section Helper Tools for tests files
//____________________________
const t = @This();
pub const cstr = []const u8;
pub const ok   = @import("std").testing.expect;
pub const info = @import("std").debug.print;
const Prefix = "[slate.test] ";
pub fn fail (comptime fmt :cstr, args :anytype) !void { t.info(t.Prefix ++ "| FAIL | " ++ fmt, args); return error.slate_FailedTest; }
pub fn echo (msg :cstr) void { @import("std").debug.print("{s}\n", .{msg}); }
pub fn eq   (result :anytype, expected :anytype) !void { try @import("std").testing.expectEqual(expected, result); }

//______________________________________
// @section List of Tests
//____________________________
test {
  @import("std").testing.refAllDecls(@This());
  _= @import("slate/gen.test.zig");
  _= @import("slate/lexer.test.zig");
  _= @import("slate/source.test.zig");
  _= @import("slate/elements.test.zig");
  _= @import("slate/char.test.zig");
  _= @import("slate/element/ident.test.zig");
  _= @import("slate/element/expression.test.zig");
  _= @import("slate/element/data.test.zig");
  _= @import("slate/element/statement.test.zig");
  _= @import("slate/element/pragma.test.zig");
  _= @import("slate/element/type.test.zig");
  _= @import("slate/element/node.test.zig");
  _= @import("slate/element/proc.test.zig");
  _= @import("slate/element/root.test.zig");
  _= @import("slate/lex/symbols.test.zig");
  _= @import("slate/lex/whitespace.test.zig");
  _= @import("slate/lex/cli.test.zig");
  _= @import("slate/lex/others.test.zig");
  _= @import("slate/lex/data.test.zig");
  _= @import("slate/lex/lexeme.test.zig");
  _= @import("slate/gen/zig.test.zig");
  _= @import("slate/gen/minim.test.zig");
  _= @import("slate/gen/base.test.zig");
  _= @import("slate/gen/C.test.zig");
  _= @import("slate/gen/C/proc.test.zig");
}
