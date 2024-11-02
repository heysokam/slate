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

//______________________________________
/// @descr Describes a growable list of arbitrary data
pub fn DataList (T :type) type {
  return struct {
    /// @descr Describes a location/position inside the list
    pub const Pos = pos.type;
    const pos = struct {
      const @"type" = usize;
      /// @descr Describes an invalid location/position inside the list
      pub const Invalid :pos.type= std.math.maxInt(pos.type);
    };
    /// @descr Describes a growable list of arbitrary data
    pub const Entries = seq(T);
    entries :?Entries=  null,
    /// @descr Creates a new empty DataList(T) object.
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.entries= Entries.init(A)}; }
    /// @descr Releases all memory used by the DataList(T)
    pub fn destroy (L:*@This()) void { L.entries.?.deinit(); }
    /// @descr Returns true if the Node list has no nodes.
    pub fn empty (L:*const @This()) bool { return L.entries == null or L.entries.?.items.len == 0; }
    /// @descr Adds the given {@arg val} to the {@arg L} DataList(T)
    pub fn add (L :*@This(), val :T) !void { try L.entries.?.append(val); }
    /// @descr Duplicates the data of the {@arg N} so that it is safe to call {@link DataList(T).destroy} without deallocating the duplicate.
    pub fn clone (L :*const @This()) !@This() { return @This(){.entries= try L.entries.?.clone()}; }
    /// @descr Returns the list of items contained in {@arg L}. Returns an empty list otherwise.
    pub fn items (L :*const @This()) []T { return if (!L.empty()) L.entries.?.items else &.{}; }
    /// @descr Returns the length of the list of items contained in {@arg L}.
    pub fn len (L :*const @This()) @This().Pos { return if (!L.empty()) L.entries.?.items.len else @This().pos.Invalid; }
    /// @descr Returns the position/id of the last entry in the list of items contained in {@arg L}.
    pub fn last (L :*const @This()) @This().Pos { return if (!L.empty()) L.entries.?.items.len-1 else @This().pos.Invalid; }
    /// @descr Returns the item contained in {@arg L} at position {@arg P}. Returns null otherwise.
    pub fn at (L :*const @This(), P :@This().Pos) ?T { return if (!L.empty()) L.entries.?.items[P] else null; }
  };
} //:: zstd.DataList


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
  // pub fn set (comptime T :type) type {
    return struct {
      data  :Data,
      const Data = std.AutoHashMap(T, void);
      pub const Iter = Data.KeyIterator;
      pub fn create   (A :std.mem.Allocator) @This() { return @This(){.data= std.AutoHashMap(T, void).init(A)}; }
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

