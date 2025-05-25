#:______________________________________________________________________
#  grammar  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:______________________________________________________________________
# @deps std
import std/tables
import std/sets
import std/sequtils
import std/random as std_random
# @deps slate
import ../../lexer/src/lex
import ../../lexer/src/chars
# @deps Grammar
import ./tok

const tst = """
whitespace   = {' ', '\t', '\n', '\r'}
alphabetic   = {'a'..'z', 'A'..'Z'}
digit        = {'0'..'9'}
digitLetters = {'a'..'f', 'A'..'F', '_', 'o', 'O', 'x', 'X', 'b', 'B'}
numeric      = digit | digitLetters
alphanumeric = alphabetic | numeric
"""

#_______________________________________
# @section Grammar: Rules
#_____________________________
type RuleKind * = enum Char, Ref
type Rule * = object
  kind  *:RuleKind
  val   *:string
type Rules * = OrderedSet[Rule]

#_______________________________________
# @section Grammar: Management
#_____________________________
type Grammar * = object
  rules  *:Table[string, Rules]
#___________________
func `->` *(rules :Rules) :seq[Rules]= @[rules]
func `|` *(A :seq[Rules]; B :Rules) :seq[Rules]= A & B
#___________________
func add *(G :var Grammar; name :string; list :set[char]) :Rules=
  G.rules[name] = initOrderedSet[Rule]()
  for ch in list: G.rules[name].incl Rule(kind: Char, val: $ch )
  result = G.rules[name]
#___________________
func random *(G :var Grammar; name :string) :string =
  {.cast(noSideEffect).}:
    while true:
      randomize()
      let rules = G.rules[name]
      let id    = rand(0..rules.len)
      if id == rules.len: break
      result.add rules.toSeq()[id].val


#___________________
func add *(G :var Grammar; name :string; list :seq[Rules]) :Rules=
  ## @descr Adds a new rule to the grammar by merging all rules of {@arg list} into the {@arg name} rule entry of {@arg G} Grammar
  G.rules[name] = initOrderedSet[Rule]()
  for entry in list:    # For every toprule we need to merge : seq[Rules]       -> OrderedSet[Rule]
    for rule in entry:  # For every rule in that toprule     : OrderedSet[Rule] -> Rule
      G.rules[name].incl Rule(kind: rule.kind, val: rule.val )
  result = G.rules[name]


func minim () :void=
  var G = Grammar()
  let whitespace   = G.add("whitespace",   Ch.whitespace  )
  let alphabetic   = G.add("alphabetic",   Ch.alphabetic  )
  let digit        = G.add("digit",        Ch.digit       )
  let digitLetters = G.add("digitLetters", Ch.digitLetters)
  let underscore   = G.add("underscore",   Ch.underscore  )

  let numeric    = G.add("numeric", ->
    digit        |
    digitLetters |
    underscore   )

  debugEcho G.random("numeric")


when isMainModule: minim()

