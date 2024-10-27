//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const fail = zstd.fail;
// @deps *Slate.C
const C = @import("./rules.zig");

pub const Type = union(enum) {
  any     :Type.Any,
  array   :*Type.Array,

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Any = struct {
    name    :cstr,
    mut     :bool=  false,
    ptr     :bool=  false,
    const Templ = "{s}{s}{s}";
    pub fn format (T :*const Type.Any, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Type.Any.Templ, .{
        T.name,
        if (!T.mut) " const" else "",
        if (T.ptr) "*" else "",
        });
    }
    pub fn new (name :cstr, args:struct {
      mut :bool= false,
      ptr :bool= false,
    }) Type {
      return Type{.any= Type.Any{ .name= name, .mut= args.mut, .ptr= args.ptr }};
    }
  };

  /// @descr Array Type. Can contain other types (recursive).
  pub const Array = struct {
    type    :Type,
    count   :?cstr=  null,
    const TemplCount = "[{s}]";
    pub fn writeType (T :*const Type.Array, name :cstr, mut :bool, writer :anytype) anyerror!void {
      try Type.writeType(&T.type, name, mut, writer);
      if (T.count != null) try writer.print(Type.Array.TemplCount, .{T.count orelse ""});
    }
    pub fn new (name :cstr, args:struct {
      mut   :bool=   false,
      ptr   :bool=   false,
      count :?cstr=  null,
    }, A :std.mem.Allocator) !Type {
      var array = try A.create(Type.Array);
      array.count = args.count;
      array.type  = Type.Any.new(
        name, .{
        .mut  = args.mut,
        .ptr  = args.ptr
        }); //:: .type
      return Type{.array= array };
    }
  };

  const TemplBase  = "{s}";
  const TemplConst = TemplBase++" const {s}";
  const Templ      = TemplBase++" {s}";
  pub fn writeType (T :*const Type, name :cstr, mut :bool, writer :anytype) !void {
    switch (T.*) {
      .any   =>
        if (mut) try writer.print(Type.Templ,      .{T.any, name})
        else     try writer.print(Type.TemplConst, .{T.any, name}),
      .array => try T.array.writeType(name, mut, writer),
    }
  }

  pub fn format (T :*const Type, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    switch (T.*) {
      .any   => try writer.print(Type.TemplBase, .{T.any}),
      .array => fail("Tried to format an array type, but should be calling writeType instead.\n", .{}),
    }
  }

};

