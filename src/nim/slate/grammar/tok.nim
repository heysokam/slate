# @deps slate
import ../../lexer/src/source
import ../../lexer/src/lex
import ../../lexer/src/lexeme
# @deps grammar
import ./token


#_______________________________________
# @section Tokenizer Management
#_____________________________
type Tok * = object
  pos  *:source.Pos  = 0
  src  *:source.Code = ""
  buf  *:lexeme.List = @[]
  res  *:token.List  = @[]

func create   *(_:typedesc[Tok], L :Lex) :Tok= Tok(src: L.src, buf: L.res)
func destroy  *(T :var Tok) :void= T = Tok()
func pos_next *(T :Tok, pos :source.Pos) :source.Pos {.inline.}=
  result = T.pos+pos
  if result >= T.buf.len.uint: result = T.buf.len-1


#_______________________________________
# @section Tokenizer: Entry Point
#_____________________________
func process *(T :var Tok) :void=
  while T.pos < T.buf.len.uint:
    debugEcho T.pos
    T.pos.inc

