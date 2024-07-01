//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const todo = zstd.todo;

//.......................................................
// Expressions:
// - Can contain Identifiers, Literals and Operators
// - Evaluate to values
// - C: Legal at top level. Zig: Legal at block level
// const Expr = union(enum) {
//   Id  :u8, // todo
//   Lit :u8, // todo
//   Op  :u8, // todo
// };
pub const Expr = union(enum) {
  Lit  :Expr.Literal,

  pub fn format(E :*const Expr, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
    switch (E.*) {
      .Lit   => try Expr.Literal.format(&E.Lit,f,o,writer),
    }
  }

  pub const Literal = union(enum) {
    Flt    :Literal.Float,
    Intgr  :Literal.Int,
    Strng  :Literal.String,
    Ch     :Literal.Char,

    pub fn format(L :*const Expr.Literal, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
      switch (L.*) {
        .Flt   => try Expr.Literal.Float.format(&L.Flt,f,o,writer),
        .Intgr => try Expr.Literal.Int.format(&L.Intgr,f,o,writer),
        .Strng => try Expr.Literal.String.format(&L.Strng,f,o,writer),
        .Ch    => try Expr.Literal.Char.format(&L.Ch,f,o,writer),
      }
    }

    pub const Float = struct {
      val   :cstr,
      size  :todo= null,
      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Flt= Expr.Literal.Float{ .val= args.val }}};
      }
      const Templ = "{s}";
      fn format(L :*const Expr.Literal.Float, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Float.Templ, .{L.val});
      }
    };

    pub const Int = struct {
      val    :cstr,
      signed :todo= null,
      size   :todo= null,

      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Intgr= Expr.Literal.Int{ .val= args.val }}};
      }
      const Templ = "{s}";
      fn format(L :*const Expr.Literal.Int, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Int.Templ, .{L.val});
      }
    };

    pub const Char = struct {
      val  :cstr,
      const Templ = "'{s}'";
      fn format(L :*const Expr.Literal.Char, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Char.Templ, .{L.val});
      }
    };

    pub const String = struct {
      val       :cstr,
      multiline :todo= null,
      fn format(L :*const Expr.Literal.String, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print("\"{s}\"", .{L.val});
      }
    };
  };
};

