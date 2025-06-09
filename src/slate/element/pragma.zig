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
  // Namespace/Module resolution
  import,

  const Id  = std.meta.Tag(Pragma);
  const Map = zstd.Map(Pragma.Id);
  const Kw  = Map.initComptime(.{
    // Types
    .{ "readonly",   Pragma.Id.readonly },
    // Procs
    .{ "pure",       Pragma.Id.pure     },
    .{ "inline",     Pragma.Id.Inline   },
    .{ "import",     Pragma.Id.import   },
    .{ "noreturn",   Pragma.Id.Noreturn },
  });

  pub fn from (name :cstr) Pragma { return switch (Pragma.Kw.get(name) orelse Pragma.Empty) {
    .Empty    => Pragma.Empty,
    // Types
    .readonly => Pragma.readonly,
    // Procs
    .pure     => Pragma.pure,
    .Inline   => Pragma.Inline,
    .import   => Pragma.import,
    .Noreturn => Pragma.Noreturn,
  };}

  pub const List  = zstd.UnorderedSet(Pragma);
  pub const Store = zstd.DataList(Pragma.List);
};

