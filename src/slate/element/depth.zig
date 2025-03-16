//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Depth = @This();
// @deps slate
const source = @import("../source.zig");

/// @descr Level used to decide what's in or out of scope
scope   :Depth.Level,
/// @descr
///  Level used to decide increases/decreases in indentation.
///  Used to for meaningful indentation tagging.
indent  :Depth.Level,

pub fn default () Depth { return Depth{.indent= 0, .scope= 0}; }

pub const Level = source.Pos;
