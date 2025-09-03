//:__________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:__________________________________________________________
//! @fileoverview
//! Single header library for generic lexing of any source code string.
//!
//! Overview
//! Provides base Character, Lexer and Lexeme tools.
//! The core of these tools is to provide generic character walking logic.
//! The result is then consumed by a tokenizer to dictate the symbols of a language.
//! This separation of concerns greatly simplifies parsing logic.
//!
//! Lexeme
//! The result of the lexing process will contain a slice of Lexemes.
//! Each Lexeme represents an (Id, Location) pair, without any text.
//! Said data can be stored freely by the consumer as they see fit.
//!
//! Lexer
//! Instead of each parser requiring its own character walking logic,
//! this Lexer implements a generic walker that creates a list of Lexemes.
//! This list can then be consumed by a tokenizer,
//! which can focus solely on interpreting the meaningless symbols
//! and give meaning to the target language.
//________________________________________________________________________|
#ifndef H_slate_lexer
#define H_slate_lexer
// @deps std
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpre-c23-compat"
#pragma GCC diagnostic ignored "-Wunsafe-buffer-usage"


//______________________________________
// @section General Helpers
//____________________________

#define slate_error(msg, ...)          \
  do {                                 \
    fprintf(stderr, msg, __VA_ARGS__); \
    assert(false);                     \
  } while (0)


//______________________________________
// @section Base Types
//____________________________

typedef bool       slate_bool;
typedef size_t     slate_size;
typedef char const slate_Ch;
typedef slate_Ch*  slate_cstring;
#define slate_cstring_equal(A, B) ((A) == NULL || (B == NULL)) ? 0 : strcmp(A, B) == 0


//_______________________________________
// @section Character: Singles
//____________________________
// clang-format off

// Whitespace
slate_bool slate_ch_isSpace             (slate_Ch ch);
slate_bool slate_ch_isTab               (slate_Ch ch);
slate_bool slate_ch_isNewline           (slate_Ch ch);
// Operators / Symbols
slate_bool slate_ch_isExclamation       (slate_Ch ch);
slate_bool slate_ch_isQuote_single      (slate_Ch ch);
slate_bool slate_ch_isQuote_double      (slate_Ch ch);
slate_bool slate_ch_isQuote_backtick    (slate_Ch ch);
slate_bool slate_ch_isHashtag           (slate_Ch ch);
slate_bool slate_ch_isDollar            (slate_Ch ch);
slate_bool slate_ch_isPercent           (slate_Ch ch);
slate_bool slate_ch_isAmpersand         (slate_Ch ch);
slate_bool slate_ch_isParenthesis_left  (slate_Ch ch);
slate_bool slate_ch_isParenthesis_right (slate_Ch ch);
slate_bool slate_ch_isStar              (slate_Ch ch);
slate_bool slate_ch_isPlus              (slate_Ch ch);
slate_bool slate_ch_isComma             (slate_Ch ch);
slate_bool slate_ch_isMinus             (slate_Ch ch);
slate_bool slate_ch_isDot               (slate_Ch ch);
slate_bool slate_ch_isSlash_forward     (slate_Ch ch);
slate_bool slate_ch_isSlash_back        (slate_Ch ch);
slate_bool slate_ch_isColon             (slate_Ch ch);
slate_bool slate_ch_isSemicolon         (slate_Ch ch);
slate_bool slate_ch_isLess              (slate_Ch ch);
slate_bool slate_ch_isEqual             (slate_Ch ch);
slate_bool slate_ch_isMore              (slate_Ch ch);
slate_bool slate_ch_isQuestion          (slate_Ch ch);
slate_bool slate_ch_isAt                (slate_Ch ch);
slate_bool slate_ch_isBracket_left      (slate_Ch ch);
slate_bool slate_ch_isBracket_right     (slate_Ch ch);
slate_bool slate_ch_isCaret             (slate_Ch ch);
slate_bool slate_ch_isUnderscore        (slate_Ch ch);
slate_bool slate_ch_isBrace_left        (slate_Ch ch);
slate_bool slate_ch_isBrace_right       (slate_Ch ch);
slate_bool slate_ch_isPipe              (slate_Ch ch);
slate_bool slate_ch_isTilde             (slate_Ch ch);
slate_bool slate_ch_isEOF               (slate_Ch ch);

// clang-format on


//______________________________________
// @section Character: Groups
//____________________________
// clang-format off

// Whitespace
slate_bool slate_ch_isWhitespace  (slate_Ch ch);
// Identifiers & Numbers
slate_bool slate_ch_isDigit       (slate_Ch ch);
slate_bool slate_ch_isAlphabetic  (slate_Ch ch);
slate_bool slate_ch_isIdent       (slate_Ch ch);
// Operators / Symbols
slate_bool slate_ch_isQuote       (slate_Ch ch);
slate_bool slate_ch_isParenthesis (slate_Ch ch);
slate_bool slate_ch_isSlash       (slate_Ch ch);
slate_bool slate_ch_isBracket     (slate_Ch ch);
slate_bool slate_ch_isBrace       (slate_Ch ch);

// clang-format on


//______________________________________
// @section Source: Types
//____________________________

typedef slate_cstring slate_source_Code;
typedef slate_size    slate_source_Pos;

typedef struct slate_source_Location {
  slate_source_Pos start;
  slate_source_Pos end;
} slate_source_Location;


//______________________________________
// @section Source: Tools
//____________________________

/// @brief Returns the string value found at the {@arg loc} location of {@arg src}.
/// @note Does not perform bounds check on {@arg src}. It will fail when the location is out of bounds.
slate_cstring slate_source_location_from (slate_source_Location const* const loc, slate_source_Code const src);

/// @brief Returns true when {@arg B} is located right after {@arg A}
slate_bool slate_source_location_adjacent (slate_source_Location const* const A, slate_source_Location const* const B);

/// @brief
/// Adds the {@arg B} location to {@arg A}.
/// They are required to be adjacent.
slate_source_Location slate_source_location_add (slate_source_Location const* const A, slate_source_Location const* const B);

slate_bool slate_source_location_equal (slate_source_Location const* const loc, slate_source_Code const src, slate_cstring const trg);


//______________________________________
// @section Lexeme: Types
//____________________________
typedef enum slate_lexeme_Id {
  slate_lexeme_identifier,
  slate_lexeme_number,
  slate_lexeme_whitespace,         // ` ` \t // TODO: Might need to split into multiple IDs
  slate_lexeme_newline,            // \n \r  // TODO: Might need to split into multiple IDs
  slate_lexeme_exclamation,        // !
  slate_lexeme_quote_single,       // '
  slate_lexeme_quote_double,       // "
  slate_lexeme_quote_backtick,     // `
  slate_lexeme_hashtag,            // #
  slate_lexeme_dollar,             // $
  slate_lexeme_percent,            // %
  slate_lexeme_ampersand,          // &
  slate_lexeme_parenthesis_left,   // (
  slate_lexeme_parenthesis_right,  // )
  slate_lexeme_star,               // *
  slate_lexeme_plus,               // +
  slate_lexeme_comma,              // ,
  slate_lexeme_minus,              // -
  slate_lexeme_dot,                // .
  slate_lexeme_slash_forward,      // /
  slate_lexeme_slash_back,         // `\`
  slate_lexeme_colon,              // :
  slate_lexeme_semicolon,          // ;
  slate_lexeme_less,               // <
  slate_lexeme_more,               // >
  slate_lexeme_equal,              // =
  slate_lexeme_question,           // ?
  slate_lexeme_at,                 // @
  slate_lexeme_bracket_left,       // [
  slate_lexeme_bracket_right,      // ]
  slate_lexeme_caret,              // ^
  slate_lexeme_brace_left,         // {
  slate_lexeme_brace_right,        // }
  slate_lexeme_pipe,               // |
  slate_lexeme_tilde,              // ~
  slate_lexeme_eof,                // \0
  // clang-format off
  slate_lexeme_Id_Force32 = 0x7FFFFFFF,
  // clang-format on
} slate_lexeme_Id;

typedef struct slate_Lexeme {
  slate_source_Location loc;
  slate_lexeme_Id       id;
  char                  priv_pad[4];
} slate_Lexeme;

typedef struct slate_lexeme_List {
  slate_Lexeme* ptr;
  slate_size    len;
  slate_size    cap;
} slate_lexeme_List;


//______________________________________
// @section Lexeme: Tools
//____________________________

slate_cstring slate_lexeme_toString (slate_lexeme_Id const id);

void slate_lexeme_list_grow (slate_lexeme_List* const list, slate_size const len);


//______________________________________
// @section Lexer
//____________________________

typedef struct slate_Lexer {
  struct {
    slate_size /* readonly */    len;  // Only for ergonomics. .src is NULL terminated
    slate_cstring /* readonly */ ptr;
  } src;
  slate_source_Pos  pos;
  slate_lexeme_List res;
} slate_Lexer;

slate_Lexer slate_lexer_create (slate_cstring const src);
void        slate_lexer_destroy (slate_Lexer* const L);
void        slate_lexer_process (slate_Lexer* const L);
void        slate_lexer_add (slate_Lexer* const L, slate_lexeme_Id const id, slate_source_Location const loc);
void        slate_lexer_add_single (slate_Lexer* const L, slate_lexeme_Id const id);
void        slate_lexer_report (slate_Lexer const* const L);

// clang-format off

void slate_lexer_newline     (slate_Lexer* const L);
void slate_lexer_exclamation (slate_Lexer* const L);
void slate_lexer_hashtag     (slate_Lexer* const L);
void slate_lexer_dollar      (slate_Lexer* const L);
void slate_lexer_percent     (slate_Lexer* const L);
void slate_lexer_ampersand   (slate_Lexer* const L);
void slate_lexer_star        (slate_Lexer* const L);
void slate_lexer_plus        (slate_Lexer* const L);
void slate_lexer_comma       (slate_Lexer* const L);
void slate_lexer_minus       (slate_Lexer* const L);
void slate_lexer_dot         (slate_Lexer* const L);
void slate_lexer_colon       (slate_Lexer* const L);
void slate_lexer_semicolon   (slate_Lexer* const L);
void slate_lexer_less        (slate_Lexer* const L);
void slate_lexer_equal       (slate_Lexer* const L);
void slate_lexer_more        (slate_Lexer* const L);
void slate_lexer_question    (slate_Lexer* const L);
void slate_lexer_at          (slate_Lexer* const L);
void slate_lexer_caret       (slate_Lexer* const L);
void slate_lexer_pipe        (slate_Lexer* const L);
void slate_lexer_tilde       (slate_Lexer* const L);
void slate_lexer_eof         (slate_Lexer* const L);
void slate_lexer_quote       (slate_Lexer* const L);
void slate_lexer_parenthesis (slate_Lexer* const L);
void slate_lexer_slash       (slate_Lexer* const L);
void slate_lexer_bracket     (slate_Lexer* const L);
void slate_lexer_brace       (slate_Lexer* const L);
void slate_lexer_number      (slate_Lexer* const L);
void slate_lexer_identifier  (slate_Lexer* const L);
void slate_lexer_whitespace  (slate_Lexer* const L);

// clang-format on


//__________________________________________________________________________________________________
// Single Header Implementation                                                                    |
//_________________________________________________________________________________________________|
#ifdef slate_Implementation


//_______________________________________
// @section Character: Singles
//____________________________
// clang-format off

// Whitespace
inline slate_bool slate_ch_isSpace             (slate_Ch ch) { return ch == ' '; }
inline slate_bool slate_ch_isTab               (slate_Ch ch) { return ch == '\t'; }
inline slate_bool slate_ch_isNewline           (slate_Ch ch) { return ch == '\n' || ch == '\r'; }

// Operators / Symbols
inline slate_bool slate_ch_isExclamation       (slate_Ch ch) { return ch == '!'; }
inline slate_bool slate_ch_isQuote_single      (slate_Ch ch) { return ch == '\''; }
inline slate_bool slate_ch_isQuote_double      (slate_Ch ch) { return ch == '"'; }
inline slate_bool slate_ch_isQuote_backtick    (slate_Ch ch) { return ch == '`'; }
inline slate_bool slate_ch_isHashtag           (slate_Ch ch) { return ch == '#'; }
inline slate_bool slate_ch_isDollar            (slate_Ch ch) { return ch == '$'; }
inline slate_bool slate_ch_isPercent           (slate_Ch ch) { return ch == '%'; }
inline slate_bool slate_ch_isAmpersand         (slate_Ch ch) { return ch == '&'; }
inline slate_bool slate_ch_isParenthesis_left  (slate_Ch ch) { return ch == '('; }
inline slate_bool slate_ch_isParenthesis_right (slate_Ch ch) { return ch == ')'; }
inline slate_bool slate_ch_isStar              (slate_Ch ch) { return ch == '*'; }
inline slate_bool slate_ch_isPlus              (slate_Ch ch) { return ch == '+'; }
inline slate_bool slate_ch_isComma             (slate_Ch ch) { return ch == ','; }
inline slate_bool slate_ch_isMinus             (slate_Ch ch) { return ch == '-'; }
inline slate_bool slate_ch_isDot               (slate_Ch ch) { return ch == '.'; }
inline slate_bool slate_ch_isSlash_forward     (slate_Ch ch) { return ch == '/'; }
inline slate_bool slate_ch_isSlash_back        (slate_Ch ch) { return ch == '\\'; }
inline slate_bool slate_ch_isColon             (slate_Ch ch) { return ch == ':'; }
inline slate_bool slate_ch_isSemicolon         (slate_Ch ch) { return ch == ';'; }
inline slate_bool slate_ch_isLess              (slate_Ch ch) { return ch == '<'; }
inline slate_bool slate_ch_isEqual             (slate_Ch ch) { return ch == '='; }
inline slate_bool slate_ch_isMore              (slate_Ch ch) { return ch == '>'; }
inline slate_bool slate_ch_isQuestion          (slate_Ch ch) { return ch == '?'; }
inline slate_bool slate_ch_isAt                (slate_Ch ch) { return ch == '@'; }
inline slate_bool slate_ch_isBracket_left      (slate_Ch ch) { return ch == '['; }
inline slate_bool slate_ch_isBracket_right     (slate_Ch ch) { return ch == ']'; }
inline slate_bool slate_ch_isCaret             (slate_Ch ch) { return ch == '^'; }
inline slate_bool slate_ch_isUnderscore        (slate_Ch ch) { return ch == '_'; }
inline slate_bool slate_ch_isBrace_left        (slate_Ch ch) { return ch == '{'; }
inline slate_bool slate_ch_isBrace_right       (slate_Ch ch) { return ch == '}'; }
inline slate_bool slate_ch_isPipe              (slate_Ch ch) { return ch == '|'; }
inline slate_bool slate_ch_isTilde             (slate_Ch ch) { return ch == '~'; }
inline slate_bool slate_ch_isEOF               (slate_Ch ch) { return ch == 0 || ch == EOF; }

// clang-format on


//______________________________________
// @section Character: Groups
//____________________________
// clang-format off

// Whitespace
inline slate_bool slate_ch_isWhitespace  (slate_Ch ch) { return slate_ch_isSpace(ch) || slate_ch_isTab(ch); }
// Identifiers & Numbers
inline slate_bool slate_ch_isDigit       (slate_Ch ch) { return (ch >= '0' && ch <= '9'); }
inline slate_bool slate_ch_isAlphabetic  (slate_Ch ch) { return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z'); }
inline slate_bool slate_ch_isIdent       (slate_Ch ch) { return slate_ch_isUnderscore(ch) || slate_ch_isAlphabetic(ch) || slate_ch_isDigit(ch); }
// Operators / Symbols
inline slate_bool slate_ch_isQuote       (slate_Ch ch) { return slate_ch_isQuote_single(ch) || slate_ch_isQuote_double(ch) || slate_ch_isQuote_backtick(ch); }
inline slate_bool slate_ch_isParenthesis (slate_Ch ch) { return slate_ch_isParenthesis_left(ch) || slate_ch_isParenthesis_right(ch); }
inline slate_bool slate_ch_isSlash       (slate_Ch ch) { return slate_ch_isSlash_forward(ch) || slate_ch_isSlash_back(ch); }
inline slate_bool slate_ch_isBracket     (slate_Ch ch) { return slate_ch_isBracket_left(ch) || slate_ch_isBracket_right(ch); }
inline slate_bool slate_ch_isBrace       (slate_Ch ch) { return slate_ch_isBrace_left(ch) || slate_ch_isBrace_right(ch); }

// clang-format on


//______________________________________
// @section Source: Tools
//____________________________

inline slate_cstring slate_source_location_from (
  slate_source_Location const* const loc,
  slate_source_Code const            src
) {
  slate_size len    = loc->end - loc->start + 1;
  char*      result = malloc(len * sizeof(char));
  result            = memcpy(result, src + loc->start, len);
  result[len]       = 0;
  return result;
}


inline slate_bool slate_source_location_adjacent (
  slate_source_Location const* const A,
  slate_source_Location const* const B
) {
  return B->start == A->end + 1;
}


inline slate_source_Location slate_source_location_add (
  slate_source_Location const* const A,
  slate_source_Location const* const B
) {  // clang-format off
  if (!slate_source_location_adjacent(A, B)) slate_error(
    "Tried to add a location to another, but the locations are not adjacent. %zu != %zu", B->start, A->end + 1);  // clang-format on
  return (slate_source_Location){ .start = A->start, .end = B->end };
}


inline slate_bool slate_source_location_equal (
  slate_source_Location const* const loc,
  slate_source_Code const            src,
  slate_cstring const                trg
) {
  return strcmp(trg, slate_source_location_from(loc, src)) == 0;
}


//______________________________________
// @section Lexeme: Tools
//____________________________

inline slate_cstring slate_lexeme_toString (
  slate_lexeme_Id const id
) {
  switch (id) {
    case slate_lexeme_identifier        : return "identifier";
    case slate_lexeme_newline           : return "newline";
    case slate_lexeme_number            : return "number";
    case slate_lexeme_whitespace        : return "whitespace";
    case slate_lexeme_exclamation       : return "exclamation";
    case slate_lexeme_quote_single      : return "quote_single";
    case slate_lexeme_quote_double      : return "quote_double";
    case slate_lexeme_quote_backtick    : return "quote_backtick";
    case slate_lexeme_hashtag           : return "hashtag";
    case slate_lexeme_dollar            : return "dollar";
    case slate_lexeme_percent           : return "percent";
    case slate_lexeme_ampersand         : return "ampersand";
    case slate_lexeme_parenthesis_left  : return "parenthesis_left";
    case slate_lexeme_parenthesis_right : return "parenthesis_right";
    case slate_lexeme_star              : return "star";
    case slate_lexeme_plus              : return "plus";
    case slate_lexeme_comma             : return "comma";
    case slate_lexeme_minus             : return "minus";
    case slate_lexeme_dot               : return "dot";
    case slate_lexeme_slash_forward     : return "slash_forward";
    case slate_lexeme_slash_back        : return "slash_back";
    case slate_lexeme_colon             : return "colon";
    case slate_lexeme_semicolon         : return "semicolon";
    case slate_lexeme_less              : return "less";
    case slate_lexeme_more              : return "more";
    case slate_lexeme_equal             : return "equal";
    case slate_lexeme_question          : return "question";
    case slate_lexeme_at                : return "at";
    case slate_lexeme_bracket_left      : return "bracket_left";
    case slate_lexeme_bracket_right     : return "bracket_right";
    case slate_lexeme_caret             : return "caret";
    case slate_lexeme_brace_left        : return "brace_left";
    case slate_lexeme_brace_right       : return "brace_right";
    case slate_lexeme_pipe              : return "pipe";
    case slate_lexeme_tilde             : return "tilde";
    case slate_lexeme_eof               : return "EOF";
    default                             : return "UnknownLexemeID";
  }
}

void slate_lexeme_list_grow (
  slate_lexeme_List* const list,
  slate_size const         len
) {
  list->len += len;
  if (!list->cap) {
    list->cap = len;
    list->len = len;
    list->ptr = (slate_Lexeme*)malloc(list->cap * sizeof(*list->ptr));
  } else if (list->len > list->cap) {
    list->cap *= 2;
    list->ptr = (slate_Lexeme*)realloc(list->ptr, list->cap * sizeof(*list->ptr));
  }
}


//______________________________________
// @section Lexer: Tools
//____________________________

inline slate_Lexer slate_lexer_create (
  slate_cstring const src
) {
  slate_Lexer result = (slate_Lexer){ 0 };
  result.src.ptr     = src;
  result.src.len     = strlen(result.src.ptr);
  return result;
}

inline void slate_lexer_destroy (
  slate_Lexer* const L
) {
  L->pos     = 0;
  L->src.len = 0;
  L->src.ptr = NULL;
  L->res.len = 0;
  L->res.cap = 0;
  if (L->res.ptr) free(L->res.ptr);
  L->res.ptr = NULL;
}

inline void slate_lexer_add (
  slate_Lexer* const          L,
  slate_lexeme_Id const       id,
  slate_source_Location const loc
) {
  slate_lexeme_list_grow(&L->res, 1);
  L->res.ptr[L->res.len - 1] = (slate_Lexeme){ .id = id, .loc = loc };
}

inline void slate_lexer_add_single (
  slate_Lexer* const    L,
  slate_lexeme_Id const id
) {
  slate_lexer_add(L, id, (slate_source_Location){ .start = L->pos, .end = L->pos });
}

inline void slate_lexer_report (
  slate_Lexer const* const L
) {
  printf("[slate.Lexer] Contents ...........................\n");
  printf("%s\n", L->src.ptr);
  printf("..............................\n");
  for (slate_size id = 0; id < L->res.len; ++id) /* clang-format off */ {
    slate_cstring code = slate_source_location_from(&(L->res.ptr[id].loc), L->src.ptr);
    printf("%02zu : Lexeme.Id.%s : `%s`\n", id, slate_lexeme_toString(L->res.ptr[id].id), code);
    free((void*)code);
  } /* clang-format on */
  printf("..................................................\n");
}

//____________________________
// Single-Character: Singles
// clang-format off

inline void slate_lexer_newline     (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_newline); }
inline void slate_lexer_exclamation (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_exclamation); }
inline void slate_lexer_hashtag     (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_hashtag); }
inline void slate_lexer_dollar      (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_dollar); }
inline void slate_lexer_percent     (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_percent); }
inline void slate_lexer_ampersand   (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_ampersand); }
inline void slate_lexer_star        (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_star); }
inline void slate_lexer_plus        (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_plus); }
inline void slate_lexer_comma       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_comma); }
inline void slate_lexer_minus       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_minus); }
inline void slate_lexer_dot         (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_dot); }
inline void slate_lexer_colon       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_colon); }
inline void slate_lexer_semicolon   (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_semicolon); }
inline void slate_lexer_less        (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_less); }
inline void slate_lexer_equal       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_equal); }
inline void slate_lexer_more        (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_more); }
inline void slate_lexer_question    (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_question); }
inline void slate_lexer_at          (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_at); }
inline void slate_lexer_caret       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_caret); }
inline void slate_lexer_pipe        (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_pipe); }
inline void slate_lexer_tilde       (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_tilde); }
inline void slate_lexer_eof         (slate_Lexer* const L) { slate_lexer_add_single(L, slate_lexeme_eof); }

// clang-format on

//____________________________
// Single-Character: Groups

inline void slate_lexer_quote (
  slate_Lexer* const L
) {
  slate_Ch ch = L->src.ptr[L->pos];
  if (slate_ch_isQuote_single(ch)) slate_lexer_add_single(L, slate_lexeme_quote_single);
  else if (slate_ch_isQuote_double(ch)) slate_lexer_add_single(L, slate_lexeme_quote_double);
  else if (slate_ch_isQuote_backtick(ch)) slate_lexer_add_single(L, slate_lexeme_quote_backtick);
  else slate_error("[slate.Lexer] Unknown Quote Character: %d:`%c`", ch, ch);
}
//__________________
inline void slate_lexer_parenthesis (
  slate_Lexer* const L
) {
  slate_Ch ch = L->src.ptr[L->pos];
  if (slate_ch_isParenthesis_left(ch)) slate_lexer_add_single(L, slate_lexeme_parenthesis_left);
  else if (slate_ch_isParenthesis_right(ch)) slate_lexer_add_single(L, slate_lexeme_parenthesis_right);
  else slate_error("[slate.Lexer] Unknown Parenthesis Character: %d:`%c`", ch, ch);
}
//__________________
inline void slate_lexer_slash (
  slate_Lexer* const L
) {
  slate_Ch ch = L->src.ptr[L->pos];
  if (slate_ch_isSlash_forward(ch)) slate_lexer_add_single(L, slate_lexeme_slash_forward);
  else if (slate_ch_isSlash_back(ch)) slate_lexer_add_single(L, slate_lexeme_slash_back);
  else slate_error("[slate.Lexer] Unknown Slash Character: %d:`%c`", ch, ch);
}
//__________________
inline void slate_lexer_bracket (
  slate_Lexer* const L
) {
  slate_Ch ch = L->src.ptr[L->pos];
  if (slate_ch_isBracket_left(ch)) slate_lexer_add_single(L, slate_lexeme_bracket_left);
  else if (slate_ch_isBracket_right(ch)) slate_lexer_add_single(L, slate_lexeme_bracket_right);
  else slate_error("[slate.Lexer] Unknown Bracket Character: %d:`%c`", ch, ch);
}
//__________________
inline void slate_lexer_brace (
  slate_Lexer* const L
) {
  slate_Ch ch = L->src.ptr[L->pos];
  if (slate_ch_isBrace_left(ch)) slate_lexer_add_single(L, slate_lexeme_brace_left);
  else if (slate_ch_isBrace_right(ch)) slate_lexer_add_single(L, slate_lexeme_brace_right);
  else slate_error("[slate.Lexer] Unknown Brace Character: %d:`%c`", ch, ch);
}

//____________________________
// Multi-Character
inline void slate_lexer_number (
  slate_Lexer* const L
) {
  slate_source_Location loc = (slate_source_Location){ L->pos, L->pos };
  while (slate_ch_isDigit(L->src.ptr[L->pos])) {
    loc.end = L->pos;
    L->pos += 1;
  }
  slate_lexer_add(L, slate_lexeme_number, loc);
  L->pos -= 1;
}
//__________________
inline void slate_lexer_identifier (
  slate_Lexer* const L
) {
  slate_source_Location loc = (slate_source_Location){ L->pos, L->pos };
  while (slate_ch_isIdent(L->src.ptr[L->pos])) {
    loc.end = L->pos;
    L->pos += 1;
  }
  slate_lexer_add(L, slate_lexeme_identifier, loc);
  L->pos -= 1;
}
//__________________
inline void slate_lexer_whitespace (
  slate_Lexer* const L
) {
  slate_source_Location loc = (slate_source_Location){ L->pos, L->pos };
  while (slate_ch_isWhitespace(L->src.ptr[L->pos])) {
    loc.end = L->pos;
    L->pos += 1;
  }
  slate_lexer_add(L, slate_lexeme_whitespace, loc);
  L->pos -= 1;
}


//______________________________________
// @section Lexer: Entry Point
//____________________________

void slate_lexer_process (
  slate_Lexer* const L
) {
  while (L->pos < L->src.len) {
    slate_Ch const ch = L->src.ptr[L->pos];
    if (slate_ch_isDigit(ch)) slate_lexer_number(L);
    else if (slate_ch_isIdent(ch)) slate_lexer_identifier(L);
    else if (slate_ch_isWhitespace(ch)) slate_lexer_whitespace(L);
    else if (slate_ch_isNewline(ch)) slate_lexer_newline(L);
    else if (slate_ch_isExclamation(ch)) slate_lexer_exclamation(L);
    else if (slate_ch_isQuote(ch)) slate_lexer_quote(L);
    else if (slate_ch_isHashtag(ch)) slate_lexer_hashtag(L);
    else if (slate_ch_isDollar(ch)) slate_lexer_dollar(L);
    else if (slate_ch_isPercent(ch)) slate_lexer_percent(L);
    else if (slate_ch_isAmpersand(ch)) slate_lexer_ampersand(L);
    else if (slate_ch_isParenthesis(ch)) slate_lexer_parenthesis(L);
    else if (slate_ch_isStar(ch)) slate_lexer_star(L);
    else if (slate_ch_isPlus(ch)) slate_lexer_plus(L);
    else if (slate_ch_isComma(ch)) slate_lexer_comma(L);
    else if (slate_ch_isMinus(ch)) slate_lexer_minus(L);
    else if (slate_ch_isDot(ch)) slate_lexer_dot(L);
    else if (slate_ch_isSlash(ch)) slate_lexer_slash(L);
    else if (slate_ch_isColon(ch)) slate_lexer_colon(L);
    else if (slate_ch_isSemicolon(ch)) slate_lexer_semicolon(L);
    else if (slate_ch_isLess(ch)) slate_lexer_less(L);
    else if (slate_ch_isEqual(ch)) slate_lexer_equal(L);
    else if (slate_ch_isMore(ch)) slate_lexer_more(L);
    else if (slate_ch_isQuestion(ch)) slate_lexer_question(L);
    else if (slate_ch_isAt(ch)) slate_lexer_at(L);
    else if (slate_ch_isBracket(ch)) slate_lexer_bracket(L);
    else if (slate_ch_isCaret(ch)) slate_lexer_caret(L);
    else if (slate_ch_isBrace(ch)) slate_lexer_brace(L);
    else if (slate_ch_isPipe(ch)) slate_lexer_pipe(L);
    else if (slate_ch_isTilde(ch)) slate_lexer_tilde(L);
    else if (slate_ch_isEOF(ch)) return slate_lexer_eof(L);
    else slate_error("[slate.Lexer] Unknown First Character: `%c`", ch);
    L->pos += 1;
  }
}


#endif  // slate_Implementation

#pragma GCC diagnostic pop
#endif  // H_slate_lexer

