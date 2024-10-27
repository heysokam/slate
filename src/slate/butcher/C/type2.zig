//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Type = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate.C
const C = @import("./rules.zig");

name  :cstr,
type  :C.Type,
mut   :bool= false,
ptr   :bool= false,

const Templ      = "{s}";
const ConstTempl = Type.Templ ++ " const";
pub fn format(T :*const Type, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
  if (T.mut) { try writer.print(Type.Templ,      .{T.name}); }
  else       { try writer.print(Type.ConstTempl, .{T.name}); }
}

pub const Array = struct {
  name  :cstr,
  count :cstr,
  type  :*Type,
};

