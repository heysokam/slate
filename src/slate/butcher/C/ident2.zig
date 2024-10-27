//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate.C
const C = @import("./rules.zig");

pub const Ident = union(enum) {
  Id  :Ident.Name,
  Kw  :Ident.Keyword,
  Ty  :Ident.Type,

  const Templ = "{s}";

  pub const Keyword = struct {
    id  :C.Keyw,
    pub fn format(K :*const Ident.Keyword, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{@tagName(K.id)});
    }
  };
};

