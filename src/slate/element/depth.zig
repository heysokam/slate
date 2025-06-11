//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Depth = @This();
// @deps slate
const source = @import("../source.zig");

/// @descr DepthLevel deciding what's in or out of scope
scope   :Depth.Level,
/// @descr
///  DepthLevel deciding increases/decreases in indentation.
///  For meaningful indentation tagging.
indent  :Depth.Level,

pub fn default () Depth { return Depth{.indent= 0, .scope= 0}; }

pub const Level = source.Pos;

