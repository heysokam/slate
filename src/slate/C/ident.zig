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

  pub const Name = struct {
    name :cstr,
    const Templ = "{s}";
    pub fn format(N :*const Ident.Name, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{N.name});
    }
  };

  pub const Type = struct {
    name :cstr,
    type :C.Type,
    mut  :bool= false,
    const Templ      = "{s}";
    const ConstTempl = Ident.Type.Templ ++ " const";
    pub fn format(T :*const Ident.Type, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (T.mut) { try writer.print(Ident.Type.Templ,      .{T.name}); }
      else       { try writer.print(Ident.Type.ConstTempl, .{T.name}); }
    }
  };

  pub const Keyword = struct {
    id :C.Keyw,
    pub fn format(K :*const Ident.Keyword, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{@tagName(K.id)});
    }
  };
};

