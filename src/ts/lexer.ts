//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________

//______________________________________
// @section Characters
//____________________________
export namespace Ch {
export const code            = (ch :string) :number=> ch.charCodeAt(0)
export const range_fromCodes = (start :number, end :number) :string=> JSON.stringify((Array.from(Array(end + start).keys()).slice(start).map((item) => String.fromCharCode(item))).join(''))
export const range           = (start :string, end :string) :string=> Ch.range_fromCodes(Ch.code(start), Ch.code(end))
export const From            = (code :number) :string=> String.fromCharCode(code)

// Whitespace
export const space        = " "
export const tab          = "\t"
export const newline      = "\n\r"
export const whitespace   = Ch.space + Ch.tab + Ch.newline

// Characters
export const lowercase    = Ch.range('a','z')
export const uppercase    = Ch.range('A','Z')
export const alphabetic   = Ch.lowercase + Ch.uppercase
export const digit        = Ch.range('0','9')
export const digitLetters = Ch.range('a','f') + Ch.range('A','F') + "oOxXbB"

// Symbols
export const exclamation = '!'
export const quote_D     = '"'
export const quote_S     = '\''
export const quote_B     = '`'
export const hash        = '#'
export const dollar      = '$'
export const percent     = '%'
export const ampersand   = '&'
export const paren_L     = '('
export const paren_R     = ')'
export const star        = '*'
export const plus        = '+'
export const comma       = ','
export const minus       = '-'
export const dot         = '.'
export const slash_F     = '/'
export const slash_B     = '\\'
export const colon       = ':'
export const semicolon   = ';'
export const less        = '<'
export const more        = '>'
export const equal       = '='
export const question    = '?'
export const at          = '@'
export const bracket_L   = '['
export const bracket_R   = ']'
export const caret       = '^'
export const underscore  = '_'
export const brace_L     = '{'
export const brace_R     = '}'
export const pipe        = '|'
export const tilde       = '~'
export const Undefined   = Ch.From(0xAA)
export const EOF         = Ch.From(0)
// Character Groups
export const numeric     = Ch.digit + Ch.digitLetters + Ch.underscore
export const quote       = Ch.quote_D + Ch.quote_S + Ch.quote_B
export const parenthesis = Ch.paren_L + Ch.paren_R
export const slash       = Ch.slash_F + Ch.slash_B
export const compare     = Ch.less + Ch.more
export const chevron     = Ch.compare + Ch.caret
export const bracket     = Ch.bracket_L + Ch.bracket_R
export const brace       = Ch.brace_L + Ch.brace_R
export const ascii       = Ch.whitespace + Ch.range_fromCodes(32,126)
export const ascii_ext   = Ch.range_fromCodes(127,255)
export const ascii_all   = Ch.ascii + Ch.ascii_ext
export const printable   = Ch.ascii + Ch.From(128) + Ch.range_fromCodes(130,140) + Ch.From(142) + Ch.range_fromCodes(145,156) + Ch.range_fromCodes(158,159) + Ch.range_fromCodes(161,172) + Ch.range_fromCodes(174,255)
} //:: Ch


//______________________________________
// @section Source
//____________________________
export namespace source {
  export type  Code     = string
  export type  Position = number
  export type  Location = { start :source.Position, end :source.Position }
  export const From     = (loc :source.Location, src :source.Code) :string=> src.slice(loc.start, loc.end+1)
}


//______________________________________
// @section Lexeme
//____________________________
export namespace lexeme {
  // @description {@link Lx.id} Valid kinds for Lexemes
export enum Id  {
  ident,
  number,
  underscore,  // _
  colon,       // :
  equal,       // =
  star,        // *
  paren_L,     // (
  paren_R,     // )
  hash,        // #
  semicolon,   // ;
  quote_S,     // '  (single quote)
  quote_D,     // "  (double quote)
  quote_B,     // `  (backtick quote)
  brace_L,     // {
  brace_R,     // }
  bracket_L,   // [
  bracket_R,   // ]
  dot,         // .
  comma,       // ,
  // Operators
  plus,        // +
  minus,       // -  (also dash, min, minus)
  slash_F,     // /  (forward slash)
  less,        // <
  more,        // >
  at,          // @
  dollar,      // $
  tilde,       // ~
  ampersand,   // &
  percent,     // %
  pipe,        // |
  exclamation, // !
  question,    // ?
  caret,       // ^
  slash_B,     // \  (backward slash)
  // Whitespace
  space,       // ` `
  newline,     // \n \r
  tab,         // \t
  EOF,         // 0x0  (the null character 0 is treated as an EOF marker)
} //:: lexeme.Id
} //:: lexeme
export type Lexeme = {
  id   :lexeme.Id
  loc  :source.Location
}
export namespace lexeme {
  export type List = Lexeme[]
  export const From = (lx :Lexeme, src :source.Code) :string=> source.From(lx.loc, src)
}



//______________________________________
// @section Lexer Errors
//____________________________
export class LexerError extends Error {}
export class UnknownFirstCharacterError extends LexerError {}
export class InvalidFirstCharacterError extends LexerError {}
export namespace lexer {
  /**
   * @description
   * Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
   * */
  export function fail(err :any) { throw err }
} //:: lexer

export class Lexer {
  pos  :source.Position
  src  :source.Code
  res  :lexeme.List
  constructor(src :source.Code) {
    this.pos = 0
    this.src = src.slice()
    this.res = []
  }
  destroy() {
    this.pos = 0
    this.src = ""
    this.res = []
  }

  //_______________________________________
  // @section Lexer Management
  //_____________________________
  pos_next (pos :source.Position) :source.Position {
    let result = this.pos + pos
    if (result >= this.src.length) result = this.src.length-1 // Saturate
    return result
  }
  last () :boolean { return this.pos == this.src.length-1 }
  move (pos :source.Position) :void { this.pos = this.pos_next(pos) }
  next (pos :source.Position) :string { return this.src.at(this.pos_next(pos)) || "" }
  ch   () :string { return this.next(0) }
  add  (id :lexeme.Id, loc ?:source.Location) :void { this.res.push({id: id, loc: loc || { start: this.pos, end: this.pos }}) }

  //_______________________________________
  // @section Identifier Characters
  //_____________________________
  alphabetic () :void {
    let start = this.pos
    let end   = this.pos
    while (Ch.alphabetic.includes(this.ch())) {
      end = this.pos
      this.move(1)
      if (this.last()) break; // FIX: Probably shouldn't be here
    }
    this.add(lexeme.Id.ident, {start: start, end: end})
    this.move(-1)
  } //:: Lexer.alphabetic
  //__________________
  digit () :void {
    let start = this.pos
    let end   = this.pos
    while (Ch.digit.includes(this.ch())) {
      end = this.pos
      this.move(1)
      if (this.last()) break; // FIX: Probably shouldn't be here
    }
    this.add(lexeme.Id.number, {start: start, end: end})
    this.move(-1)
  } //:: Lexer.alphabetic

  //_______________________________________
  // @section Symbols: Single Character
  //_____________________________
  // Single Entry
  exclamation () :void { this.add(lexeme.Id.exclamation) }
  hash        () :void { this.add(lexeme.Id.hash)        }
  dollar      () :void { this.add(lexeme.Id.dollar)      }
  percent     () :void { this.add(lexeme.Id.percent)     }
  ampersand   () :void { this.add(lexeme.Id.ampersand)   }
  star        () :void { this.add(lexeme.Id.star)        }
  plus        () :void { this.add(lexeme.Id.plus)        }
  comma       () :void { this.add(lexeme.Id.comma)       }
  minus       () :void { this.add(lexeme.Id.minus)       }
  dot         () :void { this.add(lexeme.Id.dot)         }
  colon       () :void { this.add(lexeme.Id.colon)       }
  semicolon   () :void { this.add(lexeme.Id.semicolon)   }
  equal       () :void { this.add(lexeme.Id.equal)       }
  question    () :void { this.add(lexeme.Id.question)    }
  at          () :void { this.add(lexeme.Id.at)          }
  pipe        () :void { this.add(lexeme.Id.pipe)        }
  tilde       () :void { this.add(lexeme.Id.tilde)       }
  underscore  () :void { this.add(lexeme.Id.underscore)  }
  //___________________
  // Groups
  whitespace () :void {
    switch (this.ch()) {
      case Ch.space   : this.add(lexeme.Id.space)   ; break;
      case Ch.tab     : this.add(lexeme.Id.tab)     ; break;
      case Ch.newline : this.add(lexeme.Id.newline) ; break;
      default: lexer.fail(new LexerError(`whitespace : \`${this.ch()}\``))
    }
  }
  quote () :void {
    switch (this.ch()) {
      case Ch.quote_D : this.add(lexeme.Id.quote_D) ; break;
      case Ch.quote_S : this.add(lexeme.Id.quote_S) ; break;
      case Ch.quote_B : this.add(lexeme.Id.quote_B) ; break;
      default: lexer.fail(new LexerError(`quote : \`${this.ch()}\``))
    }
  }
  parenthesis () :void {
    switch (this.ch()) {
      case Ch.paren_L : this.add(lexeme.Id.paren_L) ; break;
      case Ch.paren_R : this.add(lexeme.Id.paren_R) ; break;
      default: lexer.fail(new LexerError(`parenthesis : \`${this.ch()}\``))
    }
  }
  slash () :void {
    switch (this.ch()) {
      case Ch.slash_B : this.add(lexeme.Id.slash_B) ; break;
      case Ch.slash_F : this.add(lexeme.Id.slash_F) ; break;
      default: lexer.fail(new LexerError(`slash : \`${this.ch()}\``))
    }
  }
  bracket () :void {
    switch (this.ch()) {
      case Ch.bracket_L : this.add(lexeme.Id.bracket_L) ; break;
      case Ch.bracket_R : this.add(lexeme.Id.bracket_R) ; break;
      default: lexer.fail(new LexerError(`bracket : \`${this.ch()}\``))
    }
  }
  chevron () :void {
    switch (this.ch()) {
      case Ch.less  : this.add(lexeme.Id.less)  ; break;
      case Ch.more  : this.add(lexeme.Id.more)  ; break;
      case Ch.caret : this.add(lexeme.Id.caret) ; break;
      default: lexer.fail(new LexerError(`chevron : \`${this.ch()}\``))
    }
  }
  brace () :void {
    switch (this.ch()) {
      case Ch.brace_L : this.add(lexeme.Id.brace_L) ; break;
      case Ch.brace_R : this.add(lexeme.Id.brace_R) ; break;
      default: lexer.fail(new LexerError(`brace : \`${this.ch()}\``))
    }
  }

  process () :void {
    while (this.pos < this.src.length) { switch (this.ch()) {
      case Ch.whitespace  : this.whitespace(); break;
      case Ch.alphabetic  : this.alphabetic(); break;
      case Ch.digit       : this.digit(); break;
      case Ch.parenthesis : this.parenthesis(); break;
      case Ch.star        : this.star(); break;
      case Ch.colon       : this.colon(); break;
      case Ch.equal       : this.equal(); break;
      case Ch.exclamation : this.exclamation(); break;
      case Ch.quote       : this.quote(); break;
      case Ch.hash        : this.hash(); break;
      case Ch.dollar      : this.dollar(); break;
      case Ch.percent     : this.percent(); break;
      case Ch.ampersand   : this.ampersand(); break;
      case Ch.plus        : this.plus(); break;
      case Ch.comma       : this.comma(); break;
      case Ch.minus       : this.minus(); break;
      case Ch.dot         : this.dot(); break;
      case Ch.slash       : this.slash(); break;
      case Ch.semicolon   : this.semicolon(); break;
      case Ch.chevron     : this.chevron(); break;
      case Ch.question    : this.question(); break;
      case Ch.at          : this.at(); break;
      case Ch.bracket     : this.bracket(); break;
      case Ch.underscore  : this.underscore(); break;
      case Ch.brace       : this.brace(); break;
      case Ch.pipe        : this.pipe(); break;
      case Ch.tilde       : this.tilde(); break;
      case Ch.ascii_ext   : lexer.fail(new InvalidFirstCharacterError(`TODO: Lexing character ${Ch.code(this.ch())}:\`${this.ch()}\` is not supported. Use 32..126 ascii instead.`))
      default             : lexer.fail(new UnknownFirstCharacterError(`TODO: Lexing character ${Ch.code(this.ch())}:\`${this.ch()}\` not implemented.`))
    }}
  } //:: Lexer.process
} //:: Lexer

