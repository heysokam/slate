//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
const base = @This();
// @deps std
const std = @import("std");


//______________________________________
/// @descr
///  Distinct Integer that identifies something uniquely
///  Can only identify, compare with others, or request a new id with `id.next()`
pub fn Id (comptime T :type) type { return enum(T) {
  pub const Base = T;
  Root = 0,
  None = std.math.maxInt(@This().Base),
  _,
  pub inline fn value (id :*const @This()) @This().Base { return @intFromEnum(id.*); }
  pub inline fn empty (id :*const @This()) bool { return id.* == .None; }
  pub inline fn eq    (id :*const @This(), B :@This()) bool { return id.value() == B.value(); }
  pub inline fn from  (num :anytype) @This() { return @enumFromInt(@as(@This().Base, @intCast(num))); }
  pub inline fn next  (id :*const @This()) @This() { return @This().from(
    if (id.empty()) 0 else id.value() + 1
  );}
};} //:: Base.Id

//______________________________________
// Aliases
pub const ScopeId = base.Id(u32);

