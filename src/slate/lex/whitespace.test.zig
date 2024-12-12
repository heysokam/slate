//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/lex/whitespace.zig
//________________________________________________________|
const t = @import("../../tests.zig");
const slate = struct {
  const Lx  = @import("../lex/lexeme.zig").Lx;
  const Lex = @import("../lexer.zig").Lex;
};


//______________________________________
// @section Lexer: Whitespace
//____________________________
test "slate.lexer.space | should add a single Lx.Id.space to the lexer result if the current character is ` `" {
  const Expected = slate.Lx.Id.space;
  // Setup
  var L = try slate.Lex.create(t.A, " ");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ' ');
  // Check
  try L.space();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.space | should return an error when the current character is not ` `" {
  const Expected = error.slate_lex_UnknownSpace;
  // Setup
  var L = try slate.Lex.create(t.A, "o");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != ' ');
  // Check
  const result = L.space();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: NewLine
//____________________________
test "slate.lexer.newline | should add a single Lx.Id.newline to the lexer result if the current character is `\n`" {
  const Expected = slate.Lx.Id.newline;
  // Setup
  var L = try slate.Lex.create(t.A, "\n");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '\n');
  // Check
  try L.newline();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.newline | should return an error when the current character is not `\n`" {
  const Expected = error.slate_lex_UnknownNewline;
  // Setup
  var L = try slate.Lex.create(t.A, "p");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '\n');
  // Check
  const result = L.newline();
  try t.err(result, Expected);
}

