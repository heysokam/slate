//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
import { describe, it, expect } from 'bun:test'
import * as runic from './runic'

describe("Command", () => {
  it("must exec a command without erroring when requested", () => {
    const Expected = "HelloCommand\n"
    const cmd = new runic.Command(["echo"])
    cmd.add(Expected)
    expect(cmd.parts[0]).toBe("echo")
    expect(cmd.parts[1]).toBe(Expected)
    const result = cmd.exec().stdout.toString().slice(0, -1)
    expect(result).toBe(Expected)
  })
})

