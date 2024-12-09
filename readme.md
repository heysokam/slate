# *Slate | StoS Compiler helper tools
`*Slate` is a [Source-to-Source compiler](https://en.wikipedia.org/wiki/Source-to-source_compiler) helper library
for converting the **syntax** of one language into other languages.  


## Slate.MiniM
Tools to convert the Nim-like syntax used by [MiniM](https://github.com/heysokam/minim) into any language.  


## Slate.Zig
> _TODO_  


## Slate.Nim
_(deprecated: Will be removed in favor of the MiniM syntax above)_  
Tools to convert the _untyped_ Nim AST into any language.  


## How to use
> _TODO: Example showcase of the API_  
> In the meantime, see the [MiniM Compiler](https://github.com/heysokam/minim) for a reference of how *Slate is used.  

## Technical Notes
### StoS Compiler -vs- Compiler Backend
```md
# Source-to-Source:
The target language owns the rules. All of them.
Conceptually, it's not running the source lang. It's running the target lang.
The target dictates how things should be written and structured.
The StoS compiler converts syntax so that the target compiler understands them.
But in the end its the target language that dictates every rule of how the logic is written.

# Compiler Backend:
The backend does not run the target language, it runs the source language as a concept.
The target language is just the host that communicates to the computer how to run the source language.
But in the end its the source lang, not the target lang, who dictates how the logic is written.
The compiler backend translates every feature of the source lang
so that the backend/target lang understands what the source is dictating it should do.

# Translation
## Backend
The compiler backend must convert the source concepts/expressions
such that the target understands and executes them as the source intended them.
## StoS
The compiler converts the source -syntax- into the target syntax.
```

#### Summary
```md
# StoS
The target owns the rules.
The source must respect them.

# Backend
The source owns the rules.
The target communicates instructions to the computer,
and does not own the source rules.
```

