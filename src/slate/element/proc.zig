//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Proc = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const Type   = @import("./type.zig").Type;
const source = @import("../source.zig").source;


//______________________________________
// @section Type Aliases
//____________________________
pub const Name    = @import("./ident.zig").Ident;
pub const Arg     = @import("./data.zig").Data;
pub const Args    = Arg.List;
pub const Pragma  = @import("./pragma.zig").Pragma;
pub const Pragmas = Pragma.List;
pub const ReturnT = Type.List.Pos;
pub const Body    = @import("./statement.zig").Stmt.List;

//______________________________________
// @section Type Properties
//____________________________
name     :Proc.Name,
pure     :bool= false,
public   :bool= false,
args     :?Proc.Args= null,
retT     :?Proc.ReturnT= null,
pragmas  :?Proc.Pragmas= null,
body     :?Proc.Body= null,


//______________________________________
// @section Data Management
//____________________________
/// @descr Returns an empty {@link Proc} object
pub fn create_empty () Proc {
  return Proc{.name= Proc.Name{.name= .{}}};
}
//____________________________
/// @descr Returns a {@link Proc} that contains the given properties
pub fn create (
    name      : source.Loc,
    in        : struct {
      retT    : ?Proc.ReturnT = null,
      args    : ?Proc.Args    = null,
      body    : ?Proc.Body    = null,
      pragmas : ?Proc.Pragmas = null,
      public  : bool          = false,
      pure    : bool          = false,
  }) Proc {
  return Proc{
    .pure    = in.pure,
    .name    = Proc.Name{.name= name},
    .public  = in.public,
    .args    = in.args,
    .retT    = in.retT,
    .pragmas = in.pragmas,
    .body    = in.body,
    }; //:: result
} //:: slate.Proc.create


pub fn clone (P :*const Proc) !Proc {
  return Proc.create(
    P.name.name, .{
    .retT    = P.retT,
    .args    = if (P.args    != null) try P.args.?.clone()    else null,
    .body    = if (P.body    != null) try P.body.?.clone()    else null,
    .pragmas = if (P.pragmas != null) try P.pragmas.?.clone() else null,
    .public  = P.public,
    .pure    = P.pure, }
    ); //:: result
} //:: slate.Proc.clone

pub fn destroy (P :*Proc, types :Type.List) void {
  if (P.args != null) {
    const args = P.args.?.items();
    for (0..args.len) |id| if (args[id].type != null and types.at(args[id].type.?) != null) {
      var t = types.at(args[id].type.?);
      t.?.destroy();
      } else {};
    P.args.?.destroy();
  }
  if (P.pragmas != null) P.pragmas.?.destroy();
  if (P.body != null) {
    for (0..P.body.?.len()) |id| P.body.?.items()[id].destroy();
    P.body.?.destroy();
  }
} //:: slate.Proc.destroy

