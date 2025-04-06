#:__________________________________________________________________
#  lex  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:__________________________________________________________________
# @deps std
from std/sequtils import foldl

type Ch * = distinct char
# Whitespace
func space       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {' '}
func tab         *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'\t'}
func newline     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'\n', '\r'}
func whitespace  *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.space + Ch.tab + Ch.newline
# Characters
func alphabetic  *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'a'..'z'} + {'A'..'Z'}
func digit       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'0'..'9'}
# Symbols
func exclamation *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'!'}
func quote_D     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'"'}
func quote_S     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'\''}
func quote_B     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'`'}
func hash        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'#'}
func dollar      *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'$'}
func percent     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'%'}
func ampersand   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'&'}
func paren_L     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'('}
func paren_R     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {')'}
func star        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'*'}
func plus        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'+'}
func comma       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {','}
func minus       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'-'}
func dot         *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'.'}
func slash_F     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'/'}
func slash_B     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'\\'}
func colon       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {':'}
func semicolon   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {';'}
func less        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'<'}
func more        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'>'}
func equal       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'='}
func question    *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'?'}
func at          *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'@'}
func bracket_L   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'['}
func bracket_R   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {']'}
func caret       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'^'}
func underscore  *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'_'}
func brace_L     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'{'}
func brace_R     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'}'}
func pipe        *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'|'}
func tilde       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {'~'}
func undefined   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {0xAA}
func EOF         *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {0}
# Character Groups
func quote       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.quote_D + Ch.quote_S + Ch.quote_B
func parenthesis *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.paren_L + Ch.paren_R
func slash       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.slash_F + Ch.slash_B
func compare     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.less + Ch.more
func chevron     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.compare + Ch.caret
func bracket     *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.bracket_L + Ch.bracket_R
func brace       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.brace_L + Ch.brace_R
func ascii       *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.whitespace + { 32.char .. 126.char}
func ascii_ext   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= {127.char .. 255.char}
func ascii_all   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.ascii + Ch.ascii_ext
func printable   *(_:typedesc[Ch]=Ch) :set[char] {.inline.}= Ch.ascii + { 128.char, 130.char..140.char, 142.char, 145.char..156.char, 158.char..159.char, 161.char..172.char, 174.char..255.char}
# Conversion
func toString    *(_:typedesc[Ch], list :set[char]) :string {.inline.}= list.foldl(a&b, "")

