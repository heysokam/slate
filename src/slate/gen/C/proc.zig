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
const base   = @import("../base.zig");
const spc    = base.spc;
const Ptr    = base.Ptr;
const Void   = base.Void;
const nl     = base.nl;
const indent = base.indent;
const Return = base.Return;
const Const  = base.Const;

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
      result : *zstd.str,
    ) !void {
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
      result : *zstd.str,
    ) !void {
    if (N.Proc.retT == null) { try result.appendSlice(Void); return; }
    try result.appendSlice(N.Proc.retT.?.getName());
    if (N.Proc.retT.?.isPtr()) try result.appendSlice(Ptr);
    try result.appendSlice(spc);
  } //:: Gen.proc.returnT.render
}; //:: Gen.proc.returnT

const name = struct {
  // name  :Func.Name,
  fn render (
      N      : slate.Node,
      result : *zstd.str,
    ) !void {
    try result.appendSlice(N.Proc.name.name);
  } //:: Gen.proc.name.render
}; //:: Gen.proc.name

const args = struct {
  const start = "(";
  const end   = ")";
  const sep   = ", ";
  fn last (N :slate.Node, id :usize) bool { return N.Proc.args.?.entries.?.items.len == 1 or id == N.Proc.args.?.entries.?.items.len-1; }

  fn typ (N :slate.Node, arg :slate.Data, result :*zstd.str) !void {_=N;
    try result.appendSlice(arg.type.?.getName());
    try result.appendSlice(spc);
    if (arg.type.?.isPtr()) {
      if (!arg.type.?.isMut()) try result.appendSlice(Const++spc);
      try result.appendSlice(Ptr);
      try result.appendSlice(spc);
    }
    if (!arg.write) {
      try result.appendSlice(Const);
      try result.appendSlice(spc);
    }
  }
  fn name (N :slate.Node, arg :slate.Data, result :*zstd.str) !void {_=N;
    try result.appendSlice(arg.id.name);
  }

  fn render (
      N      : slate.Node,
      result : *zstd.str,
    ) !void {
    try result.appendSlice(start);
    if (N.Proc.args == null) { try result.appendSlice(Void); try result.appendSlice(end); return; }
    for (N.Proc.args.?.entries.?.items, 0..) |arg, id| {
      try proc.args.typ( N, arg, result);
      try proc.args.name(N, arg, result);
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
  fn oneline (N :slate.Node) bool { return N.Proc.body.?.data.entries.?.items.len == 1; }
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
        result : *zstd.str,
      ) !void {
      if (!oneline(N)) try indent(result, 1);  // TODO: Deeper indentation
      // FIX: Hardcoded  return N
      try result.appendSlice(Return);
      switch (S.Retrn.body.?) {
        .Lit => {
          try result.appendSlice(spc);
          try result.appendSlice(S.Retrn.body.?.Lit.Intgr.val); },
        .Empty => {},
      }
      try result.appendSlice(body.stmt.end);
      try newline(N, result);
    }
  };

  fn render (
      N      : slate.Node,
      result : *zstd.str,
    ) !void {
    if (N.Proc.body == null) { try result.appendSlice(proto.end); return; }
    try proc.body.start(N,result);
    for (N.Proc.body.?.data.entries.?.items) |S| try proc.body.stmt.render(N, S, result);
    try proc.body.end(N,result);
  } //:: Gen.proc.body.render
}; //:: Gen.proc.body


pub fn render (
    N      : slate.Node,
    result : *zstd.str,
  ) !void {
  try attributes.render(N, result);
  try returnT.render(N, result);
  try name.render(N, result);
  try args.render(N, result);
  try body.render(N, result);
}

