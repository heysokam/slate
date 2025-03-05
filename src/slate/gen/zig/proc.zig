//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Zig codegen: Proc
//___________________________________|
pub const proc = @This();
// @deps std
const std = @import("std");
// @deps zdk
const zstd = @import("../../../zstd.zig");
// @deps *Slate
const slate   = @import("../../../slate.zig");
const source  = slate.source;
const base    = @import("../base.zig");
const spc     = base.spc;
const Ptr     = base.Ptr;
const nl      = base.nl;
const indent  = base.indent;
const kw      = base.kw;
const @"type" = @import("./type.zig");

const attributes = struct {
  const public = "pub" ++ spc;
  const Inline = "inline" ++ spc;
  const Extern = "extern" ++ spc;

  fn render(
      N      : slate.Node,
      src    : source.Code,
      data   : slate.Pragma.Store,
      result : *zstd.str,
    ) !void {_=src;
    if (N.Proc.public) try result.appendSlice(attributes.public);
    if (N.Proc.pragmas != .None) {
      const pragmas = data.at(N.Proc.pragmas).?;
      if (pragmas.has(.import)) try result.appendSlice(attributes.Extern);
      if (pragmas.has(.Inline)) try result.appendSlice(attributes.Inline);
    }
    try result.appendSlice(kw.Func ++ spc);
  }
}; //:: Gen.zig.proc.attributes

const name = struct {
  fn render(
      N        : slate.Node,
      src      : source.Code,
      result   : *zstd.str,
    ) !void {
    try result.appendSlice(N.Proc.name.from(src));
  }
}; //:: Gen.zig.proc.name

const args = struct {
  const start    = "(";
  const end      = ")";
  const sep      = ", ";
  const sep_type = " :";
  const Ptr      = base.Ptr;
  fn last (list :[]slate.Proc.Arg, id :usize) bool { return list.len == 1 or id == list.len-1; }

  fn @"type" (
      arg     : slate.Data,
      src     : source.Code,
      types   : slate.Type.List,
      result : *zstd.str
    ) !void {
    if (arg.type == null) return error.slate_gen_zig_Proc_ArgumentsMustHaveTypes;
    if (types.at(arg.type.?) == null) return error.slate_gen_zig_Proc_ArgumentsMustHaveTypes;
    try proc.type.render(types.at(arg.type.?).?, src, types, arg.write, result);
  }

  fn name (
      arg    : slate.Data,
      src    : source.Code,
      result : *zstd.str
    ) !void {
    try result.appendSlice(arg.id.from(src));
  } //:: Gen.proc.args.name

  fn render(
      N        : slate.Node,
      src      : source.Code,
      types    : slate.Type.List,
      argsData : slate.Proc.Arg.Store,
      result   : *zstd.str,
    ) !void {
    try result.appendSlice(spc);
    try result.appendSlice(start);
    if (N.Proc.args == .None) { try result.appendSlice(args.end); return; }
    const list = argsData.at(N.Proc.args).?.items();
    for (list, 0..) |arg, id| {
      try proc.args.name(arg, src, result);
      try result.appendSlice(args.sep_type);
      try proc.args.type(arg, src, types, result);
      if (!args.last(list,id)) try result.appendSlice(args.sep);
    }
    try result.appendSlice(args.end);
  }
}; //:: Gen.zig.proc.args

const returnT = struct {
  const ErrorSep = "!";

  fn render(
      N        : slate.Node,
      src      : source.Code,
      types    : slate.Type.List,
      result   : *zstd.str,
    ) !void {
    try result.appendSlice(spc);
    if (N.Proc.retT == .None) { try result.appendSlice(kw.Void); return; } // FIX: noreturn pragma
    if (types.at(N.Proc.retT) == null) return error.slate_gen_zig_Proc_ReturnTypeMustExistWhenDeclared;
    const retT :slate.Type= types.at(N.Proc.retT).?;
    // FIX: Error return types
    if (N.Proc.err != null) {
      try result.appendSlice(N.Proc.err.?.from(src));
      try result.appendSlice(proc.returnT.ErrorSep);
    }
    const write = false;  // FIX: Remove hardcoded. Should allow `proc f() :mut T`
    try proc.type.render(retT, src, types, write, result);
  }
}; //:: Gen.zig.proc.returnT

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
    }
  };

  fn render(
      N        : slate.Node,
      src      : source.Code,
      bodyData : slate.Proc.BodyStore,
      result   : *zstd.str,
    ) !void {
    if (N.Proc.body == .None) { try result.appendSlice(proto.end); return; }
    try proc.body.start(N, bodyData, result);
    for (bodyData.at(N.Proc.body).?.items()) |S| try proc.body.stmt.render(N, S, bodyData, src, result);
    try proc.body.end(N, result);
  }
}; //:: Gen.zig.proc.body

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
  try proc.name.render(N, src, result);
  try proc.args.render(N, src, types, argsData, result);
  try proc.returnT.render(N, src, types, result);
  try proc.body.render(N, src, bodyData, result);
} //:: Gen.zig.proc.render

