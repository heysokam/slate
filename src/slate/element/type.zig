//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Generic Data type
//______________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const Pragma = @import("./pragma.zig").Pragma.List;
// const C = @import("../C.zig");

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
    type    :Type,
    count   :?cstr=    null,
    mut     :bool=     false,  // FIX: Should not be here
    ptr     :bool=     false,  // FIX: Should not be here
    pragma  :?Pragma=  null,
  };

  pub const Number = struct {
    size  :usize,
    mut   :bool=  false,  // FIX: Should not be here
    ptr   :bool=  false,  // FIX: Should not be here
    kind  :Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
  };

  pub const String = struct {
    kind  :Type.String.Kind,
    ptr   :bool=  false,  // FIX: Should not be here
    pub const Kind = enum { normal, multiline, raw, char };
  };

  pub const Void = struct { _:void=undefined,
    pub fn new() Type { return Type{.void= Type.Void{}}; }
  };

  pub fn getName (T :*const Type) cstr {
    return switch (T.*) {
      .any    => | t | t.name,
      .array  => | t | t.type.getName(),
      .number => "someNum",  // FIX: Return the actual number type
      .string => "string",
      .void   => "void",
    };
  }

  pub fn isMut (T :*const Type) bool {
    return switch (T.*) {
      .any    => | t | t.mut,
      .number => | t | t.mut,
      .array  => | t | t.type.isMut(),
      .string => false,  // TODO: string primitive ? maybe ?
      .void   => false,
    };
  }

  pub fn isPtr (T :*const Type) bool {
    return switch (T.*) {
      .any    => | t | t.ptr,
      .number => | t | t.ptr,
      .string => | t | t.ptr,
      .array  => | t | t.type.isPtr(),
      .void   => false,
    };
  }
};

