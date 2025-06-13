//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Scope = @This();
// @deps std
const std = @import("std");
// @deps slate
const slate = struct {
  const Depth = @import("./depth.zig");
};
pub const Id = @import("./base.zig").ScopeId;


/// @private
/// @descr Allocator used to manage the Scope's internal data
A          :std.mem.Allocator,
/// @private
/// @descr Highest Scope.Id ever seen by this Scope
id_highest :Scope.Id,
/// @private
/// @descr Stack-like container, used to track currently active scopes.
history    :slate.Depth.History,


//______________________________________
/// @descr
///  Returns a Scope object with default (uninitialized) values.
///  The user is expected to call {@link Scope.init} on the result.
pub fn create (A :std.mem.Allocator) Scope { return Scope{
  .A          = A,
  .id_highest = Scope.Id.None,
  .history    = slate.Depth.History{},
};}

//______________________________________
/// @descr Deallocates all data contained in the given {@arg S} Scope.
pub fn destroy (S :*Scope) void {
  S.history.deinit(S.A);
  S.id_highest = Scope.Id.None;
  S.A          = undefined;
}

//______________________________________
/// @descr
///  Initializes the {@arg S} Scope's History and highest Id,
///  such that it can register and compare scopes with other scopes.
pub fn init (S :*Scope, indent :slate.Depth.Level) !void {
  try S.history.append(S.A, slate.Depth{
    .indent = indent,
    .scope  = S.id_highest.next()
  });
  S.id_highest = S.current().scope;
}

//______________________________________
/// @descr Updates the highest Id tracked by the Scope's history, and returns its resulting value
pub fn id_next (S :*Scope) Scope.Id {
  S.id_highest = S.id_highest.next();
  return S.id_highest;
}

//______________________________________
/// @descr Returns the last entry of this Scope's History
pub fn current (S :*const Scope) slate.Depth { return S.history.items[S.history.items.len-1]; }

//______________________________________
/// @descr Creates a new Scope entry with the given {@arg indent} level and adds it to the History
pub fn increase (S :*Scope, indent :slate.Depth.Level) !void {
  try S.history.append(S.A, slate.Depth{
    .indent = indent,
    .scope  = S.id_next()
  });
}

//______________________________________
/// @descr
///  Returns whether or not the given {@arg indent} should trigger a scope decrease
///  Any indentation level lower than the {@arg scope} indent level will trigger a decrease.
pub fn should_decrease (S :*const Scope, indent :slate.Depth.Level) bool {
  if (S.history.items.len == 0) return false;
  return S.current().indent > indent;
}

//______________________________________
/// @descr
///  Removes the last scope entry from the History,
///  until a matching scope is found
pub fn decrease (S :*Scope, indent :slate.Depth.Level) !void {
  if (S.history.items.len == 0) return error.Scope_decrease_history_isEmpty;
  while (S.should_decrease(indent)) _= S.history.pop() orelse break;
}

