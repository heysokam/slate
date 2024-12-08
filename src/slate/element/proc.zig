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
// @section Type Properties
//____________________________
name     :Proc.Name,
pure     :bool                 = false,
public   :bool                 = false,
args     :Proc.ArgStore.Pos    = .None,
retT     :Proc.ReturnT         = .None,
pragmas  :Proc.PragmaStore.Pos = .None,
body     :Proc.BodyStore.Pos   = .None,

//______________________________________
// @section Data Management
//____________________________
/// @descr Returns an empty {@link Proc} object
pub fn create_empty () Proc {
  return Proc{.name= Proc.Name{.name= .{}}};
}


//______________________________________
// @section Proc Type Aliases
//____________________________
pub const Name = @import("./ident.zig").Ident;
pub const Arg  = @import("./data.zig").Data;
const Pragma   = @import("./pragma.zig").Pragma;
const Stmt     = @import("./statement.zig").Stmt;
//____________________________
/// @descr Describes the List of arguments of this Proc
/// @important The responsability of creating this list, and the Store type that holds them, lays on the creator of the Proc object.
pub const Args = Proc.Arg.List;
/// @descr Describes a list of argument lists (aka `List(List(Arg))`)
/// @important The responsability of creating this store, and its contained lists, lays on the creator of the Proc object.
pub const ArgStore = Proc.Arg.Store;
//____________________________
/// @descr Describes the List of pragmas of this Proc
/// @important The responsability of creating this list, and the Store type that holds them, lays on the creator of the Proc object.
pub const Pragmas = Proc.Pragma.List;
/// @descr Describes a list of pragma lists (aka `List(List(Pragma))`)
/// @important The responsability of creating this store, and its contained lists, lays on the creator of the Proc object.
pub const PragmaStore = Proc.Pragma.Store;
//____________________________
/// @descr Describes the position of the data for the return type of this Proc in the global List of types.
/// @important The responsability of creating the Types list lays on the creator of the Proc object.
pub const ReturnT = Type.List.Pos;
//____________________________
/// @descr Describes the List of Statements that define the body of this Proc
/// @important The responsability of creating this list, and the Store type that holds them, lays on the creator of the Proc object.
pub const Body = Stmt.List;
/// @descr Describes a list of Body lists (aka `List(List(Stmt))`)
/// @important The responsability of creating this store, and its contained lists, lays on the creator of the Proc object.
pub const BodyStore = Stmt.Store;

