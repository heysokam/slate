//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/gen/base.zig
//___________________________________________________|
const t = @import("../../tests.zig");
const base = @import("./base.zig");

test "should add the expected indentation based on {@arg N}" {
  const Text = "abcdefg";
  const Tab  = "  ";

  // Setup.1
  const Expected1 = Tab ++ Text;
  var src1 = @import("../../zstd.zig").str.init(@import("std").testing.allocator);
  defer src1.deinit();
  try src1.appendSlice(Tab);
  try src1.appendSlice(Text);
  // Check
  try base.indent(&src1, 1);
  const result1 = src1.items;
  try t.eq_str(result1, Expected1);

  // Setup.2
  const Expected2 = Tab ++ Tab ++ Text;
  var src2 = @import("../../zstd.zig").str.init(@import("std").testing.allocator);
  defer src2.deinit();
  try src2.appendSlice(Tab);
  try src2.appendSlice(Text);
  // Check
  try base.indent(&src2, 1);
  const result2 = src2.items;
  try t.eq_str(result2, Expected2);

}
