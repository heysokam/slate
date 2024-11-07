//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview C codegen: Proc
//_________________________________|
pub const proc = @This();
// @deps zstd
const zstd = @import("../../../zstd.zig");
// @deps *Slate
const slate  = @import("../../../slate.zig");
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

  fn render (
      N      : slate.Node,
      src    : source.Code,
      result : *zstd.str,
    ) !void {_=src;
    // __attribute__((attr))   Attributes
    if (N.Proc.pure) try result.appendSlice(attributes.Const);
    if (N.Proc.pragmas != null) {
      if (N.Proc.pragmas.?.has(.pure)) try result.appendSlice(attributes.pure);
      // [[attr]]   Attributes
      if (N.Proc.pragmas.?.has(.Noreturn)) try result.appendSlice(attributes.Noreturn);
      // Keywords
      if (N.Proc.pragmas.?.has(.Inline)) try result.appendSlice(attributes.Inline);
    }
    if (!N.Proc.public) try result.appendSlice(attributes.static);
  } //:: Gen.proc.attributes.render
}; //:: Gen.proc.attributes

const returnT = struct {
  fn render (
      N      : slate.Node,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.str,
    ) !void {
    if (N.Proc.retT == null) { try result.appendSlice(kw.Void); return; }
    const retT = types.at(N.Proc.retT.?);
    if (retT == null) return error.genC_Proc_ReturnTypeMustExistWhenDeclared;
    const tName = retT.?.getLoc(types);
    if (tName.valid()) try result.appendSlice(src[tName.start..tName.end]);
    if (retT.?.isPtr(types)) try result.appendSlice(Ptr);
    try result.appendSlice(spc);
  } //:: Gen.proc.returnT.render
}; //:: Gen.proc.returnT

const name = struct {
  // name  :Func.Name,
  fn render (
      N      : slate.Node,
      src    : source.Code,
      result : *zstd.str,
    ) !void {
    try result.appendSlice(N.Proc.name.from(src));
  } //:: Gen.proc.name.render
}; //:: Gen.proc.name

const args = struct {
  const start = "(";
  const end   = ")";
  const sep   = ", ";
  fn last (N :slate.Node, id :usize) bool { return N.Proc.args.?.entries.?.items.len == 1 or id == N.Proc.args.?.entries.?.items.len-1; }

  fn typ (
      N      : slate.Node,
      arg    : slate.Data,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.str
    ) !void {_=N;
    if (arg.type == null) return error.genC_Proc_ArgumentsMustHaveTypes;
    const argT = types.at(arg.type.?);
    if (argT == null) return error.genC_Proc_ArgumentsMustHaveTypes;
    const tName = argT.?.getLoc(types);
    try result.appendSlice(tName.from(src));
    try result.appendSlice(spc);
    if (argT.?.isPtr(types)) {
      if (!argT.?.isMut(types)) try result.appendSlice(kw.Const++spc);
      try result.appendSlice(Ptr);
      try result.appendSlice(spc);
    }
    if (!arg.write) {
      try result.appendSlice(kw.Const);
      try result.appendSlice(spc);
    }
  }
  fn name (
      N      : slate.Node,
      arg    : slate.Data,
      src    : source.Code,
      result : *zstd.str
    ) !void {_=N;
    try result.appendSlice(arg.id.from(src));
  }

  fn render (
      N      : slate.Node,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.str,
    ) !void {
    try result.appendSlice(start);
    if (N.Proc.args == null) { try result.appendSlice(kw.Void); try result.appendSlice(end); return; }
    for (N.Proc.args.?.entries.?.items, 0..) |arg, id| {
      try proc.args.typ( N, arg, src, types, result);
      try proc.args.name(N, arg, src, result);
      if (!args.last(N,id)) try result.appendSlice(args.sep);
    }
    try result.appendSlice(end);
  } //:: Gen.proc.args.render
}; //:: Gen.proc.args

const body = struct {
  const proto = struct {
    const end = base.end;
  };
  const def = struct {
    const start = "{";
    const end   = "}";
  };
  fn oneline (N :slate.Node) bool { return N.Proc.body != null and N.Proc.body.?.items().len == 1; }
  fn newline (N :slate.Node, result :*zstd.str) !void {
    if (body.oneline(N)) { try result.appendSlice(spc); }
    else                 { try result.appendSlice(nl ); }
  }
  fn start (N :slate.Node, result :*zstd.str) !void {
    try result.appendSlice(spc);
    try result.appendSlice(def.start);
    try proc.body.newline(N, result);
  }
  fn end (N :slate.Node, result :*zstd.str) !void {_=N;
    try result.appendSlice(def.end);
  }

  const stmt = struct {
    const end = base.end;
    fn render (
        N      : slate.Node,
        S      : slate.Stmt,
        src    : source.Code,
        result : *zstd.str,
      ) !void {
      if (!oneline(N)) try indent(result, 1);  // TODO: Deeper indentation
      // FIX: Hardcoded  return N
      try result.appendSlice(kw.Return);
      switch (S.Retrn.body.?) {
        .Lit => {
          try result.appendSlice(spc);
          try result.appendSlice(S.Retrn.body.?.Lit.Intgr.loc.from(src)); },
        .Empty => {},
        }
      try result.appendSlice(body.stmt.end);
      try newline(N, result);
    } //:: Gen.proc.body.stmt.render
  }; //:: Gen.proc.body.stmt

  fn render (
      N      : slate.Node,
      src    : source.Code,
      result : *zstd.str,
    ) !void {
    if (N.Proc.body == null) { try result.appendSlice(proto.end); return; }
    try proc.body.start(N, result);
    for (N.Proc.body.?.items()) |S| try proc.body.stmt.render(N, S, src, result);
    try proc.body.end(N, result);
  } //:: Gen.proc.body.render
}; //:: Gen.proc.body


const std = @import("std");
pub fn render (
    N      : slate.Node,
    src    : source.Code,
    types  : slate.Type.List,
    result : *zstd.str,
  ) !void {
  try attributes.render(N, src, result);
  try returnT.render(N, src, types, result);
  try name.render(N, src, result);
  try args.render(N, src, types, result);
  try body.render(N, src, result);
} //:: Gen.C.proc.render

