//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/char.zig
//_______________________________________________________|
// @deps *Slate
const t    = @import("../tests.zig");
const char = @import("./char.zig");

//______________________________________
// @section char.List.range
//____________________________
test "char.List.range | should return an array containing the expected values in the character range" {
  try t.eq(char.List.range(42,  42), [_]u8{ '*' });
  try t.eq(char.List.range(32,  33), [_]u8{ ' ', '!' });
  try t.eq(char.List.range( 0,   3), [_]u8{ 0,1,2,3 });
  try t.eq(char.List.range(32, 255), char.List.printable);
  try t.eq(char.List.range(32, 255), char.List.printable);
}

//______________________________________
// @section char.List.contains
//____________________________
test "char.List.contains | should return true when C is contained in the given list" {
  try t.ok(char.List.contains(&[_]u8{ '*' }      , '*'));
  try t.ok(char.List.contains(&[_]u8{ ' ', '!' } , '!'));
  try t.ok(char.List.contains(&[_]u8{ 0,1,2,3 }  ,  0 ));
}

test "char.List.contains | should return false when C is not contained in the given list" {
  try t.ok(!char.List.contains(&[_]u8{ '*' }      , '!'));
  try t.ok(!char.List.contains(&[_]u8{ ' ', '!' } , '_'));
  try t.ok(!char.List.contains(&[_]u8{ 0,1,2,3 }  ,  4 ));
  try t.ok(!char.List.contains(&[_]u8{ 0,5,8,4 }  , ' '));
}


//______________________________________
// @section isWhitespace
//____________________________
test "isWhitespace | should return true for all characters we expect to be whitespace characters" {
  for (char.List.whitespace) |ch| try t.ok(char.isWhitespace(ch));
}

test "isWhitespace | should return false for any character that we don't consider a whitespace character" {
  next: for (char.List.printable) |ch| {
    for (char.List.whitespace) |valid| if (ch == valid) continue: next;
    t.ok(!char.isWhitespace(@intCast(ch)))
      catch return t.fail("Found character that should not be considered whitespace '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isDigit
//____________________________
test "isDigit | should return true for all characters we expect to be digit characters" {
  for (char.List.digit) |ch| try t.ok(char.isDigit(ch));
}

test "isDigit | should return false for any character that we don't consider a digit character" {
  next: for (char.List.printable) |ch| {
    for (char.List.digit) |valid| if (ch == valid) continue: next;
    t.ok(!char.isDigit(@intCast(ch)))
      catch return t.fail("Found character that should not be considered digit '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isHex
//____________________________
test "isHex | should return true for all characters we expect to be hex characters" {
  for (char.List.hex) |ch| try t.ok(char.isHex(ch));
}

test "isHex | should return false for any character that we don't consider a hex character" {
  next: for (char.List.printable) |ch| {
    for (char.List.hex) |valid| if (ch == valid) continue: next;
    t.ok(!char.isHex(@intCast(ch)))
      catch return t.fail("Found character that should not be considered hex '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isAlphanumeric
//____________________________
test "isAlphanumeric | should return true for all characters we expect to be alphanumeric characters" {
  for (char.List.alphanumeric) |ch| try t.ok(char.isAlphanumeric(ch));
}

test "isAlphanumeric | should return false for any character that we don't consider an alphanumeric character" {
  next: for (char.List.printable) |ch| {
    for (char.List.alphanumeric) |valid| if (ch == valid) continue: next;
    t.ok(!char.isAlphanumeric(@intCast(ch)))
      catch return t.fail("Found character that should not be considered alphanumeric '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isNumeric
//____________________________
test "isNumeric | should return true for all characters we expect to be numeric characters" {
  for (char.List.numeric) |ch| try t.ok(char.isNumeric(ch));
}

test "isNumeric | should return false for any character that we don't consider a numeric character" {
  next: for (char.List.printable) |ch| {
    for (char.List.numeric) |valid| if (ch == valid) continue: next;
    t.ok(!char.isNumeric(@intCast(ch)))
      catch return t.fail("Found character that should not be considered numeric '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isIdent
//____________________________
test "isIdent | should return true for all characters we expect to be identifier characters" {
  for (char.List.identifier) |ch| try t.ok(char.isIdent(ch));
}

test "isIdent | should return false for any character that we don't consider an identifier character" {
  next: for (char.List.printable) |ch| {
    for (char.List.identifier) |valid| if (ch == valid) continue: next;
    t.ok(!char.isIdent(@intCast(ch)))
      catch return t.fail("Found character that should not be considered identifier '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isOperator
//____________________________
test "isOperator | should return true for all characters we expect to be operator characters" {
  for (char.List.operator) |ch| try t.ok(char.isOperator(ch));
}

test "isOperator | should return false for any character that we don't consider an operator character" {
  next: for (char.List.printable) |ch| {
    for (char.List.operator) |valid| if (ch == valid) continue: next;
    t.ok(!char.isOperator(@intCast(ch)))
      catch return t.fail("Found character that should not be considered operator '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isQuote
//____________________________
test "isQuote | should return true for all characters we expect to be quote characters" {
  for (char.List.quote) |ch| try t.ok(char.isQuote(ch));
}

test "isQuote | should return false for any character that we don't consider a quote character" {
  next: for (char.List.printable) |ch| {
    for (char.List.quote) |valid| if (ch == valid) continue: next;
    t.ok(!char.isQuote(@intCast(ch)))
      catch return t.fail("Found character that should not be considered quote '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isPar
//____________________________
test "isParenthesis | should return true for all characters we expect to be parenthesis characters" {
  for (char.List.parenthesis) |ch| try t.ok(char.isParenthesis(ch));
}

test "isParenthesis | should return false for any character that we don't consider a parenthesis character" {
  next: for (char.List.printable) |ch| {
    for (char.List.parenthesis) |valid| if (ch == valid) continue: next;
    t.ok(!char.isParenthesis(@intCast(ch)))
      catch return t.fail("Found character that should not be considered parenthesis '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isPunctuation
//____________________________
test "isPunctuation | should return true for all characters we expect to be punctuation characters" {
  for (char.List.punctuation) |ch| try t.ok(char.isPunctuation(ch));
}

test "isPunctuation | should return false for any character that we don't consider a punctuation character" {
  next: for (char.List.printable) |ch| {
    for (char.List.punctuation) |valid| if (ch == valid) continue: next;
    t.ok(!char.isPunctuation(@intCast(ch)))
      catch return t.fail("Found character that should not be considered punctuation '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isContextChange
//____________________________
test "isContextChange | should return true for all characters we expect to be contextChange characters" {
  for (char.List.contextChange) |ch| try t.ok(char.isContextChange(ch));
}

test "isContextChange | should return false for any character that we don't consider a contextChange character" {
  next: for (char.List.printable) |ch| {
    for (char.List.contextChange) |valid| if (ch == valid) continue: next;
    t.ok(!char.isContextChange(@intCast(ch)))
      catch return t.fail("Found character that should not be considered contextChange '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isSemicolon
//____________________________
test "isSemicolon | should return true for all characters we expect to be semicolon characters" {
  for ([_]u8{';'}) |ch| try t.ok(char.isSemicolon(ch));
}

test "isSemicolon | should return false for any character that we don't consider a semicolon character" {
  next: for (char.List.printable) |ch| {
    for ([_]u8{';'}) |valid| if (ch == valid) continue: next;
    t.ok(!char.isSemicolon(@intCast(ch)))
      catch return t.fail("Found character that should not be considered semicolon '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isColon
//____________________________
test "isColon | should return true for all characters we expect to be colon characters" {
  for ([_]u8{':'}) |ch| try t.ok(char.isColon(ch));
}

test "isColon | should return false for any character that we don't consider a colon character" {
  next: for (char.List.printable) |ch| {
    for ([_]u8{':'}) |valid| if (ch == valid) continue: next;
    t.ok(!char.isColon(@intCast(ch)))
      catch return t.fail("Found character that should not be considered colon '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isDot
//____________________________
test "isDot | should return true for all characters we expect to be dot characters" {
  for ([_]u8{'.'}) |ch| try t.ok(char.isDot(ch));
}

test "isDot | should return false for any character that we don't consider a dot character" {
  next: for (char.List.printable) |ch| {
    for ([_]u8{'.'}) |valid| if (ch == valid) continue: next;
    t.ok(!char.isDot(@intCast(ch)))
      catch return t.fail("Found character that should not be considered dot '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isComma
//____________________________
test "isComma | should return true for all characters we expect to be comma characters" {
  for ([_]u8{','}) |ch| try t.ok(char.isComma(ch));
}

test "isComma | should return false for any character that we don't consider a comma character" {
  next: for (char.List.printable) |ch| {
    for ([_]u8{','}) |valid| if (ch == valid) continue: next;
    t.ok(!char.isComma(@intCast(ch)))
      catch return t.fail("Found character that should not be considered comma '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}


//______________________________________
// @section isHash
//____________________________
test "isHash | should return true for all characters we expect to be hash characters" {
  for ([_]u8{'#'}) |ch| try t.ok(char.isHash(ch));
}

test "isHash | should return false for any character that we don't consider a hash character" {
  next: for (char.List.printable) |ch| {
    for ([_]u8{'#'}) |valid| if (ch == valid) continue: next;
    t.ok(!char.isHash(@intCast(ch)))
      catch return t.fail("Found character that should not be considered hash '{c}' : {d}\n", .{@as(u8, @intCast(ch)), ch});
  }
}

