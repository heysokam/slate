//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
const std  = @import("std");
const zstd = @import("./zstd.zig");
const cstr = zstd.cstr;
const Seq  = zstd.Seq;
const todo = zstd.todo;
const prnt = zstd.prnt;


const Include = todo;


//.......................................................
// Expressions:
// - Can contain Identifiers, Literals and Operators
// - Evaluate to values
// - C: Legal at top level. Zig: Legal at block level
// const Expr = union(enum) {
//   Id  :u8, // todo
//   Lit :u8, // todo
//   Op  :u8, // todo
// };
const Expr = union(enum) {
  Lit  :Expr.Literal,

  pub fn format(E :*const Expr, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
    switch (E.*) {
      .Lit   => try Expr.Literal.format(&E.Lit,f,o,writer),
    }
  }

  const Literal = union(enum) {
    Flt    :Literal.Float,
    Intgr  :Literal.Int,
    Strng  :Literal.String,
    Ch     :Literal.Char,

    pub fn format(L :*const Expr.Literal, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
      switch (L.*) {
        .Flt   => try Expr.Literal.Float.format(&L.Flt,f,o,writer),
        .Intgr => try Expr.Literal.Int.format(&L.Intgr,f,o,writer),
        .Strng => try Expr.Literal.String.format(&L.Strng,f,o,writer),
        .Ch    => try Expr.Literal.Char.format(&L.Ch,f,o,writer),
      }
    }

    const Float = struct {
      val   :cstr,
      size  :todo= null,
      fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Flt= Expr.Literal.Float{ .val= args.val }}};
      }
      const Templ = "{s}";
      fn format(L :*const Expr.Literal.Float, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Float.Templ, .{L.val});
      }
    };

    const Int = struct {
      val    :cstr,
      signed :todo= null,
      size   :todo= null,

      fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Intgr= Expr.Literal.Int{ .val= args.val }}};
      }
      const Templ = "{s}";
      fn format(L :*const Expr.Literal.Int, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Int.Templ, .{L.val});
      }
    };

    const Char = struct {
      val  :cstr,
      const Templ = "'{s}'";
      fn format(L :*const Expr.Literal.Char, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print(Expr.Literal.Char.Templ, .{L.val});
      }
    };

    const String = struct {
      val       :cstr,
      multiline :todo= null,
      fn format(L :*const Expr.Literal.String, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        try writer.print("\"{s}\"", .{L.val});
      }
    };
  };
};

//.......................................................
// Statements:
// - Anything that can make up a line.
// - ?? Can be expressions
// - ?? Legal at the top level
const Stmt = union(enum) {
  Retrn   :Stmt.Return,
  // Asgn    :Stmt.Assign,
  // If      :Stmt.If,
  // Whil    :Stmt.While,
  // Fr      :Stmt.For,
  // Swtch   :Stmt.Switch,
  // Discrd  :Stmt.Discard,
  // Commnt  :Stmt.Comment,
  // Incl    :Stmt.Include,
  // Blck    :Stmt.Block,

  pub fn format(S :*const Stmt, comptime f:[]const u8, o:std.fmt.FormatOptions, writer :anytype) !void {
    switch (S.*) {
      .Retrn => try Stmt.Return.format(&S.Retrn,f,o,writer),
    }
  }

  const Return = struct {
    body  :?Expr= null,

    fn new(E :Expr) Stmt {
      return Stmt{ .Retrn= Stmt.Return{ .body= E } };
    }
    const BaseTempl = "return";
    const Templ     = BaseTempl ++ " {?s}";
    pub fn format(R :*const Stmt.Return, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (R.body == null) { try writer.print(Stmt.Return.BaseTempl, .{});         }
      else                { try writer.print(Stmt.Return.Templ,     .{R.body}); }
    }
  };

  // const Assign  = todo;
  // const If      = todo;
  // const While   = todo;
  // const For     = todo;
  // const Switch  = todo;
  // const Discard = todo;
  // const Comment = todo;
  // const Block   = todo;
  const Templ = "{s};";
  const List = struct {
    data  :?Seq(Stmt),
    pub fn init(A :std.mem.Allocator) @This() { return List{.data= Seq(Stmt).init(A)}; }
    pub fn append(L :*Stmt.List, val :Stmt) !void { try L.data.?.append(val); }
    pub fn format(L :*const Stmt.List, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (L.data == null or L.data.?.items.len == 0) return;
      for (L.data.?.items) | stmt | {
        try writer.print(Stmt.Templ, .{stmt});
      }
      if (L.data.?.items.len > 1) { try writer.print("\n", .{}); }
    }
  };
};

const Func = struct {
  attr  :Func.Attr.List= undefined,
  retT  :Ident.Type,
  name  :Ident.Name,
  args  :Func.Arg.List= undefined,
  body  :Func.Body= undefined,

  pub const Body = struct {
    data  :Stmt.List,
    const Templ = " {{ {s} }}\n";
    pub fn init(A :std.mem.Allocator) @This() { return Body{.data= Stmt.List{.data= Seq(Stmt).init(A)}}; }
    pub fn append(B :*Func.Body, val :Stmt) !void { try B.data.data.?.append(val); }
    pub fn format(B :*const Func.Body, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      if (B.data.data == null or B.data.data.?.items.len == 0) return;
      try writer.print(Func.Body.Templ, .{B.data});
    }
  };

  pub const Attr = enum {
    pure, Const,
    static, Inline,
    Noreturn, noreturn_C11, noreturn_GNU,

    const Templ = "{s}";

    pub const List = struct {
      data :?Seq(Attr),
      pub fn format(L :*const Func.Attr.List, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        if (L.data == null or L.data.?.items.len == 0) return;
        for (L.data.?.items, 0..) | A, id | { _=id;
          try writer.print(Attr.Templ, .{@tagName(A)});
        }
      }
    };
  };

  const Arg = struct {
    type  :Ident.Type,
    name  :Ident.Name,

    const Templ = "{s} {s}";
    pub fn format(arg :*const Func.Arg, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Func.Arg.Templ, .{arg.type, arg.name});
    }

    const List = struct {
      data :?Seq(Func.Arg),

      const SepTempl = ", ";
      pub fn format(L :*const Func.Arg.List, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
        if (L.data == null or L.data.?.items.len == 0) {
          try writer.print("void", .{});
          return;
        }
        for (L.data.?.items, 0..) | arg, id | {
          try writer.print(Func.Arg.Templ, .{arg.type, arg.name});
          if (id != 0 and id != L.data.?.items.len) {
            try writer.print(Func.Arg.List.SepTempl, .{});
          }
        }
      }
    };
  };

  pub fn new(args :struct {
    name :cstr,
    retT :cstr,
  }) Func {
    _ = args;
    return Func{};
  }

  const BaseTempl  = "{s}{s} {s}({s})";
  const ProtoTempl = BaseTempl ++ ";\n";
  const DefTempl   = BaseTempl ++ "{s}";
  pub fn format(F :*const Func, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
    try writer.print(Func.DefTempl, .{
      F.attr,  // 0. Attributes
      F.retT,  // 1. Return type
      F.name,  // 2. Name
      F.args,  // 3. Arguments
      F.body,  // 4. Body
    });
  }
};

pub const Keyw = enum {
  typedef, static
};
pub const CType = enum {
  i32, u32
};

pub const Ident = union(enum) {
  Id  :Ident.Name,
  Kw  :Ident.Keyword,
  Ty  :Ident.Type,

  const Templ = "{s}";

  pub const Name = struct {
    name :cstr,
    pub fn format(N :*const Ident.Name, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{N.name});
    }
  };

  pub const Type = struct {
    name :cstr,
    type :CType,
    pub fn format(T :*const Ident.Type, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{T.name});
    }
  };

  pub const Keyword = struct {
    id :Keyw,
    pub fn format(K :*const Ident.Keyword, comptime _:[]const u8, _:std.fmt.FormatOptions, writer :anytype) !void {
      try writer.print(Ident.Templ, .{@tagName(K.id)});
    }
  };
};


test "hello.42" {
  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();

  const retT   = "int";
  const fname  = "main";
  const result = "42";

  var body = Func.Body.init(A.allocator());
  try body.append(Stmt.Return.new(Expr.Literal.Int.new(.{ .val= result })));
  const f = Func{
    .retT= Ident.Type{ .name= retT, .type= .i32 },
    .name= Ident.Name{ .name= fname },
    .body= body,
    }; // << Func{ ... }
  const out = try std.fmt.allocPrint(A.allocator(), "{s}", .{f});
  std.debug.print("{s}", .{f});

  try std.testing.expect(std.mem.eql(u8, out, retT++" "++fname++"(void) { return "++result++"; }\n"));
}

