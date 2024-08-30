//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Func = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const seq  = zstd.seq;
// @deps *Slate.C
const Ident = @import("./ident.zig").Ident;
const Stmt  = @import("./statement.zig").Stmt;


attr  :Func.Attr.List= undefined,
retT  :Ident.Type,
name  :Ident.Name,
args  :Func.Arg.List= undefined,
body  :Func.Body= undefined,

pub const Body = struct {
  data  :Data,
  const Data = Stmt.List;
  const Templ = " {{ {s} }}\n";
  pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Data.create(A)}; }
  pub fn add (B :*Func.Body, val :Stmt) !void { try B.data.data.?.append(val); }
  pub fn format (B :*const Func.Body, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    if (B.data.data == null or B.data.data.?.items.len == 0) return;
    try writer.print(Func.Body.Templ, .{B.data});
  }
};

pub const Attr = enum {
  pure, Const,
  static, Inline,
  Noreturn, noreturn_C11, noreturn_GNU,

  const Templ = "{s} ";

  pub const List = struct {
    data :?Data,
    const Data = seq(Attr);
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Data.init(A)}; }
    pub fn add (B :*Func.Attr.List, val :Attr) !void { try B.data.?.append(val); }
    pub fn format (L :*const Func.Attr.List, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.items.len == 0) return;
      for (L.data.?.items, 0..) | A, id | { _=id;
        try writer.print(Attr.Templ, .{@tagName(A)});
      }
    }
  };
};

pub const Arg = struct {
  type  :Ident.Type,
  name  :Ident.Name,

  const Templ = "{s} {s}";
  pub fn format(arg :*const Func.Arg, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
    try writer.print(Func.Arg.Templ, .{arg.type, arg.name});
  }

  const List = struct {
    data :?Data,
    const Data = seq(Func.Arg);
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Data.init(A)}; }
    const SepTempl = ", ";
    pub fn format (L :*const Func.Arg.List, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.items.len == 0) {
        try writer.print("void", .{});
        return;
      }
      for (L.data.?.items, 0..) | arg, id | {
        try writer.print(Func.Arg.Templ, .{arg.type, arg.name});
        if (id != 0 and id != L.data.?.items.len) {
          try writer.print(Func.Arg.List.SepTempl, .{});
        }
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
    F.attr,  // 0. Attributes
    F.retT,  // 1. Return type
    F.name,  // 2. Name
    F.args,  // 3. Arguments
    F.body,  // 4. Body
  });
}

