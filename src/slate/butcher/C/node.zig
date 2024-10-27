//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const fail = zstd.fail;
const seq  = zstd.seq;
// @deps C.ast
const Func = @import("./func.zig");


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Func :Func,
  pub const List = struct {
    data :?Data= null,
    const Data = seq(Node);

    /// @descr Creates a new empty Node.List object.
    pub fn create (A :std.mem.Allocator) Node.List { return Node.List{.data= Data.init(A)}; }
    /// @descr Releases all memory used by the Node.List
    pub fn destroy (L :*Node.List) void { L.data.?.deinit(); }
    /// @descr Returns true if the Node list has no nodes.
    pub fn empty (L :*const Node.List) bool { return L.data == null or L.data.?.items.len == 0; }
    /// @descr Adds the {@arg val} Node to the Node.List of the {@arg ast}.
    pub fn add (L :*Node.List, val :Node) !void { try L.data.?.append(val); }
  };

  const Templ = "{s}";
  pub fn format (N :*const Node, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    switch (N.*) {
    .Func => try writer.print(Node.Templ, .{N.*.Func}),
    // else  => |node| fail("Unknown C.Node Kind '{s}'", .{@tagName(node)})
    }
  }
};

