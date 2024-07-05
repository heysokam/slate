//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const fail = zstd.fail;
const Seq  = zstd.Seq;
// @deps C.ast
const Func = @import("./func.zig");


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Func :Func,
  pub const List = struct {
    data :?Seq(Node)= null,

    /// @descr Creates a new empty Node.List object.
    pub fn create(A :std.mem.Allocator) Node.List { return Node.List{.data= Seq(Node).init(A)}; }
    /// @descr Releases all memory used by the Node.List
    pub fn destroy(L:*Node.List) void { L.data.?.deinit(); }
    /// @descr Returns true if the Node list has no nodes.
    pub fn empty(L:*const Node.List) bool { return L.data == null or L.data.?.items.len == 0; }
    /// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
    pub fn append(L :*Node.List, val :Node) !void { try L.data.?.append(val); }
  };

  pub fn format(N :*const Node, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    switch (N.*) {
    .Func => try writer.print("{s}", .{N.*.Func}),
    // else  => |node| fail("Unknown C.Node Kind '{s}'", .{@tagName(node)})
    }
  }
};

