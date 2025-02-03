//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Character identification tools
//________________________________________________|
const char = @This();
// @deps std
const std = @import("std");

//______________________________________
// @section Lists of Known/Expected character categories
//____________________________
pub const List = struct {
  pub const EOF           = @as(u8, 0);
  pub const printable     = char.range(32, 255);
  pub const digit         = char.range('0','9');
  pub const alphabetic    = char.range('A','Z') ++ char.range('a','z');
  pub const alphanumeric  = digit ++ alphabetic;
  pub const hex           = digit ++ char.range('A','F') ++ char.range('a','f');
  pub const numeric       = hex   ++ [_]u8{'x','b','o', 'u','i','f','d', '_', '\''};
  pub const whitespace    = [_]u8{ ' ', '\t', '\n', '\r' };
  pub const identifier    = [_]u8{ '_' } ++ alphanumeric;
  pub const quote         = [_]u8{ '\'', '"', '`' };
  pub const parenthesis   = [_]u8{ '(',')', '[',']' , '{','}' };
  pub const punctuation   = [_]u8{ ':', ';', ',', '.' };
  pub const contextChange = whitespace ++ quote ++ operator ++ parenthesis ++ punctuation ++ [_]u8{ '#' };
  pub const operator      = operators.standard ++ operators.special;
  pub const operators     = struct {
    pub const standard    = [_]u8{
      '*', '+', '-', '/', '%',
      '<', '>', '&', '|', '!',
      '~', '^', '=', '$', };
    pub const special     = [_]u8{
      ':', '.', '@', '?', '\\'};
  }; //:: char.List.operator

  //____________________________
  /// @descr Returns whether or not the {@arg list} of characters contains the {@arg C} character
  pub fn contains (list :[]const u8, C :u8) bool { return std.mem.indexOfScalar(u8, list, C) != null; }
  //____________________________
  /// @descr Returns a list of all characters contained in range[from..to]  (both included)
  pub fn range (comptime from :anytype, comptime to :anytype) [to+1-from]u8 {
    var result :[to+1-from]u8= undefined;
    for (from..to+1) |ch| result[ch-from] = @intCast(ch);
    return result;
  } //:: char.List.range
}; //:: char.List
pub const range = char.List.range;


//______________________________________
// @section Forward exports from std
//____________________________
pub const isWhitespace   = std.ascii.isWhitespace;
pub const isDigit        = std.ascii.isDigit;
pub const isHex          = std.ascii.isHex;
pub const isAlphanumeric = std.ascii.isAlphanumeric;


//______________________________________
// @section Extensions to std.ascii
//____________________________
/// @descr Returns whether or not {@arg C} is a character that should be understood as an EOF marker
pub fn isEOF (C :u8) bool { return C == char.List.EOF; }
/// @descr Returns whether or not {@arg C} is a valid numeric character
/// @note Not the same as {@link std.isDigit}
pub fn isNumeric (C :u8) bool { return char.List.contains(char.List.numeric[0..], C); }
/// @descr Returns whether or not {@arg C} is a valid identifier character
pub fn isIdent (C :u8) bool { return char.List.contains(char.List.identifier[0..], C); }
/// @descr Returns whether or not {@arg C} is an operator symbol
pub fn isOperator (C :u8) bool { return char.List.contains(char.List.operator[0..], C); }
/// @descr Returns whether or not {@arg C} is a quote symbol
pub fn isQuote (C :u8) bool { return char.List.contains(char.List.quote[0..], C); }
/// @descr Returns whether or not {@arg C} is a parenthesis, bracket or brace symbol
pub fn isParenthesis (C :u8) bool { return char.List.contains(char.List.parenthesis[0..], C); }
/// @descr Returns whether or not {@arg C} is a parenthesis or a bracket symbol
pub fn isPunctuation (C :u8) bool { return char.List.contains(char.List.punctuation[0..], C); }
/// @descr Returns whether or not {@arg C} is a character that should trigger a context switch
pub fn isContextChange (C :u8) bool { return char.isEOF(C) or char.List.contains(char.List.contextChange[0..], C); }
//____________________________
/// @descr Returns whether or not {@arg C} is a semicolon symbol
pub fn isSemicolon (C :u8) bool { return C == ';'; }
/// @descr Returns whether or not {@arg C} is a colon symbol
pub fn isColon (C :u8) bool { return C == ':'; }
/// @descr Returns whether or not {@arg C} is a dot symbol
pub fn isDot (C :u8) bool { return C == '.'; }
/// @descr Returns whether or not {@arg C} is a comma symbol
pub fn isComma (C :u8) bool { return C == ','; }
/// @descr Returns whether or not {@arg C} is a hash symbol
pub fn isHash (C :u8) bool { return C == '#'; }

