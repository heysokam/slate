//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/lexer.zig
//________________________________________________|
const std = @import("std");
const t = @import("../tests.zig");
const slate = struct {
  const Lx     = @import("./lex/lexeme.zig").Lx;
  const Lex    = @import("./lexer.zig").Lex;
  const source = @import("./source.zig");
};

const Hello42 = struct {
  const src :slate.source.Code= "proc main *() :int= return 42";
  const res = &[_]slate.Lx{
    slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  0, .end=  3}},
    slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  4, .end=  4}},

    slate.Lx{.id= .ident, .  loc= slate.source.Loc{.start=  5, .end=  8}},
    slate.Lx{.id= .space,   .loc= slate.source.Loc{.start=  9, .end=  9}},

    slate.Lx{.id= .star,    .loc= slate.source.Loc{.start= 10, .end= 10}},
    slate.Lx{.id= .paren_L, .loc= slate.source.Loc{.start= 11, .end= 11}},
    slate.Lx{.id= .paren_R, .loc= slate.source.Loc{.start= 12, .end= 12}},
    slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 13, .end= 13}},

    slate.Lx{.id= .colon,   .loc= slate.source.Loc{.start= 14, .end= 14}},
    slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 15, .end= 17}},
    slate.Lx{.id= .eq,      .loc= slate.source.Loc{.start= 18, .end= 18}},
    slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 19, .end= 19}},

    slate.Lx{.id= .ident,   .loc= slate.source.Loc{.start= 20, .end= 25}},
    slate.Lx{.id= .space,   .loc= slate.source.Loc{.start= 26, .end= 26}},

    slate.Lx{.id= .number,  .loc= slate.source.Loc{.start= 27, .end= 28}},
  };
};

//______________________________________
// @section Lexer.process: Lexeme Start/End
//____________________________
test "slate.lexer.process | should create lexemes that have the correct start/end position values" {
  const Expected = Hello42;
  // Setup
  var L = try slate.Lex.create(t.A, Expected.src);
  defer L.destroy();
  // Validate
  try t.eq(L.res.len, 0);
  // Run
  try L.process();
  // Check
  try t.eq(L.res.len, Expected.res.len);
  for (L.res.items(.id), L.res.items(.loc), 0..) |lx, loc, id| {
    try t.eq(lx,        Expected.res[id].id);
    try t.eq(loc.start, Expected.res[id].loc.start);
    try t.eq(loc.end,   Expected.res[id].loc.end);
    try t.eq_str(loc.from(L.src), Expected.res[id].loc.from(Expected.src));
  }
}

