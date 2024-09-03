//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Generic Data type
//______________________________________________|
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const Pragma = @import("./pragma.zig").Pragma.List;

pub const Type = union(enum) {
  any     :Type.Any,
  array   :*Type.Array,
  number  :Type.Number,
  string  :Type.String,
  void    :Type.Void,

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Any = struct {
    name    :cstr,
    mut     :bool=     false,  // FIX: Should not be here
    ptr     :bool=     false,  // FIX: Should not be here
    pragma  :?Pragma=  null,
  };

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Array = struct {
    typ     :Type,
    count   :?cstr=    null,
    mut     :bool=     false,  // FIX: Should not be here
    ptr     :bool=     false,  // FIX: Should not be here
    pragma  :?Pragma=  null,
  };

  pub const Number = struct {
    size  :usize,
    kind  :Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
  };

  pub const String = struct {
    kind  :Type.String.Kind,
    pub const Kind = enum { normal, multiline, raw, char };
  };

  pub const Void = struct { _:void=undefined,
    pub fn new() Type { return Type{.void= Type.Void{}}; }
  };
};

