//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
pub const source = @This();
// @deps std
const std = @import("std");
// @deps zstd
const zstd = @import("../zstd.zig");

pub const Code = [:0]const u8;
pub const Str  = []const u8;
pub const Pos  = u32;
pub const Loc  = struct {
  start  :source.Pos=  source.Loc.Invalid,
  end    :source.Pos=  source.Loc.Invalid,
  pub const Invalid = std.math.maxInt(source.Pos);

  pub const check = struct {
    //______________________________________
    /// @descr Returns true when both elements of {@arg A} are valid
    pub fn valid (A:*const Loc) bool { return A.start != source.Loc.Invalid and A.end != source.Loc.Invalid; }
    //______________________________________
    /// @descr Returns true when one of the elements of {@arg A} is invalid
    pub fn invalid (A:*const Loc) bool { return !A.valid(); }
  };
  pub const valid   = source.Loc.check.valid;
  pub const invalid = source.Loc.check.invalid;
  pub const some    = source.Loc.check.valid;
  pub const none    = source.Loc.check.invalid;

  //______________________________________
  /// @descr Returns true when {@arg B} is located right after {@arg A}
  pub fn adjacent (B:*const Loc, A:Loc) bool { return B.start == A.end+1; }

  //______________________________________
  /// @descr Returns the end value of {@arg L} for use as the max value in range iterators
  pub fn max (L:*const Loc) source.Pos { return L.end+1; }

  //______________________________________
  /// @descr
  ///  Adds the {@arg B} location to {@arg A}.
  ///  They are required to be adjacent.
  pub fn add (A:*Loc, B:Loc) void {
    zstd.ensure(B.adjacent(A.*), "Tried to add a location to another, but the locations are not adjacent.");
    A.end = B.end;
  } //:: slate.source.Loc.add

  //______________________________________
  /// @descr Returns the string value found at the {@arg L} location of {@arg src}.
  /// @note Returns an empty string when {@arg L} does not represent a valid location.
  /// @note Does not perform bounds check on {@arg src}. It will fail when the location is out of bounds.
  pub fn from (L :*const Loc, src :source.Code) source.Str { return if (L.valid()) src[L.start..L.max()] else ""; }

  //______________________________________
  /// @descr Returns the lenght of the {@arg L} location,
  /// @note Result is the difference between (start,end), +1 to turn it into a .len
  pub fn len (L :*const Loc) source.Pos { return L.end-L.start + 1; }
}; //:: slate.source.Loc

