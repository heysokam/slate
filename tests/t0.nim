import std/unittest
test "correct sum": check 5+5 == 10


##[
#___________________________________________________________________
# idents.nim
type PIdent * = ref TIdent
type TIdent *{.acyclic.} = object
  id   *:int     # unique id; use this for comparisons and not the pointers
  s    *:string
  next *:PIdent  # for hash-table chaining
  h    *:Hash    # hash value of s

type IdentCache * = ref object
  buckets      :array[0..4096 * 2 - 1, PIdent]
  wordCounter  :int
  idAnon      *:PIdent
  idDelegator *:PIdent
  emptyIdent  *:PIdent

type TCallingConvention* = enum
  ccNimCall      = "nimcall"  # nimcall, also the default
  ccStdCall      = "stdcall"  # procedure is stdcall
  ccCDecl        = "cdecl"    # cdecl
  ccSafeCall     = "safecall" # safecall
  ccSysCall      = "syscall"  # system call
  ccInline       = "inline"   # proc should be inlined
  ccNoInline     = "noinline" # proc should not be inlined
  ccFastCall     = "fastcall" # fastcall (pass parameters in registers)
  ccThisCall     = "thiscall" # thiscall (parameters are pushed right-to-left)
  ccClosure      = "closure"  # proc has a closure
  ccNoConvention = "noconv"   # needed for generating proper C procs sometimes

#___________________________________________________________________
# lineinfos.nim
# This is designed to be as small as possible, because it is used in syntax nodes.
# We save space here by using two int16 and an int32.
# On 64 bit and on 32 bit systems this is only 8 bytes.
type FileIndex * = distinct int32
type TLineInfo * = object
  line       *:uint16
  col        *:int16
  fileIndex  *:FileIndex
  when defined(nimpretty):
    offsetA*, offsetB               *: int
    commentOffsetA*, commentOffsetB *: int


#___________________________________________________________________
# parser.nim
type TNodeKind* = enum # order is extremely important, because ranges are used to check whether a node belongs to a certain class
  nkNone,               # unknown node kind: indicates an error
                        # Expressions:
                        # Atoms:
  nkEmpty,              # the node is empty
  nkIdent,              # node is an identifier
  nkSym,                # node is a symbol
  nkType,               # node is used for its typ field

  nkCharLit,            # a character literal ''
  nkIntLit,             # an integer literal
  nkInt8Lit,
  nkInt16Lit,
  nkInt32Lit,
  nkInt64Lit,
  nkUIntLit,            # an unsigned integer literal
  nkUInt8Lit,
  nkUInt16Lit,
  nkUInt32Lit,
  nkUInt64Lit,
  nkFloatLit,           # a floating point literal
  nkFloat32Lit,
  nkFloat64Lit,
  nkFloat128Lit,
  nkStrLit,             # a string literal ""
  nkRStrLit,            # a raw string literal r""
  nkTripleStrLit,       # a triple string literal """
  nkNilLit,             # the nil literal
                        # end of atoms
  nkComesFrom,          # "comes from" template/macro information for
                        # better stack trace generation
  nkDotCall,            # used to temporarily flag a nkCall node;
                        # this is used
                        # for transforming ``s.len`` to ``len(s)``

  nkCommand,            # a call like ``p 2, 4`` without parenthesis
  nkCall,               # a call like p(x, y) or an operation like +(a, b)
  nkCallStrLit,         # a call with a string literal
                        # x"abc" has two sons: nkIdent, nkRStrLit
                        # x"""abc""" has two sons: nkIdent, nkTripleStrLit
  nkInfix,              # a call like (a + b)
  nkPrefix,             # a call like !a
  nkPostfix,            # something like a! (also used for visibility)
  nkHiddenCallConv,     # an implicit type conversion via a type converter

  nkExprEqExpr,         # a named parameter with equals: ''expr = expr''
  nkExprColonExpr,      # a named parameter with colon: ''expr: expr''
  nkIdentDefs,          # a definition like `a, b: typeDesc = expr`
                        # either typeDesc or expr may be nil; used in
                        # formal parameters, var statements, etc.
  nkVarTuple,           # a ``var (a, b) = expr`` construct
  nkPar,                # syntactic (); may be a tuple constructor
  nkObjConstr,          # object constructor: T(a: 1, b: 2)
  nkCurly,              # syntactic {}
  nkCurlyExpr,          # an expression like a{i}
  nkBracket,            # syntactic []
  nkBracketExpr,        # an expression like a[i..j, k]
  nkPragmaExpr,         # an expression like a{.pragmas.}
  nkRange,              # an expression like i..j
  nkDotExpr,            # a.b
  nkCheckedFieldExpr,   # a.b, but b is a field that needs to be checked
  nkDerefExpr,          # a^
  nkIfExpr,             # if as an expression
  nkElifExpr,
  nkElseExpr,
  nkLambda,             # lambda expression
  nkDo,                 # lambda block appering as trailing proc param
  nkAccQuoted,          # `a` as a node

  nkTableConstr,        # a table constructor {expr: expr}
  nkBind,               # ``bind expr`` node
  nkClosedSymChoice,    # symbol choice node; a list of nkSyms (closed)
  nkOpenSymChoice,      # symbol choice node; a list of nkSyms (open)
  nkHiddenStdConv,      # an implicit standard type conversion
  nkHiddenSubConv,      # an implicit type conversion from a subtype
                        # to a supertype
  nkConv,               # a type conversion
  nkCast,               # a type cast
  nkStaticExpr,         # a static expr
  nkAddr,               # a addr expression
  nkHiddenAddr,         # implicit address operator
  nkHiddenDeref,        # implicit ^ operator
  nkObjDownConv,        # down conversion between object types
  nkObjUpConv,          # up conversion between object types
  nkChckRangeF,         # range check for floats
  nkChckRange64,        # range check for 64 bit ints
  nkChckRange,          # range check for ints
  nkStringToCString,    # string to cstring
  nkCStringToString,    # cstring to string
                        # end of expressions

  nkAsgn,               # a = b
  nkFastAsgn,           # internal node for a fast ``a = b``
                        # (no string copy)
  nkGenericParams,      # generic parameters
  nkFormalParams,       # formal parameters
  nkOfInherit,          # inherited from symbol

  nkImportAs,           # a 'as' b in an import statement
  nkProcDef,            # a proc
  nkMethodDef,          # a method
  nkConverterDef,       # a converter
  nkMacroDef,           # a macro
  nkTemplateDef,        # a template
  nkIteratorDef,        # an iterator

  nkOfBranch,           # used inside case statements
                        # for (cond, action)-pairs
  nkElifBranch,         # used in if statements
  nkExceptBranch,       # an except section
  nkElse,               # an else part
  nkAsmStmt,            # an assembler block
  nkPragma,             # a pragma statement
  nkPragmaBlock,        # a pragma with a block
  nkIfStmt,             # an if statement
  nkWhenStmt,           # a when expression or statement
  nkForStmt,            # a for statement
  nkParForStmt,         # a parallel for statement
  nkWhileStmt,          # a while statement
  nkCaseStmt,           # a case statement
  nkTypeSection,        # a type section (consists of type definitions)
  nkVarSection,         # a var section
  nkLetSection,         # a let section
  nkConstSection,       # a const section
  nkConstDef,           # a const definition
  nkTypeDef,            # a type definition
  nkYieldStmt,          # the yield statement as a tree
  nkDefer,              # the 'defer' statement
  nkTryStmt,            # a try statement
  nkFinally,            # a finally section
  nkRaiseStmt,          # a raise statement
  nkReturnStmt,         # a return statement
  nkBreakStmt,          # a break statement
  nkContinueStmt,       # a continue statement
  nkBlockStmt,          # a block statement
  nkStaticStmt,         # a static statement
  nkDiscardStmt,        # a discard statement
  nkStmtList,           # a list of statements
  nkImportStmt,         # an import statement
  nkImportExceptStmt,   # an import x except a statement
  nkExportStmt,         # an export statement
  nkExportExceptStmt,   # an 'export except' statement
  nkFromStmt,           # a from * import statement
  nkIncludeStmt,        # an include statement
  nkBindStmt,           # a bind statement
  nkMixinStmt,          # a mixin statement
  nkUsingStmt,          # an using statement
  nkCommentStmt,        # a comment statement
  nkStmtListExpr,       # a statement list followed by an expr; this is used
                        # to allow powerful multi-line templates
  nkBlockExpr,          # a statement block ending in an expr; this is used
                        # to allow powerful multi-line templates that open a
                        # temporary scope
  nkStmtListType,       # a statement list ending in a type; for macros
  nkBlockType,          # a statement block ending in a type; for macros
                        # types as syntactic trees:

  nkWith,               # distinct with `foo`
  nkWithout,            # distinct without `foo`

  nkTypeOfExpr,         # type(1+2)
  nkObjectTy,           # object body
  nkTupleTy,            # tuple body
  nkTupleClassTy,       # tuple type class
  nkTypeClassTy,        # user-defined type class
  nkStaticTy,           # ``static[T]``
  nkRecList,            # list of object parts
  nkRecCase,            # case section of object
  nkRecWhen,            # when section of object
  nkRefTy,              # ``ref T``
  nkPtrTy,              # ``ptr T``
  nkVarTy,              # ``var T``
  nkConstTy,            # ``const T``
  nkOutTy,              # ``out T``
  nkDistinctTy,         # distinct type
  nkProcTy,             # proc type
  nkIteratorTy,         # iterator type
  nkSinkAsgn,           # '=sink(x, y)'
  nkEnumTy,             # enum body
  nkEnumFieldDef,       # `ident = expr` in an enumeration
  nkArgList,            # argument list
  nkPattern,            # a special pattern; used for matching
  nkHiddenTryStmt,      # a hidden try statement
  nkClosure,            # (prc, env)-pair (internally used for code gen)
  nkGotoState,          # used for the state machine (for iterators)
  nkState,              # give a label to a code section (for iterators)
  nkBreakState,         # special break statement for easier code generation
  nkFuncDef,            # a func
  nkTupleConstr         # a tuple constructor
  nkError               # erroneous AST node
  nkModuleRef           # for .rod file support: A (moduleId, itemId) pair
  nkReplayAction        # for .rod file support: A replay action
  nkNilRodNode          # for .rod file support: a 'nil' PNode

const nkWhen           * = nkWhenStmt
const nkWhenExpr       * = nkWhenStmt
const nkLastBlockStmts * = {nkRaiseStmt, nkReturnStmt, nkBreakStmt, nkContinueStmt}


type TTypeKind* = enum  # order is important!
                   # Don't forget to change hti.nim if you make a change here
                   # XXX put this into an include file to avoid this issue!
                   # several types are no longer used (guess which), but a spot in the sequence is kept for backwards compatibility
                   # (apparently something with bootstrapping)
                   # if you need to add a type, they can apparently be reused
  tyNone, tyBool, tyChar,
  tyEmpty, tyAlias, tyNil, tyUntyped, tyTyped, tyTypeDesc,
  tyGenericInvocation, # ``T[a, b]`` for types to invoke
  tyGenericBody,       # ``T[a, b, body]`` last parameter is the body
  tyGenericInst,       # ``T[a, b, realInstance]`` instantiated generic type
                       # realInstance will be a concrete type like tyObject unless this is an instance of a generic alias type.
                       # then realInstance will be the tyGenericInst of the completely (recursively) resolved alias.

  tyGenericParam,      # ``a`` in the above patterns
  tyDistinct,
  tyEnum,
  tyOrdinal,           # integer types (including enums and boolean)
  tyArray,
  tyObject,
  tyTuple,
  tySet,
  tyRange,
  tyPtr, tyRef,
  tyVar,
  tySequence,
  tyProc,
  tyPointer, tyOpenArray,
  tyString, tyCstring, tyForward,
  tyInt, tyInt8, tyInt16, tyInt32, tyInt64, # signed integers
  tyFloat, tyFloat32, tyFloat64, tyFloat128,
  tyUInt, tyUInt8, tyUInt16, tyUInt32, tyUInt64,
  tyOwned, tySink, tyLent,
  tyVarargs,
  tyUncheckedArray
    # An array with boundaries [0,+∞]

  tyProxy # used as errornous type (for idetools)

  tyBuiltInTypeClass
    # Type such as the catch-all object, tuple, seq, etc

  tyUserTypeClass
    # the body of a user-defined type class

  tyUserTypeClassInst
    # Instance of a parametric user-defined type class.
    # Structured similarly to tyGenericInst.
    # tyGenericInst represents concrete types, while
    # this is still a "generic param" that will bind types
    # and resolves them during sigmatch and instantiation.

  tyCompositeTypeClass
    # Type such as seq[Number]
    # The notes for tyUserTypeClassInst apply here as well
    # sons[0]: the original expression used by the user.
    # sons[1]: fully expanded and instantiated meta type
    # (potentially following aliases)

  tyInferred
    # In the initial state `base` stores a type class constraining
    # the types that can be inferred. After a candidate type is
    # selected, it's stored in `lastSon`. Between `base` and `lastSon`
    # there may be 0, 2 or more types that were also considered as
    # possible candidates in the inference process (i.e. lastSon will
    # be updated to store a type best conforming to all candidates)

  tyAnd, tyOr, tyNot
    # boolean type classes such as `string|int`,`not seq`,
    # `Sortable and Enumable`, etc

  tyAnything
    # a type class matching any type

  tyStatic
    # a value known at compile type (the underlying type is .base)

  tyFromExpr
    # This is a type representing an expression that depends
    # on generic parameters (the expression is stored in t.n)
    # It will be converted to a real type only during generic
    # instantiation and prior to this it has the potential to
    # be any type.

  tyConcept
    # new style concept.

  tyVoid
    # now different from tyEmpty, hurray!
  tyIterable

const tyPureObject      * = tyTuple
const GcTypeKinds       * = {tyRef, tySequence, tyString}
const tyError           * = tyProxy # as an errornous node should match everything
const tyUnknown         * = tyFromExpr
const tyUnknownTypes    * = {tyError, tyFromExpr}
const tyTypeClasses     * = {tyBuiltInTypeClass, tyCompositeTypeClass, tyUserTypeClass, tyUserTypeClassInst, tyAnd, tyOr, tyNot, tyAnything}
const tyMetaTypes       * = {tyGenericParam, tyTypeDesc, tyUntyped} + tyTypeClasses
const tyUserTypeClasses * = {tyUserTypeClass, tyUserTypeClassInst}
  # consider renaming as `tyAbstractVarRange`
const abstractVarRange  * = {tyGenericInst, tyRange, tyVar, tyDistinct, tyOrdinal, tyTypeDesc, tyAlias, tyInferred, tySink, tyOwned}
const abstractInst      * = {tyGenericInst, tyDistinct, tyOrdinal, tyTypeDesc, tyAlias, tyInferred, tySink, tyOwned} # xxx what about tyStatic?

type TTypeKinds* = set[TTypeKind]
type TNodeFlag* = enum
  nfNone,
  nfBase2,               # nfBase10 is default, so not needed
  nfBase8,
  nfBase16,
  nfAllConst,            # used to mark complex expressions constant; easy to get rid of, but unfortunately it has measurable impact for compilation efficiency
  nfTransf,              # node has been transformed
  nfNoRewrite            # node should not be transformed anymore
  nfSem                  # node has been checked for semantics
  nfLL                   # node has gone through lambda lifting
  nfDotField             # the call can use a dot operator
  nfDotSetter            # the call can use a setter dot operarator
  nfExplicitCall         # x.y() was used instead of x.y
  nfExprCall             # this is an attempt to call a regular expression
  nfIsRef                # this node is a 'ref' node; used for the VM
  nfIsPtr                # this node is a 'ptr' node; used for the VM
  nfPreventCg            # this node should be ignored by the codegen
  nfBlockArg             # this a stmtlist appearing in a call (e.g. a do block)
  nfFromTemplate         # a top-level node returned from a template
  nfDefaultParam         # an automatically inserter default parameter
  nfDefaultRefsParam     # a default param value references another parameter. the flag is applied to proc default values and to calls
  nfExecuteOnReload      # A top-level statement that will be executed during reloads
  nfLastRead             # this node is a last read
  nfFirstWrite           # this node is a first write
  nfHasComment           # node has a comment
  nfSkipFieldChecking    # node skips field visable checking
type TNodeFlags * = set[TNodeFlag]

type TTypeFlag  * = enum        # keep below 32 for efficiency reasons (now: 47)
  tfVarargs,             # procedure has C styled varargs
                         # tyArray type represeting a varargs list
  tfNoSideEffect,        # procedure type does not allow side effects
  tfFinal,               # is the object final?
  tfInheritable,         # is the object inheritable?
  tfHasOwned,            # type contains an 'owned' type and must be moved
  tfEnumHasHoles,        # enum cannot be mapped into a range
  tfShallow,             # type can be shallow copied on assignment
  tfThread,              # proc type is marked as ``thread``; alias for ``gcsafe``
  tfFromGeneric,         # type is an instantiation of a generic; this is needed
                         # because for instantiations of objects, structural
                         # type equality has to be used
  tfUnresolved,          # marks unresolved typedesc/static params: e.g.
                         # proc foo(T: typedesc, list: seq[T]): var T
                         # proc foo(L: static[int]): array[L, int]
                         # can be attached to ranges to indicate that the range
                         # can be attached to generic procs with free standing
                         # type parameters: e.g. proc foo[T]()
                         # depends on unresolved static params.
  tfResolved             # marks a user type class, after it has been bound to a
                         # concrete type (lastSon becomes the concrete type)
  tfRetType,             # marks return types in proc (used to detect type classes
                         # used as return types for return type inference)
  tfCapturesEnv,         # whether proc really captures some environment
  tfByCopy,              # pass object/tuple by copy (C backend)
  tfByRef,               # pass object/tuple by reference (C backend)
  tfIterator,            # type is really an iterator, not a tyProc
  tfPartial,             # type is declared as 'partial'
  tfNotNil,              # type cannot be 'nil'
  tfRequiresInit,        # type constains a "not nil" constraint somewhere or
                         # a `requiresInit` field, so the default zero init
                         # is not appropriate
  tfNeedsFullInit,       # object type marked with {.requiresInit.}
                         # all fields must be initialized
  tfVarIsPtr,            # 'var' type is translated like 'ptr' even in C++ mode
  tfHasMeta,             # type contains "wildcard" sub-types such as generic params
                         # or other type classes
  tfHasGCedMem,          # type contains GC'ed memory
  tfPacked
  tfHasStatic
  tfGenericTypeParam
  tfImplicitTypeParam
  tfInferrableStatic
  tfConceptMatchedTypeSym
  tfExplicit             # for typedescs, marks types explicitly prefixed with the
                         # `type` operator (e.g. type int)
  tfWildcard             # consider a proc like foo[T, I](x: Type[T, I])
                         # T and I here can bind to both typedesc and static types
                         # before this is determined, we'll consider them to be a
                         # wildcard type.
  tfHasAsgn              # type has overloaded assignment operator
  tfBorrowDot            # distinct type borrows '.'
  tfTriggersCompileTime  # uses the NimNode type which make the proc
                         # implicitly '.compiletime'
  tfRefsAnonObj          # used for 'ref object' and 'ptr object'
  tfCovariant            # covariant generic param mimicking a ptr type
  tfWeakCovariant        # covariant generic param mimicking a seq/array type
  tfContravariant        # contravariant generic param
  tfCheckedForDestructor # type was checked for having a destructor.
                         # If it has one, t.destructor is not nil.
  tfAcyclic              # object type was annotated as .acyclic
  tfIncompleteStruct     # treat this type as if it had sizeof(pointer)
  tfCompleteStruct
                         # (for importc types); type is fully specified, allowing to compute
                         # sizeof, alignof, offsetof at CT
  tfExplicitCallConv
  tfIsConstructor
  tfEffectSystemWorkaround
  tfIsOutParam
  tfSendable
type TTypeFlags* = set[TTypeFlag]
const tfUnion      * = tfNoSideEffect
const tfGcSafe     * = tfThread
const tfObjHasKids * = tfEnumHasHoles
const tfReturnsNew * = tfInheritable
var eqTypeFlags* = {tfIterator, tfNotNil, tfVarIsPtr, tfGcSafe, tfNoSideEffect, tfIsOutParam, tfSendable}
  ## type flags that are essential for type equality.
  ## This is now a variable because for emulation of version:1.0 we
  ## might exclude {tfGcSafe, tfNoSideEffect}.


type TSymKind* = enum    # the different symbols (start with the prefix sk); order is important for the documentation generator!
  skUnknown,             # unknown symbol: used for parsing assembler blocks and first phase symbol lookup in generics
  skConditional,         # symbol for the preprocessor (may become obsolete)
  skDynLib,              # symbol represents a dynamic library; this is used internally; it does not exist in Nim code
  skParam,               # a parameter
  skGenericParam,        # a generic parameter; eq in ``proc x[eq=`==`]()``
  skTemp,                # a temporary variable (introduced by compiler)
  skModule,              # module identifier
  skType,                # a type
  skVar,                 # a variable
  skLet,                 # a 'let' symbol
  skConst,               # a constant
  skResult,              # special 'result' variable
  skProc,                # a proc
  skFunc,                # a func
  skMethod,              # a method
  skIterator,            # an iterator
  skConverter,           # a type converter
  skMacro,               # a macro
  skTemplate,            # a template; currently also misused for user-defined pragmas
  skField,               # a field in a record or object
  skEnumField,           # an identifier in an enum
  skForVar,              # a for loop variable
  skLabel,               # a label (for block statement)
  skStub,                # symbol is a stub and not yet loaded from the ROD file (it is loaded on demand, which may mean: never)
  skPackage,             # symbol is a package (used for canonicalization)
type TSymKinds* = set[TSymKind]
const routineKinds       * = {skProc, skFunc, skMethod, skIterator, skConverter, skMacro, skTemplate}
const ExportableSymKinds * = {skVar, skLet, skConst, skType, skEnumField, skStub} + routineKinds
const skError            * = skUnknown


type ItemId* = object
  module*: int32
  item*: int32
proc `$`  *(x: ItemId): string =  "(module: " & $x.module & ", item: " & $x.item & ")"
proc `==` *(a, b: ItemId): bool {.inline.} =  a.item == b.item and a.module == b.module
proc hash *(x: ItemId): Hash =  var h: Hash = hash(x.module); h = h !& hash(x.item); result = !$h


type
type TIdObj* {.acyclic.} = object of RootObj
  itemId  *:ItemId
type PIdObj * = ref TIdObj

type PNode    * = ref TNode
type TNodeSeq * = seq[PNode]
type TType *{.acyclic.}= object of TIdObj # types are identical iff they have the same id; there may be multiple copies of a type in memory! Keep in sync with PackedType
  kind         *:TTypeKind                # kind of type
  callConv     *:TCallingConvention       # for procs
  flags        *:TTypeFlags               # flags of the type
  sons         *:TTypeSeq                 # base types, etc.
  n            *:PNode                    # node for types:
                                          # for range types a nkRange node
                                          # for record types a nkRecord node
                                          # for enum types a list of symbols
                                          # if kind == tyInt: it is an 'int literal(x)' type
                                          # for procs and tyGenericBody, it's the
                                          # formal param list
                                          # for concepts, the concept body
                                          # else: unused
  owner        *:PSym                     # the 'owner' of the type
  sym          *:PSym                     # types have the sym associated with them. used for converting types to strings
  size         *:BiggestInt               # the size of the type in bytes -1 means that the size is unkwown
  align        *:int16                    # the type's alignment requirements
  paddingAtEnd *:int16                    #
  loc          *:TLoc
  typeInst     *:PType                    # for generic instantiations the tyGenericInst that led to this type.
  uniqueId     *:ItemId                   # due to a design mistake, we need to keep the real ID here as it is required by the --incremental:on mode.
type PType    * = ref TType
type TTypeSeq * = seq[PType]


type TSym* {.acyclic.} = object of TIdObj # Keep in sync with PackedSym proc and type instantiations are cached in the generic symbol
  case kind              *:TSymKind
  of routineKinds:
                                     # procInstCache*: seq[PInstantiation]
    gcUnsafetyReason     *:PSym     # for better error messages regarding gcsafe
    transformedBody      *:PNode    # cached body after transf pass
  of skLet, skVar, skField, skForVar:
    guard                *:PSym
    bitsize              *:int
    alignment            *:int      # for alignment
  else: nil
  magic                  *:TMagic
  typ                    *:PType
  name                   *:PIdent
  info                   *:TLineInfo
  when defined(nimsuggest):
    endInfo              *:TLineInfo
    hasUserSpecifiedType *:bool     # used for determining whether to display inlay type hints
  owner                  *:PSym
  flags                  *:TSymFlags
  ast                    *:PNode    # syntax tree of proc, iterator, etc.: the whole proc including header;
                                    # used for easy generation of error messages
                                    # for variant record fields the discriminant expression
                                    # for modules, it's a placeholder for compiler generated code that will be appended to the module after the sem pass (see appendToModule)
  options                *:TOptions
  position               *:int      # used for many different things:
                                    # for enum fields its position;
                                    # for fields its offset
                                    # for parameters its position (starting with 0)
                                    # for a conditional:
                                    # 1 iff the symbol is defined, else 0
                                    # (or not in symbol table)
                                    # for modules, an unique index corresponding
                                    # to the module's fileIdx
                                    # for variables a slot index for the evaluator
  offset                 *:int32    # offset of record field
  disamb                 *:int32    # disambiguation number; the basic idea is that `<procname>__<module>_<disamb>`
  loc                    *:TLoc
  annex                  *:PLib     # additional fields (seldom used, so we use a reference to another object to save space)
  when hasFFI:
    cname                *:string   # resolved C declaration name in importc decl, e.g.: proc fun() {.importc: "$1aux".} => cname = funaux
  constraint             *:PNode    # additional constraints like 'lit|result'; also misused for the codegenDecl and virtual pragmas in the hope it won't cause problems for skModule the string literal to output for deprecated modules.
  when defined(nimsuggest):
    allUsages            *:seq[TLineInfo]
type PSym     * = ref TSym



type TNode    * {.final, acyclic.} = object # on a 32bit machine, this takes 32 bytes
  when defined(useNodeIds):
    id       *:int
  typ        *:PType
  info       *:TLineInfo
  flags      *:TNodeFlags
  case kind  *:TNodeKind
  of nkCharLit..nkUInt64Lit:
    intVal   *:BiggestInt
  of nkFloatLit..nkFloat128Lit:
    floatVal *:BiggestFloat
  of nkStrLit..nkTripleStrLit:
    strVal   *:string
  of nkSym:
    sym      *:PSym
  of nkIdent:
    ident    *:PIdent
  else:
    sons     *:TNodeSeq
  when defined(nimsuggest):
    endInfo  *:TLineInfo

type TStrTable* = object         # a table[PIdent] of PSym
  counter*: int
  data*: seq[PSym]

# -------------- backend information -------------------------------
type TLocKind* = enum
  locNone,                  # no location
  locTemp,                  # temporary location
  locLocalVar,              # location is a local variable
  locGlobalVar,             # location is a global variable
  locParam,                 # location is a parameter
  locField,                 # location is a record field
  locExpr,                  # "location" is really an expression
  locProc,                  # location is a proc (an address of a procedure)
  locData,                  # location is a constant
  locCall,                  # location is a call expression
  locOther                  # location is something other
type TLocFlag* = enum
  lfIndirect,               # backend introduced a pointer
  lfNoDeepCopy,             # no need for a deep copy
  lfNoDecl,                 # do not declare it in C
  lfDynamicLib,             # link symbol to dynamic library
  lfExportLib,              # export symbol for dynamic library generation
  lfHeader,                 # include header file for symbol
  lfImportCompilerProc,     # ``importc`` of a compilerproc
  lfSingleUse               # no location yet and will only be used once
  lfEnforceDeref            # a copyMem is required to dereference if this a ptr array due to C array limitations. See #1181, #6422, #11171
  lfPrepareForMutation      # string location is about to be mutated (V2)
type TStorageLoc* = enum
  OnUnknown,                # location is unknown (stack, heap or static)
  OnStatic,                 # in a static section
  OnStack,                  # location is on hardware stack
  OnHeap                    # location is on heap or global (reference counting needed)
type TLocFlags* = set[TLocFlag]
type TLoc* = object
  k       *:TLocKind        # kind of location
  storage *:TStorageLoc
  flags   *:TLocFlags       # location's flags
  lode    *:PNode           # Node where the location came from; can be faked
  r       *:Rope            # rope value of location (code generators)

# ---------------- end of backend information ------------------------------

type TLibKind* = enum
  libHeader, libDynamic

type TLib* = object              # also misused for headers! keep in sync with PackedLib
  kind         *:TLibKind
  generated    *:bool       # needed for the backends:
  isOverridden *:bool
  name         *:Rope
  path         *:PNode      # can be a string literal!


type CompilesId * = int ## id that is used for the caching logic within ``system.compiles``. See the seminst module.
type TInstantiation* = object
  sym           *:PSym
  concreteTypes *:seq[PType]
  compilesId    *:CompilesId
type PInstantiation* = ref TInstantiation


type TScope* {.acyclic.} = object
  depthLevel         *:int
  symbols            *:TStrTable
  parent             *:PScope
  allowPrivateAccess *:seq[PSym] #  # enable access to private fields
type PScope* = ref TScope


type PLib* = ref TLib
type TTypeAttachedOp* = enum ## as usual, order is important here
  attachedWasMoved,
  attachedDestructor,
  attachedAsgn,
  attachedDup,
  attachedSink,
  attachedTrace,
  attachedDeepCopy

type TPair * = object
  key*, val *: RootRef
type TPairSeq * = seq[TPair]

type TIdPair * = object
  key       *:PIdObj
  val       *:RootRef
type TIdPairSeq * = seq[TIdPair]

type TIdTable * = object # the same as table[PIdent] of PObject
  counter   *:int
  data      *:TIdPairSeq

type TIdNodePair * = object
  key       *:PIdObj
  val       *:PNode
type TIdNodePairSeq * = seq[TIdNodePair]
type TIdNodeTable * = object # the same as table[PIdObj] of PNode
  counter   *:int
  data      *:TIdNodePairSeq

type TNodePair * = object
  h         *:Hash                 # because it is expensive to compute!
  key       *:PNode
  val       *:int
type TNodePairSeq * = seq[TNodePair]
type TNodeTable * = object # the same as table[PNode] of int; # nodes are compared by structure!
  counter   *:int
  data      *:TNodePairSeq

type TObjectSeq * = seq[RootRef]
type TObjectSet * = object
  counter   *:int
  data      *:TObjectSeq

type TImplication* = enum
  impUnknown, impNo, impYes

template nodeId(n: PNode): int = cast[int](n)

# we put comments in a side channel to avoid increasing `sizeof(TNode)`, which
# reduces memory usage given that `PNode` is the most allocated type by far.
type Gconfig = object
  comments: Table[int, string] # nodeId => comment
  useIc*: bool
var gconfig {.threadvar.}: Gconfig

proc setUseIc*(useIc: bool) = gconfig.useIc = useIc

proc comment*(n: PNode): string =
  if nfHasComment in n.flags and not gconfig.useIc:
    # IC doesn't track comments, see `packed_ast`, so this could fail
    result = gconfig.comments[n.nodeId]

proc `comment=`*(n: PNode, a: string) =
  let id = n.nodeId
  if a.len > 0:
    # if needed, we could periodically cleanup gconfig.comments when its size increases, # to ensure only live nodes (and with nfHasComment) have an entry in gconfig.comments;
    # for compiling compiler, the waste is very small:
    # num calls to newNodeImpl: 14984160 (num of PNode allocations)
    # size of gconfig.comments: 33585
    # num of nodes with comments that were deleted and hence wasted: 3081
    n.flags.incl nfHasComment
    gconfig.comments[id] = a
  elif nfHasComment in n.flags:
    n.flags.excl nfHasComment
    gconfig.comments.del(id)

# BUGFIX: a module is overloadable so that a proc can have the same name as an imported module.
# This is necessary because of the poor naming choices in the standard library.
const OverloadableSyms* = {skProc, skFunc, skMethod, skIterator, skConverter, skModule, skTemplate, skMacro, skEnumField}
const GenericTypes*: TTypeKinds = {tyGenericInvocation, tyGenericBody, tyGenericParam}
const StructuralEquivTypes*: TTypeKinds = {tyNil, tyTuple, tyArray, tySet, tyRange, tyPtr, tyRef, tyVar, tyLent, tySequence, tyProc, tyOpenArray, tyVarargs}
const ConcreteTypes*: TTypeKinds = { # types of the expr that may occur in:: var x = expr
    tyBool, tyChar, tyEnum, tyArray, tyObject, tySet, tyTuple, tyRange, tyPtr, tyRef, tyVar, tyLent, tySequence, tyProc, tyPointer, tyOpenArray, tyString, tyCstring, tyInt..tyInt64, tyFloat..tyFloat128, tyUInt..tyUInt64}
const IntegralTypes* = {tyBool, tyChar, tyEnum, tyInt..tyInt64, tyFloat..tyFloat128, tyUInt..tyUInt64} # weird name because it contains tyFloat
const ConstantDataTypes*: TTypeKinds = {tyArray, tySet, tyTuple, tySequence}
const NilableTypes*: TTypeKinds = {tyPointer, tyCstring, tyRef, tyPtr, tyProc, tyError} # TODO
const PtrLikeKinds*: TTypeKinds = {tyPointer, tyPtr} # for VM
const PersistentNodeFlags*: TNodeFlags = {nfBase2, nfBase8, nfBase16, nfDotSetter, nfDotField, nfIsRef, nfIsPtr, nfPreventCg, nfLL, nfFromTemplate, nfDefaultRefsParam, nfExecuteOnReload, nfLastRead, nfFirstWrite, nfSkipFieldChecking}
const namePos          * = 0
const patternPos       * = 1  # empty except for term rewriting macros
const genericParamsPos * = 2
const paramsPos        * = 3
const pragmasPos       * = 4
const miscPos          * = 5  # used for undocumented and hacky stuff
const bodyPos          * = 6  # position of body; use rodread.getBody() instead!
const resultPos        * = 7
const dispatcherPos    * = 8

const nfAllFieldsSet    * = nfBase2
const nkCallKinds       * = {nkCall, nkInfix, nkPrefix, nkPostfix, nkCommand, nkCallStrLit, nkHiddenCallConv}
const nkIdentKinds      * = {nkIdent, nkSym, nkAccQuoted, nkOpenSymChoice, nkClosedSymChoice}
const nkPragmaCallKinds * = {nkExprColonExpr, nkCall, nkCallStrLit}
const nkLiterals        * = {nkCharLit..nkTripleStrLit}
const nkFloatLiterals   * = {nkFloatLit..nkFloat128Lit}
const nkLambdaKinds     * = {nkLambda, nkDo}
const declarativeDefs   * = {nkProcDef, nkFuncDef, nkMethodDef, nkIteratorDef, nkConverterDef}
const routineDefs       * = declarativeDefs + {nkMacroDef, nkTemplateDef}
const procDefs          * = nkLambdaKinds + declarativeDefs
const callableDefs      * = nkLambdaKinds + routineDefs

const nkSymChoices      * = {nkClosedSymChoice, nkOpenSymChoice}
const nkStrKinds        * = {nkStrLit..nkTripleStrLit}

const skLocalVars       * = {skVar, skLet, skForVar, skParam, skResult}
const skProcKinds       * = {skProc, skFunc, skTemplate, skMacro, skIterator, skMethod, skConverter}

const defaultSize         = -1
const defaultAlignment    = -1
const defaultOffset     * = -1
]##

