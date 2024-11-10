//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Minimal duplicate of `heysokam/zstd` tools, to not depend on any module.
//_________________________________________________________________________________________|
pub const zstd = @This();
// @deps std
const std = @import("std");
const Dir = std.fs.Dir;

//______________________________________
// @section Types
//____________________________
pub const todo        = ?u8;
pub const cstr        = []const u8;
pub const mstr        = []u8;
pub const seq         = std.ArrayList;
pub const List        = std.MultiArrayList;
pub const ByteBuffer  = zstd.str;
pub const Map         = std.StaticStringMap;
pub const StringTable = std.StringHashMap;

pub const str = Str.T;
pub const Str = struct {
  const T = zstd.seq(u8);
  pub fn from (S :cstr, A :std.mem.Allocator) !zstd.str {
    var result = try zstd.str.initCapacity(A, S.len);
    try result.appendSlice(S);
    return result;
  } //:: zstd.Str.from
}; //:: zstd.Str


pub fn Distinct (T :type) type { return enum(T) {
  None = switch (@TypeOf(T)) {
    .int, .comptime_int => std.math.maxInt(T),
    else => unreachable }, // FIX: Implement support for other types
  _,
  pub inline fn val (pos :*const @This()) T { return @intFromEnum(pos); }
  pub inline fn from (num :T) @This() { return @enumFromInt(num); }
  pub inline fn none (pos :*const @This()) bool { return pos == .None; }
  pub inline fn hasValue (pos :*const @This()) bool { return !pos.none(); }
};} //:: zstd.Distinct


//______________________________________
/// @descr Describes a growable list of arbitrary data that must be indexed with a Distinct(uint)
pub fn DataList2 (T :type, P :type) type { switch (@typeInfo(T)) {
    .int, .comptime_int => |t| if (t.int.signedness != .unsigned)
            @compileError("The integer type used for the Index/Position of the list MUST be unsigned."),
    else => @compileError("The type used for the Index/Position of the list MUST be an integer.")
  } return struct {
  const Uint = P;
  /// @descr Describes a location/position inside the list
  pub const Pos = zstd.Distinct(Uint);
  /// @descr Describes a growable list of arbitrary data
  pub const Entries = std.AutoArrayHashMapUnmanaged(@This().Pos, T);
  A        :std.mem.Allocator,
  entries  :Entries= .{},

  // @descr Creates a new empty DataList(T) object.
  pub fn create (A :std.mem.Allocator) @This() { return @This(){.A=A, .entries= Entries.init(A, &.{}, &.{})}; }
  // @descr Releases all memory used by the DataList(T)
  pub fn destroy (L :*@This()) void { L.entries.deinit(L.A); }
  // @descr Duplicates the data of the {@arg N} so that it is safe to call {@link DataList(T).destroy} without deallocating the duplicate.
  pub fn clone (L :*const @This()) !@This() { return @This(){.A=L.A, .entries= try L.entries.clone(L.A)}; }
  // @descr Adds the given {@arg val} to the {@arg L} DataList(T)
  pub fn add (L :*@This(), val :T) !void { try L.entries.put(L.A, @This().Pos.from(L.entries.entries.len), val); }
  // @descr Sets the item contained in {@arg L} at position {@arg pos} to the value of {@arg V}
  pub fn set (L :*const @This(), pos :@This().Pos, V :T) void { L.entries.put(L.A, pos, V); }
  // @descr Returns the list of items contained in {@arg L}. Returns an empty list otherwise.
  pub inline fn items (L :*const @This()) []T { return L.entries.values(); }
  // @descr Returns the item contained in {@arg L} at position {@arg pos}. Returns null otherwise.
  pub inline fn at (L :*const @This(), pos :@This().Pos) ?T { return L.entries.get(pos); }
  // @descr Returns true if the Node list has no nodes.
  pub inline fn empty (L :*const @This()) bool { return L.entries.entries.len == 0; }
  // @descr Returns the length of the list of items contained in {@arg L}.
  pub inline fn len (L :*const @This()) Uint { return L.entries.entries.len; }
  // @descr Returns the position/id of the last entry in the list of items contained in {@arg L}.
  pub inline fn last (L :*const @This()) @This().Pos { return @This().Pos.from(L.len()-1); }
};} //:: zstd.DataList
pub fn DataList (T :type) type { return DataList2(T, usize); }


//______________________________________
// @section Logging
//____________________________
pub const prnt = std.debug.print;
pub const fail = std.debug.panic;


//______________________________________
// @section File I/O
//____________________________
pub const files = struct {
  pub fn write (src :cstr, trg :cstr, args:struct{
      dir :Dir= std.fs.cwd(),
    }) !void {
    try args.dir.writeFile(.{.sub_path= trg, .data= src});
  } //:: zstd.files.write
}; //:: zstd.files


//______________________________________
// @section Set Aliases
//____________________________
/// @descr Describes a set[T] that doesn't maintain insertion order.
/// @todo Support for containing strings by conditionally returning an std.BufSet
/// @todo Rename to UnorderedSet and implement set as OrderedSet by default
pub const set = struct {
  pub fn Unordered (comptime T :type) type {
    return struct {
      data  :Data,
      const Data = std.AutoHashMap(T, void);
      pub const Iter = Data.KeyIterator;
      pub fn create   (A :std.mem.Allocator) @This() { return @This(){.data= std.AutoHashMap(T, void).init(A)}; }
      pub fn clone    (S :*const @This()) !@This() { return @This(){.data= try S.data.clone()}; }
      pub fn destroy  (S :*@This()) void { S.data.deinit(); }
      pub fn incl     (S :*@This(), val :T) !void { _ = try S.data.getOrPut(val); }
      pub fn excl     (S :*@This(), val :T)  void { _ = S.data.remove(val) ; }
      pub fn iter     (S :*const @This()) @This().Iter { return S.data.keyIterator(); }
      pub fn contains (S :*const @This(), val :T) bool { return S.data.contains(val); }
      pub fn has      (S :*const @This(), val :T) bool { return S.contains(val); }
    };
  } //:: zstd.set.Unordered
}; //:: zstd.set


//______________________________________
// @section Assertions
//____________________________
pub const ensure = zstd.validate.always;
pub const assert = zstd.validate.debug;
pub const validate = struct {
  pub fn always (cond :bool, msg :zstd.cstr) void {
    if (!cond) std.debug.panic("{s}\n", .{msg});
  } //:: zstd.validate.always

  pub fn debug (cond :bool, msg :zstd.cstr) void {
    if (!std.debug.runtime_safety) return;
    if (!cond) std.debug.panic("{s}\n", .{msg});
  } //:: zstd.validate.debug
}; //:: zstd.validate

