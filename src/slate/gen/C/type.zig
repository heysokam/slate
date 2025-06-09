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
    result  : *zstd.string,
  ) !void {
  const tName = T.getLoc(types);
  try result.add(tName.from(src));
  if (T.isPtr(types)) {
    if (!T.isMut(types)) try result.add(spc++kw.Const);
    try result.add(Ptr);
  }
  try result.add(spc);
  if (!write and runtime) {
    try result.add(kw.Const);
    try result.add(spc);
  }

  // if (T.isOpt()) try result.add(Opt);
  // // Array or Slice case. Takes {.readonly.} into account
  // if (T.isArr()) {
  //   // FIX: C Arrays
  //   // FIX: * Arrays
  //   try result.add_one('[');
  //   const slice = Type.isSlice(T.array, src);
  //   if (!slice) try result.add(T.array.count.?.from(src));
  //   try result.add_one(']');
  //   if (!write and slice) try result.add(kw.Const++spc);
  //   if (types.at(T.array.type).?.isOpt()) try result.add(Opt);
  //   if (T.isPtr(types)) try result.add(Ptr);
  //   if (!T.isMut(types)) try result.add(kw.Const++spc);
  // // Pointer case. Ignores {.readonly.}
  // } else if (T.isPtr(types)) {
  //   try result.add(Ptr);
  //   if (!write) try result.add(kw.Const++spc);
  // }
  // // Add name
  // const tName = T.getLoc(types);
  // try result.add(tName.from(src));
} //:: slate.Gen.C.type.name

pub fn array (
    T      : slate.Type,
    src    : source.Code,
    result : *zstd.string,
  ) !void {
  switch (T) { .array  => | t | {
    try result.add_one('[');
    const count = if (t.count != null) t.count.?.from(src) else "";
    if (!std.mem.eql(u8, count, "_")) try result.add(count);
    try result.add_one(']');
  }, else => {}}
} //:: slate.Gen.C.type

