//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer: State/Data Management
//_____________________________________________|
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;


pub fn report (L:*Lex) void {
  Lex.prnt("--- slate.Lexer ---\n", .{});
  for (L.res.items(.id), L.res.items(.loc), 0..) |lx, loc, id| {
    Lex.prnt("{d:0>2}: {s} : `{s}`\n", .{id, @tagName(lx), loc.from(L.src)});
  }
  Lex.prnt("-------------------\n", .{});
}

pub fn autogen (L:*Lex) void {
  Lex.prnt("--- slate.Lexer ---\n", .{});
  for (L.res.items(.id), L.res.items(.loc), 0..) |lx, loc, id| {
    Lex.prnt("slate.Lx{{.id= .{s}, .loc= slate.source.Loc{{.start= {d:>3}, .end= {d:>3} }}}}, // {d}: `{s}`\n",
      .{@tagName(lx), loc.start, loc.end, id, loc.from(L.src)});
  }
  Lex.prnt("-------------------\n", .{});
}

