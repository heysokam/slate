//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Codegen: Base Tools
//____________________________________|
pub const Ptr         = "*";
pub const Opt         = "?";
pub const Err         = "!";
pub const spc         = " ";
pub const tab         = spc++spc;
pub const nl          = "\n";
pub const semicolon   = ";";
pub const colon       = ":";
pub const eq          = "=";
pub const kw          = struct {
  pub const Pub       = "pub";
  pub const Func      = "fn";
  pub const Void      = "void";
  pub const Const     = "const";
  pub const Constexpr = "constexpr";
  pub const Var       = "var";
  pub const Return    = "return";
  pub const Static    = "static";
};

const zstd = @import("../../zstd.zig");
pub fn indent (result :*zstd.str, N :usize) !void {
  for (0..N) |_| try result.appendSlice(tab);
}

