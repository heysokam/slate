//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Ast = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const seq  = zstd.seq;
const cstr = zstd.cstr;
// @deps minim
pub usingnamespace @import("./rules.zig");
pub const Node   = @import("./node.zig").Node;

/// @descr Contains the allocator used by the AST
A     :std.mem.Allocator,
/// @descr Contains the list of Top-Level nodes of the AST
list  :Node.List,

/// @descr Returns an empty {@link Ast} object
pub fn newEmpty () Ast { return Ast{.list= Ast.Node.List{}, .A= std.heap.page_allocator}; }
/// @descr Creates a new empty {@link Ast} object with its data correctly initialized.
pub fn create (A :std.mem.Allocator) Ast { return Ast{.list= Node.List.create(A), .A= A}; }
/// @descr Releases all memory used by the Node.List
pub fn destroy (L :*Ast) void { L.list.destroy(); }
/// @descr Returns true if the AST has no nodes in its {@link Ast.list} field
pub fn empty (ast :*const Ast) bool { return ast.list.empty(); }
/// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
pub fn add (ast :*Ast, val :Node) !void { try ast.list.add(val); }

pub fn format (ast :*const Ast, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
  if (ast.empty()) return;
  for (ast.list.data.?.items) | N | { try writer.print("{s}", .{N}); }
}

pub fn report (ast :*const Ast) void {
  std.debug.print("..*Slate.C.Codegen.........\n", .{});
  std.debug.print("{s}", .{ast});
  std.debug.print("...........................\n", .{});
}

pub fn write (ast :*const Ast, trg :cstr) !void {
  const code = try std.fmt.allocPrint(ast.A, "{s}", .{ast});
  defer ast.A.free(code);
  try std.fs.cwd().makePath(std.fs.path.dirname(trg) orelse ".");
  try zstd.files.write(code, trg, .{});
}

