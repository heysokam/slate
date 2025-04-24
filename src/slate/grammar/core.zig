//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const Grammar = @This();
// @deps std
const std = @import("std");
const cstr = []const u8;
// @deps slate
const slate = struct {
  const Lex = @import("../lexer.zig");
};
const source = @import("../source.zig");
const Par = @import("./par.zig");

// grammars are made from rules
// rules are made of patterns and elements
// patterns are made of elements
// elements are made of charaters

A     :std.mem.Allocator,
data  :Data,

const Data    = std.StringArrayHashMap(Grammar.Rule);
const Rule    = []const Grammar.Pattern;
const Pattern = []const Grammar.Element;
const Element = union(enum) {
  value  : source.Code, // literal string
  ruleID : source.Code, // rule name
  const Options = struct {
    kind     : enum { id, value }= .value,
    value    : source.Code = null,
    optional : bool = false,
    repeat   : bool = false,
  };

  pub fn create (opts :Grammar.Element.Options) Grammar.Element {
    var result :Grammar.Element= undefined;
    switch (opts.kind) {
      .value  => result.value  = opts.value,
      .ruleID => result.ruleID = opts.value,
    }
    return result;
  }
};

pub fn create (A :std.mem.Allocator) Grammar { return Grammar{.data= Data.init(A), .A= A}; }
pub fn destroy (G :*Grammar) void { G.data.deinit(); }
pub fn clone (G :*const Grammar) !Grammar { return Grammar{.data= try G.data.clone(), .A= G.A}; }

pub fn add (G :*Grammar, id :source.Code, rule :Rule) !void { try G.data.put(id, rule); }
pub fn get (G :*const Grammar, id :source.Code) ?Rule { return G.data.get(id); }
pub fn get_ids (G :*const Grammar) []const cstr { return G.data.keys(); }
pub fn get_str (G :*const Grammar, id :source.Code) !source.Code {
  var result = std.ArrayList(u8).init(G.A);
  defer result.deinit();

  try result.appendSlice(id);
  try result.appendSlice(" = ");

  const rule = G.get(id) orelse return error.RuleNotFound;
  for (rule, 0..) |patt, pos| {
    for (patt) |elem| {
      switch (elem) {
        .value => {
          try result.append('\'');
          try result.appendSlice(elem.value);
          try result.append('\'');
        },
        .ruleID => try result.appendSlice(elem.ruleID),
      }
      try result.append(' ');
    }
    if (rule.len > 1 and pos < rule.len-1) try result.appendSlice(" | ");
  }

  return try result.toOwnedSliceSentinel(0);
} //:: Grammar.get_str

pub const element = Grammar.Element.create;

pub fn parse (src :source.Code, A :std.mem.Allocator) !Grammar {
  var L = try slate.Lex.create(A, src);
  defer L.destroy();
  try L.process();

  var P = try Grammar.Par.create(&L);
  defer P.destroy();
  try P.process();
  return P.res.clone();
}

