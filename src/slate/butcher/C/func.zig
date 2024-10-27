//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Func = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate.C
const Name = @import("./ident.zig").Ident;
const Stmt = @import("./statement.zig").Stmt;
const Type = @import("./type.zig").Type;
const Data = @import("./data.zig").Data;


attr  :?Func.Attr.List= null,
retT  :Func.Type,
name  :Func.Name,
args  :?Func.Arg.List= null,
body  :?Func.Body= null,

pub const Body = struct {
  data  :Body.Data= Body.Data{.data= null},
  const Data = Stmt.List;
  const Templ = " {{ {s} }}\n";
  pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Body.Data.create(A)}; }
  pub fn add (B :*Func.Body, val :Stmt) !void { try B.data.add(val); }
  pub fn format (B :*const Func.Body, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    if (B.data.data == null or B.data.data.?.entries == null or B.data.data.?.entries.?.items.len == 0) return;
    try writer.print(Func.Body.Templ, .{B.data});
  }
};

pub const Attr = enum {
  pure, Const,
  static, Inline,
  Noreturn, noreturn_C11, noreturn_GNU,

  const Templ = "{s} ";

  pub const List = struct {
    data  :?Attr.List.Data= null,
    const Data = zstd.DataList(Func.Attr);
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Attr.List.Data.create(A)}; }
    pub fn add (L :*Func.Attr.List, val :Func.Attr) !void { try L.data.?.add(val); }
    pub fn format (L :*const Func.Attr.List, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.entries == null or L.data.?.entries.?.items.len == 0) return;
      for (L.data.?.entries.?.items, 0..) | A, id | { _=id;
        try writer.print(Attr.Templ, .{@tagName(A)});
      }
    }
  };
};

pub const Arg = struct {
  data  :Data,
  write :bool,

  const Templ = "{s}";
  pub fn format(arg :*const Func.Arg, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
    try arg.data.type.?.writeType(arg.data.id.name, arg.write, writer);
  }

  pub const List = struct {
    data  :?Arg.List.Data= null,
    const Data = zstd.DataList(Func.Arg);
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= @This().Data.create(A)}; }
    pub fn add (L :*@This(), val :Func.Arg) !void { try L.data.?.add(val); }
    const SepTempl = ", ";
    fn last (L :*const Func.Arg.List, id :usize) bool { return id == L.data.?.entries.?.items.len-1; }
    pub fn format (L :*const Func.Arg.List, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.entries == null or L.data.?.entries.?.items.len == 0) {
        try writer.print("void", .{});
        return;
      }
      for (L.data.?.entries.?.items, 0..) | arg, id | {
        try writer.print(Arg.Templ, .{arg});
        if (!L.last(id)) try writer.print(Func.Arg.List.SepTempl, .{});
      }
    }
  };
};

pub fn new (args :struct {
  name :cstr,
  retT :cstr,
}) Func {
  _ = args;
  return Func{};
}

const BaseTempl  = "{s}{s} {s}({s})";
const ProtoTempl = BaseTempl ++ ";\n";
const DefTempl   = BaseTempl ++ "{s}";
pub fn format (F :*const Func, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
  try writer.print(Func.DefTempl, .{
    F.attr orelse Func.Attr.List{},  // 0. Attributes
    F.retT,                          // 1. Return type
    F.name,                          // 2. Name
    F.args orelse Func.Arg.List{},   // 3. Arguments
    F.body orelse Func.Body{},       // 4. Body
  });
}

