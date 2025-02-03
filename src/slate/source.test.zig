//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
//! @fileoverview Unit Tests for slate/source.zig
//____________________________________________________________|
// @deps *Slate
const t      = @import("../tests.zig");
const source = @import("./source.zig");

//______________________________________
// @section source.Code
//____________________________
test "source.Code | should be the expected type" {
  const T = @typeInfo(source.Code);
  try t.ok(T.Pointer.size == @import("std").builtin.Type.Pointer.Size.Slice);
  try t.ok(T.Pointer.child == u8);
  try t.ok(T.Pointer.is_const == true);
  try t.ok(T.Pointer.is_allowzero == false);
  try t.ok(T.Pointer.sentinel != null);
  try t.ok(T.Pointer.alignment == 1);
}

//______________________________________
// @section source.Code
//____________________________
test "source.Str | should be the expected type" {
  const T = @typeInfo(source.Str);
  try t.ok(T.Pointer.size == @import("std").builtin.Type.Pointer.Size.Slice);
  try t.ok(T.Pointer.child == u8);
  try t.ok(T.Pointer.is_const == true);
  try t.ok(T.Pointer.is_allowzero == false);
  try t.ok(T.Pointer.sentinel == null);
  try t.ok(T.Pointer.alignment == 1);
}


//______________________________________
// @section source.Pos
//____________________________
test "source.Pos | should be an unsigned type" {
  const Expected = @import("std").builtin.Signedness.unsigned;
  const result = @typeInfo(source.Pos).Int.signedness;
  try t.eq(result, Expected);
}

test "source.Pos | should be the expected size" {
  const Expected = 32;
  const result = @typeInfo(source.Pos).Int.bits;
  try t.eq(result, Expected);
}

test "source.Loc | should initialize .start with the expected default value" {
  const Expected = source.Loc.Invalid;
  const result = (source.Loc{}).start;
  try t.eq(result, Expected);
}


//______________________________________
// @section source.Loc
//____________________________
test "source.Loc | should initialize .end with the expected default value" {
  const Expected = source.Loc.Invalid;
  const result = (source.Loc{}).end;
  try t.eq(result, Expected);
}


//______________________________________
// @section source.Loc.Invalid
//____________________________
test "source.Loc.Invalid | should be expected value" {
  try t.eq(source.Loc.Invalid, @import("std").math.maxInt(source.Pos));
}


//______________________________________
// @section source.Loc.check.valid
//____________________________
test "source.Loc.check.valid | should return true when both .start and .end are valid" {
  const Expected = true;
  // Setup
  const L = source.Loc{.start= 41, .end= 42};
  // Validate
  try t.ok(L.start != source.Loc.Invalid);
  try t.ok(L.end   != source.Loc.Invalid);
  // Check
  const result = source.Loc.check.valid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.valid | should return false when .start is valid and .end is invalid" {
  const Expected = false;
  // Setup
  const L = source.Loc{.start= 42, .end= source.Loc.Invalid};
  // Validate
  try t.ok(L.start != source.Loc.Invalid);
  try t.ok(L.end   == source.Loc.Invalid);
  // Check
  const result = source.Loc.check.valid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.valid | should return false when .start is invalid and .end is valid" {
  const Expected = false;
  // Setup
  const L = source.Loc{.start= source.Loc.Invalid, .end= 42};
  // Validate
  try t.ok(L.start == source.Loc.Invalid);
  try t.ok(L.end   != source.Loc.Invalid);
  // Check
  const result = source.Loc.check.valid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.valid | should return false when both .start and .end are invalid" {
  const Expected = false;
  // Setup
  const L = source.Loc{.start= source.Loc.Invalid, .end= source.Loc.Invalid};
  // Validate
  try t.ok(L.start == source.Loc.Invalid);
  try t.ok(L.end   == source.Loc.Invalid);
  // Check
  const result = source.Loc.check.valid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.valid | should return false for a location initialized with the default values" {
  const Expected = false;
  // Setup
  const L = source.Loc{};
  // Check
  const result = source.Loc.check.valid(&L);
  try t.eq(result, Expected);
}


//______________________________________
// @section source.Loc.check.invalid
//____________________________
test "source.Loc.check.invalid | should return false when both .start and .end are valid" {
  const Expected = false;
  // Setup
  const L = source.Loc{.start= 41, .end= 42};
  // Validate
  try t.ok(L.start != source.Loc.Invalid);
  try t.ok(L.end   != source.Loc.Invalid);
  // Check
  const result = source.Loc.check.invalid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.invalid | should return true when .start is valid and .end is invalid" {
  const Expected = true;
  // Setup
  const L = source.Loc{.start= 42, .end= source.Loc.Invalid};
  // Validate
  try t.ok(L.start != source.Loc.Invalid);
  try t.ok(L.end   == source.Loc.Invalid);
  // Check
  const result = source.Loc.check.invalid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.invalid | should return true when .start is invalid and .end is valid" {
  const Expected = true;
  // Setup
  const L = source.Loc{.start= source.Loc.Invalid, .end= source.Loc.Invalid};
  // Validate
  try t.ok(L.start == source.Loc.Invalid);
  try t.ok(L.end   == source.Loc.Invalid);
  // Check
  const result = source.Loc.check.invalid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.invalid | should return true when both .start and .end are invalid" {
  const Expected = true;
  // Setup
  const L = source.Loc{.start= source.Loc.Invalid, .end= source.Loc.Invalid};
  // Validate
  try t.ok(L.start == source.Loc.Invalid);
  try t.ok(L.end   == source.Loc.Invalid);
  // Check
  const result = source.Loc.check.invalid(&L);
  try t.eq(result, Expected);
}

test "source.Loc.check.invalid | should return true for a location initialized with the default values" {
  const Expected = true;
  // Setup
  const L = source.Loc{};
  // Check
  const result = source.Loc.check.invalid(&L);
  try t.eq(result, Expected);
}

//______________________________________
// @section source.Loc.check aliases
//____________________________
test "source.Loc.valid | should be an alias to source.Loc.check.valid" {
  const Expected = source.Loc.check.valid;
  const result = source.Loc.valid;
  try t.eq(result, Expected);
}

test "source.Loc.invalid | should be an alias to source.Loc.check.invalid" {
  const Expected = source.Loc.check.invalid;
  const result = source.Loc.invalid;
  try t.eq(result, Expected);
}

test "source.Loc.some | should be an alias to source.Loc.check.valid" {
  const Expected = source.Loc.check.valid;
  const result = source.Loc.some;
  try t.eq(result, Expected);
}

test "source.Loc.none | should be an alias to source.Loc.check.invalid" {
  const Expected = source.Loc.check.invalid;
  const result = source.Loc.none;
  try t.eq(result, Expected);
}


//______________________________________
// @section source.Loc.adjacent
//____________________________
test "source.Loc.adjacent | should return true when B.start is equal to A.end+1" {
  const Expected = true;
  // Setup
  const A = source.Loc{.start= 41, .end= 42};
  const B = source.Loc{.start= A.end+1};
  // Validate
  try t.ok(B.start == A.end+1);
  // Check
  const result = source.Loc.adjacent(&B, A);
  try t.eq(result, Expected);
}

test "source.Loc.adjacent | should return false when B.start is not equal to A.end+1" {
  const Expected = false;
  // Setup
  const A = source.Loc{.start=   41, .end=   42};
  const B = source.Loc{.start= 1234, .end= 5678};
  // Validate
  try t.ok(B.start != A.end+1);
  // Check
  const result = source.Loc.adjacent(&B, A);
  try t.eq(result, Expected);
}


//______________________________________
// @section source.Loc.add
//____________________________
test "source.Loc.add | should set A.end to the value of B.end when B is adjacent to A" {
  const Expected = 42;
  // Setup
  var   A = source.Loc{.start= 20, .end= 21};
  const B = source.Loc{.start= A.end+1, .end= Expected};
  // Validate
  try t.ok(B.adjacent(A));
  // Check
  A.add(B);
  const result = A.end;
  try t.eq(result, Expected);
}

//______________________________________
// @section source.Loc.from
//____________________________
test "source.Loc.from | should return an empty string if {@arg L} is not valid" {
  const Expected = "";
  // Setup
  const src = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890";
  const L = source.Loc{};
  // Validate
  try t.ok(L.invalid());
  // Check
  const result = source.Loc.from(&L, src);
  try t.eq(result, Expected);
}

test "source.Loc.from | should return the [L.start..L.end] portion of {@arg src} if {@arg L} is valid" {
  const src      = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890";
  const Start    = 21;
  const End      = 42;
  const Expected = src[Start..End];
  // Setup
  const L = source.Loc{.start= Start, .end= End};
  // Validate
  try t.ok(L.valid());
  // Check
  const result = source.Loc.from(&L, src);
  try t.eq(result, Expected);
}

