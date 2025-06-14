//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
/// Expressions:
/// - Can contain Identifiers, Literals and Operators
/// - Evaluate to values
/// - C: Legal at top level. Zig: Legal at block level
//_____________________________________________________|
pub const Expr = @This().type;
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const todo = zstd.todo;
// @deps *Slate
const slate = struct { const Depth = @import("./depth.zig"); };
const source = @import("../source.zig").source;


//______________________________________
const @"type" = union(enum) {
  Empty,
  Lit   :Expr.Literal,
  // Id
  // Op
  // Ternary
  // TODO: other Expr kinds

  pub const Literal = union(enum) {
    Intgr  :Literal.Int,
    // Flt    :Literal.Float,
    // Strng  :Literal.String,
    // Ch     :Literal.Char,

    pub const Int = struct {
      loc     :source.Loc,
      signed  :todo=  null,  // TODO: Pass in Int sign
      size    :todo=  null,  // TODO: Pass in Int size
      /// @descr Describes the indentation/scope levels of this Node
      depth   :slate.Depth= .default(),
      pub fn create (loc :source.Loc, depth :slate.Depth) Expr { return Expr{ .Lit= Expr.Literal{ .Intgr= Expr.Literal.Int{
        .loc   = loc,
        .depth = depth,
      }}};} //:: slate.Expr.Literal.Int.create
    }; //:: slate.Expr.Literal.Int

    // const Float = struct {
    //   loc   :source.Loc,
    //   size  :todo= null,  // TODO: Pass in float size
    //   pub fn create (loc :source.Loc) Expr { return Expr{ .Lit= Expr.Literal{ .Flt= Expr.Literal.Float{ .loc= loc }}}; } //:: slate.Expr.Literal.Float.create

    // pub const Char = struct {
    //   loc  :source.Loc,
    //   pub fn create (loc :source.Loc) Expr { return Expr{ .Lit= Expr.Literal{ .Ch= Expr.Literal.Char{ .loc= loc }}}; } //:: slate.Expr.Literal.Char.create
    // }; //:: slate.Expr.Literal.Char

    // pub const String = struct {
    //   loc       :source.Loc,
    //   multiline :todo= null,  // TODO: Pass in multiline case
    //   pub fn create (loc :source.Loc) Expr { return Expr{ .Lit= Expr.Literal{ .Strng= Expr.Literal.String{ .loc= loc }}}; } //:: slate.Expr.Literal.String.create
    // }; //:: slate.Expr.Literal.String
  }; //:: slate.Expr.Literal
}; //:: slate.Expr

