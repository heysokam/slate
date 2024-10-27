//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const C      = @This();
pub const Func   = @import("./C/func.zig");
pub const Stmt   = @import("./C/statement.zig").Stmt;
pub const Expr   = @import("./C/expression.zig").Expr;
pub const Ident  = @import("./C/ident.zig").Ident;
pub const Type   = @import("./C/type.zig").Type;
pub const Data   = @import("./C/data.zig").Data;
pub const Ast    = @import("./C/ast.zig");


//______________________________________
// @section Unit Tests
//____________________________
// @deps std
const std   = @import("std");
const prnt  = std.debug.print;
const check = std.testing.expect;
const eq    = std.mem.eql;

test "hello.42" {
  var A = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer A.deinit();

  const retT   = "int";
  const fname  = "main";
  const result = "42";

  var body = Func.Body.create(A.allocator());
  try body.add(Stmt.Return.new(Expr.Literal.Int.new(.{ .val= result })));
  const f = Func{
    .retT= Type.Any.new(retT, .{}),
    .name= Ident{ .name= fname },
    .body= body,
    }; // << Func{ ... }
  const out = try std.fmt.allocPrint(A.allocator(), "{s}", .{f});
  // prnt("{s}", .{f});

  try check(eq(u8, out, retT++" const "++fname++"(void) { return "++result++"; }\n"));
}

