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
  const Extern       = "extern" ++ spc;

  fn render (
      N      : slate.Node,
      src    : source.Code,
      data   : slate.Pragma.Store,
      result : *zstd.str,
    ) !void {_=src;
    // __attribute__((attr))   Attributes
    if (N.Proc.pure) try result.appendSlice(attributes.Const);
    if (N.Proc.pragmas != .None) {
      const pragmas = data.at(N.Proc.pragmas).?;
      if (pragmas.has(.pure)) try result.appendSlice(attributes.pure);
      // [[attr]]   Attributes
      if (pragmas.has(.Noreturn)) try result.appendSlice(attributes.Noreturn);
      // Keywords
      // if (pragmas.has(.import)) try result.appendSlice(attributes.Extern);
      if (pragmas.has(.Inline)) try result.appendSlice(attributes.Inline);
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
    if (N.Proc.ret.type == .None) { try result.appendSlice(kw.Void); return; }
    if (types.at(N.Proc.ret.type) == null) return error.slate_gen_C_Proc_ReturnTypeMustExistWhenDeclared;
    const retT :slate.Type= types.at(N.Proc.ret.type).?;
    const tName = retT.getLoc(types);
    if (tName.valid()) try result.appendSlice(tName.from(src));
    if (retT.isPtr(types)) {
      if (!retT.isMut(types)) try result.appendSlice(spc++kw.Const);
      try result.appendSlice(Ptr);
    }
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
    try result.appendSlice(spc);
  } //:: Gen.proc.name.render
}; //:: Gen.proc.name

const args = struct {
  const start = "(";
  const end   = ")";
  const sep   = ", ";
  fn last (list :[]slate.Proc.Arg, id :usize) bool { return list.len == 1 or id == list.len-1; }

  fn @"type" (
      arg    : slate.Data,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.str
    ) !void {
    if (arg.type == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    if (types.at(arg.type.?) == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    const argT :slate.Type= types.at(arg.type.?).?;
    const tName = argT.getLoc(types);
    try result.appendSlice(tName.from(src));
    if (argT.isPtr(types)) {
      if (!argT.isMut(types)) try result.appendSlice(spc++kw.Const);
      try result.appendSlice(Ptr);
    }
    try result.appendSlice(spc);
    if (!arg.write) {
      try result.appendSlice(kw.Const);
      try result.appendSlice(spc);
    }
  } //:: Gen.proc.args.type

  fn name (
      arg    : slate.Data,
      src    : source.Code,
      result : *zstd.str
    ) !void {
    try result.appendSlice(arg.id.from(src));
  } //:: Gen.proc.args.name

  fn array (
      arg    : slate.Data,
      src    : source.Code,
      types  : slate.Type.List,
      result : *zstd.str
    ) !void {
    if (arg.type == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    const argT = types.at(arg.type.?);
    if (argT == null) return error.slate_gen_C_Proc_ArgumentsMustHaveTypes;
    switch (argT.?) { .array  => | t | {
      try result.append('[');
      const count = if (t.count != null) t.count.?.from(src) else "";
      if (!std.mem.eql(u8, count, "_")) try result.appendSlice(count);
      try result.append(']');
    }, else => {}}
  } //:: Gen.proc.args.array

  fn render (
      N        : slate.Node,
      src      : source.Code,
      types    : slate.Type.List,
      argsData : slate.Proc.ArgStore,
      result   : *zstd.str,
    ) !void {
    try result.appendSlice(start);
    if (N.Proc.args == .None) { try result.appendSlice(kw.Void); try result.appendSlice(args.end); return; }
    const list = argsData.at(N.Proc.args).?.items();
    for (list, 0..) |arg, id| {
      try proc.args.type(arg, src, types, result);
      try proc.args.name(arg, src, result);
      try proc.args.array(arg, src, types, result);
      if (!args.last(list,id)) try result.appendSlice(args.sep);
    }
    try result.appendSlice(args.end);
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
      result   : *zstd.str
    ) !void {
    if (body.oneline(N, bodyData)) { try result.appendSlice(spc); }
    else                           { try result.appendSlice(nl ); }
  }

  fn start (
      N        : slate.Node,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.str
    ) !void {
    try result.appendSlice(spc);
    try result.appendSlice(def.start);
    try proc.body.newline(N, bodyData, result);
  }

  fn end (N :slate.Node, result :*zstd.str) !void {_=N;
    try result.appendSlice(def.end);
  }

  const stmt = struct {
    const end = base.end;
    fn render (
        N        : slate.Node,
        S        : slate.Stmt,
        bodyData : slate.Proc.BodyStore,
        src      : source.Code,
        result   : *zstd.str,
      ) !void {
      if (!oneline(N, bodyData)) try indent(result, 1);  // TODO: Deeper indentation
      // FIX: Hardcoded  return N
      try result.appendSlice(kw.Return);
      switch (S.Retrn.body orelse .Empty) {
        .Lit => {
          try result.appendSlice(spc);
          try result.appendSlice(S.Retrn.body.?.Lit.Intgr.loc.from(src)); },
        .Empty => {},
        }
      try result.appendSlice(body.stmt.end);
      try newline(N, bodyData, result);
    } //:: Gen.proc.body.stmt.render
  }; //:: Gen.proc.body.stmt

  fn render (
      N        : slate.Node,
      src      : source.Code,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.str,
    ) !void {
    if (N.Proc.body == .None) { try result.appendSlice(proto.end); return; }
    try proc.body.start(N, bodyData, result);
    for (bodyData.at(N.Proc.body).?.items()) |S| try proc.body.stmt.render(N, S, bodyData, src, result);
    try proc.body.end(N, result);
  } //:: Gen.proc.body.render
}; //:: Gen.proc.body


pub fn render (
    N        : slate.Node,
    src      : source.Code,
    types    : slate.Type.List,
    pragmas  : slate.Pragma.Store,
    argsData : slate.Proc.Arg.Store,
    bodyData : slate.Proc.BodyStore,
    result   : *zstd.str,
  ) !void {
  try proc.attributes.render(N, src, pragmas, result);
  try proc.returnT.render(N, src, types, result);
  try proc.name.render(N, src, result);
  try proc.args.render(N, src, types, argsData, result);
  try proc.body.render(N, src, bodyData, result);
} //:: Gen.C.proc.render

