//:_______________________________________________________________________
//  ᛟ minim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_______________________________________________________________________
//! @fileoverview Character identification tools
//________________________________________________|
// @deps std
const std = @import("std");


//______________________________________
// @section Forward exports from std
//____________________________
pub const isWhitespace   = std.ascii.isWhitespace;
pub const isAlphanumeric = std.ascii.isAlphanumeric;
pub const isDigit        = std.ascii.isDigit;
pub const isHex          = std.ascii.isHex;


//______________________________________
// @section Extensions to std.ascii
//____________________________
/// @descr Returns whether or not the {@arg C} is a valid identifier character
pub fn isIdent (C :u8) bool {
  if (isAlphanumeric(C)) { return true; }
  return switch (C) { // Search for other valid chars
    '_' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a valid numeric character
/// @note Not the same as {@link std.isDigit}
pub fn isNumeric (C :u8) bool {
  if (isDigit(C) or isHex(C)) return true;
  return switch (C) { // Search for other valid chars
    '\'', 'x','b','o', 'f','F', 'u','U', 'i','I' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is an operator symbol
pub fn isOperator (C :u8) bool {
  return switch (C) { // Search for other valid chars
    // Standard
    '*', '+', '-', '/', '%',
    '<', '>', '&', '|', '!',
    '~', '^', '=', '$', => true,
    // Specials
    ':', '.', '@', '?', '\\', => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a quote symbol
pub fn isQuote (C :u8) bool {
  return switch (C) {
    '\'', '"', '`' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a parenthesis, bracket or brace symbol
pub fn isPar (C :u8) bool {
  return switch (C) {
    '(',')', '[',']' , '{','}' => true,
    else => false,
  };
}

//__________________
/// @descr Returns whether or not the {@arg C} is a semicolon symbol
pub fn isSemicolon (C :u8) bool { return C == ';'; }
//__________________
/// @descr Returns whether or not the {@arg C} is a colon symbol
pub fn isColon (C :u8) bool { return C == ':'; }
//__________________
/// @descr Returns whether or not the {@arg C} is a dot symbol
pub fn isDot (C :u8) bool { return C == '.'; }
//__________________
/// @descr Returns whether or not the {@arg C} is a comma symbol
pub fn isComma (C :u8) bool { return C == ','; }
//__________________
/// @descr Returns whether or not the {@arg C} is a hash symbol
pub fn isHash (C :u8) bool { return C == '#'; }

//__________________
/// @descr Returns whether or not the {@arg C} is a parenthesis or a bracket symbol
pub fn isPunctuation (C :u8) bool {
  return isColon(C) or isSemicolon(C) or isComma(C) or isDot(C);
}

//__________________
/// @descr Returns whether or not the {@arg C} is a character that should trigger a context switch
pub fn isContextChange (C :u8) bool {
  return isWhitespace(C) or isQuote(C) or isOperator(C) or isPar(C) or isPunctuation(C) or isHash(C);
}

