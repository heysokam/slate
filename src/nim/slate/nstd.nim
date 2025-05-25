include ./safety

#_______________________________________
# @section General Aliases
#_____________________________
type u64 * = uint64
type Sz  * = range[0'u..uint.high]
type P   * = pointer


#_______________________________________
# @section Slices
#_____________________________
type Slice *[T]= object
  data :ptr T
  len  :Sz


#_______________________________________
# @section cstring
#_____________________________
type CString {.importc: "const char*".} = cstring
type cstr * = distinct CString
converter autoString *(val :string) :cstr= val.cstr

#_______________________________________
# @section string
#_____________________________
type str * = string
func info *(val :str | char) :void=
  {.cast(noSideEffect).}: echo val


#_______________________________________
# @section Allocator
#_____________________________
{.pragma: allo, noconv, noSideEffect, gcsafe, mmsafe.}
type FnAlloc  = proc (size :Natural) :P {.allo.}
type FnFree   = proc (p :P) :void {.allo.}
type FnResize = proc (p :P; news :Natural) :P {.allo.}
#_____________________________
type AllocatorKind * = enum System
type Allocator * = object
  alloc  *:FnAlloc
  resize *:FnResize
  free   *:FnFree
  kind   *:AllocatorKind

