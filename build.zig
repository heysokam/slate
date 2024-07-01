//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub fn build(b: *@import("std").Build) void {
  _ = b.addModule("slate", .{
    .root_source_file = .{ .path = "src/zig/slate.zig" },
    .target           = b.standardTargetOptions(.{}),
    .optimize         = b.standardOptimizeOption(.{}),
   });
}

