//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview
//!  Unique symbol/name
//!  Represents a unique entity in the code
//__________________________________________|
pub const Ident = @This();
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;

/// @descr Describes the name used to access the target entity
name  :cstr

