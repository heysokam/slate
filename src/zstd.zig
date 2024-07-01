//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Minimal duplicate of `heysokam/zstd` tools, to not depend on any module.
//_________________________________________________________________________________________|
// @deps std
const std  = @import("std");

//______________________________________
// @section Types
//____________________________
pub const todo = ?u8;
pub const cstr = []const u8;
pub const Seq  = std.ArrayList;
pub const Str  = Seq(u8);
pub const List = std.MultiArrayList;
pub const ByteBuffer = Str;

//______________________________________
// @section Logging
//____________________________
pub const prnt = std.debug.print;
pub const fail = std.debug.panic;

