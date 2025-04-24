//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Par = @This();
// @deps std
const std  = @import("std");
const cstr = @import("../../zstd.zig").cstr;
// @deps slate
const source  = @import("../source.zig");
const slate   = struct {
  const Lex = @import("../lexer.zig").Lex;
  const Lx  = @import("../lex/lexeme.zig");
};
// @deps slate.grammar
const Grammar = @import("./core.zig").Grammar;
const Pos = i64;

A    :std.mem.Allocator,
buf  :slate.Lx.List,
res  :Grammar,
pos  :Par.Pos= 0,
src  :source.Code,

//______________________________________
// @section Parser Object Management
//____________________________
pub fn create (L :*const slate.Lex) !Par { return Par{.A=L.A, .buf=try L.res.clone(L.A), .src=L.src, .res=Grammar.create(L.A)}; } //:: Par.create
pub fn destroy (P :*Par) void { P.res.destroy();} //:: Par.destroy


//______________________________________
// @section Error Management
//____________________________
const fail = std.debug.panic;
pub fn err (P:*const Par, code :anyerror, msg :cstr) !void {
  std.debug.print("Error :: {s} \n{any}\n", .{msg, P.lx()});
  return code;
} //:: Par.err

//______________________________________
// @section Parse: General Tools
//____________________________
pub fn expect (P:*Par, id :slate.Lx.Id, kind :cstr) !void {
  if (P.lx().id == id) return;
  const msg = try std.fmt.allocPrint(P.A, "Unexpected Token for {s}. Expected '{s}', but found:  {d}:'{s}' : `{s}`",
    .{kind, @tagName(id), P.pos, @tagName(P.lx().id), P.lx().from(P.src)});
  defer P.A.free(msg);
  return P.err(error.UnexpectedToken, msg);
}
fn lx (P :*const Par) slate.Lx { return P.buf.get(@intCast(P.pos)); }
fn move (P:*Par, N :Par.Pos) void { P.pos +|= N; }
fn ind (P :*Par) !void {
  while (true) { switch (P.lx().id) {
    .space => P.move(1),
    else   => break,
  }}
} //:: Par.ind

//______________________________________
// @section Parse: Rules
//____________________________
fn character (P :*Par) !void {
  try P.expect(slate.Lx.Id.quote_S, "Rule.Character");
  P.move(1);
  try P.expect(slate.Lx.Id.quote_S, "Rule.Character");
} //:: Par.character

fn pattern (P :*Par) !void {
  try P.expect(slate.Lx.Id.ident, "Rule.Pattern");
} //:: Par.pattern

fn rule (P :*Par) !void {
  try P.expect(slate.Lx.Id.ident, "Rule");
  P.move(1);
  try P.ind();
  try P.expect(slate.Lx.Id.eq, "Rule");
  P.move(1);
  try P.ind();
  switch (P.lx().id) {
    .quote_S => try P.character(),
    .ident   => try P.pattern(),
    else     => try P.err(error.UnknownRuleLexeme, "Unknown Rule Lexeme"),
  }
} //:: Par.rule


pub fn process (P :*Par) !void {
  // TopLevel Grammar Symbols
  while (P.pos < P.buf.len) : ( P.move(1) ) { switch (P.lx().id) {
    .ident => try P.rule(),
    else   => try P.err(error.UnknownTopLevelLexeme, "Unknown TopLevel Lexeme"),
  }}
} //:: Par.process

