//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer Process: Identifiers & Literals
//______________________________________________________|
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Ch  = @import("../char.zig");
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;

//__________________________
/// @descr Processes an identifier into a Lexeme, and adds it to the {@arg L.res} result.
pub fn ident (L:*Lex) !void {
  const start = L.pos;
  var   end   = L.pos;
  while (true) : (L.pos += 1) {
    const c = L.ch();
    if      (Ch.isIdent(c))         { end +|= 1; }
    else if (Ch.isContextChange(c)) { end -|= 1; break; }
    else                            { return Lex.fail(error.slate_lex_UnknownIdentifier, "Unknown Identifier character '{c}' (0x{X})", .{c, c}); }
  }
  try L.add(Lx.Id.ident, start, end);
  L.pos = end;
}

//__________________________
/// @descr Processes a number into a Lexeme, and adds it to the {@arg L.res} result.
pub fn number (L:*Lex) !void {
  const start = L.pos;
  var   end   = L.pos;
  while (true) : (L.pos += 1) {
    const c = L.ch();
    if      (Ch.isNumeric(c))       { end +|= 1; }
    else if (Ch.isContextChange(c)) { end -|= 1; break; }
    else                            { return Lex.fail(error.slate_lex_UnknownNumber, "Unknown Numeric character '{c}' (0x{X})", .{c, c}); }
  }
  try L.add(Lx.Id.number, start, end);
  L.pos = end;
}

