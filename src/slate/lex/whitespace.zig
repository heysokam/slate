//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer Process: Whitespace
//__________________________________________|
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;


//__________________________
/// @descr Processes a single ` ` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn space (L:*Lex) !void { try L.add_single(Lx.Id.space); }
//__________________________
/// @descr Processes a single `\n` character into a Lexeme, and adds it to the {@arg L.res} result.
pub fn newline (L:*Lex) !void { try L.add_single(Lx.Id.newline); }

