//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Ident = @This();
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const Pragma = @import("./pragma.zig").Pragma.List;

/// @descr Describes the Name of an Identifier
pub const Name = struct {
  name :cstr,
};

/// @descr Describes the Generic type of a value
pub const Type = union(enum) {
  number  :Ident.Type.Number,
  string  :Ident.Type.String,
  void    :Ident.Type.Void,
  any     :Ident.Type.Any,

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Any = struct {
    name    :cstr,
    mut     :bool=     false,  // FIX: Should not be here
    ptr     :bool=     false,  // FIX: Should not be here
    pragma  :?Pragma=  null,
  };

  pub const Number = struct {
    size  :usize,
    kind  :Ident.Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
  };

  pub const String = struct {
    kind  :Ident.Type.String.Kind,
    pub const Kind = enum { normal, multiline, raw, char };
  };

  pub const Void = struct { _:void=undefined,
    pub fn new() Ident.Type {
      return Ident.Type{.void= Ident.Type.Void{}};
    }
  };
};


