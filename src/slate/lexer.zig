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
const cstr = zstd.cstr;
// @deps *Slate
const Ch = @import("./char.zig");
const Lx = @import("./lex/lexeme.zig");


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
buf  :zstd.ByteBuffer,
/// @field {@link Lex.res} The list of lexemes resulting from the Lexer process.
res  :Lx.List,


//__________________________
/// @descr Creates a new empty Lexer object.
pub fn create (A :std.mem.Allocator) Lex {
  return Lex {
    .A   = A,
    .pos = 0,
    .buf = zstd.ByteBuffer.init(A),
    .res = Lx.List{},
  };
}

//__________________________
/// @descr Creates a new Lexer object from the given {@arg src} code data.
pub fn create_with (A :std.mem.Allocator, src :cstr) !Lex {
  var result = Lex{
    .A   = A,
    .pos = 0,
    .buf = try zstd.ByteBuffer.initCapacity(A, src.len),
    .res = Lx.List{},
  };
  result.buf.appendSliceAssumeCapacity(src[0..]);
  return result;
}

//__________________________
/// @descr Frees all resources owned by the Lexer object.
pub fn destroy (L:*Lex) void {
  L.buf.deinit();
  for (L.res.items(.val)) |lx| lx.deinit();
  L.res.deinit(L.A);
}

//__________________________
pub fn cloneResult (L:*Lex) !Lx.List {
  var result = Lx.List{};
  for (0..L.res.len) |id| try result.append(L.A,
    try Lx.create_with(L.res.items(.id)[id], L.res.items(.val)[id]));
  return result;
}
//______________________________________
// @section Lexer: General Tools
//__________________________
pub const report = @import("./lex/cli.zig").report;
pub const fail   = zstd.fail;
pub const prnt   = zstd.prnt;


//______________________________________
// @section Lexer: State/Data Management
pub const data = @import("./lex/data.zig");
pub const append_toLast = data.append.toLast;
pub const append_single = data.append.single;
pub const ch            = data.ch;


//______________________________________
// @section Lexer Process: Ident+Literals
pub const others     = @import("./lex/others.zig");
pub const ident      = others.ident;
pub const number     = others.number;
//______________________________________
// @section Lexer Process: Symbols
pub const symbols    = @import("./lex/symbols.zig");
pub const paren      = symbols.paren;
pub const brace      = symbols.brace;
pub const bracket    = symbols.bracket;
pub const eq         = symbols.eq;
pub const at         = symbols.at;
pub const star       = symbols.star;
pub const colon      = symbols.colon;
pub const semicolon  = symbols.semicolon;
pub const dot        = symbols.dot;
pub const comma      = symbols.comma;
pub const hash       = symbols.hash;
pub const quote_S    = symbols.quote_S;
pub const quote_D    = symbols.quote_D;
pub const quote_B    = symbols.quote_B;
//______________________________________
// @section Lexer Process: Whitespace
pub const whitespace = @import("./lex/whitespace.zig");
pub const newline    = whitespace.newline;
pub const space      = whitespace.space;
//__________________________
/// @descr Lexer Process: Entry Point
pub fn process(L:*Lex) !void {
  while (L.pos < L.buf.items.len) : (L.pos += 1) {
    const c = L.ch();
    switch (c) {
    'a'...'z',
    'A'...'Z',
    '_',       => try L.ident(),
    '0'...'9'  => try L.number(),
    '*'        => try L.star(),
    '(', ')'   => try L.paren(),
    '{', '}'   => try L.brace(),
    '[', ']'   => try L.bracket(),
    ':'        => try L.colon(),
    ';'        => try L.semicolon(),
    '.'        => try L.dot(),
    ','        => try L.comma(),
    '='        => try L.eq(),
    '@'        => try L.at(),
    '#'        => try L.hash(),
    '\''       => try L.quote_S(),
    '\"'       => try L.quote_D(),
    '`'        => try L.quote_B(),
    ' '        => try L.space(),
    '\n'       => try L.newline(),
    else => |char| Lex.fail("Unknown first character '{c}' (0x{X})", .{char, char})
    }
  }
}

