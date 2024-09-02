//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps zstd
const zstd = @import("../../zstd.zig");

pub const Pragma = enum {
  pure, Inline, Noreturn,

  pub const List = struct {
    const Data = zstd.seq(Pragma);
    data :?Data,
  };
};

