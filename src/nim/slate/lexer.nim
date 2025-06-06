#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
# @deps ndk
import ./nstd
# @deps Lex
import ./chars
import ./source


#_______________________________________
# @section Lexeme
#_____________________________
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
type lexeme_Id  = lexer.Id
#___________________
type Lx * = object
  id   *:lexeme_Id
  loc  *:source.Loc
type List * = seq[Lx]
type lexeme_List = lexer.List
#___________________
func From *(lx :Lx; src :source.Code) :string= lx.loc.From(src)


#_______________________________________
# @section Lexer Errors
#_____________________________
type LexerError = object of CatchableError
type UnknownFirstCharacterError = object of LexerError
type InvalidFirstCharacterError = object of LexerError
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## @descr Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))


#_______________________________________
# @section Lexer Management
#_____________________________
type Lex * = object
  pos  *:source.Pos  = 0
  src  *:source.Code = ""
  res  *:lexeme_List = @[]
func create   *(_:typedesc[Lex]; src :source.Code) :Lex= Lex(src: src)
func destroy  *(L :var Lex) :void= L = Lex()
func pos_next *(L :Lex; pos :source.Pos) :source.Pos {.inline.}=
  result = L.pos+pos
  if result >= L.src.len.Sz: result = L.src.len-1
func last     *(L :Lex) :bool= L.pos == L.src.len.Sz-1
func next     *(L :Lex; pos :source.Pos) :char {.inline.}= L.src[L.pos_next(pos)]
func move     *(L :var Lex; pos :source.Pos) :void {.inline.}= L.pos = L.pos_next(pos)
func ch       *(L :Lex) :char {.inline.}= L.next(0)
func add      *(L :var Lex; id :lexeme_Id, loc :source.Loc) :void {.inline.}= L.res.add Lx(id: id, loc: loc)
func add      *(L :var Lex; id :lexeme_Id) :void {.inline.}= L.add id, source.Loc(start:L.pos, End:L.pos)


#_______________________________________
# @section Identifier Characters
#_____________________________
func alphabetic *(L :var Lex) :void=
  let start = L.pos
  var End   = L.pos
  while L.ch in Ch.alphabetic:
    End = L.pos
    L.move(1)
    if L.last: break # FIX: This shouldn't be here
  L.add lexeme_Id.ident, source.Loc(start:start, End:End)
  L.move(-1)
#___________________
func digit *(L :var Lex) :void=
  let start = L.pos
  var End   = L.pos
  while L.ch in Ch.digit:
    End = L.pos
    L.move(1)
    if L.last: break # FIX: This shouldn't be here
  L.add lexeme_Id.number, source.Loc(start:start, End:End)
  # L.move(-1) # FIX: Is this missing here? Found it while porting to the TS version


#_______________________________________
# @section Symbols: Single Character
#_____________________________
# Single Entry
func exclamation *(L :var Lex) :void=  L.add lexeme_Id.exclamation
func hash        *(L :var Lex) :void=  L.add lexeme_Id.hash
func dollar      *(L :var Lex) :void=  L.add lexeme_Id.dollar
func percent     *(L :var Lex) :void=  L.add lexeme_Id.percent
func ampersand   *(L :var Lex) :void=  L.add lexeme_Id.ampersand
func star        *(L :var Lex) :void=  L.add lexeme_Id.star
func plus        *(L :var Lex) :void=  L.add lexeme_Id.plus
func comma       *(L :var Lex) :void=  L.add lexeme_Id.comma
func minus       *(L :var Lex) :void=  L.add lexeme_Id.minus
func dot         *(L :var Lex) :void=  L.add lexeme_Id.dot
func colon       *(L :var Lex) :void=  L.add lexeme_Id.colon
func semicolon   *(L :var Lex) :void=  L.add lexeme_Id.semicolon
func equal       *(L :var Lex) :void=  L.add lexeme_Id.equal
func question    *(L :var Lex) :void=  L.add lexeme_Id.question
func at          *(L :var Lex) :void=  L.add lexeme_Id.at
func pipe        *(L :var Lex) :void=  L.add lexeme_Id.pipe
func tilde       *(L :var Lex) :void=  L.add lexeme_Id.tilde
func underscore  *(L :var Lex) :void=  L.add lexeme_Id.underscore
#___________________
# Groups
func whitespace *(L :var Lex) :void=
  case L.ch
  of Ch.space   : L.add lexeme_Id.space
  of Ch.tab     : L.add lexeme_Id.tab
  of Ch.newline : L.add lexeme_Id.newline
  else: lexer.fail LexerError, "whitespace  : `" & L.src[L.pos] & "`"
func quote *(L :var Lex) :void=
  case L.ch
  of Ch.quote_D : L.add lexeme_Id.quote_D
  of Ch.quote_S : L.add lexeme_Id.quote_S
  of Ch.quote_B : L.add lexeme_Id.quote_B
  else: lexer.fail LexerError, "quote: `" & L.src[L.pos] & "`"
func parenthesis *(L :var Lex) :void=
  case L.ch
  of Ch.paren_L : L.add lexeme_Id.paren_L
  of Ch.paren_R : L.add lexeme_Id.paren_R
  else: lexer.fail LexerError, "parenthesis: `" & L.src[L.pos] & "`"
func slash *(L :var Lex) :void=
  case L.ch
  of Ch.slash_B : L.add lexeme_Id.slash_B
  of Ch.slash_F : L.add lexeme_Id.slash_F
  else: lexer.fail LexerError, "slash: `" & L.src[L.pos] & "`"
func bracket *(L :var Lex) :void=
  case L.ch
  of Ch.bracket_L : L.add lexeme_Id.bracket_L
  of Ch.bracket_R : L.add lexeme_Id.bracket_R
  else: lexer.fail LexerError, "bracket: `" & L.src[L.pos] & "`"
func chevron *(L :var Lex) :void=
  case L.ch
  of Ch.less  : L.add lexeme_Id.less
  of Ch.more  : L.add lexeme_Id.more
  of Ch.caret : L.add lexeme_Id.caret
  else: lexer.fail LexerError, "chevron: `" & L.src[L.pos] & "`"
func brace *(L :var Lex) :void=
  case L.ch
  of Ch.brace_L : L.add lexeme_Id.brace_L
  of Ch.brace_R : L.add lexeme_Id.brace_R
  else: lexer.fail LexerError, "brace: `" & L.src[L.pos] & "`"



#_______________________________________
# @section Lexer: Entry Point
#_____________________________
func process *(L :var Lex) :void=
  while L.pos < L.src.len.Sz:
    case L.ch
    of Ch.whitespace  : L.whitespace
    of Ch.alphabetic  : L.alphabetic
    of Ch.digit       : L.digit
    of Ch.parenthesis : L.parenthesis
    of Ch.star        : L.star
    of Ch.colon       : L.colon
    of Ch.equal       : L.equal
    of Ch.exclamation : L.exclamation
    of Ch.quote       : L.quote
    of Ch.hash        : L.hash
    of Ch.dollar      : L.dollar
    of Ch.percent     : L.percent
    of Ch.ampersand   : L.ampersand
    of Ch.plus        : L.plus
    of Ch.comma       : L.comma
    of Ch.minus       : L.minus
    of Ch.dot         : L.dot
    of Ch.slash       : L.slash
    of Ch.semicolon   : L.semicolon
    of Ch.chevron     : L.chevron
    of Ch.question    : L.question
    of Ch.at          : L.at
    of Ch.bracket     : L.bracket
    of Ch.underscore  : L.underscore
    of Ch.brace       : L.brace
    of Ch.pipe        : L.pipe
    of Ch.tilde       : L.tilde
    of Ch.ascii_ext   : lexer.fail InvalidFirstCharacterError, &"TODO: Lexing character {$L.src[L.pos].ord}:`{L.src[L.pos]}` is not supported. Use 32..126 ascii instead."
    else              : lexer.fail UnknownFirstCharacterError, &"TODO: Lexing character {$L.src[L.pos].ord}:`{L.src[L.pos]}` not implemented."
    L.pos.inc
 
