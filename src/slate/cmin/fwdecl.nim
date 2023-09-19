import ../nimc

type TODO = object of CatchableError
template todo (code :PNode) :void=
  raise newException(TODO, &"\nInterpreting {code.kind} is currently not supported for CMin.\n\nIts tree is:\n{code.treeRepr}\nIts code is:\n{code.renderTree}\n\n")

## Generator Cases for Min C
# Process
proc cminProcDef          (code :PNode; indent :int= 0) :string
proc cminReturnStmt       (code :PNode; indent :int= 1) :string
proc cminConstSection     (code :PNode; indent :int= 0) :string
proc cminLetSection       (code :PNode; indent :int= 0) :string

# TODO
proc cminVarSection       (code :PNode) :string=  assert code.kind == nkVarSection       ; todo(code)  ## TODO : Converts a nkVarSection into the Min C Language

proc cminNone             (code :PNode) :string=  assert code.kind == nkNone             ; todo(code)  ## TODO : Converts a nkNone into the Min C Language
proc cminEmpty            (code :PNode) :string=  assert code.kind == nkEmpty            ; todo(code)  ## TODO : Converts a nkEmpty into the Min C Language
proc cminIdent            (code :PNode) :string=  assert code.kind == nkIdent            ; todo(code)  ## TODO : Converts a nkIdent into the Min C Language
proc cminSym              (code :PNode) :string=  assert code.kind == nkSym              ; todo(code)  ## TODO : Converts a nkSym into the Min C Language
proc cminType             (code :PNode) :string=  assert code.kind == nkType             ; todo(code)  ## TODO : Converts a nkType into the Min C Language
proc cminCharLit          (code :PNode) :string=  assert code.kind == nkCharLit          ; todo(code)  ## TODO : Converts a nkCharLit into the Min C Language
proc cminIntLit           (code :PNode) :string=  assert code.kind == nkIntLit           ; todo(code)  ## TODO : Converts a nkIntLit into the Min C Language
proc cminInt8Lit          (code :PNode) :string=  assert code.kind == nkInt8Lit          ; todo(code)  ## TODO : Converts a nkInt8Lit into the Min C Language
proc cminInt16Lit         (code :PNode) :string=  assert code.kind == nkInt16Lit         ; todo(code)  ## TODO : Converts a nkInt16Lit into the Min C Language
proc cminInt32Lit         (code :PNode) :string=  assert code.kind == nkInt32Lit         ; todo(code)  ## TODO : Converts a nkInt32Lit into the Min C Language
proc cminInt64Lit         (code :PNode) :string=  assert code.kind == nkInt64Lit         ; todo(code)  ## TODO : Converts a nkInt64Lit into the Min C Language
proc cminUIntLit          (code :PNode) :string=  assert code.kind == nkUIntLit          ; todo(code)  ## TODO : Converts a nkUIntLit into the Min C Language
proc cminUInt8Lit         (code :PNode) :string=  assert code.kind == nkUInt8Lit         ; todo(code)  ## TODO : Converts a nkUInt8Lit into the Min C Language
proc cminUInt16Lit        (code :PNode) :string=  assert code.kind == nkUInt16Lit        ; todo(code)  ## TODO : Converts a nkUInt16Lit into the Min C Language
proc cminUInt32Lit        (code :PNode) :string=  assert code.kind == nkUInt32Lit        ; todo(code)  ## TODO : Converts a nkUInt32Lit into the Min C Language
proc cminUInt64Lit        (code :PNode) :string=  assert code.kind == nkUInt64Lit        ; todo(code)  ## TODO : Converts a nkUInt64Lit into the Min C Language
proc cminFloatLit         (code :PNode) :string=  assert code.kind == nkFloatLit         ; todo(code)  ## TODO : Converts a nkFloatLit into the Min C Language
proc cminFloat32Lit       (code :PNode) :string=  assert code.kind == nkFloat32Lit       ; todo(code)  ## TODO : Converts a nkFloat32Lit into the Min C Language
proc cminFloat64Lit       (code :PNode) :string=  assert code.kind == nkFloat64Lit       ; todo(code)  ## TODO : Converts a nkFloat64Lit into the Min C Language
proc cminFloat128Lit      (code :PNode) :string=  assert code.kind == nkFloat128Lit      ; todo(code)  ## TODO : Converts a nkFloat128Lit into the Min C Language
proc cminStrLit           (code :PNode) :string=  assert code.kind == nkStrLit           ; todo(code)  ## TODO : Converts a nkStrLit into the Min C Language
proc cminRStrLit          (code :PNode) :string=  assert code.kind == nkRStrLit          ; todo(code)  ## TODO : Converts a nkRStrLit into the Min C Language
proc cminTripleStrLit     (code :PNode) :string=  assert code.kind == nkTripleStrLit     ; todo(code)  ## TODO : Converts a nkTripleStrLit into the Min C Language
proc cminNilLit           (code :PNode) :string=  assert code.kind == nkNilLit           ; todo(code)  ## TODO : Converts a nkNilLit into the Min C Language
proc cminComesFrom        (code :PNode) :string=  assert code.kind == nkComesFrom        ; todo(code)  ## TODO : Converts a nkComesFrom into the Min C Language
proc cminDotCall          (code :PNode) :string=  assert code.kind == nkDotCall          ; todo(code)  ## TODO : Converts a nkDotCall into the Min C Language
proc cminCommand          (code :PNode) :string=  assert code.kind == nkCommand          ; todo(code)  ## TODO : Converts a nkCommand into the Min C Language
proc cminCall             (code :PNode) :string=  assert code.kind == nkCall             ; todo(code)  ## TODO : Converts a nkCall into the Min C Language
proc cminCallStrLit       (code :PNode) :string=  assert code.kind == nkCallStrLit       ; todo(code)  ## TODO : Converts a nkCallStrLit into the Min C Language
proc cminInfix            (code :PNode) :string=  assert code.kind == nkInfix            ; todo(code)  ## TODO : Converts a nkInfix into the Min C Language
proc cminPrefix           (code :PNode) :string=  assert code.kind == nkPrefix           ; todo(code)  ## TODO : Converts a nkPrefix into the Min C Language
proc cminPostfix          (code :PNode) :string=  assert code.kind == nkPostfix          ; todo(code)  ## TODO : Converts a nkPostfix into the Min C Language
proc cminHiddenCallConv   (code :PNode) :string=  assert code.kind == nkHiddenCallConv   ; todo(code)  ## TODO : Converts a nkHiddenCallConv into the Min C Language
proc cminExprEqExpr       (code :PNode) :string=  assert code.kind == nkExprEqExpr       ; todo(code)  ## TODO : Converts a nkExprEqExpr into the Min C Language
proc cminExprColonExpr    (code :PNode) :string=  assert code.kind == nkExprColonExpr    ; todo(code)  ## TODO : Converts a nkExprColonExpr into the Min C Language
proc cminIdentDefs        (code :PNode) :string=  assert code.kind == nkIdentDefs        ; todo(code)  ## TODO : Converts a nkIdentDefs into the Min C Language
proc cminVarTuple         (code :PNode) :string=  assert code.kind == nkVarTuple         ; todo(code)  ## TODO : Converts a nkVarTuple into the Min C Language
proc cminPar              (code :PNode) :string=  assert code.kind == nkPar              ; todo(code)  ## TODO : Converts a nkPar into the Min C Language
proc cminObjConstr        (code :PNode) :string=  assert code.kind == nkObjConstr        ; todo(code)  ## TODO : Converts a nkObjConstr into the Min C Language
proc cminCurly            (code :PNode) :string=  assert code.kind == nkCurly            ; todo(code)  ## TODO : Converts a nkCurly into the Min C Language
proc cminCurlyExpr        (code :PNode) :string=  assert code.kind == nkCurlyExpr        ; todo(code)  ## TODO : Converts a nkCurlyExpr into the Min C Language
proc cminBracket          (code :PNode) :string=  assert code.kind == nkBracket          ; todo(code)  ## TODO : Converts a nkBracket into the Min C Language
proc cminBracketExpr      (code :PNode) :string=  assert code.kind == nkBracketExpr      ; todo(code)  ## TODO : Converts a nkBracketExpr into the Min C Language
proc cminPragmaExpr       (code :PNode) :string=  assert code.kind == nkPragmaExpr       ; todo(code)  ## TODO : Converts a nkPragmaExpr into the Min C Language
proc cminRange            (code :PNode) :string=  assert code.kind == nkRange            ; todo(code)  ## TODO : Converts a nkRange into the Min C Language
proc cminDotExpr          (code :PNode) :string=  assert code.kind == nkDotExpr          ; todo(code)  ## TODO : Converts a nkDotExpr into the Min C Language
proc cminCheckedFieldExpr (code :PNode) :string=  assert code.kind == nkCheckedFieldExpr ; todo(code)  ## TODO : Converts a nkCheckedFieldExpr into the Min C Language
proc cminDerefExpr        (code :PNode) :string=  assert code.kind == nkDerefExpr        ; todo(code)  ## TODO : Converts a nkDerefExpr into the Min C Language
proc cminIfExpr           (code :PNode) :string=  assert code.kind == nkIfExpr           ; todo(code)  ## TODO : Converts a nkIfExpr into the Min C Language
proc cminElifExpr         (code :PNode) :string=  assert code.kind == nkElifExpr         ; todo(code)  ## TODO : Converts a nkElifExpr into the Min C Language
proc cminElseExpr         (code :PNode) :string=  assert code.kind == nkElseExpr         ; todo(code)  ## TODO : Converts a nkElseExpr into the Min C Language
proc cminLambda           (code :PNode) :string=  assert code.kind == nkLambda           ; todo(code)  ## TODO : Converts a nkLambda into the Min C Language
proc cminDo               (code :PNode) :string=  assert code.kind == nkDo               ; todo(code)  ## TODO : Converts a nkDo into the Min C Language
proc cminAccQuoted        (code :PNode) :string=  assert code.kind == nkAccQuoted        ; todo(code)  ## TODO : Converts a nkAccQuoted into the Min C Language
proc cminTableConstr      (code :PNode) :string=  assert code.kind == nkTableConstr      ; todo(code)  ## TODO : Converts a nkTableConstr into the Min C Language
proc cminBind             (code :PNode) :string=  assert code.kind == nkBind             ; todo(code)  ## TODO : Converts a nkBind into the Min C Language
proc cminClosedSymChoice  (code :PNode) :string=  assert code.kind == nkClosedSymChoice  ; todo(code)  ## TODO : Converts a nkClosedSymChoice into the Min C Language
proc cminOpenSymChoice    (code :PNode) :string=  assert code.kind == nkOpenSymChoice    ; todo(code)  ## TODO : Converts a nkOpenSymChoice into the Min C Language
proc cminHiddenStdConv    (code :PNode) :string=  assert code.kind == nkHiddenStdConv    ; todo(code)  ## TODO : Converts a nkHiddenStdConv into the Min C Language
proc cminHiddenSubConv    (code :PNode) :string=  assert code.kind == nkHiddenSubConv    ; todo(code)  ## TODO : Converts a nkHiddenSubConv into the Min C Language
proc cminConv             (code :PNode) :string=  assert code.kind == nkConv             ; todo(code)  ## TODO : Converts a nkConv into the Min C Language
proc cminCast             (code :PNode) :string=  assert code.kind == nkCast             ; todo(code)  ## TODO : Converts a nkCast into the Min C Language
proc cminStaticExpr       (code :PNode) :string=  assert code.kind == nkStaticExpr       ; todo(code)  ## TODO : Converts a nkStaticExpr into the Min C Language
proc cminAddr             (code :PNode) :string=  assert code.kind == nkAddr             ; todo(code)  ## TODO : Converts a nkAddr into the Min C Language
proc cminHiddenAddr       (code :PNode) :string=  assert code.kind == nkHiddenAddr       ; todo(code)  ## TODO : Converts a nkHiddenAddr into the Min C Language
proc cminHiddenDeref      (code :PNode) :string=  assert code.kind == nkHiddenDeref      ; todo(code)  ## TODO : Converts a nkHiddenDeref into the Min C Language
proc cminObjDownConv      (code :PNode) :string=  assert code.kind == nkObjDownConv      ; todo(code)  ## TODO : Converts a nkObjDownConv into the Min C Language
proc cminObjUpConv        (code :PNode) :string=  assert code.kind == nkObjUpConv        ; todo(code)  ## TODO : Converts a nkObjUpConv into the Min C Language
proc cminChckRangeF       (code :PNode) :string=  assert code.kind == nkChckRangeF       ; todo(code)  ## TODO : Converts a nkChckRangeF into the Min C Language
proc cminChckRange64      (code :PNode) :string=  assert code.kind == nkChckRange64      ; todo(code)  ## TODO : Converts a nkChckRange64 into the Min C Language
proc cminChckRange        (code :PNode) :string=  assert code.kind == nkChckRange        ; todo(code)  ## TODO : Converts a nkChckRange into the Min C Language
proc cminStringToCString  (code :PNode) :string=  assert code.kind == nkStringToCString  ; todo(code)  ## TODO : Converts a nkStringToCString into the Min C Language
proc cminCStringToString  (code :PNode) :string=  assert code.kind == nkCStringToString  ; todo(code)  ## TODO : Converts a nkCStringToString into the Min C Language
proc cminAsgn             (code :PNode) :string=  assert code.kind == nkAsgn             ; todo(code)  ## TODO : Converts a nkAsgn into the Min C Language
proc cminFastAsgn         (code :PNode) :string=  assert code.kind == nkFastAsgn         ; todo(code)  ## TODO : Converts a nkFastAsgn into the Min C Language
proc cminGenericParams    (code :PNode) :string=  assert code.kind == nkGenericParams    ; todo(code)  ## TODO : Converts a nkGenericParams into the Min C Language
proc cminFormalParams     (code :PNode) :string=  assert code.kind == nkFormalParams     ; todo(code)  ## TODO : Converts a nkFormalParams into the Min C Language
proc cminOfInherit        (code :PNode) :string=  assert code.kind == nkOfInherit        ; todo(code)  ## TODO : Converts a nkOfInherit into the Min C Language
proc cminImportAs         (code :PNode) :string=  assert code.kind == nkImportAs         ; todo(code)  ## TODO : Converts a nkImportAs into the Min C Language

proc cminMethodDef        (code :PNode) :string=  assert code.kind == nkMethodDef        ; todo(code)  ## TODO : Converts a nkMethodDef into the Min C Language
proc cminConverterDef     (code :PNode) :string=  assert code.kind == nkConverterDef     ; todo(code)  ## TODO : Converts a nkConverterDef into the Min C Language
proc cminMacroDef         (code :PNode) :string=  assert code.kind == nkMacroDef         ; todo(code)  ## TODO : Converts a nkMacroDef into the Min C Language
proc cminTemplateDef      (code :PNode) :string=  assert code.kind == nkTemplateDef      ; todo(code)  ## TODO : Converts a nkTemplateDef into the Min C Language
proc cminIteratorDef      (code :PNode) :string=  assert code.kind == nkIteratorDef      ; todo(code)  ## TODO : Converts a nkIteratorDef into the Min C Language

proc cminOfBranch         (code :PNode) :string=  assert code.kind == nkOfBranch         ; todo(code)  ## TODO : Converts a nkOfBranch into the Min C Language
proc cminElifBranch       (code :PNode) :string=  assert code.kind == nkElifBranch       ; todo(code)  ## TODO : Converts a nkElifBranch into the Min C Language
proc cminExceptBranch     (code :PNode) :string=  assert code.kind == nkExceptBranch     ; todo(code)  ## TODO : Converts a nkExceptBranch into the Min C Language
proc cminElse             (code :PNode) :string=  assert code.kind == nkElse             ; todo(code)  ## TODO : Converts a nkElse into the Min C Language
proc cminAsmStmt          (code :PNode) :string=  assert code.kind == nkAsmStmt          ; todo(code)  ## TODO : Converts a nkAsmStmt into the Min C Language
proc cminPragma           (code :PNode) :string=  assert code.kind == nkPragma           ; todo(code)  ## TODO : Converts a nkPragma into the Min C Language
proc cminPragmaBlock      (code :PNode) :string=  assert code.kind == nkPragmaBlock      ; todo(code)  ## TODO : Converts a nkPragmaBlock into the Min C Language
proc cminIfStmt           (code :PNode) :string=  assert code.kind == nkIfStmt           ; todo(code)  ## TODO : Converts a nkIfStmt into the Min C Language
proc cminWhenStmt         (code :PNode) :string=  assert code.kind == nkWhenStmt         ; todo(code)  ## TODO : Converts a nkWhenStmt into the Min C Language
proc cminForStmt          (code :PNode) :string=  assert code.kind == nkForStmt          ; todo(code)  ## TODO : Converts a nkForStmt into the Min C Language
proc cminParForStmt       (code :PNode) :string=  assert code.kind == nkParForStmt       ; todo(code)  ## TODO : Converts a nkParForStmt into the Min C Language
proc cminWhileStmt        (code :PNode) :string=  assert code.kind == nkWhileStmt        ; todo(code)  ## TODO : Converts a nkWhileStmt into the Min C Language
proc cminCaseStmt         (code :PNode) :string=  assert code.kind == nkCaseStmt         ; todo(code)  ## TODO : Converts a nkCaseStmt into the Min C Language
proc cminTypeSection      (code :PNode) :string=  assert code.kind == nkTypeSection      ; todo(code)  ## TODO : Converts a nkTypeSection into the Min C Language

proc cminConstDef         (code :PNode) :string=  assert code.kind == nkConstDef         ; todo(code)  ## TODO : Converts a nkConstDef into the Min C Language
proc cminTypeDef          (code :PNode) :string=  assert code.kind == nkTypeDef          ; todo(code)  ## TODO : Converts a nkTypeDef into the Min C Language
proc cminYieldStmt        (code :PNode) :string=  assert code.kind == nkYieldStmt        ; todo(code)  ## TODO : Converts a nkYieldStmt into the Min C Language
proc cminDefer            (code :PNode) :string=  assert code.kind == nkDefer            ; todo(code)  ## TODO : Converts a nkDefer into the Min C Language
proc cminTryStmt          (code :PNode) :string=  assert code.kind == nkTryStmt          ; todo(code)  ## TODO : Converts a nkTryStmt into the Min C Language
proc cminFinally          (code :PNode) :string=  assert code.kind == nkFinally          ; todo(code)  ## TODO : Converts a nkFinally into the Min C Language
proc cminRaiseStmt        (code :PNode) :string=  assert code.kind == nkRaiseStmt        ; todo(code)  ## TODO : Converts a nkRaiseStmt into the Min C Language

proc cminBreakStmt        (code :PNode) :string=  assert code.kind == nkBreakStmt        ; todo(code)  ## TODO : Converts a nkBreakStmt into the Min C Language
proc cminContinueStmt     (code :PNode) :string=  assert code.kind == nkContinueStmt     ; todo(code)  ## TODO : Converts a nkContinueStmt into the Min C Language
proc cminBlockStmt        (code :PNode) :string=  assert code.kind == nkBlockStmt        ; todo(code)  ## TODO : Converts a nkBlockStmt into the Min C Language
proc cminStaticStmt       (code :PNode) :string=  assert code.kind == nkStaticStmt       ; todo(code)  ## TODO : Converts a nkStaticStmt into the Min C Language
proc cminDiscardStmt      (code :PNode) :string=  assert code.kind == nkDiscardStmt      ; todo(code)  ## TODO : Converts a nkDiscardStmt into the Min C Language
proc cminImportStmt       (code :PNode) :string=  assert code.kind == nkImportStmt       ; todo(code)  ## TODO : Converts a nkImportStmt into the Min C Language
proc cminImportExceptStmt (code :PNode) :string=  assert code.kind == nkImportExceptStmt ; todo(code)  ## TODO : Converts a nkImportExceptStmt into the Min C Language
proc cminExportStmt       (code :PNode) :string=  assert code.kind == nkExportStmt       ; todo(code)  ## TODO : Converts a nkExportStmt into the Min C Language
proc cminExportExceptStmt (code :PNode) :string=  assert code.kind == nkExportExceptStmt ; todo(code)  ## TODO : Converts a nkExportExceptStmt into the Min C Language
proc cminFromStmt         (code :PNode) :string=  assert code.kind == nkFromStmt         ; todo(code)  ## TODO : Converts a nkFromStmt into the Min C Language
proc cminIncludeStmt      (code :PNode) :string=  assert code.kind == nkIncludeStmt      ; todo(code)  ## TODO : Converts a nkIncludeStmt into the Min C Language
proc cminBindStmt         (code :PNode) :string=  assert code.kind == nkBindStmt         ; todo(code)  ## TODO : Converts a nkBindStmt into the Min C Language
proc cminMixinStmt        (code :PNode) :string=  assert code.kind == nkMixinStmt        ; todo(code)  ## TODO : Converts a nkMixinStmt into the Min C Language
proc cminUsingStmt        (code :PNode) :string=  assert code.kind == nkUsingStmt        ; todo(code)  ## TODO : Converts a nkUsingStmt into the Min C Language
proc cminCommentStmt      (code :PNode) :string=  assert code.kind == nkCommentStmt      ; todo(code)  ## TODO : Converts a nkCommentStmt into the Min C Language
proc cminStmtListExpr     (code :PNode) :string=  assert code.kind == nkStmtListExpr     ; todo(code)  ## TODO : Converts a nkStmtListExpr into the Min C Language
proc cminBlockExpr        (code :PNode) :string=  assert code.kind == nkBlockExpr        ; todo(code)  ## TODO : Converts a nkBlockExpr into the Min C Language
proc cminStmtListType     (code :PNode) :string=  assert code.kind == nkStmtListType     ; todo(code)  ## TODO : Converts a nkStmtListType into the Min C Language
proc cminBlockType        (code :PNode) :string=  assert code.kind == nkBlockType        ; todo(code)  ## TODO : Converts a nkBlockType into the Min C Language
proc cminWith             (code :PNode) :string=  assert code.kind == nkWith             ; todo(code)  ## TODO : Converts a nkWith into the Min C Language
proc cminWithout          (code :PNode) :string=  assert code.kind == nkWithout          ; todo(code)  ## TODO : Converts a nkWithout into the Min C Language
proc cminTypeOfExpr       (code :PNode) :string=  assert code.kind == nkTypeOfExpr       ; todo(code)  ## TODO : Converts a nkTypeOfExpr into the Min C Language
proc cminObjectTy         (code :PNode) :string=  assert code.kind == nkObjectTy         ; todo(code)  ## TODO : Converts a nkObjectTy into the Min C Language
proc cminTupleTy          (code :PNode) :string=  assert code.kind == nkTupleTy          ; todo(code)  ## TODO : Converts a nkTupleTy into the Min C Language
proc cminTupleClassTy     (code :PNode) :string=  assert code.kind == nkTupleClassTy     ; todo(code)  ## TODO : Converts a nkTupleClassTy into the Min C Language
proc cminTypeClassTy      (code :PNode) :string=  assert code.kind == nkTypeClassTy      ; todo(code)  ## TODO : Converts a nkTypeClassTy into the Min C Language
proc cminStaticTy         (code :PNode) :string=  assert code.kind == nkStaticTy         ; todo(code)  ## TODO : Converts a nkStaticTy into the Min C Language
proc cminRecList          (code :PNode) :string=  assert code.kind == nkRecList          ; todo(code)  ## TODO : Converts a nkRecList into the Min C Language
proc cminRecCase          (code :PNode) :string=  assert code.kind == nkRecCase          ; todo(code)  ## TODO : Converts a nkRecCase into the Min C Language
proc cminRecWhen          (code :PNode) :string=  assert code.kind == nkRecWhen          ; todo(code)  ## TODO : Converts a nkRecWhen into the Min C Language

proc cminRefTy            (code :PNode) :string=  assert code.kind == nkRefTy            ; todo(code)  ## TODO : Converts a nkRefTy into the Min C Language
proc cminPtrTy            (code :PNode) :string=  assert code.kind == nkPtrTy            ; todo(code)  ## TODO : Converts a nkPtrTy into the Min C Language
proc cminVarTy            (code :PNode) :string=  assert code.kind == nkVarTy            ; todo(code)  ## TODO : Converts a nkVarTy into the Min C Language
proc cminConstTy          (code :PNode) :string=  assert code.kind == nkConstTy          ; todo(code)  ## TODO : Converts a nkConstTy into the Min C Language
proc cminOutTy            (code :PNode) :string=  assert code.kind == nkOutTy            ; todo(code)  ## TODO : Converts a nkOutTy into the Min C Language
proc cminDistinctTy       (code :PNode) :string=  assert code.kind == nkDistinctTy       ; todo(code)  ## TODO : Converts a nkDistinctTy into the Min C Language
proc cminProcTy           (code :PNode) :string=  assert code.kind == nkProcTy           ; todo(code)  ## TODO : Converts a nkProcTy into the Min C Language
proc cminIteratorTy       (code :PNode) :string=  assert code.kind == nkIteratorTy       ; todo(code)  ## TODO : Converts a nkIteratorTy into the Min C Language
proc cminSinkAsgn         (code :PNode) :string=  assert code.kind == nkSinkAsgn         ; todo(code)  ## TODO : Converts a nkSinkAsgn into the Min C Language
proc cminEnumTy           (code :PNode) :string=  assert code.kind == nkEnumTy           ; todo(code)  ## TODO : Converts a nkEnumTy into the Min C Language
proc cminEnumFieldDef     (code :PNode) :string=  assert code.kind == nkEnumFieldDef     ; todo(code)  ## TODO : Converts a nkEnumFieldDef into the Min C Language

proc cminArgList          (code :PNode) :string=  assert code.kind == nkArgList          ; todo(code)  ## TODO : Converts a nkArgList into the Min C Language
proc cminPattern          (code :PNode) :string=  assert code.kind == nkPattern          ; todo(code)  ## TODO : Converts a nkPattern into the Min C Language
proc cminHiddenTryStmt    (code :PNode) :string=  assert code.kind == nkHiddenTryStmt    ; todo(code)  ## TODO : Converts a nkHiddenTryStmt into the Min C Language
proc cminClosure          (code :PNode) :string=  assert code.kind == nkClosure          ; todo(code)  ## TODO : Converts a nkClosure into the Min C Language
proc cminGotoState        (code :PNode) :string=  assert code.kind == nkGotoState        ; todo(code)  ## TODO : Converts a nkGotoState into the Min C Language
proc cminState            (code :PNode) :string=  assert code.kind == nkState            ; todo(code)  ## TODO : Converts a nkState into the Min C Language
proc cminBreakState       (code :PNode) :string=  assert code.kind == nkBreakState       ; todo(code)  ## TODO : Converts a nkBreakState into the Min C Language
proc cminFuncDef          (code :PNode) :string=  assert code.kind == nkFuncDef          ; todo(code)  ## TODO : Converts a nkFuncDef into the Min C Language
proc cminTupleConstr      (code :PNode) :string=  assert code.kind == nkTupleConstr      ; todo(code)  ## TODO : Converts a nkTupleConstr into the Min C Language
proc cminError            (code :PNode) :string=  assert code.kind == nkError            ; todo(code)  ## TODO : Converts a nkError into the Min C Language
proc cminModuleRef        (code :PNode) :string=  assert code.kind == nkModuleRef        ; todo(code)  ## TODO : Converts a nkModuleRef into the Min C Language
proc cminReplayAction     (code :PNode) :string=  assert code.kind == nkReplayAction     ; todo(code)  ## TODO : Converts a nkReplayAction into the Min C Language
proc cminNilRodNode       (code :PNode) :string=  assert code.kind == nkNilRodNode       ; todo(code)  ## TODO : Converts a nkNilRodNode into the Min C Language
# Recursive
# proc cminStmtList         (code :PNode) :string=  assert code.kind == nkStmtList         ; todo(code)  ## TODO : Converts a nkStmtList into the Min C Language

# Main Code Generator
proc Cmin (code :PNode; indent :int= 0) :string

