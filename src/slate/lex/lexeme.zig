//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Lexeme.
//! @out From the lexing process.
//! @in For the Tokenizer process of the target language.
//________________________________________________________|
pub const Lx = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");

/// @field {@link Lx.id} The Id of the Lexeme
id   :Lx.Id,
/// @field {@link Lx.val} The string value of the Lexeme
val  :zstd.ByteBuffer,


pub fn create (
    I : Lx.Id,
    A : std.mem.Allocator
  ) !Lx {
  return Lx{
    .id  = I,
    .val = zstd.ByteBuffer.init(A)};
} //:: Lx.create

pub fn create_with (
    I : Lx.Id,
    V : zstd.ByteBuffer,
  ) !Lx {
  return Lx{.id= I, .val= try V.clone()};
} //:: Lx.create

pub fn destroy (L:*Lx) !void { L.val.deinit(); }


/// @descr {@link Lx.id} Valid kinds for Lexemes
pub const Id = enum {
  ident,
  number,
  colon,     // :
  eq,        // =
  star,      // *
  paren_L,   // (
  paren_R,   // )
  hash,      // #
  semicolon, // ;
  quote_S,   // '  (single quote)
  quote_D,   // "  (double quote)
  quote_B,   // `  (backtick quote)
  brace_L,   // {
  brace_R,   // }
  bracket_L, // [
  bracket_R, // ]
  dot,       // .
  comma,     // ,
  // Operators
  plus,      // +
  min,       // -
  slash,     // /
  less,      // <
  more,      // >
  at,        // @
  dollar,    // $
  tilde,     // ~
  amp,       // &
  pcnt,      // %
  pipe,      // |
  excl,      // !
  qmark,     // ?
  hat,       // ^
  bslash,    // \
  // Whitespace
  space,     // ` `
  newline,   // \n
  tab,       // \t
  ret,       // \r
};
//____________________________
/// @descr Describes a list of {@link Lx} Lexeme objects
/// @out From the Lexer process
/// @in To the Tokenizer process of the target language
pub const List = zstd.List(Lx);

