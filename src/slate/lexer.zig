//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview
//!  Contains a Generic Lexer.
//!  Its process will create a list of lexemes,
//!  that will be the input for the Tokenizer process of the target language.
//! @note
//!  A lexeme is a sequence of characters in the source program
//!  that matches the pattern for a token
//!  and is identified by the lexical analyzer as an instance of that token.
//___________________________________________________________________________|
pub const Lex = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../zstd.zig");
const fail = zstd.fail;
const ByteBuffer = zstd.ByteBuffer;
// @deps *Slate
const Ch = @import("./char.zig");
const Lx = @import("./lexeme.zig");



//______________________________________
/// @descr
/// Describes a Lexer process and its data.
/// @in A sequence of ascii characters  (cstr)
/// @out The list of lexemes that those characters represent.
//____________________________
/// @field {@link Lex.A} The Allocator used by the Lexer
A    :std.mem.Allocator,
/// @field {@link Lex.pos} The current {@link Lex.buf} position read by the Lexer.
pos  :u64,
/// @field {@link Lex.buf} The sequence of ascii characters that are being lexed.
buf  :ByteBuffer,
/// @field {@link Lex.res} The list of lexemes resulting from the Lexer process.
res  :Lx.List,

//__________________________
/// @descr Returns the character located in the current position of the buffer
fn ch (L:*Lex) u8 { return L.buf.items[L.pos]; }

//__________________________
/// @descr Creates a new empty Lexer object.
pub fn create (A :std.mem.Allocator) Lex {
  return Lex {
    .A   = A,
    .pos = 0,
    .buf = ByteBuffer.init(A),
    .res = Lx.List{},
  };
}

//__________________________
/// @descr Creates a new Lexer object from the given {@arg data}.
pub fn create_with (A :std.mem.Allocator, data :[]const u8) !Lex {
  var result = Lex{
    .A   = A,
    .pos = 0,
    .buf = try ByteBuffer.initCapacity(A, data.len),
    .res = Lx.List{},
  };
  try result.buf.appendSlice(data[0..]);
  return result;
}


//__________________________
/// @descr Frees all resources owned by the Lexer object.
pub fn destroy (L:*Lex) void {
  L.buf.deinit();
  L.res.deinit(L.A);
}

//__________________________
/// @descr Adds a single character to the last lexeme of the {@arg L.res} Lexer result.
fn append_toLast (L:*Lex, C :u8) !void {
  const id = L.res.len-1;
  try L.res.items(.val)[id].append(C);
}

//__________________________
/// @descr Processes an identifier into a Lexeme, and adds it to the {@arg L.res} result.
fn ident (L:*Lex) !void {
  try L.res.append(L.A, Lx{
    .id  = Lx.Id.ident,
    .val = ByteBuffer.init(L.A),
  });
  while (true) : (L.pos += 1) {
    const c = L.ch();
    if      (Ch.isIdent(c))         { try L.append_toLast(c); }
    else if (Ch.isContextChange(c)) { break; }
    else                            { fail("Unknown Identifier character '{c}' (0x{X})", .{c, c}); }
  }
  L.pos -= 1;
}

//__________________________
/// @descr Processes a number into a Lexeme, and adds it to the {@arg L.res} result.
fn number (L:*Lex) !void {
  try L.res.append(L.A, Lx{
    .id  = Lx.Id.number,
    .val = ByteBuffer.init(L.A),
  });
  while (true) : (L.pos += 1) {
    const c = L.ch();
    if      (Ch.isNumeric(c))       { try L.append_toLast(c); }
    else if (Ch.isContextChange(c)) { break; }
    else                            { fail("Unknown Numeric character '{c}' (0x{X})", .{c, c}); }
  }
  L.pos -= 1;
}

//__________________________
/// @descr Adds a single {@arg Lx} lexeme with {@arg id} to the result, and appends a single character into its {@arg Lx.val} field.
fn append_single (L:*Lex, id :Lx.Id) !void {
  try L.res.append(L.A, Lx{
    .id  = id,
    .val = ByteBuffer.init(L.A),
  });
  try L.append_toLast(L.ch());
}

//__________________________
/// @descr Processes a single `(` or `)` character into a Lexeme, and adds it to the {@arg L.res} result.
fn paren (L:*Lex) !void {
  const id = switch(L.ch()) {
    '(' => Lx.Id.paren_L,
    ')' => Lx.Id.paren_R,
    else => |char| fail("Unknown Paren character '{c}' (0x{X})", .{char, char})
  };
  try L.append_single(id);
}
//__________________________
/// @descr Processes a single `{` or `}` character into a Lexeme, and adds it to the {@arg L.res} result.
fn brace (L:*Lex) !void {
  const id = switch(L.ch()) {
    '{' => Lx.Id.brace_L,
    '}' => Lx.Id.brace_R,
    else => |char| fail("Unknown Brace character '{c}' (0x{X})", .{char, char})
  };
  try L.append_single(id);
}
//__________________________
/// @descr Processes a single `[` or `]` characte[ into a Lexeme, and adds it to the {@arg L.res} result.
fn bracket (L:*Lex) !void {
  const id = switch(L.ch()) {
    '[' => Lx.Id.bracket_L,
    ']' => Lx.Id.bracket_R,
    else => |char| fail("Unknown Bracket character '{c}' (0x{X})", .{char, char})
  };
  try L.append_single(id);
}

//__________________________
/// @descr Processes a single `=` character into a Lexeme, and adds it to the {@arg L.res} result.
fn eq (L:*Lex) !void { try L.append_single(Lx.Id.eq); }
//__________________________
/// @descr Processes a single `@` character into a Lexeme, and adds it to the {@arg L.res} result.
fn at (L:*Lex) !void { try L.append_single(Lx.Id.at); }
//__________________________
/// @descr Processes a single `*` character into a Lexeme, and adds it to the {@arg L.res} result.
fn star (L:*Lex) !void { try L.append_single(Lx.Id.star); }
//__________________________
/// @descr Processes a single `:` character into a Lexeme, and adds it to the {@arg L.res} result.
fn colon (L:*Lex) !void { try L.append_single(Lx.Id.colon); }
//__________________________
/// @descr Processes a single `;` character into a Lexeme, and adds it to the {@arg L.res} result.
fn semicolon (L:*Lex) !void { try L.append_single(Lx.Id.semicolon); }
//__________________________
/// @descr Processes a single `.` character into a Lexeme, and adds it to the {@arg L.res} result.
fn dot (L:*Lex) !void { try L.append_single(Lx.Id.dot); }
//__________________________
/// @descr Processes a single `,` character into a Lexeme, and adds it to the {@arg L.res} result.
fn comma (L:*Lex) !void { try L.append_single(Lx.Id.comma); }
//__________________________
/// @descr Processes a single `#` character into a Lexeme, and adds it to the {@arg L.res} result.
fn hash (L:*Lex) !void { try L.append_single(Lx.Id.hash); }
//__________________________
/// @descr Processes a single `'` character into a Lexeme, and adds it to the {@arg L.res} result.
fn quote_S (L:*Lex) !void { try L.append_single(Lx.Id.quote_S); }
//__________________________
/// @descr Processes a single `"` character into a Lexeme, and adds it to the {@arg L.res} result.
fn quote_D (L:*Lex) !void { try L.append_single(Lx.Id.quote_D); }
//__________________________
/// @descr Processes a single '`' character into a Lexeme, and adds it to the {@arg L.res} result.
fn quote_B (L:*Lex) !void { try L.append_single(Lx.Id.quote_B); }
//__________________________
/// @descr Processes a single ` ` character into a Lexeme, and adds it to the {@arg L.res} result.
fn space (L:*Lex) !void { try L.append_single(Lx.Id.space); }
//__________________________
/// @descr Processes a single `\n` character into a Lexeme, and adds it to the {@arg L.res} result.
fn newline (L:*Lex) !void { try L.append_single(Lx.Id.newline); }


//__________________________
/// @descr Lexer Entry Point
pub fn process(L:*Lex) !void {
  while (L.pos < L.buf.items.len) : (L.pos += 1) {
    const c = L.ch();
    switch (c) {
    'a'...'z', 'A'...'Z', '_', => try L.ident(),
    '0'...'9'                  => try L.number(),
    '*'                        => try L.star(),
    '(', ')'                   => try L.paren(),
    '{', '}'                   => try L.brace(),
    '[', ']'                   => try L.bracket(),
    ':'                        => try L.colon(),
    ';'                        => try L.semicolon(),
    '.'                        => try L.dot(),
    ','                        => try L.comma(),
    '='                        => try L.eq(),
    '@'                        => try L.at(),
    '#'                        => try L.hash(),
    '\''                       => try L.quote_S(),
    '\"'                       => try L.quote_D(),
    '`'                        => try L.quote_B(),
    ' '                        => try L.space(),
    '\n'                       => try L.newline(),
    else => |char| fail("Unknown first character '{c}' (0x{X})", .{char, char})
    }
  }
}

//__________________________
pub fn report(L:*Lex) void {
  std.debug.print("--- slate.Lexer ---\n", .{});
  for (L.res.items(.id), L.res.items(.val)) | id, val | {
    std.debug.print("{s} : {s}\n", .{@tagName(id), val.items});
  }
  std.debug.print("-------------------\n", .{});
}

