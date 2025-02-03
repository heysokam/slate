//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/lex/others.zig
//____________________________________________________________|
const t = @import("../../tests.zig");
const slate = struct {
  const Lx  = @import("../lex/lexeme.zig").Lx;
  const Lex = @import("../lexer.zig").Lex;
  const Ch  = @import("../char.zig");
};

//______________________________________
// @section Lexer: Identifier
//____________________________
test "slate.lexer.ident | should return an error when the current character is not an Identifier or ContextChange character" {
  const Expected = error.slate_lex_UnknownIdentifier;
  // Setup
  var L = try slate.Lex.create(t.A, &.{31});
  defer L.destroy();
  // Validate
  try t.ok(!slate.Ch.isIdent(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  const result = L.ident();
  try t.err(result, Expected);
}

test "slate.lexer.ident | should increment {@arg L}.pos until the first ContextChange character is found" {
  const Expected = 3;
  // Setup
  var L = try slate.Lex.create(t.A, "abcd e213\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isIdent(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.ident();
  const result = L.pos;
  try t.eq(result, Expected);
}

test "slate.lexer.ident | should increment {@arg L}.pos by one for every Identifier character found" {
  const Expected = 7;
  // Setup
  var L = try slate.Lex.create(t.A, "abcde213\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isIdent(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.ident();
  const result = L.pos;
  try t.eq(result, Expected);
}

test "slate.lexer.ident | should add an ident Lexeme with the expected start/end positions" {
  const Expected = slate.Lx.Id.ident;
  // Setup
  var L = try slate.Lex.create(t.A, "abcd e213\n");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isIdent(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.ident();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.ident | should leave {@arg L}.pos at 0 of the next character/lexeme that should be lexed, without skipping any" {
  const Expected = 7;
  // Setup
  var L = try slate.Lex.create(t.A, "abcde213\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isIdent(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.ident();
  const result = L.res.items(.loc)[L.res.len-1].end;
  try t.eq(result, Expected);
}






//______________________________________
// @section Lexer: Number
//____________________________
test "slate.lexer.number | should return an error when the current character is not an Number or ContextChange character" {
  const Expected = error.slate_lex_UnknownNumber;
  // Setup
  var L = try slate.Lex.create(t.A, "ghLj");
  defer L.destroy();
  // Validate
  try t.ok(!slate.Ch.isNumeric(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  const result = L.number();
  try t.err(result, Expected);
}

test "slate.lexer.number | should increment {@arg L}.pos until the first ContextChange character is found" {
  const Expected = 5;
  // Setup
  var L = try slate.Lex.create(t.A, "0123_4 e567\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isNumeric(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.number();
  const result = L.pos;
  try t.eq(result, Expected);
}

test "slate.lexer.number | should increment {@arg L}.pos by one for every Number character found" {
  const Expected = 9;
  // Setup
  var L = try slate.Lex.create(t.A, "0123_4e567\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isNumeric(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.number();
  const result = L.pos;
  try t.eq(result, Expected);
}

test "slate.lexer.number | should add an number Lexeme with the expected start/end positions" {
  const Expected = slate.Lx.Id.number;
  // Setup
  var L = try slate.Lex.create(t.A, "0123_4 e567\n");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isNumeric(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.number();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.number | should leave {@arg L}.pos at 0 of the next character/lexeme that should be lexed, without skipping any" {
  const Expected = 26;
  // Setup
  var L = try slate.Lex.create(t.A, "0x0o0b0123_4567e123'u'i'f'd\n&(*)12340atarst");
  defer L.destroy();
  // Validate
  try t.ok(slate.Ch.isNumeric(L.ch()));
  try t.ok(!slate.Ch.isContextChange(L.ch()));
  // Check
  try L.number();
  const result = L.res.items(.loc)[L.res.len-1].end;
  try t.eq(result, Expected);
}

