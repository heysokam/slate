//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;

pub const Pragma = union(enum) {
  Empty,
  // Types
  readonly,
  // Procs
  pure, Inline, Noreturn,

  const Id  = std.meta.Tag(Pragma);
  const Map = zstd.Map(Pragma.Id);
  const Kw  = Map.initComptime(.{
    // Types
    .{ "readonly",   Pragma.Id.readonly },
    // Procs
    .{ "pure",       Pragma.Id.pure     },
    .{ "inline",     Pragma.Id.Inline   },
    .{ "noreturn",   Pragma.Id.Noreturn },
  });

  pub fn new (name :cstr) Pragma {
    switch (Pragma.Kw.get(name) orelse Pragma.Empty) {
      .Empty    => return Pragma.Empty,
      // Types
      .readonly => return Pragma.readonly,
      // Procs
      .pure     => return Pragma.pure,
      .Inline   => return Pragma.Inline,
      .Noreturn => return Pragma.Noreturn,
    }
  }

  pub const List = zstd.set.Unordered(Pragma);
  // pub const List = struct {
  //   const Data = zstd.set.Unordered(Pragma);
  //   data :?Data,
  //   pub fn create (A :std.mem.Allocator) @This() { return @This(){.data= Data.create(A)}; }
  //   pub fn add (L :*Pragma.List, val :Pragma) !void { try L.data.?.incl(val); }
  //   pub fn has (L :*Pragma.List, val :Pragma) bool { return L.data != null and L.data.?.contains(val); }
  // };
};

