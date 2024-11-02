//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer Process: Symbols
//_______________________________________|
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;


//__________________________
/// @descr Processes a single `(` or `)` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn paren (L:*Lex) !void {
  const id = switch(L.ch()) {
    '(' => Lx.Id.paren_L,
    ')' => Lx.Id.paren_R,
    else => |char| Lex.fail("Unknown Paren character '{c}' (0x{X})", .{char, char})
  };
  try L.add_single(id);
}
//__________________________
/// @descr Processes a single `{` or `}` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn brace (L:*Lex) !void {
  const id = switch(L.ch()) {
    '{' => Lx.Id.brace_L,
    '}' => Lx.Id.brace_R,
    else => |char| Lex.fail("Unknown Brace character '{c}' (0x{X})", .{char, char})
  };
  try L.add_single(id);
}
//__________________________
/// @descr Processes a single `[` or `]` characte[ into a Lexeme, and adds it to the {@arg L.res} result.
pub fn bracket (L:*Lex) !void {
  const id = switch(L.ch()) {
    '[' => Lx.Id.bracket_L,
    ']' => Lx.Id.bracket_R,
    else => |char| Lex.fail("Unknown Bracket character '{c}' (0x{X})", .{char, char})
  };
  try L.add_single(id);
}
//__________________________
/// @descr Processes a single `=` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn eq (L:*Lex) !void { try L.add_single(Lx.Id.eq); }
//__________________________
/// @descr Processes a single `@` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn at (L:*Lex) !void { try L.add_single(Lx.Id.at); }
//__________________________
/// @descr Processes a single `*` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn star (L:*Lex) !void { try L.add_single(Lx.Id.star); }
//__________________________
/// @descr Processes a single `:` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn colon (L:*Lex) !void { try L.add_single(Lx.Id.colon); }
//__________________________
/// @descr Processes a single `;` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn semicolon (L:*Lex) !void { try L.add_single(Lx.Id.semicolon); }
//__________________________
/// @descr Processes a single `.` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn dot (L:*Lex) !void { try L.add_single(Lx.Id.dot); }
//__________________________
/// @descr Processes a single `,` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn comma (L:*Lex) !void { try L.add_single(Lx.Id.comma); }
//__________________________
/// @descr Processes a single `#` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn hash (L:*Lex) !void { try L.add_single(Lx.Id.hash); }
//__________________________
/// @descr Processes a single `'` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_S (L:*Lex) !void { try L.add_single(Lx.Id.quote_S); }
//__________________________
/// @descr Processes a single `"` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_D (L:*Lex) !void { try L.add_single(Lx.Id.quote_D); }
//__________________________
/// @descr Processes a single '`' character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_B (L:*Lex) !void { try L.add_single(Lx.Id.quote_B); }

