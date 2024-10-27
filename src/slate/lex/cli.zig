//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Lexer: State/Data Management
//_____________________________________________|
// @deps *Slate
const Lex = @import("../lexer.zig").Lex;


pub fn report(L:*Lex) void {
  Lex.prnt("--- slate.Lexer ---\n", .{});
  for (L.res.items(.id), L.res.items(.val)) | id, val | {
    Lex.prnt("{s} : {s}\n", .{@tagName(id), val.items});
  }
  Lex.prnt("-------------------\n", .{});
}

