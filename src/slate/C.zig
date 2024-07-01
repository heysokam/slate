//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const C      = @This();
pub const Func   = @import("./C/func.zig");
pub const Stmt   = @import("./C/statement.zig").Stmt;
pub const Expr   = @import("./C/expression.zig").Expr;
pub const Ident  = @import("./C/ident.zig").Ident;
pub usingnamespace @import("./C/rules.zig");


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

  var body = Func.Body.init(A.allocator());
  try body.append(Stmt.Return.new(Expr.Literal.Int.new(.{ .val= result })));
  const f = Func{
    .retT= Ident.Type{ .name= retT, .type= .i32 },
    .name= Ident.Name{ .name= fname },
    .body= body,
    }; // << Func{ ... }
  const out = try std.fmt.allocPrint(A.allocator(), "{s}", .{f});
  // prnt("{s}", .{f});

  try check(eq(u8, out, retT++" "++fname++"(void) { return "++result++"; }\n"));
}

