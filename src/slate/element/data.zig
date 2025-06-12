//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview
//!  Describes a Generic Data element, in the form:
//!  Data { Identifier, Type, Value { Expression } }
//!
//!  @note @important
//!   Matches the CS concept of a Variable Declaration,
//!   but without mutability properties implicit in its name.
//!   https://en.wikipedia.org/wiki/Variable_(computer_science)
//_______________________________________________________________|
pub const Data = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
// @deps *Slate
const slate = struct { const Depth = @import("./depth.zig"); };
pub const Ident = @import("./ident.zig").Ident;
pub const Expr  = @import("./expression.zig").Expr;
pub const Type  = @import("./type.zig").Type;
pub const List  = zstd.DataList(Data);
pub const Store = zstd.DataList(Data.List);


/// @descr Describes the identifier used to target the desired Data
id     :Ident,
/// @descr Position inside the Type.List of the Metadata/Information about the Type of the Value
/// @note A value of null means that it is untyped
type   :?Type.List.Pos=  null,
/// @descr Describes the value of the data, or the expression that generates it
/// @note
///  A value of null means that the data does not represent any value syntactically or semantically
///  Such a case is distinct to the value being assignable but undefined.
///  _(eg. A function parameter in C cannot define a default value, since the language does not allow it)_
value  :?Expr=  null,
/// @descr Describes the indentation/scope levels of this Node
depth  :slate.Depth= .default(),


/// @descr Whether the data can be read from or not
read     :bool=  true,
/// @descr Whether the data can be written to or not
write    :bool=  false,
/// @descr Whether the data is considered runtime or comptime
runtime  :bool=  true,

