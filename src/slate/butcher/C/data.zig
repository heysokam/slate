//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Data = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../../zstd.zig");
const cstr = zstd.cstr;
// @deps *Slate.C
const C     = @import("./rules.zig");
const Ident = @import("./ident.zig").Ident;
const Type  = @import("./type.zig").Type;
const Expr  = @import("./expression.zig").Expr;


/// @descr Describes the identifier used to target the desired Data
id     :Ident,
/// @descr Metadata/Information about the Type of the Value
///  @note A value of null means that it is not typed
type   :?Type=  null,
/// @descr Describes the value of the data, or the expression that generates it
/// @note
///  A value of null means that the data does not represent any value syntactically or semantically
///  Such a case is distinct to the value being assignable but undefined.
///  _(eg. A function parameter in C cannot define a default value, since the language does not allow it)_
value  :?Expr=  null,

/// @descr Whether the data can be written to or not
write  :bool= false,

