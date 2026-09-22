# FUN - Lexical Scope

FUN extends [LET](https://github.com/tinyinterpreters/let) with first-class functions.

Functions are first-class citizens of the language since they are values that can be bound to names:

```txt
let
  identity =
    fun (x) x
in
(identity -(456, 123))
```

passed as arguments:

```txt
let
  applytwice =
    fun (f) (f (f 5))
in
let
  double =
    fun (x) -(x, -(0, x))
in
(applytwice double)
```

and returned as results:

```txt
let
  select =
    fun (n)
      if zero?(n) then
        fun (x) x

      else
        fun (x) -(x, 1)
in
((select 1) 8)
```

In this version of FUN, functions are **lexically scoped** (for the dynamically scoped version check out the [`dynamic-scope`](https://github.com/tinyinterpreters/fun/tree/dynamic-scope) branch). The runtime value that represents a function definition now saves the environment in which the function was created. This value is called a **closure**. When the function is called, the closure associated with that function provides the environment in which that function's free variables can be accessed.

So the following example:

```txt
let
  add =
    fun (a)
      fun (b)
        -(a, -(0, b))
in
let
  a = 11
in
((add 3) 5)
```

evaluates to `8` and not `16`.

For a closer look at how closures enable lexically scoped functions, read [FUN: Making Curried Functions Work in the Presence of Free Variables](https://blog.tinyinterpreters.dev/posts/fun-currying-free-variables).

## Explore

To explore this language on your own machine, you'll need [Nix](https://zero-to-nix.com/start/install/) with flakes enabled.

```bash
nix develop
elm repl
```

Then:

```elm
import FUN.Interpreter as I

I.run """
  let
    add =
      fun (a)
        fun (b)
          -(a, -(0, b))
  in
  let
    a = 11
  in
  ((add 3) 5)
"""
-- Ok (VNumber 8)
```
