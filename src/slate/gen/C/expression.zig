//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Zig codegen: Type
//___________________________________|
pub const @"type" = @This();
const Type = @This();
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("../../../zstd.zig");
// @deps *Slate
const slate  = @import("../../../slate.zig");
const source = slate.source;
const base   = @import("../base.zig");
const spc    = base.spc;
const Ptr    = base.Ptr;
const Opt    = base.Opt;
const kw     = base.kw;

pub fn render (
    S        : slate.Expr,
    src      : source.Code,
    pragmas  : slate.Pragma.Store,
    result   : *zstd.str,
  ) !void {_=pragmas;
  // FIX: Remove hardcoded Int Literal
  try result.appendSlice(S.Lit.Intgr.loc.from(src));
} //:: Gen.C.expression.render

