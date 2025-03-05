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
const kw     = base.kw;

fn isSlice (T :slate.Type.Array, src :source.Code) bool { return std.mem.eql(u8, T.count.?.from(src), "_"); }

pub fn render (
    T      : slate.Type,
    src    : source.Code,
    types  : slate.Type.List,
    write  : bool,
    result : *zstd.str,
  ) !void {
  // Array or Slice case. Takes {.readonly.} into account
  if (T.isArr()) {
    // FIX: C Arrays
    try result.append('[');
    const count = T.array.count.?.from(src);
    const slice = Type.isSlice(T.array, src);
    if (!slice) try result.appendSlice(count);
    try result.append(']');
    if (!write and slice) try result.appendSlice(kw.Const++spc);
    if (T.isPtr(types)) try result.appendSlice(Ptr);
    if (!T.isMut(types)) try result.appendSlice(kw.Const++spc);
  // Pointer case. Ignores {.readonly.}
  } else if (T.isPtr(types)) {
    try result.appendSlice(Ptr);
    if (!write) try result.appendSlice(kw.Const++spc);
  }
  // Add name
  const tName = T.getLoc(types);
  try result.appendSlice(tName.from(src));
} //:: slate.Gen.Type

