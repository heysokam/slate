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


A          :std.mem.Allocator,
id_highest :Scope.Id,
history    :slate.Depth.History,


pub fn create (A :std.mem.Allocator) Scope { return Scope{
  .A          = A,
  .id_highest = Scope.Id.None,
  .history    = slate.Depth.History{},
};}

pub fn destroy (S :*const Scope) void {
  S.history.deinit(S.A);
  S.id_highest = Scope.Id.None;
  S.A          = undefined;
}

pub fn current (S :*Scope) slate.Depth { return S.history.items[S.history.items.len-1]; }
pub fn id_next (S :*Scope) void {
  S.id_highest = S.id_highest.next();
  return S.id_highest;
}

