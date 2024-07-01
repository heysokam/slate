//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Ast = @This();
// @deps std
const std = @import("std");
// @deps minim
pub usingnamespace @import("./rules.zig");
pub const Node   = @import("./node.zig").Node;

/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty(ast :*const Ast) bool { return ast.list.empty(); }

pub fn format(ast :*const Ast, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
  if (ast.empty()) return;
  try writer.print("", .{});
}

