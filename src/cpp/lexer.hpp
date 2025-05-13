//:_____________________________________________________________________
//  slate  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU LGPLv3 or later  :
//:_____________________________________________________________________
//! @fileoverview
//! Single header library for generic lexing of any source code string.
//! Part of the toolset at : https://github.com/heysokam/slate
//!
//! Overview
//! Provides base Character, Lexer and Lexeme tools.
//! The core of these tools is to provide generic character walking logic.
//! The result is then consumed by a parser to dictate the rules of a language.
//! This separation of concerns greatly simplifies parsing logic.
//!
//! Lexeme
//! The result of the lexing process will contain a vector of Lexemes
//! Each Lexeme represents an (Id, Location) pair, without any text.
//! Said data can be stored freely by the consumer as they see fit.
//!
//! Lexer
//! Instead of each parser requiring its own character walking logic,
//! this Lexer implements a generic walker that creates a list of Lexemes.
//! This list can then be consumed by a parser,
//! which can focus solely on dictating the rules of the target language.
//!
//! Requires -std=c++20 (for std::format)
//___________________________________________________________________________|
#if !defined Hpp_slate_lexer_base
#define Hpp_slate_lexer_base
// @dependencies libc++
#include <string>
#include <cstddef>
#include <vector>
#include <format>
#include <stdexcept>
#include <ostream>


//______________________________________
// @section General Helpers
//____________________________
/// Pure Function Attribute
/// See: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-const-function-attribute
#if defined __GNUC__ || defined __clang__
#if !defined pure
#define pure __attribute__((const))
#endif
#else
#if !defined pure
#define pure
#endif
#endif


//____________________________
// Slate: Base Character, Lexer and Lexeme Tools
namespace slate {
using string = std::string;  // FIX: Allow unicode and/or u8


//......................................
// @section Character: Singles
//............................
namespace Ch {
// Whitespace
pure inline bool isSpace(char const ch) { return ch == ' '; }
pure inline bool isTab(char const ch) { return ch == '\t'; }
pure inline bool isNewline(char const ch) { return ch == '\n' or ch == '\r'; }
// Operators / Symbols
pure inline bool isExclamation(char const ch) { return ch == '!'; }
pure inline bool isQuote_single(char const ch) { return ch == '\''; }
pure inline bool isQuote_double(char const ch) { return ch == '"'; }
pure inline bool isQuote_backtick(char const ch) { return ch == '`'; }
pure inline bool isHashtag(char const ch) { return ch == '#'; }
pure inline bool isDollar(char const ch) { return ch == '$'; }
pure inline bool isPercent(char const ch) { return ch == '%'; }
pure inline bool isAmpersand(char const ch) { return ch == '&'; }
pure inline bool isParenthesis_left(char const ch) { return ch == '('; }
pure inline bool isParenthesis_right(char const ch) { return ch == ')'; }
pure inline bool isStar(char const ch) { return ch == '*'; }
pure inline bool isPlus(char const ch) { return ch == '+'; }
pure inline bool isComma(char const ch) { return ch == ','; }
pure inline bool isMinus(char const ch) { return ch == '-'; }
pure inline bool isDot(char const ch) { return ch == '.'; }
pure inline bool isSlash_forward(char const ch) { return ch == '/'; }
pure inline bool isSlash_back(char const ch) { return ch == '\\'; }
pure inline bool isColon(char const ch) { return ch == ':'; }
pure inline bool isSemicolon(char const ch) { return ch == ';'; }
pure inline bool isLess(char const ch) { return ch == '<'; }
pure inline bool isEqual(char const ch) { return ch == '='; }
pure inline bool isMore(char const ch) { return ch == '>'; }
pure inline bool isQuestion(char const ch) { return ch == '?'; }
pure inline bool isAt(char const ch) { return ch == '@'; }
pure inline bool isBracket_left(char const ch) { return ch == '['; }
pure inline bool isBracket_right(char const ch) { return ch == ']'; }
pure inline bool isCaret(char const ch) { return ch == '^'; }
pure inline bool isUnderscore(char const ch) { return ch == '_'; }
pure inline bool isBrace_left(char const ch) { return ch == '{'; }
pure inline bool isBrace_right(char const ch) { return ch == '}'; }
pure inline bool isPipe(char const ch) { return ch == '|'; }
pure inline bool isTilde(char const ch) { return ch == '~'; }
pure inline bool isEOF(char const ch) { return ch == 0 or ch == EOF; }
};  // namespace Ch


//......................................
// @section Character: Groups
//............................
namespace Ch {
// Whitespace
pure inline bool isWhitespace(char const ch) { return Ch::isSpace(ch) or Ch::isTab(ch); }
// Identifiers & Numbers
pure inline bool isDigit(char const ch) { return (ch >= '0' and ch <= '9'); }
pure inline bool isAlphabetic(char const ch) { return (ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z'); }
pure inline bool isIdent(char const ch) { return Ch::isUnderscore(ch) or Ch::isAlphabetic(ch) or Ch::isDigit(ch); }
// Operators / Symbols
pure inline bool isQuote(char const ch) { return Ch::isQuote_single(ch) or Ch::isQuote_double(ch) or Ch::isQuote_backtick(ch); }
pure inline bool isParenthesis(char const ch) { return Ch::isParenthesis_left(ch) or Ch::isParenthesis_right(ch); }
pure inline bool isSlash(char const ch) { return Ch::isSlash_forward(ch) or Ch::isSlash_back(ch); }
pure inline bool isBracket(char const ch) { return Ch::isBracket_left(ch) or Ch::isBracket_right(ch); }
pure inline bool isBrace(char const ch) { return Ch::isBrace_left(ch) or Ch::isBrace_right(ch); }
};  // namespace Ch


//......................................
// @section SourceCode: Types
//............................
namespace source {
typedef std::size_t Pos;
typedef slate::string Code;
typedef struct Location {
  source::Pos start;
  source::Pos end;
} Location;
};  // namespace source


//......................................
// @section SourceCode: Tools
//............................
namespace source {

/// @brief Returns the string value found at the {@arg loc} location of {@arg src}.
/// @note Does not perform bounds check on {@arg src}. It will fail when the location is out of bounds.
pure inline slate::string Location_from(Location const& loc, source::Code const& src) { return src.substr(loc.start, loc.end - loc.start + 1); }

/// @brief Returns true when {@arg B} is located right after {@arg A}
pure inline bool Location_adjacent(Location const& A, Location const& B) { return B.start == A.end + 1; }

/// @brief
/// Adds the {@arg B} location to {@arg A}.
/// They are required to be adjacent.
pure inline Location Location_add(Location const& A, Location const& B) {
  if (!Location_adjacent(A, B))
    throw std::runtime_error(std::format("Tried to add a location to another, but the locations are not adjacent. {} != {}", B.start, A.end + 1));
  return Location{.start = A.start, .end = B.end};
}
};  // namespace source


//......................................
// @section Lexeme: Types
//............................
struct Lexeme;

namespace lex {

enum class Id {
  identifier,
  number,
  whitespace,         // ` ` \t // TODO: Might need to split into multiple IDs
  newline,            // \n \r  // TODO: Might need to split into multiple IDs
  exclamation,        // !
  quote_single,       // '
  quote_double,       // "
  quote_backtick,     // `
  hashtag,            // #
  dollar,             // $
  percent,            // %
  ampersand,          // &
  parenthesis_left,   // (
  parenthesis_right,  // )
  star,               // *
  plus,               // +
  comma,              // ,
  minus,              // -
  dot,                // .
  slash_forward,      // /
  slash_back,         // `\`
  colon,              // :
  semicolon,          // ;
  less,               // <
  more,               // >
  equal,              // =
  question,           // ?
  at,                 // @
  bracket_left,       // [
  bracket_right,      // ]
  caret,              // ^
  brace_left,         // {
  brace_right,        // }
  pipe,               // |
  tilde,              // ~
  eof,                // \0
};  //:: lex.Id
using List = std::vector<Lexeme>;

};  // namespace lex

typedef struct Lexeme {
  lex::Id id;
  source::Location loc;
} Lexeme;


//......................................
// @section Lexeme: Tools
//............................
namespace lex {
pure inline slate::string Id_toString(lex::Id const& id) {
  switch (id) {
    case lex::Id::identifier: return "identifier";
    case lex::Id::newline: return "newline";
    case lex::Id::number: return "number";
    case lex::Id::whitespace: return "whitespace";
    case lex::Id::exclamation: return "exclamation";
    case lex::Id::quote_single: return "quote_single";
    case lex::Id::quote_double: return "quote_double";
    case lex::Id::quote_backtick: return "quote_backtick";
    case lex::Id::hashtag: return "hashtag";
    case lex::Id::dollar: return "dollar";
    case lex::Id::percent: return "percent";
    case lex::Id::ampersand: return "ampersand";
    case lex::Id::parenthesis_left: return "parenthesis_left";
    case lex::Id::parenthesis_right: return "parenthesis_right";
    case lex::Id::star: return "star";
    case lex::Id::plus: return "plus";
    case lex::Id::comma: return "comma";
    case lex::Id::minus: return "minus";
    case lex::Id::dot: return "dot";
    case lex::Id::slash_forward: return "slash_forward";
    case lex::Id::slash_back: return "slash_back";
    case lex::Id::colon: return "colon";
    case lex::Id::semicolon: return "semicolon";
    case lex::Id::less: return "less";
    case lex::Id::more: return "more";
    case lex::Id::equal: return "equal";
    case lex::Id::question: return "question";
    case lex::Id::at: return "at";
    case lex::Id::bracket_left: return "bracket_left";
    case lex::Id::bracket_right: return "bracket_right";
    case lex::Id::caret: return "caret";
    case lex::Id::brace_left: return "brace_left";
    case lex::Id::brace_right: return "brace_right";
    case lex::Id::pipe: return "pipe";
    case lex::Id::tilde: return "tilde";
    case lex::Id::eof: return "EOF";
    default: return "UnknownLexemeID";
  }
}
};  // namespace lex

pure inline slate::string Lexeme_toString(Lexeme const& lx, source::Code src) {
  return std::format("{} : `{}`\n", Id_toString(lx.id), source::Location_from(lx.loc, src));
}

//......................................
// @section Lexer: Types & Tools
//............................
class Lexer {
 public:
  source::Code m_src;
  source::Pos m_pos = 0;
  lex::List result;

  pure inline source::Code src() { return m_src.substr(0, m_src.length()); }

  inline Lexer(source::Code code) {
    m_pos = 0;
    m_src = code;
    m_src.push_back(0);  // Crucial: Null terminator represents EOF
    result = lex::List();
  }

  inline void m_add(lex::Id id) {
    auto lexeme = Lexeme();
    lexeme.id = id;
    lexeme.loc.start = m_pos;
    lexeme.loc.end = m_pos;
    result.push_back(lexeme);
    ++m_pos;
  }

  //............................
  // Single-Character: Singles
  inline void m_newline() { m_add(lex::Id::newline); }
  inline void m_exclamation() { m_add(lex::Id::exclamation); }
  inline void m_hashtag() { m_add(lex::Id::hashtag); }
  inline void m_dollar() { m_add(lex::Id::dollar); }
  inline void m_percent() { m_add(lex::Id::percent); }
  inline void m_ampersand() { m_add(lex::Id::ampersand); }
  inline void m_star() { m_add(lex::Id::star); }
  inline void m_plus() { m_add(lex::Id::plus); }
  inline void m_comma() { m_add(lex::Id::comma); }
  inline void m_minus() { m_add(lex::Id::minus); }
  inline void m_dot() { m_add(lex::Id::dot); }
  inline void m_colon() { m_add(lex::Id::colon); }
  inline void m_semicolon() { m_add(lex::Id::semicolon); }
  inline void m_less() { m_add(lex::Id::less); }
  inline void m_equal() { m_add(lex::Id::equal); }
  inline void m_more() { m_add(lex::Id::more); }
  inline void m_question() { m_add(lex::Id::question); }
  inline void m_at() { m_add(lex::Id::at); }
  inline void m_caret() { m_add(lex::Id::caret); }
  inline void m_pipe() { m_add(lex::Id::pipe); }
  inline void m_tilde() { m_add(lex::Id::tilde); }
  inline void m_eof() { m_add(lex::Id::eof); }

  //............................
  // Single-Character: Groups
  inline void m_quote() {
    char const ch = m_src.at(m_pos);
    if (Ch::isQuote_single(ch)) m_add(lex::Id::quote_single);
    else if (Ch::isQuote_double(ch)) m_add(lex::Id::quote_double);
    else if (Ch::isQuote_backtick(ch)) m_add(lex::Id::quote_backtick);
    else throw std::runtime_error(std::format("Unknown Quote Character: `{}`", ch));
  }
  //..................
  inline void m_parenthesis() {
    char const ch = m_src.at(m_pos);
    if (Ch::isParenthesis_left(ch)) m_add(lex::Id::parenthesis_left);
    else if (Ch::isParenthesis_right(ch)) m_add(lex::Id::parenthesis_right);
    else throw std::runtime_error(std::format("Unknown Parenthesis Character: `{}`", ch));
  }
  //..................
  inline void m_slash() {
    char const ch = m_src.at(m_pos);
    if (Ch::isSlash_forward(ch)) m_add(lex::Id::slash_forward);
    else if (Ch::isSlash_back(ch)) m_add(lex::Id::slash_back);
    else throw std::runtime_error(std::format("Unknown Slash Character: `{}`", ch));
  }
  //..................
  inline void m_bracket() {
    char const ch = m_src.at(m_pos);
    if (Ch::isBracket_left(ch)) m_add(lex::Id::bracket_left);
    else if (Ch::isBracket_right(ch)) m_add(lex::Id::bracket_right);
    else throw std::runtime_error(std::format("Unknown Bracket Character: `{}`", ch));
  }
  //..................
  inline void m_brace() {
    char const ch = m_src.at(m_pos);
    if (Ch::isBrace_left(ch)) m_add(lex::Id::brace_left);
    else if (Ch::isBrace_right(ch)) m_add(lex::Id::brace_right);
    else throw std::runtime_error(std::format("Unknown Brace Character: `{}`", ch));
  }

  //............................
  // Multi-Character
  inline void m_number() {
    auto lexeme = Lexeme();
    lexeme.id = lex::Id::number;
    lexeme.loc.start = m_pos;
    lexeme.loc.end = m_pos;
    while (Ch::isDigit(m_src.at(m_pos))) {
      lexeme.loc.end = m_pos;
      ++m_pos;
    }
    result.push_back(lexeme);
  }
  //..................
  inline void m_identifier() {
    auto lexeme = Lexeme();
    lexeme.id = lex::Id::identifier;
    lexeme.loc.start = m_pos;
    lexeme.loc.end = m_pos;
    while (Ch::isIdent(m_src.at(m_pos))) {
      lexeme.loc.end = m_pos;
      ++m_pos;
    }
    result.push_back(lexeme);
  }
  //..................
  inline void m_whitespace() {
    auto lexeme = Lexeme();
    lexeme.id = lex::Id::whitespace;
    lexeme.loc.start = m_pos;
    lexeme.loc.end = m_pos;
    while (Ch::isWhitespace(m_src.at(m_pos))) {
      lexeme.loc.end = m_pos;
      ++m_pos;
    }
    result.push_back(lexeme);
  }

  //............................
  // Lexer: Entry Point
  inline void process() {
    while (m_pos < m_src.length()) {
      char const ch = m_src.at(m_pos);
      if (Ch::isDigit(ch)) m_number();
      else if (Ch::isIdent(ch)) m_identifier();
      else if (Ch::isWhitespace(ch)) m_whitespace();
      else if (Ch::isNewline(ch)) m_newline();
      else if (Ch::isExclamation(ch)) m_exclamation();
      else if (Ch::isQuote(ch)) m_quote();
      else if (Ch::isHashtag(ch)) m_hashtag();
      else if (Ch::isDollar(ch)) m_dollar();
      else if (Ch::isPercent(ch)) m_percent();
      else if (Ch::isAmpersand(ch)) m_ampersand();
      else if (Ch::isParenthesis(ch)) m_parenthesis();
      else if (Ch::isStar(ch)) m_star();
      else if (Ch::isPlus(ch)) m_plus();
      else if (Ch::isComma(ch)) m_comma();
      else if (Ch::isMinus(ch)) m_minus();
      else if (Ch::isDot(ch)) m_dot();
      else if (Ch::isSlash(ch)) m_slash();
      else if (Ch::isColon(ch)) m_colon();
      else if (Ch::isSemicolon(ch)) m_semicolon();
      else if (Ch::isLess(ch)) m_less();
      else if (Ch::isEqual(ch)) m_equal();
      else if (Ch::isMore(ch)) m_more();
      else if (Ch::isQuestion(ch)) m_question();
      else if (Ch::isAt(ch)) m_at();
      else if (Ch::isBracket(ch)) m_bracket();
      else if (Ch::isCaret(ch)) m_caret();
      else if (Ch::isBrace(ch)) m_brace();
      else if (Ch::isPipe(ch)) m_pipe();
      else if (Ch::isTilde(ch)) m_tilde();
      else if (Ch::isEOF(ch)) return m_eof();
      else throw std::runtime_error(std::format("Unknown First Character: `{}`", ch));
    }
  }  //:: Lexer.process
};  //:: Lexer

inline std::ostream& operator<<(std::ostream& other, Lexer L) {
  for (auto const lx : L.result) other << Lexeme_toString(lx, L.m_src);
  return other;
}

};  // namespace slate

//............................
// Lexer: Auto-Formatters
template <>
struct std::formatter<slate::lex::Id> : std::formatter<std::string_view> {
  template <typename Context>
  auto format(slate::lex::Id const id, Context& context) const {
    return formatter<std::string_view>::format(slate::lex::Id_toString(id), context);
  }
};

#endif  // Hpp_slate_lexer_base

