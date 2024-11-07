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

  pub fn clone (N :*const Node) !Node { return switch (N.*) {
    .Proc => Node{.Proc= try N.Proc.clone()}, };
  } //:: slate.Node.clone

  pub const List = Node.list.type;
  pub const list = struct {
    const @"type" = zstd.DataList(Node);

    pub fn clone (L :*const Node.List) !Node.List {
      var result = try L.clone();
      for (0..L.len()) |id| if (L.at(id) != null) result.set(id, try L.at(id).?.clone());
      return result;
    }
  };
}; //:: slate.Node

