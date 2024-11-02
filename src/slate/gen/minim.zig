//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Zig code generation from *Slate Nodes
//______________________________________________________________|
pub const Minim = @This();
pub const minim = @This();
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const slate  = @import("../../slate.zig");
const source = slate.source;
const Node   = slate.Node;

//______________________________________
/// @descr
///  Converts the given *Slate {@arg N} Node into the Minim programming language.
///  The generated code will be appended to the {@arg result}.
pub fn render (
    N      : Node,
    src    : source.Code,
    types  : slate.Type.List,
    result : *zstd.str,
  ) !void {_=N; _=src; _=types;
  zstd.fail("TODO: UNIMPLEMENTED\n", .{});
  try result.appendSlice("TODO: UNIMPLEMENTED | Minim Codegen");
}

