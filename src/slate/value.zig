//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Generic Value and its Type
//_______________________________________________________|
pub const Value = @This();
// @deps zstd
const zstd = @import("../zstd.zig");
const cstr = zstd.cstr;


/// @descr Contains the value as a list of chars
val  :cstr,
/// @descr Metadata/Information about the Type of the Value
/// @note A value of null means that it is not typed
typ  :?Value.Type= null,
/// @descr Whether the value can be read from or not
read  :bool= true,
/// @descr Whether the value can be written to or not
write :bool= true,


/// @descr Describes the Generic type of a value
pub const Type = union(enum) {
  number  :Value.Type.Number,
  string  :Value.Type.String,

  pub const Number = struct {
    size  :usize,
    kind  :Value.Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
  };

  pub const String = struct {
    kind  :Value.Type.String.Kind,
    pub const Kind = enum { normal, multiline, raw, char };
  };
};

