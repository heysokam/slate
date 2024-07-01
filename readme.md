# *Slate | StoS Compiler helper tools
`*Slate` is a [Source-to-Source compiler](https://en.wikipedia.org/wiki/Source-to-source_compiler) helper library for converting code into other languages.  


## Slate.Zig
> _TODO_  


## Slate.Nim
The tools provided can be used to convert the Nim AST into any language.  

### How to use
> _TODO: Example showcase of the API_  
> See the [MinC Compiler](https://github.com/heysokam/minc) implementation for a reference of how *Slate is used.  

### StoS Compiler -vs- Nim Backend Compiler
``` md
# Source-to-Source:
The target language owns the rules. All of them.
Conceptually, it's not running nim. It's running the target language.
The target language dictates how things should be written and structured.
The StoS compiler converts the syntax so that the target compiler understands them.
But in the end its the target language that dictates the rules of how the logic of an application is written.

# Nim Backend:
The backend does not run the target language, it runs Nim as a concept.
The target language is just the host that communicates to the computer how to run nim features.
But in the end its nim, not the target language, who dictates how the logic of an application is written
The backend compiler translates every feature of nim so that the backend lang understands what Nim is dictating it should do.
```

