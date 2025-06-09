//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview C codegen: Proc
//_________________________________|
pub const proc = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../../zstd.zig");
// @deps *Slate
const slate  = struct {
  usingnamespace @import("../../../slate.zig");
  const @"type" = @import("./type.zig");
};
const source = slate.source;
const base   = @import("../base.zig");
const spc    = base.spc;
const Ptr    = base.Ptr;
const nl     = base.nl;
const indent = base.indent;
const kw     = base.kw;

const attributes = struct {
  const pfx          = "__attribute__((";
  const sfx          = "))";
  const pure         = pfx ++ "pure"     ++ sfx ++ spc;
  const Const        = pfx ++ "const"    ++ sfx ++ spc;
  const noreturn_GNU = pfx ++ "noreturn" ++ sfx ++ spc;
  const Noreturn     = "[[noreturn]]" ++ spc;
  const noreturn_C11 = "_Noreturn" ++ spc;
  const static       = "static" ++ spc;
  const Inline       = "inline" ++ spc;
  const Extern       = "extern" ++ spc;

  fn render (
      N      : slate.Node,
      src    : source.Code,
      data   : slate.Pragma.Store,
      result : *zstd.string,
    ) !void {_=src;
    // __attribute__((attr))   Attributes
    if (N.Proc.pure) try result.add(attributes.Const);
    if (N.Proc.pragmas != .None) {
      const pragmas = data.at(N.Proc.pragmas).?;
      if (pragmas.has(.pure)) try result.add(attributes.pure);
      // [[attr]]   Attributes
      if (pragmas.has(.Noreturn)) try result.add(attributes.Noreturn);
      // Keywords
      // if (pragmas.has(.import)) try result.add(attributes.Extern);
      if (pragmas.has(.Inline)) try result.add(attributes.Inline);
    }
    if (!N.Proc.public) try result.add(attributes.static);
  } //:: Gen.C.proc.attributes.render
}; //:: Gen.C.proc.attributes

const returnT = struct {
  fn render (
      N      : slate.Node,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string,
    ) !void {
    if (N.Proc.ret.type == .None) { try result.add(kw.Void); return; }
    if (types.at(N.Proc.ret.type) == null) return error.slate_gen_C_Proc_ReturnTypeMustExistWhenDeclared;
    const retT :slate.Type= types.at(N.Proc.ret.type).?;
    const tName = retT.getLoc(types);
    if (tName.valid()) try result.add(tName.from(src));
    if (retT.isPtr(types)) {
      if (!retT.isMut(types)) try result.add(spc++kw.Const);
      try result.add(Ptr);
    }
    try result.add(spc);
  } //:: Gen.C.proc.returnT.render
}; //:: Gen.C.proc.returnT

const name = struct {
  fn render (
      N      : slate.Node,
      src    : source.Code,
      result : *zstd.string,
    ) !void {
    try result.add(N.Proc.name.from(src));
    try result.add(spc);
  } //:: Gen.C.proc.name.render
}; //:: Gen.C.proc.name

const args = struct {
  const start = "(";
  const end   = ")";
  const sep   = ", ";
  fn last (list :[]slate.Proc.Arg, id :usize) bool { return list.len == 1 or id == list.len-1; }

  fn @"type" (
      arg    : slate.Data,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string
    ) !void {
    if (arg.type == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    if (types.at(arg.type.?) == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    try slate.type.name(types.at(arg.type.?).?, src, types, arg.write, arg.runtime, result);
  } //:: Gen.C.proc.args.type

  fn name (
      arg    : slate.Data,
      src    : source.Code,
      result : *zstd.string
    ) !void {
    try result.add(arg.id.from(src));
  } //:: Gen.C.proc.args.name

  fn array (
      arg    : slate.Data,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.string
    ) !void {
    if (arg.type == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    if (types.at(arg.type.?) == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    try slate.type.array(types.at(arg.type.?).?, src, result);
  } //:: Gen.C.proc.args.array

  fn render (
      N        : slate.Node,
      src      : source.Code,
      types    : slate.Type.List,
      argsData : slate.Proc.ArgStore,
      result   : *zstd.string,
    ) !void {
    try result.add(start);
    if (N.Proc.args == .None) { try result.add(kw.Void); try result.add(args.end); return; }
    const list = argsData.at(N.Proc.args).?.items();
    for (list, 0..) |arg, id| {
      try proc.args.type(arg, src, types, result);
      try proc.args.name(arg, src, result);
      try proc.args.array(arg, src, types, result);
      if (!args.last(list,id)) try result.add(args.sep);
    }
    try result.add(args.end);
  } //:: Gen.C.proc.args.render
}; //:: Gen.C.proc.args

const body = struct {
  const proto = struct {
    const end = base.semicolon;
  };
  const def = struct {
    const start = "{";
    const end   = "}";
  };

  fn oneline (
      N        : slate.Node,
      bodyData : slate.Proc.BodyStore,
    ) bool { return
    N.Proc.body != .None
    and bodyData.at(N.Proc.body).?.items().len == 1;
  }

  fn newline (
      N        : slate.Node,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.string
    ) !void {
    if (body.oneline(N, bodyData)) { try result.add(spc); }
    else                           { try result.add(nl ); }
  }

  fn start (
      N        : slate.Node,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.string
    ) !void {
    try result.add(spc);
    try result.add(def.start);
    try proc.body.newline(N, bodyData, result);
  }

  fn end (N :slate.Node, result :*zstd.string) !void {_=N;
    try result.add(def.end);
  }

  const stmt = struct {
    const end = base.semicolon;
    fn render (
        N        : slate.Node,
        S        : slate.Stmt,
        bodyData : slate.Proc.BodyStore,
        src      : source.Code,
        result   : *zstd.string,
      ) !void {
      if (!oneline(N, bodyData)) try indent(result, 1);  // TODO: Deeper indentation
      // FIX: Hardcoded  return N
      try result.add(kw.Return);
      switch (S.Retrn.body orelse .Empty) {
        .Lit => {
          try result.add(spc);
          try result.add(S.Retrn.body.?.Lit.Intgr.loc.from(src)); },
        .Empty => {},
        }
      try result.add(body.stmt.end);
      try newline(N, bodyData, result);
    } //:: Gen.C.proc.body.stmt.render
  }; //:: Gen.C.proc.body.stmt

  fn render (
      N        : slate.Node,
      src      : source.Code,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.string,
    ) !void {
    if (N.Proc.body == .None) { try result.add(proto.end); return; }
    try proc.body.start(N, bodyData, result);
    for (bodyData.at(N.Proc.body).?.items()) |S| try proc.body.stmt.render(N, S, bodyData, src, result);
    try proc.body.end(N, result);
  } //:: Gen.C.proc.body.render
}; //:: Gen.C.proc.body


pub fn render (
    N        : slate.Node,
    src      : source.Code,
    types    : slate.Type.List,
    pragmas  : slate.Pragma.Store,
    argsData : slate.Proc.Arg.Store,
    bodyData : slate.Proc.BodyStore,
    result   : *zstd.string,
  ) !void {
  try proc.attributes.render(N, src, pragmas, result);
  try proc.returnT.render(N, src, types, result);
  try proc.name.render(N, src, result);
  try proc.args.render(N, src, types, argsData, result);
  try proc.body.render(N, src, bodyData, result);
} //:: Gen.C.proc.render

