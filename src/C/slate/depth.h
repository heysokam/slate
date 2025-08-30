//:__________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:__________________________________________________________
//! @fileoverview Types for representing Meaningful Indentation.
//______________________________________________________________|
#ifndef H_slate_depth
#define H_slate_depth
#include "./lexer.h"

typedef slate_size                slate_depth_Level;
typedef slate_size                slate_depth_Column;
typedef slate_size /* Distinct */ slate_depth_Scope;

typedef struct slate_Depth {
  slate_depth_Column column;
  slate_depth_Level  indentation;
  slate_depth_Scope  scope;
} slate_Depth;

#endif  // H_slate_depth

