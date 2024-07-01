#:______________________________________________________
#  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  MIT  :
#:______________________________________________________
when not defined(nimscript):  import system/nimscript  # Silence nimsuggest errors

# Package
packageName   = "slate"
version       = "0.5.10"
author        = "sOkam"
description   = "*Slate | StoS Compiler Helper for Nim syntax"
license       = "MIT"
srcDir        = "src/nim"
skipFiles     = @["build.nim", "nim.cfg"]
installExt    = @["nim"]
bin           = @[packageName]
# Dependencies
requires "nim >= 2.0.0"
