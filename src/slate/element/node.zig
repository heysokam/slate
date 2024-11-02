//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Proc = @import("./proc.zig");
const Type = @import("./type.zig").Type;


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Proc  :Proc,

  pub fn destroy (N :*Node, types :Type.List) void { switch (N.*) {
    .Proc => N.Proc.destroy(types), }
  } //:: slate.Node.destroy

  pub const List = zstd.DataList(Node);
}; //:: slate.Node

