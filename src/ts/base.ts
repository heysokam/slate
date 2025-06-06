//:___________________________________________________________________
//  *Slate  |  Copyright (C) Ivan Mar (sOkam!)  |  LGPLv3 or higher  :
//:___________________________________________________________________
import { spawnSync as std_exec } from 'node:child_process'
import { log as echo } from 'console'


//______________________________________
// @section Json Helper Tools
//____________________________
export const json_print = (data: any) => echo(JSON.stringify(data, null, 2))

export type JsonValue = string | number | boolean | null
export type JsonArray = Array<JsonValue | JsonObject>
export interface JsonObject {
  [key: string]: JsonValue | JsonObject | JsonArray
}


//______________________________________
// @section Command Helper Tools
//____________________________
export class Command {
  parts :string[]
  constructor(parts ?:string[]) {
    this.parts = []
    this.parts = parts || []
  }
  add(arg :string) { this.parts.push(arg) }
  run() { return std_exec(this.parts[0], this.parts.slice(1), {stdio: ["inherit", "inherit", "inherit"]}) }
  exec() { return std_exec(this.parts[0], this.parts.slice(1), {stdio: ["pipe", "pipe", "pipe"]}) }
}

