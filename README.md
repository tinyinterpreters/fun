# FUN - Dynamic Scope

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

In this version of FUN, functions are **dynamically scoped** (for the lexically scoped version check out the [`lexical-scope`](https://github.com/tinyinterpreters/fun/tree/lexical-scope) branch). The runtime value that represents a function definition does not save the environment in which it was created. When the function is called, its free variables are looked up in the environment in which it was called.

For example:

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

evaluates to `16` and not `8`.

For a closer look at how first-class dynamically scoped functions work, read [FUN: First-Class Functions, Currying, and a Surprise](https://blog.tinyinterpreters.dev/posts/fun-first-class-functions/).

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
-- Ok (VNumber 16)
```
