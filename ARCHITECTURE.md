# Architecture Overview

This repository is a Lua implementation of a ZIL toolchain and runtime for Infocom-style text adventures. It has two main responsibilities:

1. Parse and compile ZIL source into Lua.
2. Execute compiled adventures inside a controlled game environment.

## System Shape

The codebase is organized around four layers:

1. Frontend: parse ZIL source into an AST.
2. Compiler: transform the AST into Lua code.
3. Runtime: create a game environment, load compiled modules, and run `GO()`.
4. Content and tests: adventures, walkthroughs, and regression suites written in ZIL and Lua.

## Main Entry Paths

### Interactive game path

The standard interactive entrypoint is [main.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/main.lua). It:

1. Creates a game environment with [zilscript/runtime.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/runtime.lua).
2. Loads bootstrap support into that environment.
3. Installs ZIL module loading with `env.require("zilscript")`.
4. Loads an ordered module list such as `infocom.zork1.globals`, `infocom.zork1.parser`, `infocom.zork1.actions`, and `infocom.zork1.main`.
5. Starts the game coroutine and resumes it on each line of terminal input.

This means game startup is module-order sensitive. Shared globals and parser verbs must be loaded before the adventure `main` module.

### Require-based loading path

The `require "zilscript"` path is enabled by [zilscript/init.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/init.lua), which delegates to [zilscript/base.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/base.lua). That layer:

1. Derives `package.zilpath` from `package.path`.
2. Installs a searcher that resolves module names to `.zil` files.
3. Parses and compiles `.zil` on demand.
4. Loads the generated Lua chunk into the current Lua process.
5. Optionally saves generated `.zil.lua` files when `save_lua` is enabled.

This is the simplest path for tools and tests that want Lua-style module semantics over ZIL sources.

## Core Runtime Architecture

[zilscript/runtime.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/runtime.lua) is the execution orchestrator.

### Environment model

`create_game_env()` builds a sandbox-like table containing:

- Lua standard facilities needed by compiled code.
- A per-environment `_LOADED` cache.
- A per-environment `require` implementation.
- Source-map translation support for runtime errors.

This matters because modules are loaded into the environment table, not directly into the host global scope. That makes test runs and game runs more isolated and predictable.

### Module loading rules

`create_env_require(env)` prefers `.zil` over `.lua` when the ZIL loader is installed into that environment. The flow is:

1. Resolve module name to a file path.
2. Parse and compile `.zil` modules, or read `.lua` modules directly.
3. `load(..., env)` to execute the chunk inside the game environment.
4. Cache the result in `env._LOADED`.

### Game execution

`create_game(env)` wraps `GO()` inside a coroutine. The interactive loop in [main.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/main.lua) repeatedly resumes that coroutine with player input. This is the seam between the engine and UI.

## Compiler Architecture

The compiler lives under [zilscript/compiler](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler). It uses a small-pieces design instead of a monolithic emitter.

### Pipeline

1. [zilscript/parser.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/parser.lua) parses source text into AST nodes.
2. [zilscript/compiler/init.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/init.lua) coordinates compilation.
3. [zilscript/compiler/print_node.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/print_node.lua) walks the AST.
4. Specialized modules emit Lua for values, forms, object fields, and top-level declarations.
5. The compiler returns `declarations`, `body`, `combined`, and diagnostics.

### Important compiler modules

- [zilscript/compiler/value.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/value.lua): identifier and literal conversion.
- [zilscript/compiler/forms.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/forms.lua): special-form lowering such as `COND`, `SET`, and looping constructs.
- [zilscript/compiler/toplevel.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/toplevel.lua): `ROUTINE`, `OBJECT`, and `ROOM` compilation.
- [zilscript/compiler/fields.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/fields.lua): object and room property emission.
- [zilscript/compiler/buffer.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/buffer.lua): output buffering and indentation.
- [zilscript/compiler/diagnostics.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/diagnostics.lua), [zilscript/compiler/checker.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/checker.lua), and [zilscript/compiler/visitor.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler/visitor.lua): optional semantic analysis support.

### Design intent

The compiler is designed to keep parsing, lowering, and diagnostics loosely coupled. For changes to emitted Lua, start in the most specific emitter module rather than editing the parser or runtime first.

## Source Mapping And Error Translation

[zilscript/sourcemap.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/sourcemap.lua) translates generated Lua failures back to ZIL source locations. Both the loader path and runtime execution path use source-map translation, so debugging should usually be done from the ZIL source location that appears in errors, not from generated `.zil.lua` output.

## Game Content Layout

The repository contains both engine code and adventure content.

### Engine and framework

- [zilscript](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript): parser, compiler, runtime, bootstrap, source maps.
- [tests](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/tests): Lua-based unit tests and support scripts.
- [run-zil-test.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/run-zil-test.lua): generic ZIL test runner.

### Adventure content

- [infocom/zork1](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/infocom/zork1): canonical imported Zork I content and Zork-related tests.
- [books/blackwood-horror](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/books/blackwood-horror): local adventure content and its test walkthroughs.
- [infocom](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/infocom): other imported Infocom sources kept as regular folders, not submodules.

In practice, the engine expects adventures to be modularized into load-order-sensitive files such as globals, parser, verbs, actions, syntax, dungeon, and main.

## Testing Architecture

The repo uses three distinct testing styles:

### Lua unit tests

Files under [tests](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/tests) validate parser, compiler, runtime, source mapping, and support behavior directly from Lua.

### Pure ZIL regression tests

[run-zil-test.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/run-zil-test.lua) bootstraps the runtime, loads a ZIL module, invokes `GO()`, and reports `ASSERT` output. This is the main regression mechanism for parser/runtime/game behavior.

### Walkthrough integration tests

Adventure walkthrough files under the game folders exercise end-to-end behavior. These catch state-flow issues, parser mismatches, and softlocks better than unit tests alone.

### Test orchestration

[Makefile](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/Makefile) is the canonical test entrypoint. `make test-pure-zil` is the fastest repo-specific confidence check for ZIL behavior changes.

## Extension Points For Agents

When modifying this repo, these are the main seams to target:

- Loader behavior: [zilscript/base.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/base.lua)
- Runtime environment and module execution: [zilscript/runtime.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/runtime.lua)
- Syntax parsing: [zilscript/parser.lua](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/parser.lua)
- Code generation: [zilscript/compiler](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/zilscript/compiler)
- Game behavior and content: adventure folders under [infocom](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/infocom) and [books](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/books)

Recommended edit strategy:

1. Find the failing behavior in the narrowest layer first.
2. Prefer changing the most local compiler/runtime/content module that actually decides the behavior.
3. Validate with the smallest matching test target from [Makefile](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/Makefile).

## Current Operational Notes

- `main.lua` currently loads Zork I modules and leaves the horror book commented out.
- The runtime supports saving generated `.zil.lua` files for debugging, but these are not source of truth.
- Imported Infocom directories are vendored directly in the repository rather than managed as git submodules.
- Skills and adventure-process guidance live under [skills](/Users/ICHERNA/Developer/adventure-arena/External/zilscript/skills).

## Minimal Mental Model

If you only need the shortest useful model for this repo, use this:

1. ZIL source is parsed into an AST.
2. The compiler lowers that AST into Lua.
3. The runtime executes the Lua inside a game environment.
4. Adventures are loaded as ordered modules.
5. `GO()` is the gameplay entrypoint.
6. `make test-pure-zil` is the primary behavior regression check.