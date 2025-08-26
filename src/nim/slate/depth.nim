#:___________________________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
#:___________________________________________________________________
##! @fileoverview Types to describe Generic Depth/Indentation levels
#____________________________________________________________________|

type DepthLevel * = uint32
type Level * = DepthLevel

type ScopeID * = distinct uint32
  ## @descr
  ##  Distinct Integer that identifies something uniquely
  ##  Can only identify, compare with others, or request a new id with `id.next()`
func root *(_:typedesc[ScopeID]) :ScopeID= ScopeID(0)
func none *(_:typedesc[ScopeID]) :ScopeID= ScopeID(uint32.high)
func value *(id :ScopeID) :uint32= id.uint32
func `==` *(A,B :ScopeID) :bool {.borrow.}
func `<`  *(A,B :ScopeID) :bool {.borrow.}
func `+`  *(A,B :ScopeID) :ScopeID {.borrow.}
func empty *(id :ScopeID) :bool= id == ScopeID.none
func `$` *(id :ScopeID) :string=
  if id.empty: "none" else: $id.value
func next *(id :ScopeID) :ScopeID=
  if id.empty : ScopeID.root()
  else        : ScopeID(id.uint32 + 1)

type Depth * = object
  indent *:DepthLevel
  scope  *:ScopeID= ScopeID.none()

