//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Zig code generation from *Slate Nodes
//______________________________________________________________|
pub const Zig = @This();
pub const zig = @This();
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const slate  = @import("../../slate.zig");
const proc   = @import("./zig/proc.zig");
const source = slate.source;

fn todo (kind :zstd.cstr) !void { zstd.prnt("TODO:zig Render TopLevel {s}\n", .{kind}); }

//______________________________________
/// @descr
///  Converts the given *Slate {@arg N} Node into the Zig programming language.
///  The generated code will be appended to the {@arg result}.
pub fn render (
    N       : slate.Node,
    src     : source.Code,
    types   : slate.Type.List,
    pragmas : slate.Pragma.Store,
    args    : slate.Proc.Arg.Store,
    stmts   : slate.Stmt.Store,
    result  : *zstd.str,
  ) !void {
  switch (N) {
    .Proc => try proc.render(N, src, types, pragmas, args, stmts, result),
    .Var  => try zig.todo("Variable"),
  }
}

