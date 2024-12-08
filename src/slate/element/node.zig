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
  pub const List  = zstd.DataList(Node);
  pub const Store = zstd.DataList(Node.List);
}; //:: slate.Node

