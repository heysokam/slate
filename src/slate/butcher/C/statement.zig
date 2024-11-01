//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const seq  = zstd.seq;
const cstr = zstd.cstr;
// @deps *Slate.C
const Expr = @import("./expression.zig").Expr;


//.......................................................
// Statements:
// - Anything that can make up a line.
// - ?? Can be expressions
// - ?? Legal at the top level
pub const Stmt = union(enum) {
  Retrn   :Stmt.Return,
  // Asgn    :Stmt.Assign,
  // If      :Stmt.If,
  // Whil    :Stmt.While,
  // Fr      :Stmt.For,
  // Swtch   :Stmt.Switch,
  // Discrd  :Stmt.Discard,
  // Commnt  :Stmt.Comment,
  // Incl    :Stmt.Include,
  // Blck    :Stmt.Block,

  pub fn format (S :*const Stmt, comptime f:cstr, o:std.fmt.FormatOptions, writer :anytype) !void {
    switch (S.*) {
      .Retrn => try Stmt.Return.format(&S.Retrn,f,o,writer),
    }
  }

  pub const Return = struct {
    body  :?Expr= null,

    pub fn new (E :Expr) Stmt {
      return Stmt{ .Retrn= Stmt.Return{ .body= E } };
    }
    const BaseTempl = "return";
    const Templ     = BaseTempl ++ " {s}";
    pub fn format (R :*const Stmt.Return, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (R.body == null or R.body.? == .Empty) try writer.print(Stmt.Return.BaseTempl, .{})
      else                                      try writer.print(Stmt.Return.Templ,     .{R.body orelse Expr{.Empty={}}});
    }
  };

  // const Assign  = todo;
  // const If      = todo;
  // const While   = todo;
  // const For     = todo;
  // const Switch  = todo;
  // const Discard = todo;
  // const Comment = todo;
  // const Block   = todo;
  const Templ = "{s};";
  pub const List = struct {
    data  :?Data,
    const Data = zstd.DataList(Stmt);
    pub fn create (A :std.mem.Allocator) @This() { return List{.data= Data.create(A)}; }
    pub fn add (L :*Stmt.List, val :Stmt) !void { try L.data.?.add(val); }
    pub fn format (L :*const Stmt.List, comptime _:cstr, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.entries == null or L.data.?.entries.?.items.len == 0) return;
      for (L.data.?.entries.?.items) | stmt | {
        try writer.print(Stmt.Templ, .{stmt});
      }
      if (L.data.?.entries.?.items.len > 1) { try writer.print("\n", .{}); }
    }
  };
};

