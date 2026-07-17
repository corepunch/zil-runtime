---
name: testing
description: Execute golden-path transcripts, wrong-attempt testing, save/reload persistence checks, and harden the automated parser-driven walkthrough
---

Prove completion path, catch regressions, and close parser/content gaps.

## Inputs
- Implemented ZIL files
- `TRANSCRIPT_TESTS.md`

## Required Actions
0. Begin this loop during Stage 5 after the first playable room; Stage 6 expands and hardens it rather than starting it.
1. Execute golden-path transcript.
2. Execute wrong-attempt transcripts and confirm quality responses.
3. Run room checklist commands and object checklist commands.
4. Categorize failures (parser/disambiguation/synonym/state/softlock/etc.).
5. Fix and retest until transcript suite is stable.
6. Validate interactions between timed systems and global mechanics.
7. For each major puzzle, test at least ten likely player commands and verify top attempts have useful responses.
8. Run unwinnable-state probes (missed objects, irreversible actions, timer pressure) and document mitigation behavior.
9. Verify danger telegraphing appears before lethal or high-cost consequences.
10. Add transcript cases for playful/silly inputs to validate tone-preserving parser feedback.
11. Verify hint escalation triggers only after repeated failure.
12. Run the game through `llm.lua` one command per process using the same save file.
13. For every new room or puzzle, run a fresh-game micro-playthrough before implementing the next slice.
14. Promote each passing slice into an automated parser-driven walkthrough.
15. Test one-time events with TAKE/READ/EXAMINE repeated and reordered.
16. Test every opened container by taking its contents in the next process invocation.

## Play-As-You-Build Loop

```bash
SAVE=/tmp/adventure-slice.sav
lua5.4 llm.lua --new-game --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "go north" --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "examine reading-desk" --save "$SAVE" --game adventure-name
```

Testing has three complementary layers:
1. Direct ZIL assertions prove routines and state transitions.
2. Focused `llm.lua` sequences prove parser and cross-process persistence.
3. A full automated golden path proves the shipped game from fresh start to win.

## Executable Walkthrough Contract
- A module run by `run-zil-test.lua` must load its prerequisites and expose `RUN_TEST`.
- Prefer a parser-driven `tests/test_<adventure>_walkthrough.lua` for the release golden path.
- Add a `make test-<adventure>-walkthrough` target.

## Outputs
- Updated transcripts
- Parser-driven automated walkthrough and Make target
- Bug ledger by category
- Fix changelog

## Acceptance Checks
- Golden path is completable end-to-end.
- No known softlocks unless intentionally documented.
- Reasonable commands no longer fail silently or generically.
- Golden path passes from a fresh game with every action crossing a save/reload boundary.
- The exact documented compound nouns, conversation topics, and custom verbs parse successfully.

## Reference Sources
- `skills/source_zil_text_adventure_agents.md`: section 8
- `skills/source_writing_adventures.md`: Testing Your Adventure
