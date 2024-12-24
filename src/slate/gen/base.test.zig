//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/gen/base.zig
//___________________________________________________|
const t    = @import("../../tests.zig");
const base = @import("./base.zig");
const zstd = @import("../../zstd.zig");

test "gen.base.indent | should add the expected indentation based on {@arg N}" {
  const Tab  = "  ";
  const Text = "abcdefg";

  // Setup.1
  const Expected1 = Text ++ Tab;
  var src1 = zstd.str.init(t.A);
  defer src1.deinit();
  try src1.appendSlice(Text);
  // Check
  try base.indent(&src1, 1);
  const result1 = src1.items;
  try t.eq_str(result1, Expected1);

  // Setup.2
  const Expected2 = Text ++ Tab ++ Tab;
  var src2 = zstd.str.init(t.A);
  defer src2.deinit();
  try src2.appendSlice(Text);
  // Check
  try base.indent(&src2, 2);
  const result2 = src2.items;
  try t.eq_str(result2, Expected2);
}
