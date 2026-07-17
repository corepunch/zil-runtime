# Agent Guidance

Start with [ARCHITECTURE.md](ARCHITECTURE.md). It is the canonical high-level summary of how this repository is structured.

## Fast Orientation

- Entry point for interactive play: [main.lua](main.lua)
- Loader and require integration: [zilscript/base.lua](zilscript/base.lua) and [zilscript/init.lua](zilscript/init.lua)
- Runtime environment and module execution: [zilscript/runtime.lua](zilscript/runtime.lua)
- Parser: [zilscript/parser.lua](zilscript/parser.lua)
- Compiler pipeline: [zilscript/compiler](zilscript/compiler)
- Test orchestration: [Makefile](Makefile)
- Generic pure-ZIL test runner: [run-zil-test.lua](run-zil-test.lua)

## Working Rules For Agents

1. Read [ARCHITECTURE.md](ARCHITECTURE.md) before changing loader, runtime, parser, compiler, or content-loading behavior.
2. Prefer the narrowest layer that actually controls the behavior under change.
3. For compiler issues, start in the most specific emitter or lowering module under [zilscript/compiler](zilscript/compiler).
4. For content or gameplay issues, inspect the relevant adventure folder under [infocom](infocom) or [books](books) before changing engine code.
5. When debugging ZIL-related failures, prefer adding temporary `TELL`/print commands directly in the relevant ZIL routines to expose values, branch choices, and object locations while narrowing the problem. Remove or clearly quarantine this instrumentation before finishing unless it is intentionally part of a test.
6. Validate with the smallest relevant target from [Makefile](Makefile); for broad gameplay regressions, use `make test-pure-zil`.

## Playing Games

To play a game programmatically (e.g. to test playability or run a walkthrough), see [PLAYING.md](PLAYING.md). It documents `llm.lua` for one-command-at-a-time game interaction.

## Writing Adventures

To create a new ZIL adventure from premise through release, invoke the **@game-writer** subagent:
```
@game-writer Design, implement, test, and release a ZIL adventure about <your-premise-here>.
```
It orchestrates all eight stages (design docs → working materials → puzzle architecture → prose → ZIL implementation → testing → hint UX → packaging) into a single agent workflow. Each stage loads a corresponding skill (e.g. `skill foundation-and-premise`) for detailed guidance.

## Available Skills

The `.opencode/skills/` directory provides stage-specific skills loadable with the `skill` tool:

| Skill | Use When |
|-------|----------|
| `skill foundation-and-premise` | Defining premise, tone, and design doc |
| `skill working-materials` | Building MAP, OBJECTS, PUZZLES, STORY_STATE, TRANSCRIPT_TESTS |
| `skill world-model` | Validating puzzle fairness, parser vocabulary, softlock prevention |
| `skill content-writing` | Writing prose, NPC dialogue, layered hints |
| `skill zil-implementation` | Writing dungeon.zil, actions.zil, critical implementation rules |
| `skill testing` | Running transcripts, persistence tests, walkthrough hardening |
| `skill workflow-hints` | Review passes, hint UX, iteration planning |
| `skill packaging` | Release artifacts, definition of done |

## Current Repo Notes

- Imported Infocom materials are vendored as regular folders, not git submodules.
- Skills and staged adventure-building guidance live under [skills](skills).
- The root [ARCHITECTURE.md](ARCHITECTURE.md) file is intended to be the first-stop overview for future agent runs.
