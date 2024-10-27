//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Minimal duplicate of `heysokam/zstd` tools, to not depend on any module.
//_________________________________________________________________________________________|
// @deps std
const std = @import("std");
const Dir = std.fs.Dir;

//______________________________________
// @section Types
//____________________________
pub const todo        = ?u8;
pub const cstr        = []const u8;
pub const seq         = std.ArrayList;
pub const str         = seq(u8);
pub const List        = std.MultiArrayList;
pub const ByteBuffer  = str;
pub const Map         = std.StaticStringMap;
pub const StringTable = std.StringHashMap;


pub fn DataList (T :type) type {
  return struct {
    pub const Entries = seq(T);
    entries :?Entries=  null,
    pub fn create (A :std.mem.Allocator) @This() { return @This(){.entries= Entries.init(A)}; }
    pub fn add (L :*@This(), val :T) !void { try L.entries.?.append(val); }
  };
}

//______________________________________
// @section Logging
//____________________________
pub const prnt = std.debug.print;
pub const fail = std.debug.panic;


pub const files = struct {
  pub fn write (src :cstr, trg :cstr, args:struct{
      dir :Dir= std.fs.cwd(),
    }) !void {
    try args.dir.writeFile(.{.sub_path= trg, .data= src});
  }
};

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
  }
};

