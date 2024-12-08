//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Cable Connector to all tests of the library
//____________________________________________________________|
test {
  @import("std").testing.refAllDecls(@This());
  _= @import("slate/char.test.zig");
  _= @import("slate/gen.test.zig");
  _= @import("slate/lexer.test.zig");
  _= @import("slate/source.test.zig");
  _= @import("slate/elements.test.zig");
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
