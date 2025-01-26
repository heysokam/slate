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
// @deps *Slate
const source  = @import("./source.zig").source;
const Ch      = @import("./char.zig");
const Lx      = @import("./lex/lexeme.zig");
pub const Loc = source.Loc;
pub const Pos = source.Pos;


//______________________________________
/// @descr
/// Describes a Lexer process and its data.
/// @in A sequence of ascii characters  (cstr)
/// @out The list of lexemes that those characters represent.
//____________________________
/// @field {@link Lex.A} The Allocator used by the Lexer
A    :std.mem.Allocator,
/// @field {@link Lex.pos} The current {@link Lex.src} position read by the Lexer.
pos  :source.Pos,
/// @field {@link Lex.src} The sequence of ascii characters that are being lexed.
src  :source.Code,
/// @field {@link Lex.res} The list of lexemes resulting from the Lexer process.
res  :Lx.List,


//__________________________
/// @descr Creates a new Lexer object from the given {@arg src} code data.
pub fn create (A :std.mem.Allocator, src :source.Code) !Lex {
  return Lex{
    .A   = A,
    .pos = 0,
    .src = src,
    .res = Lx.List{},
    };
}

//__________________________
/// @descr Frees all resources owned by the Lexer object.
pub fn destroy (L:*Lex) void {
  L.res.deinit(L.A);
}

//__________________________
pub fn cloneResult (L:*Lex) !Lx.List {
  return L.res.clone(L.A);
}
//______________________________________
// @section Lexer: General Tools
//__________________________
pub const report = @import("./lex/cli.zig").report;
pub const prnt   = zstd.prnt;
pub fn fail(err :anyerror, comptime msg :zstd.cstr, args :anytype) !void {
  if (std.debug.runtime_safety) zstd.prnt("[slate.lexer.debug] Err: " ++ msg ++ "\n", args);
  return err;
}


//______________________________________
// @section Lexer: State/Data Management
pub const data       = @import("./lex/data.zig");
pub const add        = data.add.one;
pub const add_toLast = data.add.toLast;
pub const add_single = data.add.single;
pub const ch         = data.ch;


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
pub const slash_F    = symbols.slash_F;
pub const slash_B    = symbols.slash_B;
//______________________________________
// @section Lexer Process: Whitespace
pub const whitespace = @import("./lex/whitespace.zig");
pub const newline    = whitespace.newline;
pub const space      = whitespace.space;
//__________________________
/// @descr Lexer Process: Entry Point
pub fn process(L:*Lex) !void {
  while (L.pos < L.src.len) : (L.pos += 1) {
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
    '/'        => try L.slash_F(),
    '\\'       => try L.slash_B(),
    ' '        => try L.space(),
    '\n'       => try L.newline(),
    else => |char| try Lex.fail(error.slate_lexer_UnknownFirstCharacter, "Unknown first character '{c}' (0x{X})", .{char, char})
    }
  }
}

