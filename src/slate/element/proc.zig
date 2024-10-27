//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Proc = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate
const Stmt  = @import("./statement.zig").Stmt;
const Ident = @import("./ident.zig").Ident;


//______________________________________
// @section Type Aliases
//____________________________
pub const Name    = @import("./ident.zig").Ident;
pub const Arg     = @import("./data.zig").Data;
pub const Pragma  = @import("./pragma.zig").Pragma;
pub const ReturnT = @import("./type.zig").Type;

//______________________________________
// @section Type Properties
//____________________________
pure     :bool,
name     :Proc.Name,
public   :bool= false,
args     :?Proc.Arg.List= null,
retT     :?Proc.ReturnT= null,
pragmas  :?Proc.Pragma.List,
body     :?Proc.Body= null,


//______________________________________
// @section Body
//____________________________
pub const Body = struct {
  data  :Stmt.List,
  pub fn init (A :std.mem.Allocator) @This() { return Body{.data= Stmt.List.create(A)}; }
  pub fn add (B :*@This(), val :Stmt) !void { try B.data.add(val); }
};


//______________________________________
// @section Data Management
//____________________________
/// @descr Returns an empty {@link Proc} object
pub fn newEmpty () Proc {
  return Proc{
    .pure    = false,
    .name    = Proc.Name{.name= "UndefinedProc"},
    .public  = false,
    .args    = null,
    .retT    = Proc.ReturnT.Void.new(),
    .pragmas = null,
    .body    = null,
  }; // << Proc{ ... }
}

pub fn new (args :struct {
  pure    :bool,
  name    :cstr,
  public  :bool= false,
  args    :?Proc.Arg.List= null,
  retT    :Proc.ReturnT,
  pragmas :?Proc.Pragma.List= null,
  body    :?Proc.Body= null,
}) Proc {
  return Proc{
    .pure    = args.pure,
    .name    = Ident{.name= args.name},
    .public  = args.public,
    .args    = args.args,
    .retT    = args.retT,
    .pragmas = args.pragmas,
    .body    = args.body,
  }; // << Proc{ ... }
}

