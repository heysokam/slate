//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview
//!  Unique symbol/name
//!  Represents a unique entity in the code
//__________________________________________|
pub const Ident = @This();
// @deps *Slate
const source = @import("../source.zig").source;

/// @descr Describes the location in the source code of the name used to access the target entity
name  :source.Loc,

pub fn from (I:*const Ident, src :source.Code) source.Code { return src[I.name.start..I.name.end]; }
