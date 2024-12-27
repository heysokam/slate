//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/lex/data.zig
//____________________________________________________________|
const t = @import("../../tests.zig");
const slate = struct {
  const Lx     = @import("../lex/lexeme.zig").Lx;
  const Lex    = @import("../lexer.zig").Lex;
  const source = @import("../source.zig");
};


//______________________________________
// @section Lexer: Current Character
//____________________________
test "slate.lexer.ch | should return the character at {@arg L}.pos of {@arg L}.src" {
  const src = "arstqwfp1234";
  const pos = 5;
  const Expected = src[pos];
  // Setup
  var L = try slate.Lex.create(t.A, src);
  defer L.destroy();
  L.pos = pos;
  // Check
  const result = L.ch();
  try t.eq(result, Expected);
}

//______________________________________
// @section Lexer: Add Lexeme
//____________________________
test "slate.lexer.add.toLast | should increment the length of the last Lexeme of {@arg L.res} by 1" {
  const Expected = 21;
  const Initial  = Expected-1;
  // Setup
  var L = try slate.Lex.create(t.A, "123456789012345678901a");
  defer L.destroy();
  try L.res.append(t.A, slate.Lx.create2(slate.Lx.Id.ident, slate.source.Loc{.end = Initial}));
  // Run
  L.add_toLast('a');
  // Check
  const result = L.res.items(.loc)[L.res.len-1].end;
  try t.eq(result, Expected);
}

test "slate.lexer.add.one | should append a new Lexeme to {@arg L.res} with the expected {@arg id}, {@arg start} and {@arg end}" {
  const Expected = 1;
  const Initial  = Expected-1;
  // Setup
  const Id    = slate.Lx.Id.ident;
  const Start = 0;
  const End   = 1;
  var L = try slate.Lex.create(t.A, "123456789012345678901a");
  defer L.destroy();
  // Validate
  const before = L.res.len;
  try t.eq(before, Initial);
  // Run
  try L.add(Id, Start,End);
  // Check
  const result = L.res.get(L.res.len-1);
  try t.eq(result.id, Id);
  try t.eq(result.loc.start, Start);
  try t.eq(result.loc.end, End);
}

test "slate.lexer.add.one | should append a new Lexeme to {@arg L.res}" {
  const Expected = 1;
  const Initial  = Expected-1;
  // Setup
  var L = try slate.Lex.create(t.A, "123456789012345678901a");
  defer L.destroy();
  // Validate
  const before = L.res.len;
  try t.eq(before, Initial);
  // Run
  try L.add(slate.Lx.Id.ident, 0,1);
  // Check
  const result = L.res.len;
  try t.eq(result, Expected);
}

test "slate.lexer.add.single | should append a new Lexeme to {@arg L.res} with {@arg id} and the current {@arg L.pos} as its (start,end) position" {
  const ExpectedID    = slate.Lx.Id.ident;
  const ExpectedStart = 0;
  const ExpectedEnd   = 0;
  // Setup
  var L = try slate.Lex.create(t.A, "123456789012345678901a");
  defer L.destroy();
  // Run
  try L.add_single(slate.Lx.Id.ident);
  // Check
  const result = L.res.get(L.res.len-1);
  try t.eq(result.id, ExpectedID);
  try t.eq(result.loc.start, ExpectedStart);
  try t.eq(result.loc.end, ExpectedEnd);
}

