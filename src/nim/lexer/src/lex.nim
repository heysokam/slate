#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
# @deps ndk
import ./nstd
# @deps Lex
import ./chars
import ./lexeme
import ./source

#_______________________________________
# @section Lexer Errors
#_____________________________
type LexerError = object of CatchableError
type UnknownFirstCharacterError = object of LexerError
type InvalidFirstCharacterError = object of LexerError
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  ## For debugging unexpected errors on the buildsystem.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))


#_______________________________________
# @section Lexer Management
#_____________________________
type Lex * = object
  pos  *:source.Pos  = 0
  src  *:source.Code = ""
  res  *:lexeme.List = @[]
func create   *(_:typedesc[Lex], src :source.Code) :Lex= Lex(src: src)
func destroy  *(L :var Lex) :void= L = Lex()
func pos_next *(L :Lex, pos :source.Pos) :source.Pos {.inline.}=
  result = L.pos+pos
  if result >= L.src.len.Sz: result = L.src.len-1
func last     *(L :Lex) :bool= L.pos == L.src.len.Sz-1
func next     *(L :Lex, pos :source.Pos) :char {.inline.}= L.src[L.pos_next(pos)]
func move     *(L :var Lex, pos :source.Pos) :void {.inline.}= L.pos = L.pos_next(pos)
func ch       *(L :Lex) :char {.inline.}= L.next(0)
func add      *(L :var Lex, id :lexeme.Id, loc :source.Loc) :void {.inline.}= L.res.add Lx(id: id, loc: loc)
func add      *(L :var Lex, id :lexeme.Id) :void {.inline.}= L.add id, source.Loc(start:L.pos, End:L.pos)


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
  L.add lexeme.Id.ident, source.Loc(start:start, End:End)
#___________________
func digit *(L :var Lex) :void=
  let start = L.pos
  var End   = L.pos
  while L.ch in Ch.digit:
    End = L.pos
    L.move(1)
    if L.last: break # FIX: This shouldn't be here
  L.add lexeme.Id.number, source.Loc(start:start, End:End)


#_______________________________________
# @section Symbols: Single Character
#_____________________________
# Single Entry
func exclamation *(L :var Lex) :void=  L.add lexeme.Id.exclamation
func hash        *(L :var Lex) :void=  L.add lexeme.Id.hash
func dollar      *(L :var Lex) :void=  L.add lexeme.Id.dollar
func percent     *(L :var Lex) :void=  L.add lexeme.Id.percent
func ampersand   *(L :var Lex) :void=  L.add lexeme.Id.ampersand
func star        *(L :var Lex) :void=  L.add lexeme.Id.star
func plus        *(L :var Lex) :void=  L.add lexeme.Id.plus
func comma       *(L :var Lex) :void=  L.add lexeme.Id.comma
func minus       *(L :var Lex) :void=  L.add lexeme.Id.minus
func dot         *(L :var Lex) :void=  L.add lexeme.Id.dot
func colon       *(L :var Lex) :void=  L.add lexeme.Id.colon
func semicolon   *(L :var Lex) :void=  L.add lexeme.Id.semicolon
func equal       *(L :var Lex) :void=  L.add lexeme.Id.equal
func question    *(L :var Lex) :void=  L.add lexeme.Id.question
func at          *(L :var Lex) :void=  L.add lexeme.Id.at
func pipe        *(L :var Lex) :void=  L.add lexeme.Id.pipe
func tilde       *(L :var Lex) :void=  L.add lexeme.Id.tilde
func underscore  *(L :var Lex) :void=  L.add lexeme.Id.underscore
#___________________
# Groups
func whitespace *(L :var Lex) :void=
  case L.ch
  of Ch.space   : L.add lexeme.Id.space
  of Ch.tab     : L.add lexeme.Id.tab
  of Ch.newline : L.add lexeme.Id.newline
  else: lex.fail LexerError, "whitespace  : `" & L.src[L.pos] & "`"
func quote *(L :var Lex) :void=
  case L.ch
  of Ch.quote_D : L.add lexeme.Id.quote_D
  of Ch.quote_S : L.add lexeme.Id.quote_S
  of Ch.quote_B : L.add lexeme.Id.quote_B
  else: lex.fail LexerError, "quote: `" & L.src[L.pos] & "`"
func parenthesis *(L :var Lex) :void=
  case L.ch
  of Ch.paren_L : L.add lexeme.Id.paren_L
  of Ch.paren_R : L.add lexeme.Id.paren_R
  else: lex.fail LexerError, "parenthesis: `" & L.src[L.pos] & "`"
func slash *(L :var Lex) :void=
  case L.ch
  of Ch.slash_B : L.add lexeme.Id.slash_B
  of Ch.slash_F : L.add lexeme.Id.slash_F
  else: lex.fail LexerError, "slash: `" & L.src[L.pos] & "`"
func bracket *(L :var Lex) :void=
  case L.ch
  of Ch.bracket_L : L.add lexeme.Id.bracket_L
  of Ch.bracket_R : L.add lexeme.Id.bracket_R
  else: lex.fail LexerError, "bracket: `" & L.src[L.pos] & "`"
func chevron *(L :var Lex) :void=
  case L.ch
  of Ch.less  : L.add lexeme.Id.less
  of Ch.more  : L.add lexeme.Id.more
  of Ch.caret : L.add lexeme.Id.caret
  else: lex.fail LexerError, "chevron: `" & L.src[L.pos] & "`"
func brace *(L :var Lex) :void=
  case L.ch
  of Ch.brace_L : L.add lexeme.Id.brace_L
  of Ch.brace_R : L.add lexeme.Id.brace_R
  else: lex.fail LexerError, "brace: `" & L.src[L.pos] & "`"



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
    of Ch.ascii_ext   : lex.fail InvalidFirstCharacterError, &"TODO: Lexing character {$L.src[L.pos].ord}:`{L.src[L.pos]}` is not supported. Use 32..126 ascii instead."
    else              : lex.fail UnknownFirstCharacterError, &"TODO: Lexing character {$L.src[L.pos].ord}:`{L.src[L.pos]}` not implemented."
    L.pos.inc
 
