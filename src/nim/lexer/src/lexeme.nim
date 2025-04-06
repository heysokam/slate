#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
import ./source

## @descr {@link Lx.id} Valid kinds for Lexemes
type Id *{.pure.}= enum
  ident,
  number,
  underscore,  # _
  colon,       # :
  equal,       # =
  star,        # *
  paren_L,     # (
  paren_R,     # )
  hash,        # #
  semicolon,   # ;
  quote_S,     # '  (single quote)
  quote_D,     # "  (double quote)
  quote_B,     # `  (backtick quote)
  brace_L,     # {
  brace_R,     # }
  bracket_L,   # [
  bracket_R,   # ]
  dot,         # .
  comma,       # ,
  # Operators
  plus,        # +
  minus,       # -  (also dash, min, minus)
  slash_F,     # /  (forward slash)
  less,        # <
  more,        # >
  at,          # @
  dollar,      # $
  tilde,       # ~
  ampersand,   # &
  percent,     # %
  pipe,        # |
  exclamation, # !
  question,    # ?
  caret,       # ^
  slash_B,     # \  (backward slash)
  # Whitespace
  space,       # ` `
  newline,     # \n \r
  tab,         # \t
  EOF,         # 0x0  (the null character 0 is treated as an EOF marker)

type Lx * = object
  id   *:lexeme.Id
  loc  *:source.Loc
type List * = seq[Lx]

