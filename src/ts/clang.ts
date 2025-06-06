//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
// @deps std
import { default as std_assert } from 'assert'
import { log as echo } from 'console'
import * as fs from 'fs'
// @deps runic
import { astTF, SourceLocation } from '@heysokam/astTF'
import * as runic from './base'
import { json_print, JsonObject, JsonArray, JsonValue } from './base'
export namespace clang {


//______________________________________
// @section Known Node Kinds
//____________________________
export const id = {
  TranslationUnit : "TranslationUnitDecl",  // Root of module file
  Function        : "FunctionDecl",         // Procedure Declaration and Definition
  ParmVar         : "ParmVarDecl",          // Proc Argument
  // Statements
  CompoundStmt    : "CompoundStmt",         // Statement List  (eg: Proc.Body)
  ReturnStmt      : "ReturnStmt",           // return Expression
  // Expressions
  IntegerLiteral  : "IntegerLiteral"        // expression.Literal:Integer
}
export const KnownKinds = Object.values(clang.id)


//______________________________________
// @section AST Specification / Expectations
//____________________________
export namespace spec {
  // General
  export const KnownKinds      = "must be one of the implemented clang node Kinds/IDs"

  // Module: Root
  export namespace root {
  export const TranslationUnit = `must have a ${clang.id.TranslationUnit} node as the entry point of the clang AST`
  export const inner_Type      = "must have an array with name 'inner' as a field of its entry point"
  } //:: clang.spec.root

  // TopLevel: Proc
  export namespace proc {
  export const body_Statements = "must have only one `CompoundStmt` child that contains all of its statements"
  } //:: clang.spec.proc

  export namespace statement {
    export namespace retrn {
      export const Value = "must have only one Expression child that contains the resulting value."
    } //:: clang.spec.statement.retrn
  } //:: clang.spec.statement
} //:: clang.spec


//______________________________________
// @section clang Command
//____________________________
export const bin = ["./bin/.zig/zig", "clang"]
export function Command(): runic.Command {
  const result = new runic.Command(clang.bin)
  result.parts = result.parts.slice(0,clang.bin.length)
  result.add("-Xclang")
  result.add("-ast-dump=json")
  return result
} //:: clang.Command


//______________________________________
// @section clang.json Manipulation
//____________________________
export type SourceInfo = {
  generator :string
  code      :string
}

export function getJson(file: fs.PathLike): any {
  const cmd = clang.Command()
  cmd.add(file.toString())
  echo(cmd)
  const source = fs.readFileSync(file.toString()).toString()
  const result = JSON.parse(cmd.exec().stdout.toString())
  result.SourceInfo = {
    generator : "slate.clang.ts",
    code      : source,
  } as clang.SourceInfo
  return result
}

export function strip_implicit(json: JsonArray): JsonArray {
  std_assert.equal(Array.isArray(json), true, clang.spec.root.inner_Type)
  return structuredClone(json.filter((it: any) => !it.isImplicit))
}


//______________________________________
// @section clang.AST Assertion
//____________________________
export namespace assert {
export const kind_implemented = (kind :string) :void=> std_assert(clang.KnownKinds.includes(kind), clang.spec.KnownKinds + "  Found: " + kind)
export const node_implemented = (node :any) :void=> clang.assert.kind_implemented(node.kind)

export const toplevel = (json :JsonObject) :void=> {
  clang.assert.node_implemented(json)
  std_assert.equal(json.kind, clang.id.TranslationUnit, clang.spec.root.TranslationUnit)
  std_assert.notDeepEqual(json.inner, [], clang.spec.root.inner_Type)
} //:: clang.assert.toplevel

export const proc_body = (json :JsonObject) :void=> {
  std_assert.equal(json.length, 1, clang.spec.proc.body_Statements)
  clang.assert.node_implemented(json[0])
} //:: clang.assert.proc_body

export const return_value = (json :JsonObject) :void=> {
  // @ts-expect-error Makes no sense? Should be an Array just fine
  std_assert(json.inner.length == 1, clang.spec.statement.retrn.Value)
} //:: clang.assert.return_value

} //:: clang.assert


//______________________________________
// @section Conversion: clang.json -> slate.astTF
//____________________________
export const kind_astTF = (kind :string) :string=> {
  clang.assert.kind_implemented(kind)
  switch (kind) {
    case clang.id.ReturnStmt : return "Return"
    default: throw new Error(`clang.Kind \`${kind}\` has not been mapped to astTF kinds yet.`)
  }
}

// result.value = clang.range_toLocation(expr.value, expr.range)
export const range_toLocation = (value :string, range :JsonObject) :SourceLocation=> {
  const result = {} as SourceLocation
  result.start = 1234  // FIX:
  result.end   = 5678  // FIX:
  return result
}


//______________________________________
// @section Parser: clang.json -> slate.astTF
//____________________________
export class Parser {
  result :astTF
  nodes  :JsonArray
  entry  :JsonObject
  ast(): astTF { return structuredClone(this.result) }

  constructor(json: JsonObject) {
    clang.assert.toplevel(json) // Validate the input
    this.result = {} as astTF
    this.entry  = json
    this.nodes  = clang.strip_implicit(json.inner as JsonArray) // Cleanup the Node Tree
  }

  proc_arg(arg: JsonObject): any {
    clang.assert.node_implemented(arg)
    const result = {} as any /* astTF.Proc.Arg */
    // TODO:
    // echo(arg)
    return result
  }

  proc_args (proc: JsonObject): any[] {
    clang.assert.node_implemented(proc)
    const result = [] as any[]  /* astTF.Proc.Arg.List */
    for (const arg of (proc.inner as any[]).filter((it: any) => it.kind == clang.id.ParmVar)) {
      result.push(this.proc_arg(arg))
    }
    return result
  }


  expression_literal (expr: any): any {
    const result = {} as any
    result.value = clang.range_toLocation(expr.value, expr.range)
    json_print(expr);
    return result
  }

  expression (expr: any): any {
    let result = {} as any  /* astTF.Expression */
    switch (expr.kind) {
      case clang.id.IntegerLiteral: result = this.expression_literal(expr); break;
      // case clang.id.EnumDecl   : result = this.statement_enum(stmt); break;
      default: throw new Error(`Unknown clang.Expression.Kind: \`${expr.kind}\`. Might not be implemented yet.`)
    }
    return result
  }

  statement_return (stmt: any): any {
    clang.assert.node_implemented(stmt)
    clang.assert.return_value(stmt)
    const result = {} as any   /* astTF.Statement.Return */
    const value  = stmt.inner[0]
    result.value = this.expression(value)
    // TODO:
    return result
  }

  statement (stmt: any): any {
    clang.assert.node_implemented(stmt)
    let result = {} as any  /* astTF.Statement */
    switch (stmt.kind) {
      case clang.id.ReturnStmt : result = this.statement_return(stmt); break;
      // case clang.id.EnumDecl   : result = this.statement_enum(stmt); break;
      default: throw new Error(`Unknown clang.Statement.Kind: \`${stmt.kind}\`. Might not be implemented yet.`)
    }
    result.kind = clang.kind_astTF(stmt.kind)
    return result
  }

  proc_body (proc: JsonObject): any[] {
    const result = [] as any[]  /* astTF.Statement.List*/
    const compounds = (proc.inner as any[]).filter((it: any) => it.kind == clang.id.CompoundStmt) as any[]
    clang.assert.proc_body(compounds)
    const body = compounds[0]
    for (const stmt of body.inner) result.push(this.statement(stmt))
    return result
  }

  proc (toplevel: JsonObject): void {
    const result   = {} as any  /* astTF.Proc */
    result.isProto = !Array.isArray(toplevel.inner)
    result.pure    = false  // FIX: Take from `__attribute__((const))`
    result.name    = toplevel.name
    if (result.isProto) return;  // (this.result as any[]).push(result)
    echo("....... parser.proc  ...")
    // Parse Arguments & Body
    result.args = this.proc_args(toplevel)
    result.body = this.proc_body(toplevel)
    // Add to the AST
    // (this.result as any[]).push(result)
  }

  process(): void {
    this.result.data.source = this.entry.SourceInfo.code
    for (const toplevel of this.nodes) {
      clang.assert.node_implemented(toplevel)
      switch (toplevel.kind) {
        case clang.id.Function: this.proc(toplevel); break;
        default: throw new Error(`Unknown clang.TopLeven.Kind: \`${toplevel.kind}\`. Might not be implemented yet.`)
      }
    }
  }
}

} //:: clang

