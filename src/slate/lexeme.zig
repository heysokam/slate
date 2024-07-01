//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Lexeme.
//! @out From the lexing process.
//! @in For the Tokenizer process of the target language.
//________________________________________________________|
pub const Lx = @This();
// @deps zstd
const zstd = @import("../zstd.zig");
const ByteBuffer = zstd.ByteBuffer;

/// @field {@link Lx.id} The Id of the Lexeme
id   :Id,
/// @field {@link Lx.val} The string value of the Lexeme
val  :ByteBuffer,

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

