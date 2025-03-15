//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Cable Connector to all *Slate Modules and tools.
//_________________________________________________________________|
pub const Gen      = @import("./slate/gen.zig").Gen;
pub const source   = @import("./slate/source.zig").source;
pub const Loc      = source.Loc;
pub const Distinct = @import("./zstd.zig").Distinct;
pub const DataList = @import("./zstd.zig").DataList;
//__________________________________________________________
pub const Ch       = @import("./slate/char.zig");
pub const Lx       = @import("./slate/lex/lexeme.zig");
pub const Lex      = @import("./slate/lexer.zig").Lex;
pub const Ident    = @import("./slate/elements.zig").Ident;
pub const Type     = @import("./slate/elements.zig").Type;
pub const Data     = @import("./slate/elements.zig").Data;
pub const Pragma   = @import("./slate/elements.zig").Pragma;
pub const Expr     = @import("./slate/elements.zig").Expr;
pub const Stmt     = @import("./slate/elements.zig").Stmt;
//__________________________________________________________
pub const Node     = @import("./slate/elements.zig").Node;
pub const Proc     = @import("./slate/elements.zig").Proc;
pub const Variable = @import("./slate/elements.zig").Variable;
