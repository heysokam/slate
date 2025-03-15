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

fn isSlice (T :slate.Type.Array, src :source.Code) bool { return
  T.count == null or
  std.mem.eql(u8, T.count.?.from(src), "_");
}

pub fn name (
    T       : slate.Type,
    src     : source.Code,
    types   : slate.Type.List,
    write   : bool,
    runtime : bool,
    result  : *zstd.str,
  ) !void {
  const tName = T.getLoc(types);
  try result.appendSlice(tName.from(src));
  if (T.isPtr(types)) {
    if (!T.isMut(types)) try result.appendSlice(spc++kw.Const);
    try result.appendSlice(Ptr);
  }
  try result.appendSlice(spc);
  if (!write and runtime) {
    try result.appendSlice(kw.Const);
    try result.appendSlice(spc);
  }

  // if (T.isOpt()) try result.appendSlice(Opt);
  // // Array or Slice case. Takes {.readonly.} into account
  // if (T.isArr()) {
  //   // FIX: C Arrays
  //   // FIX: * Arrays
  //   try result.append('[');
  //   const slice = Type.isSlice(T.array, src);
  //   if (!slice) try result.appendSlice(T.array.count.?.from(src));
  //   try result.append(']');
  //   if (!write and slice) try result.appendSlice(kw.Const++spc);
  //   if (types.at(T.array.type).?.isOpt()) try result.appendSlice(Opt);
  //   if (T.isPtr(types)) try result.appendSlice(Ptr);
  //   if (!T.isMut(types)) try result.appendSlice(kw.Const++spc);
  // // Pointer case. Ignores {.readonly.}
  // } else if (T.isPtr(types)) {
  //   try result.appendSlice(Ptr);
  //   if (!write) try result.appendSlice(kw.Const++spc);
  // }
  // // Add name
  // const tName = T.getLoc(types);
  // try result.appendSlice(tName.from(src));
} //:: slate.Gen.C.type.name

pub fn array (
    T      : slate.Type,
    src    : source.Code,
    result : *zstd.str,
  ) !void {
  switch (T) { .array  => | t | {
    try result.append('[');
    const count = if (t.count != null) t.count.?.from(src) else "";
    if (!std.mem.eql(u8, count, "_")) try result.appendSlice(count);
    try result.append(']');
  }, else => {}}
} //:: slate.Gen.C.type

