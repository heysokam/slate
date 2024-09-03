//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
const todo = zstd.todo;


//______________________________________
/// Expressions:
/// - Can contain Identifiers, Literals and Operators
/// - Evaluate to values
/// - C: Legal at top level. Zig: Legal at block level
// const Expr = union(enum) {
//   Id  :u8, // todo
//   Lit :u8, // todo
//   Op  :u8, // todo
// };
pub const Expr = union(enum) {
  Empty,
  Lit   :Expr.Literal,

  pub const Literal = union(enum) {
    Flt    :Literal.Float,
    Intgr  :Literal.Int,
    Strng  :Literal.String,
    Ch     :Literal.Char,

    const Float = struct {
      val   :cstr,
      size  :todo= null,
      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Flt= Expr.Literal.Float{ .val= args.val }}};
      }
    };

    pub const Int = struct {
      val     :cstr,
      signed  :todo=  null,
      size    :todo=  null,

      pub fn new(args :struct {
          val : cstr,
        }) Expr {
        return Expr{ .Lit= Expr.Literal{ .Intgr= Expr.Literal.Int{ .val= args.val }}};
      }
    };

    pub const Char = struct {
      val  :cstr,
    };

    pub const String = struct {
      val       :cstr,
      multiline :todo= null,
    };
  };
};

