//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Describes a Generic Data type
//______________________________________________|
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Node    = @import("./node.zig").Node;
const source  = @import("../source.zig").source;
const Pragmas = @import("./pragma.zig").Pragma.List;

pub const Type = union(enum) {
  any     :Type.Any,
  array   :Type.Array,
  number  :Type.Number,
  string  :Type.String,
  void    :Type.Void,

  pub const List  = Type.list.type;
  pub const list  = struct {
    const @"type" = zstd.DataList(Type);
    pub const Pos = Type.list.type.Pos;
  };

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Any = struct {
    name    :source.Loc,
    mut     :bool=      false,  // FIX: Should not be here
    ptr     :bool=      false,  // FIX: Should not be here
    pragma  :?Pragmas=  null,
    pub fn create (name :source.Loc) Type { return Type{.any= Type.Any{.name= name} }; }
  }; //:: slate.Type.Any

  pub const Array = struct {
    type    :Type.List.Pos,
    count   :?source.Loc=  null,
    mut     :bool=         false,  // FIX: Should not be here
    ptr     :bool=         false,  // FIX: Should not be here
    pragma  :?Pragmas=     null,

    pub fn create (T :Node.List.Pos) Type { return Type{.array = Type.Array{.type= T}}; }

    pub fn destroy(arr :*Type.Array) void {
      if (arr.pragma != null) arr.pragma.?.destroy();
    } //:: slate.Type.Array.destroy
  }; //:: slate.Type.Array

  pub const Number = struct {
    size  :usize,
    mut   :bool=  false,  // FIX: Should not be here
    ptr   :bool=  false,  // FIX: Should not be here
    kind  :Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
    pub fn create (size :usize) Type { return Type{.number= Type.Number{.size= size} }; }
    // pub fn name (N :*const Type.Number, A :std.mem.Allocator) !zstd.str {
    //   var result = zstd.str.init(A);
    //   try result.appendSlice(@tagName(N.kind));
    //   const size = try std.fmt.allocPrint(A, ".{d}", .{N.size});
    //   defer A.free(size);
    //   try result.appendSlice(size);
    //   return result;
    // }
  };

  pub const String = struct {
    kind  :Type.String.Kind,
    ptr   :bool=  false,  // FIX: Should not be here
    pub const Kind = enum { normal, multiline, raw, char };
    pub fn create (kind :Type.String.Kind) Type { return Type{.string= Type.String{.kind= kind} }; }
    // pub fn name (S :*const Type.String, A :std.mem.Allocator) !zstd.str {
    //   return switch (S.kind) {
    //     .char => try zstd.Str.from(@tagName(S.kind), A),
    //     else  => blk: {
    //       const N = "string.";
    //       var result = try zstd.str.initCapacity(A, N.len);
    //       result.appendSliceAssumeCapacity(N);
    //       try result.appendSlice(@tagName(S.kind));
    //       break :blk result;
    //       },
    //   };
    // }
  };

  pub const Void = struct { _:void=undefined,
    pub fn create () Type { return Type{.void= Type.Void{}}; }
    // pub fn name (_:*const Type.Void, A :std.mem.Allocator) !zstd.str { return zstd.Str.from("void", A); }
  };

  //______________________________________
  /// @descr Deallocates all data of {@arg T} when its subtype has any data to deallocate.
  pub fn destroy (T:*Type) void {
    switch (T.*) {
      .array  => T.array.destroy(),
      .any    => {},
      .number => {},
      .string => {},
      .void   => {},
      }
  } //:: slate.Type.Array.destroy

  //______________________________________
  /// @descr Returns a newly allocated {@link zstd.str} containing the value of {@arg T}.name
  /// @note
  ///  Will not use the {@arg A} allocator to create the string when {@arg T} is ...
  ///  - {@link Type.any} subtype
  ///  - {@link Type.array} subtype and its contained type (recursive) is of the {@link Type.any} subtype
  // pub fn getName (T :*const Type, A :std.mem.Allocator) !zstd.str {
  //   return switch (T.*) {
  //     .any    => | t | t.name.clone(),
  //     .number => | t | t.name(A),
  //     .string => | t | t.name(A),
  //     .void   => | t | t.name(A),
  //     .array  => | t | t.type.getName(A),
  //   };
  // } //:: slate.Type.getName

  pub fn isMut (T :?*const Type, L :Type.List) bool {
    if (T == null) return false;
    return switch (T.?.*) {
      .any    => | t | t.mut,
      .number => | t | t.mut,
      .array  => | t | Type.isMut(&L.at(t.type).?, L),
      .string => false,  // TODO: string primitive ? maybe ?
      .void   => false, };
  } //:: slate.Type.isMut

  pub fn isPtr (T :?*const Type, L :Type.List) bool {
    if (T == null) return false;
    return switch (T.?.*) {
      .any    => | t | t.ptr,
      .number => | t | t.ptr,
      .string => | t | t.ptr,
      .array  => | t | Type.isPtr(&L.at(t.type).?, L),
      .void   => false, };
  } //:: slate.Type.isPtr

  pub fn getLoc (T :?*const Type, L :Type.List) source.Loc {
    if (T == null) return source.Loc{};
    return switch (T.?.*) {
      .any    => | t | t.name,
      .array  => | t | Type.getLoc(&L.at(t.type).?, L),
      .number => .{},
      .string => .{},
      .void   => .{}, };
  } //:: slate.Type.getLoc
}; //:: slate.Type

