//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Zig codegen: Proc
//___________________________________|
pub const variable = @This();
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("../../../zstd.zig");
// @deps *Slate
const slate = struct {
  usingnamespace @import("../../../slate.zig");
  const @"type" = @import("./type.zig");
  const expr    = @import("./expression.zig");
};
const source  = slate.source;
const base    = @import("../base.zig");
const spc     = base.spc;
const Ptr     = base.Ptr;
const nl      = base.nl;
const indent  = base.indent;
const kw      = base.kw;

const attributes = struct {
  fn render (
      V        : slate.Variable,
      src      : source.Code,
      pragmas  : slate.Pragma.Store,
      toplevel : bool,
      result   : *zstd.string,
    ) !void {_=src;_=pragmas;
    if (toplevel and !V.public) try result.add(kw.Static++spc); // FIX: Extern declarations
    if (!V.data.write and !V.data.runtime) try result.add(kw.Constexpr++spc);
  } //:: Gen.C.variable.attributes.render
}; //:: Gen.C.variable.attributes


const name = struct {
  fn render(
      V      : slate.Variable,
      src    : source.Code,
      result : *zstd.string,
    ) !void {
    try result.add(V.data.id.from(src));
  }
}; //:: Gen.C.variable.name


const @"type" = struct {
  fn name (
      V      : slate.Variable,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string,
    ) !void {
    try slate.type.name(types.at(V.data.type.?).?, src, types, V.data.write, V.data.runtime, result);
  } //:: Gen.C.variable.type.render

  fn array (
      V      : slate.Variable,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string,
    ) !void {
    try slate.type.array(types.at(V.data.type.?).?, src, result);
  } //:: Gen.C.variable.type.render

}; //:: Gen.C.variable.type


const assignment = struct {
  const start = base.eq;
  const end   = base.semicolon;

  fn render(
      V       : slate.Variable,
      src     : source.Code,
      pragmas : slate.Pragma.Store,
      result  : *zstd.string,
    ) !void {
    if (V.data.value != null) {
      try result.add(spc++assignment.start++spc);
      try slate.expr.render(V.data.value.?, src, pragmas, result);
    }
    try result.add(assignment.end);
  } //:: Gen.C.variable.assignment.render
}; //:: Gen.C.variable.assignment


pub fn render (
    N        : slate.Node,
    src      : source.Code,
    types    : slate.Type.List,
    pragmas  : slate.Pragma.Store,
    toplevel : bool,
    result   : *zstd.string,
  ) !void {
  try variable.attributes.render(N.Var.Var, src, pragmas, toplevel, result);
  try variable.type.name(N.Var.Var, src, types, result);
  try variable.name.render(N.Var.Var, src, result);
  try variable.type.array(N.Var.Var, src, types, result);
  try variable.assignment.render(N.Var.Var, src, pragmas, result);
} //:: Gen.C.variable.render

