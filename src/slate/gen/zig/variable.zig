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
      result   : *zstd.string,
    ) !void {_=src;_=pragmas;
    if (V.public and V.depth.scope == .Root) try result.add(kw.Pub++spc);
    if (!V.data.write) try result.add(kw.Const++spc)
    else               try result.add(kw.Var++spc);
  } //:: Gen.zig.variable.attributes.render
}; //:: Gen.zig.variable.attributes


const name = struct {
  fn render(
      V      : slate.Variable,
      src    : source.Code,
      result : *zstd.string,
    ) !void {
    try result.add(V.data.id.from(src));
  }
}; //:: Gen.zig.variable.name


const @"type" = struct {
  const start = base.colon;

  fn render(
      V      : slate.Variable,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string,
    ) !void {
    try result.add(spc++variable.type.start);
    try slate.type.render(types.at(V.data.type.?).?, src, types, V.data.write, result);
  } //:: Gen.zig.variable.type.render
}; //:: Gen.zig.variable.type


const assignment = struct {
  const start = base.eq;
  const end   = base.semicolon;

  fn render(
      V       : slate.Variable,
      src     : source.Code,
      pragmas : slate.Pragma.Store,
      result  : *zstd.string,
    ) !void {
    const hasAssignment = V.data.value != null and V.data.value.? != .Empty;
    if (hasAssignment) {
      try result.add(assignment.start++spc);
      try slate.expr.render(V.data.value.?, src, pragmas, result);
    }
    try result.add(assignment.end);
  } //:: Gen.zig.variable.assignment.render
}; //:: Gen.zig.variable.assignment


pub fn render (
    N        : slate.Node,
    src      : source.Code,
    types    : slate.Type.List,
    pragmas  : slate.Pragma.Store,
    result   : *zstd.string,
  ) !void {
  try variable.attributes.render(N.Var.Var, src, pragmas, result);
  try variable.name.render(N.Var.Var, src, result);
  try variable.type.render(N.Var.Var, src, types, result);
  try variable.assignment.render(N.Var.Var, src, pragmas, result);
} //:: Gen.zig.variable.render

