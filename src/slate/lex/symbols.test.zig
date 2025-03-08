//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/lex/symbols.test.zig
//____________________________________________________________|
const t = @import("../../tests.zig");
const slate = struct {
  const Lx  = @import("../lex/lexeme.zig").Lx;
  const Lex = @import("../lexer.zig").Lex;
};

//______________________________________
// @section Lexer: Parenthesis
//____________________________
test "slate.lexer.paren | should add a single Lx.Id.paren_L to the lexer result if the current character is `(`" {
  const Expected = slate.Lx.Id.paren_L;
  // Setup
  var L = try slate.Lex.create(t.A, "(");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '(');
  // Check
  try L.paren();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.paren | should add a single Lx.Id.paren_R to the lexer result if the current character is `)`" {
  const Expected = slate.Lx.Id.paren_R;
  // Setup
  var L = try slate.Lex.create(t.A, ")");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ')');
  // Check
  try L.paren();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.paren | should return an error when the current character is not `(` or `)`" {
  const Expected = error.slate_lex_UnknownParenthesis;
  // Setup
  var L = try slate.Lex.create(t.A, "a");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '(');
  try t.ok(L.ch() != ')');
  // Check
  const result = L.paren();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Brace
//____________________________
test "slate.lexer.brace | should add a single Lx.Id.brace_L to the lexer result if the current character is `{`" {
  const Expected = slate.Lx.Id.brace_L;
  // Setup
  var L = try slate.Lex.create(t.A, "{");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '{');
  // Check
  try L.brace();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.brace | should add a single Lx.Id.brace_R to the lexer result if the current character is `}`" {
  const Expected = slate.Lx.Id.brace_R;
  // Setup
  var L = try slate.Lex.create(t.A, "}");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '}');
  // Check
  try L.brace();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.brace | should return an error when the current character is not `{` or `}`" {
  const Expected = error.slate_lex_UnknownBrace;
  // Setup
  var L = try slate.Lex.create(t.A, "b");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '{');
  try t.ok(L.ch() != '}');
  // Check
  const result = L.brace();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Bracket
//____________________________
test "slate.lexer.bracket | should add a single Lx.Id.bracket_L to the lexer result if the current character is `[`" {
  const Expected = slate.Lx.Id.bracket_L;
  // Setup
  var L = try slate.Lex.create(t.A, "[");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '[');
  // Check
  try L.bracket();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.bracket | should add a single Lx.Id.bracket_R to the lexer result if the current character is `]`" {
  const Expected = slate.Lx.Id.bracket_R;
  // Setup
  var L = try slate.Lex.create(t.A, "]");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ']');
  // Check
  try L.bracket();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.bracket | should return an error when the current character is not `[` or `]`" {
  const Expected = error.slate_lex_UnknownBracket;
  // Setup
  var L = try slate.Lex.create(t.A, "c");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '[');
  try t.ok(L.ch() != ']');
  // Check
  const result = L.bracket();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Equal / eq
//____________________________
test "slate.lexer.eq | should add a single Lx.Id.eq to the lexer result if the current character is `=`" {
  const Expected = slate.Lx.Id.eq;
  // Setup
  var L = try slate.Lex.create(t.A, "=");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '=');
  // Check
  try L.eq();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.eq | should return an error when the current character is not `=`" {
  const Expected = error.slate_lex_UnknownEq;
  // Setup
  var L = try slate.Lex.create(t.A, "d");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '=');
  // Check
  const result = L.eq();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: At @
//____________________________
test "slate.lexer.at | should add a single Lx.Id.at to the lexer result if the current character is `@`" {
  const Expected = slate.Lx.Id.at;
  // Setup
  var L = try slate.Lex.create(t.A, "@");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '@');
  // Check
  try L.at();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.at | should return an error when the current character is not `@`" {
  const Expected = error.slate_lex_UnknownAt;
  // Setup
  var L = try slate.Lex.create(t.A, "e");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '@');
  // Check
  const result = L.at();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Star / Asterisk
//____________________________
test "slate.lexer.star | should add a single Lx.Id.star to the lexer result if the current character is `*`" {
  const Expected = slate.Lx.Id.star;
  // Setup
  var L = try slate.Lex.create(t.A, "*");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '*');
  // Check
  try L.star();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.star | should return an error when the current character is not `*`" {
  const Expected = error.slate_lex_UnknownStar;
  // Setup
  var L = try slate.Lex.create(t.A, "f");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '*');
  // Check
  const result = L.star();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Colon
//____________________________
test "slate.lexer.colon | should add a single Lx.Id.colon to the lexer result if the current character is `:`" {
  const Expected = slate.Lx.Id.colon;
  // Setup
  var L = try slate.Lex.create(t.A, ":");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ':');
  // Check
  try L.colon();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.colon | should return an error when the current character is not `:`" {
  const Expected = error.slate_lex_UnknownColon;
  // Setup
  var L = try slate.Lex.create(t.A, "g");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != ':');
  // Check
  const result = L.colon();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Semicolon
//____________________________
test "slate.lexer.semicolon | should add a single Lx.Id.semicolon to the lexer result if the current character is `;`" {
  const Expected = slate.Lx.Id.semicolon;
  // Setup
  var L = try slate.Lex.create(t.A, ";");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ';');
  // Check
  try L.semicolon();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.semicolon | should return an error when the current character is not `;`" {
  const Expected = error.slate_lex_UnknownSemicolon;
  // Setup
  var L = try slate.Lex.create(t.A, "h");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != ';');
  // Check
  const result = L.semicolon();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Dot
//____________________________
test "slate.lexer.dot | should add a single Lx.Id.dot to the lexer result if the current character is `.`" {
  const Expected = slate.Lx.Id.dot;
  // Setup
  var L = try slate.Lex.create(t.A, ".");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '.');
  // Check
  try L.dot();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.dot | should return an error when the current character is not `.`" {
  const Expected = error.slate_lex_UnknownDot;
  // Setup
  var L = try slate.Lex.create(t.A, "i");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '.');
  // Check
  const result = L.dot();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Comma
//____________________________
test "slate.lexer.comma | should add a single Lx.Id.comma to the lexer result if the current character is `,`" {
  const Expected = slate.Lx.Id.comma;
  // Setup
  var L = try slate.Lex.create(t.A, ",");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), ',');
  // Check
  try L.comma();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.comma | should return an error when the current character is not `,`" {
  const Expected = error.slate_lex_UnknownComma;
  // Setup
  var L = try slate.Lex.create(t.A, "j");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != ',');
  // Check
  const result = L.comma();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Hash
//____________________________
test "slate.lexer.hash | should add a single Lx.Id.hash to the lexer result if the current character is `#`" {
  const Expected = slate.Lx.Id.hash;
  // Setup
  var L = try slate.Lex.create(t.A, "#");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '#');
  // Check
  try L.hash();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.hash | should return an error when the current character is not `#`" {
  const Expected = error.slate_lex_UnknownHash;
  // Setup
  var L = try slate.Lex.create(t.A, "k");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '#');
  // Check
  const result = L.hash();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Single Quote
//____________________________
test "slate.lexer.quote_S | should add a single Lx.Id.quote_S to the lexer result if the current character is `'`" {
  const Expected = slate.Lx.Id.quote_S;
  // Setup
  var L = try slate.Lex.create(t.A, "'");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '\'');
  // Check
  try L.quote_S();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.quote_S | should return an error when the current character is not `'`" {
  const Expected = error.slate_lex_UnknownQuoteSingle;
  // Setup
  var L = try slate.Lex.create(t.A, "l");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '\'');
  // Check
  const result = L.quote_S();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Double Quote
//____________________________
test "slate.lexer.quote_D | should add a single Lx.Id.quote_D to the lexer result if the current character is `\"`" {
  const Expected = slate.Lx.Id.quote_D;
  // Setup
  var L = try slate.Lex.create(t.A, "\"");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '\"');
  // Check
  try L.quote_D();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.quote_D | should return an error when the current character is not `\"`" {
  const Expected = error.slate_lex_UnknownQuoteDouble;
  // Setup
  var L = try slate.Lex.create(t.A, "m");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '\"');
  // Check
  const result = L.quote_D();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Backtick Quote
//____________________________
test "slate.lexer.quote_B | should add a single Lx.Id.quote_B to the lexer result if the current character is ```" {
  const Expected = slate.Lx.Id.quote_B;
  // Setup
  var L = try slate.Lex.create(t.A, "`");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '`');
  // Check
  try L.quote_B();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.quote_B | should return an error when the current character is not ```" {
  const Expected = error.slate_lex_UnknownQuoteBacktick;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '`');
  // Check
  const result = L.quote_B();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Forwards Slash
//____________________________
test "slate.lexer.slash_F | should add a single Lx.Id.slash_F to the lexer result if the current character is `/`" {
  const Expected = slate.Lx.Id.slash_F;
  // Setup
  var L = try slate.Lex.create(t.A, "/");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '/');
  // Check
  try L.slash_F();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.slash_F | should return an error when the current character is not `/`" {
  const Expected = error.slate_lex_UnknownSlashForward;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '/');
  // Check
  const result = L.slash_F();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Backwards Slash
//____________________________
test "slate.lexer.slash_B | should add a single Lx.Id.slash_B to the lexer result if the current character is `\\`" {
  const Expected = slate.Lx.Id.slash_B;
  // Setup
  var L = try slate.Lex.create(t.A, "\\");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '\\');
  // Check
  try L.slash_B();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.slash_B | should return an error when the current character is not `\\`" {
  const Expected = error.slate_lex_UnknownSlashBackward;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '\\');
  // Check
  const result = L.slash_B();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Dash
//____________________________
test "slate.lexer.dash | should add a single Lx.Id.dash to the lexer result if the current character is `-`" {
  const Expected = slate.Lx.Id.dash;
  // Setup
  var L = try slate.Lex.create(t.A, "-");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '-');
  // Check
  try L.dash();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.dash | should return an error when the current character is not `-`" {
  const Expected = error.slate_lex_UnknownDash;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '-');
  // Check
  const result = L.dash();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Exclamation
//____________________________
test "slate.lexer.excl | should add a single Lx.Id.dash to the lexer result if the current character is `!`" {
  const Expected = slate.Lx.Id.excl;
  // Setup
  var L = try slate.Lex.create(t.A, "!");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '!');
  // Check
  try L.excl();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.excl | should return an error when the current character is not `!`" {
  const Expected = error.slate_lex_UnknownExclamation;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '!');
  // Check
  const result = L.excl();
  try t.err(result, Expected);
}


//______________________________________
// @section Lexer: Question
//____________________________
test "slate.lexer.question | should add a single Lx.Id.dash to the lexer result if the current character is `?`" {
  const Expected = slate.Lx.Id.question;
  // Setup
  var L = try slate.Lex.create(t.A, "?");
  defer L.destroy();
  // Validate
  try t.eq(L.ch(), '?');
  // Check
  try L.question();
  const result = L.res.items(.id)[L.res.len-1];
  try t.eq(result, Expected);
}

test "slate.lexer.question | should return an error when the current character is not `?`" {
  const Expected = error.slate_lex_UnknownQuestion;
  // Setup
  var L = try slate.Lex.create(t.A, "n");
  defer L.destroy();
  // Validate
  try t.ok(L.ch() != '?');
  // Check
  const result = L.question();
  try t.err(result, Expected);
}

