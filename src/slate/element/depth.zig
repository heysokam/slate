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


//______________________________________
/// @descr Returns a {@link Depth} object with the default values assigned to it
pub fn default () Depth { return Depth{.indent= 0, .scope= Scope.Id.from(0)}; }

//______________________________________
/// @descr Returns whether or not indent/scope {@arg B} is contained within this scope
pub fn contains (A :*const Depth, B :Depth) bool {
  // Any scope contains itself, independent of indentation levels
  if (A.scope == B.scope)  return true;
  // One scope cannot contain another scope with higher id (ids are incremental)
  // and an indent lower than itself
  if (B.scope > A.scope and B.indent < A.indent) return false;
  // Otherwise, any scope with indent bigger than the reference
  // is considered to be contained in it
  if (A.indent >= B.indent) return true;
  // If all the above failed to match, then the scope is not contained
  return false;
}

//______________________________________
/// @descr Type used to represent the indentation amount/depth of this tag
pub const Level = source.Pos;
//______________________________________
/// @descr
///  Linear history of Depth levels found while processing.
///  Intended to be used as a stack, and directly managed by the owner
pub const History = std.ArrayListUnmanaged(Depth);

