//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer: State/Data Management
//_____________________________________________|
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;


//__________________________
/// @descr Returns the character located in the current position of the buffer
pub fn ch (L:*Lex) u8 { return L.buf.items[L.pos]; }

pub const append = struct {
  //__________________________
  /// @descr Adds a single character to the last lexeme of the {@arg L.res} Lexer result.
  pub fn toLast (L:*Lex, C :u8) !void {
    const id = L.res.len-1;
    try L.res.items(.val)[id].append(C);
  }
  //__________________________
  /// @descr Adds a single {@arg Lx} lexeme with {@arg id} to the result, and appends a single character into its {@arg Lx.val} field.
  pub fn single (L:*Lex, id :Lx.Id) !void {
    try L.res.append(L.A, Lx{
      .id  = id,
      .val = zstd.ByteBuffer.init(L.A),
    });
    try append.toLast(L, L.ch());
  }
};

