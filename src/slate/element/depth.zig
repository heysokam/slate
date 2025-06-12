//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Depth = @This();
// @deps std
const std = @import("std");
// @deps slate
const source  = @import("../source.zig");
const Scope = struct { // Cyclic Dependency otherwise
  const Id = @import("./base.zig").ScopeId;
};


/// @descr Identifier for deciding what's in or out of scope
scope   :Scope.Id,
/// @descr
///  DepthLevel deciding increases/decreases in indentation.
///  For meaningful indentation tagging.
indent  :Depth.Level,

pub fn default () Depth { return Depth{.indent= 0, .scope= Scope.Id.from(0)}; }


//______________________________________
/// @descr Type used to represent the indentation amount/depth of this tag
pub const Level = source.Pos;
//______________________________________
/// @descr
///  Linear history of Depth levels found while processing.
///  Intended to be used as a stack, and directly managed by the owner
pub const History = std.ArrayListUnmanaged(Depth);

