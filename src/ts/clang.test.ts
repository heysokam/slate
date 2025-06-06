//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
import { describe, it, expect, afterEach } from 'bun:test'
import { log as echo } from 'console'
import * as fs from 'fs'
// @deps runic
import { astTF, Procedure } from '@heysokam/astTF'
import { json_print } from './base'
import { clang } from './clang'



export const TODO = {} as astTF
export namespace C {
export namespace cases {
  export namespace Hello42 {
    export const code :string= "int main (void) { return 42; }"
    export const ast  :astTF= {
      metadata : {
        description : "C.cases.Hello42"
      }, //:: C.cases.Hello42.ast.metadata
      data : {
        nodes: [{
          name : { start: 4, end: 7 },
          retT : { start: 0, end: 2 }
        } as Procedure],
        code: C.cases.Hello42.code
      } //:: C.cases.Hello42.ast.data
    } //:: C.cases.Hello42.ast
  } //:: C.cases.Hello42
  export namespace HelloArgs {
    export const code = "int main (int argc, char** argv) { return 42; }"
    export const ast  = TODO
  } //:: C.cases.HelloArgs
} //:: C.cases
} //:: C

//::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
describe("clang", () => {
  const TempFile = "./bin/test.c"
  afterEach(() => fs.existsSync(TempFile) && fs.rmSync(TempFile))

  it("must run clang without erroring", () => {
    const cmd = clang.Command()
    cmd.add("--version")
    const result = cmd.exec()
    expect(result.stdout.toString()).not.toBe("")
    expect(result.stderr.toString()).toBe("")
  })

  it("must run clang dump and get its json AST without erroring", () => {
    const code = C.cases.Hello42.code
    const file = TempFile
    fs.writeFileSync(file, code)
    const result = Object.keys(clang.getJson(file))
    expect(result.length).not.toBe(0)
  })

  it("must process the Hello42 case into the expected AST", () => {
    const Expected = C.cases.Hello42.ast
    const code     = C.cases.Hello42.code
    const file     = TempFile
    fs.writeFileSync(file, code)
    const json = clang.getJson(file)
    json_print(json)
    const P = new clang.Parser(json)
    P.process()
    const result = P.ast()
    echo(":: ast :::::::::::::::::::::::::::::::::::")
    echo(result)
    expect(result).toStrictEqual(Expected)
    // json_print(json)
  })
})

