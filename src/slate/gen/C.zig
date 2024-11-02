//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview C code generation from *Slate Nodes
//______________________________________________________________|
pub const C = @This();
pub const c = @This();
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const slate  = @import("../../slate.zig");
const proc   = @import("./C/proc.zig");
const source = slate.source;

//______________________________________
/// @descr
///  Converts the given *Slate {@arg N} Node into the C programming language.
///  The generated code will be appended to the {@arg result}.
pub fn render (
    N      : slate.Node,
    src    : source.Code,
    types  : slate.Type.List,
    result : *zstd.str,
  ) !void {
  switch (N) {
    .Proc => try proc.render(N, src, types, result),
  }
}

