#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
## @fileoverview Types used for the *Slate API and its internal tools

#_____________________________
const UnknownID *:int= int.high

#_____________________________
type NodeAccessError * = object of CatchableError
type KindError       * = object of CatchableError

#_____________________________
type Kind *{.pure.}= enum
  ## @descr Describes a type of an AST Node, as understood by *Slate
  None, Empty,
  Module, # @note aka. Include and Import
  Ident,
  Type, TypeDef,
  Proc, Func, Call,
  Var, Let, Const, Asgn
  Literal, RawStr,
  Return, Continue, Break,
  Pragma, Discard, Comment,

