//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Cable connector to all of the element modules
//______________________________________________________________|
pub const Ident    = @import("./element/ident.zig").Ident;
pub const Type     = @import("./element/type.zig").Type;
pub const Data     = @import("./element/data.zig").Data;
pub const Pragma   = @import("./element/pragma.zig").Pragma;
pub const Expr     = @import("./element/expression.zig").Expr;
pub const Stmt     = @import("./element/statement.zig").Stmt;
//__________________________________________________________
pub const Node     = @import("./element/node.zig").Node;
pub const Root     = @import("./element/root.zig").Root;
pub const Proc     = @import("./element/proc.zig").Proc;
pub const Variable = @import("./element/statement.zig").Stmt.Variable;

