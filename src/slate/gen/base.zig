//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Codegen: Base Tools
//____________________________________|
pub const Ptr      = "*";
pub const spc      = " ";
pub const tab      = spc++spc;
pub const nl       = "\n";
pub const end      = ";";
pub const kw       = struct {
  pub const Void   = "void";
  pub const Return = "return";
  pub const Const  = "const";
};

const zstd = @import("../../zstd.zig");
pub fn indent (result :*zstd.str, N :usize) !void {
  for (0..N) |_| try result.appendSlice(tab);
}

