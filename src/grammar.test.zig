const Grammar = @import("./slate/grammar.zig").Grammar;
// @deps std
const std = @import("std");

pub fn main() !void {
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const A = arena.allocator();
  var grammar = Grammar.create(A);
  defer grammar.destroy();

  const parens = "parens = '(' anyLetter ')'";
  const parsed = try Grammar.parse(parens, A);
  try std.testing.expectEqualStrings(parens, try parsed.get_str("parens"));

  // parens = '(' anyLetter ')'
  try grammar.add("parens", &.{
    &.{
      .{ .value  = "("         },
      .{ .ruleID = "anyLetter" },
      .{ .value  = ")"         },
    },
  });

  // mul_expr = add_expr '*' mul_expr | add_expr
  try grammar.add("mul_expr", &.{
    &.{
      .{ .ruleID = "add_expr" },
      .{ .value  = "*"        },
      .{ .ruleID = "mul_expr" },
    },
    &.{
      .{ .ruleID = "add_expr" },
    },
  });

  for (grammar.get_ids()) |id| std.debug.print("{s} = {s}\n", .{ id, try grammar.get_str(id[0..id.len-1:0]) });
}

