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
const Pragma  = @import("./pragma.zig").Pragma;

pub const Type = union(enum) {
  any     :Type.Any,
  array   :Type.Array,
  number  :Type.Number,
  string  :Type.String,
  void    :Type.Void,
  pub const List = zstd.DataList(Type);

  /// @descr Arbitrary Type. For sending the type-checking responsibility to the target Lang compiler.
  pub const Any = struct {
    name    :source.Loc,
    mut     :bool=  false,  // FIX: Should not be here
    ptr     :bool=  false,  // FIX: Should not be here
    opt     :bool=  false,  // FIX: Should not be here
    pragma  :Pragma.Store.Pos= .None,
    pub fn create (name :source.Loc) Type { return Type{.any= Type.Any{.name= name} }; }
  }; //:: slate.Type.Any

  pub const Array = struct {
    type    :Type.List.Pos,
    count   :?source.Loc=  null,
    mut     :bool=         false,  // FIX: Should not be here
    ptr     :bool=         false,  // FIX: Should not be here
    opt     :bool=         false,  // FIX: Should not be here
    pragma  :Pragma.Store.Pos= .None,
    pub fn create (T :Node.List.Pos) Type { return Type{.array = Type.Array{.type= T}}; }
  }; //:: slate.Type.Array

  pub const Number = struct {
    size  :usize,
    mut   :bool=  false,  // FIX: Should not be here
    ptr   :bool=  false,  // FIX: Should not be here
    opt   :bool=  false,  // FIX: Should not be here
    kind  :Type.Number.Kind,
    pub const Kind = enum { signed, unsigned, float };
    pub fn create (size :usize) Type { return Type{.number= Type.Number{.size= size} }; }
  };

  pub const String = struct {
    kind  :Type.String.Kind,
    ptr   :bool=  false,  // FIX: Should not be here
    opt   :bool=  false,  // FIX: Should not be here
    pub const Kind = enum { normal, multiline, raw, char };
    pub fn create (kind :Type.String.Kind) Type { return Type{.string= Type.String{.kind= kind} }; }
  };

  pub const Void = struct { _:void=undefined,
    pub fn create () Type { return Type{.void= Type.Void{}}; }
  };

  pub fn isArr (T :?*const Type) bool {
    if (T == null) return false;
    return switch (T.?.*) {
      .any,
      .number,
      .string,
      .void   => false,
      .array  => true,  };
  } //:: slate.Type.isPtr

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

  pub fn isOpt (T :?*const Type) bool {
    if (T == null) return false;
    return switch (T.?.*) {
      .any    => | t | t.opt,
      .string => | t | t.opt,
      .number => | t | t.opt,
      .array  => | t | t.opt,
      .void   => false, };
  } //:: slate.Type.isMut

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

