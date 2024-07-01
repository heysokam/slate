//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps zstd
const zstd = @import("../../zstd.zig");
const Seq  = zstd.Seq;
// @deps minim.ast
const Func = @import("./func.zig");


/// @descr Describes a Top-Level Node of the language.
pub const Node = union(enum) {
  Func :Func,
  pub const List = struct {
    data :?Seq(Node)= null,

    /// @descr Returns true if the Node list has no nodes.
    pub fn empty(L:*const Node.List) bool { return L.data == null or L.data.?.items.len == 0; }
  };
};

