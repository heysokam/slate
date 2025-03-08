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
const cstr = zstd.cstr;
// @deps *Slate
const source = @import("../source.zig").source;

/// @field {@link Lx.loc} The location (start,end) of the string value of the Lexeme in the referenced source string.
loc  :source.Loc,
/// @field {@link Lx.id} The Id of the Lexeme
id   :Lx.Id,


pub fn create2 (I :Lx.Id, L :source.Loc) Lx { return Lx{.id= I, .loc= L}; }
pub fn create  (I :Lx.Id, start :source.Pos, end :source.Pos) Lx { return Lx.create2(I, source.Loc{.start= start, .end= end}); }

pub const slice = struct {
  /// @descr Returns the string value of the Lexeme located at the {@arg L.loc} of {@arg src}.
  pub fn from (L :*const Lx, src :source.Code) source.Str { return L.loc.from(src); }
}; //:: Lx.slice
pub const from = slice.from;


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
  dash,      // -  (also called min minus)
  slash_F,   // /  (forward slash)
  less,      // <
  more,      // >
  at,        // @
  dollar,    // $
  tilde,     // ~
  amp,       // &
  pcnt,      // %
  pipe,      // |
  excl,      // !
  question,  // ?
  hat,       // ^
  slash_B,   // \  (backward slash)
  // Whitespace
  space,     // ` `
  newline,   // \n
  tab,       // \t
  ret,       // \r
  EOF,       // 0x0  (the null character 0 is treated as an EOF marker)
};
//____________________________
/// @descr Describes a list of {@link Lx} Lexeme objects
/// @out From the Lexer process
/// @in To the Tokenizer process of the target language
pub const List = zstd.List(Lx);

