\*Slate \| StoS Compiler helper for Nim
=======================================

| ``*Slate`` is a `Source-to-Source
  compiler <https://en.wikipedia.org/wiki/Source-to-source_compiler>`__
  helper library for converting Nim code into other languages.
| The tools provided can be used to convert the Nim AST into any
  language.
| Its current complete compiler goals are ``minc`` and ``wgsl``
  generation.

Current state
-------------

| Probably not too useful yet, compared to just working with PNodes
  directly.
| The library has some very useful functions, but the abstraction is
  -very- thin.
| A proper ergonomic IR system with objects needs to be well thought out
  before this lib can be its own thing.

| Until that day, please take reference from the `MinC
  Compiler <https://github.com/heysokam/minc>`__ implementation.
| It uses this same API, but it has a lot more features built on top.

StoS Compiler -vs- Nim Backend Compiler
---------------------------------------

.. code:: md

   # Source-to-Source:
   The target language owns the rules. All of them.
   Conceptually, it's not running nim. It's running the target language.
   The target language dictates how things should be written and structured.
   The StoS compiler just converts the syntax so that the target compiler understands them.
   But in the end its the target which dictates the rules of how the logic of an application is written.

   # Nim Backend:
   The backend is not really running the target language, it is running Nim as a concept.
   The target language is just the host that communicates to the computer how to do things.
   But in the end its nim, not the backend, who dictates how the logic of an application is written
   The backend compiler translates every feature of nim so that the backend lang understands what Nim is dictating it should do.

--------------

.. code:: md

   # Notes
   https://github.com/haxscramper/hnimast
