//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer: State/Data Management
//_____________________________________________|
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;


pub fn report(L:*Lex) void {
  Lex.prnt("--- slate.Lexer ---\n", .{});
  for (L.res.items(.id), L.res.items(.loc)) |id, loc| {
    Lex.prnt("{s} : {s}\n", .{@tagName(id), loc.from(L.src)});
  }
  Lex.prnt("-------------------\n", .{});
}

// TODO: Lexer Autogen
// var L = try slate.Lex.create(t.A, code);
// defer L.destroy();
// try L.process();
// for (L.res.items(.id), L.res.items(.loc), 0..) |lx, loc, id| std.debug.print("slate.Lx{{.id= .{s}, .loc= slate.source.Loc{{.start= {d}, .end= {d: >3} }}}}, // {d}: `{s}`\n", .{@tagName(lx), loc.start, loc.end, id, loc.from(code)});

