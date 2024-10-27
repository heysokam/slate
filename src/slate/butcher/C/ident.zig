//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Ident = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate.C
const C = @import("./rules.zig");

name :cstr,

const Templ = "{s}";
pub fn format(N :*const Ident, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
  try writer.print(Ident.Templ, .{N.name});
}

