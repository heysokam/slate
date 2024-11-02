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

  pub fn from (name :cstr) Pragma {
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
};

