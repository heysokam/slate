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
  try L.add_single(switch(L.ch()) {
    '(' => Lx.Id.paren_L,
    ')' => Lx.Id.paren_R,
    else => |char| return Lex.fail(error.slate_lex_UnknownParenthesis, "Unknown Paren character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `{` or `}` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn brace (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '{' => Lx.Id.brace_L,
    '}' => Lx.Id.brace_R,
    else => |char| return Lex.fail(error.slate_lex_UnknownBrace, "Unknown Brace character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `[` or `]` characte[ into a Lexeme, and adds it to the {@arg L.res} result.
pub fn bracket (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '[' => Lx.Id.bracket_L,
    ']' => Lx.Id.bracket_R,
    else => |char| return Lex.fail(error.slate_lex_UnknownBracket, "Unknown Bracket character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `=` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn eq (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '=' => Lx.Id.eq,
    else => |char| return Lex.fail(error.slate_lex_UnknownEq, "Unknown Equal character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `@` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn at (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '@' => Lx.Id.at,
    else => |char| return Lex.fail(error.slate_lex_UnknownAt, "Unknown At @ character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `*` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn star (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '*' => Lx.Id.star,
    else => |char| return Lex.fail(error.slate_lex_UnknownStar, "Unknown Star/Asterisk character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `:` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn colon (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    ':' => Lx.Id.colon,
    else => |char| return Lex.fail(error.slate_lex_UnknownColon, "Unknown Colon character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `;` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn semicolon (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    ';' => Lx.Id.semicolon,
    else => |char| return Lex.fail(error.slate_lex_UnknownSemicolon, "Unknown Semicolon character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `.` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn dot (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '.' => Lx.Id.dot,
    else => |char| return Lex.fail(error.slate_lex_UnknownDot, "Unknown Dot character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `,` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn comma (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    ',' => Lx.Id.comma,
    else => |char| return Lex.fail(error.slate_lex_UnknownComma, "Unknown Comma character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `#` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn hash (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '#' => Lx.Id.hash,
    else => |char| return Lex.fail(error.slate_lex_UnknownHash, "Unknown Hash character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `'` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_S (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '\'' => Lx.Id.quote_S,
    else => |char| return Lex.fail(error.slate_lex_UnknownQuoteSingle, "Unknown Single Quote character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single `"` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_D (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '"' => Lx.Id.quote_D,
    else => |char| return Lex.fail(error.slate_lex_UnknownQuoteDouble, "Unknown Double Quote character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single '`' character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn quote_B (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '`' => Lx.Id.quote_B,
    else => |char| return Lex.fail(error.slate_lex_UnknownQuoteBacktick, "Unknown Backtick Quote character '{c}' (0x{X})", .{char, char})
  });
}
//__________________________
/// @descr Processes a single '/' character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn slash_F (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '/' => Lx.Id.slash_F,
    else => |char| return Lex.fail(error.slate_lex_UnknownSlashForward, "Unknown Forward Slash character '{c}' (0x{X})", .{char, char})
  });
}

//__________________________
/// @descr Processes a single '\' character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn slash_B (L:*Lex) !void {
  try L.add_single(switch(L.ch()) {
    '\\' => Lx.Id.slash_B,
    else => |char| return Lex.fail(error.slate_lex_UnknownSlashBackward, "Unknown Backward Slash character '{c}' (0x{X})", .{char, char})
  });
}

