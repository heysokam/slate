//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer Process: Whitespace
//__________________________________________|
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;


//__________________________
/// @descr Processes a single ` ` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn space (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    ' ' => Lx.Id.space,
    else => |char| return Lex.fail(error.slate_lex_UnknownSpace, "Unknown Space character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `\n` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn newline (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '\n' => Lx.Id.newline,
    else => |char| return Lex.fail(error.slate_lex_UnknownNewline, "Unknown NewLine character '{c}' (0x{X})", .{char, char})
  });
}

