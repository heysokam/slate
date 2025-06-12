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
const slate = struct { const Depth = @import("./depth.zig"); };

/// @descr Describes the location in the source code of the name used to access the target entity
name   :source.Loc,
/// @descr Describes the indentation/scope levels of this Identifier
depth  :slate.Depth= .default(),

pub fn from (I:*const Ident, src :source.Code) source.Str { return I.name.from(src); }

