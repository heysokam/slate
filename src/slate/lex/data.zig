//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer: State/Data Management
//_____________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;
const Lx  = @import("./lexeme.zig").Lx;


//__________________________
/// @descr Returns the character located in the current position of the buffer
pub fn ch (L:*Lex) u8 { return L.src[L.pos]; }

pub const add = struct {
  //__________________________
  /// @descr Increments the end position of the last lexeme of {@arg L.res} by a single character.
  /// @note Ensures that the character is equal to {@arg C} on safe builds.
  pub fn toLast (L:*Lex, C :u8) void {
    const items :[]Lex.Loc= L.res.items(.loc);
    const last  :Lex.Pos=   @intCast(L.res.len-1);
    items[last].end += 1;
    zstd.ensure(L.src[items[last].end] == C, "Tried to append a character to the last Lexeme of a Lexer, but the characters do not match.");
  } //:: Lex.add.toLast
  //__________________________
  /// @descr
  ///  Adds one {@arg Lx} lexeme with {@arg id} to the result.
  ///  Defines its location to point to the (start,end) location of {@arg Lex.src}.
  pub inline fn one (L:*Lex, id :Lx.Id, start :Lex.Pos, end :Lex.Pos) !void {
    try L.res.append(L.A, Lx.create(id, start, end));
  } //:: Lex.add.one

  //__________________________
  /// @descr
  ///  Adds a single {@arg Lx} lexeme with {@arg id} to the result.
  ///  Defines its location to point to a single character of {@arg Lex.src} located at {@arg L.pos}.
  pub inline fn single (L:*Lex, id :Lx.Id) !void {
    try add.one(L, id, L.pos, L.pos);
  } //:: Lex.add.single
}; //:: Lex.add

