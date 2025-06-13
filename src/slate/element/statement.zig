//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Defines a Statement of the language
//____________________________________________________|
pub const stmt = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps slate
const slate = struct {
  const Depth = @import("./depth.zig");
  const Expr  = @import("./expression.zig").Expr;
};

//______________________________________
/// @descr
///  Statements:
///  - Anything that can make up a line.
///  - ?? Can be expressions
///  - ?? Legal at the top level
pub const Stmt = union(enum) {
  Retrn   :Stmt.Return,
  Var     :Stmt.Variable,
  // If      :Stmt.If,
  // Whil    :Stmt.While,
  // Fr      :Stmt.For,
  // Swtch   :Stmt.Switch,
  // Discrd  :Stmt.Discard,
  // Commnt  :Stmt.Comment,
  // Incl    :Stmt.Include,
  // Blck    :Stmt.Block,

  pub const Return = struct {
    body   :?slate.Expr=  null,
    /// @descr The level of scope/indentation depth that this element is tagged with.
    depth  :slate.Depth=  .default(),
    pub fn create (E :slate.Expr, D :slate.Depth) Stmt { return Stmt{ .Retrn= Stmt.Return{
      .body  = E,
      .depth = D,
    }};}
  };

  pub const Variable = struct {
    data    :Variable.Data,
    /// @descr Whether or not the variable is public binding declaration.
    public  :bool=  false,
    /// @descr The level of scope/indentation depth that this element is tagged with.
    depth   :slate.Depth=  .default(),
    pub const Data = @import("./data.zig").Data;
    pub fn create (D :Data, public :bool, depth :slate.Depth) Stmt { return Stmt{.Var= Stmt.Variable{
      .data   = D,
      .public = public,
      .depth  = depth,
    }};}
  };

  // pub const If      = todo;
  // pub const While   = todo;
  // pub const For     = todo;
  // pub const Switch  = todo;
  // pub const Discard = todo;
  // pub const Comment = todo;
  // pub const Block   = todo;

  pub const List  = zstd.DataList(Stmt);
  pub const Store = zstd.DataList(Stmt.List);
};

