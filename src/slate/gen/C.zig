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
const slate    = @import("../../slate.zig");
const proc     = @import("./C/proc.zig");
const variable = @import("./C/variable.zig");

fn todo (kind :zstd.cstr) !void { zstd.prnt("TODO:C Render TopLevel {s}\n", .{kind}); }

//______________________________________
/// @descr
///  Converts the given *Slate {@arg N} Node into the C programming language.
///  The generated code will be appended to the {@arg result}.
pub fn render (
    N       : slate.Node,
    src     : slate.source.Code,
    types   : slate.Type.List,
    pragmas : slate.Pragma.Store,
    args    : slate.Proc.Arg.Store,
    stmts   : slate.Stmt.Store,
    result  : *zstd.str,
  ) !void {
  const toplevel = true;
  switch (N) {
    .Proc => try proc.render(N, src, types, pragmas, args, stmts, result),
    .Var  => try variable.render(N, src, types, pragmas, toplevel, result),
    // else  => try C.todo("Unmapped Node for C Codegen"),
  }
} //:: Gen.C.render

