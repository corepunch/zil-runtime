# Skill 06: Testing, Transcripts, And Debugging

## Goal
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
11. Verify hint escalation triggers only after repeated failure, and that each tier preserves player dignity.
12. Run the game through `llm.lua` one command per process using the same save file. This is mandatory coverage for persistence, parser vocabulary, object location, flags, counters, and NPC movement.
13. For every new room or puzzle, run a fresh-game micro-playthrough before implementing the next slice.
14. Promote each passing slice into an automated parser-driven walkthrough; keep exact commands synchronized with `TRANSCRIPT_TESTS.md`.
15. Test one-time events with TAKE/READ/EXAMINE repeated and reordered; assert counters and rewards change once.
16. Test every opened container by taking its contents in the next process invocation.

## Play-As-You-Build Loop

Use this cadence for each vertical slice:

```bash
SAVE=/tmp/adventure-slice.sav
lua5.4 llm.lua --new-game --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "go north" --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "examine reading-desk" --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "take torn-page" --save "$SAVE" --game adventure-name
lua5.4 llm.lua --action "inventory" --save "$SAVE" --game adventure-name
```

Each line must succeed on its own. Check output for generic parser failures (`used the word`, `can't see`, `can't go`, unrecognized sentence), then try natural spaced/hyphenated variants and wrong order.

Testing has three complementary layers:

1. Direct ZIL assertions prove routines and state transitions.
2. Focused `llm.lua` sequences prove parser and cross-process persistence.
3. A full automated golden path proves the shipped game from fresh start to win.

Do not treat direct `<PERFORM ...>` calls as a substitute for typed-command coverage.

## Executable Walkthrough Contract

- A module run by `run-zil-test.lua` must load its prerequisites and expose `RUN_TEST`; defining only `GO` is not a runnable test for that harness.
- Prefer a parser-driven `tests/test_<adventure>_walkthrough.lua` for the release golden path. It should invoke `llm.lua` separately for each command, reject generic parser/scope/navigation failures, assert progress totals, and assert the win text.
- Add a `make test-<adventure>-walkthrough` target and include it in integration testing.

## Outputs
- Updated transcripts
- Parser-driven automated walkthrough and Make target
- Bug ledger by category
- Fix changelog

## Acceptance Checks
- Golden path is completable end-to-end.
- No known softlocks unless intentionally documented.
- Reasonable commands no longer fail silently or generically.
- Repeated confusion points are captured and mapped to parser/content/hint fixes.
- Transcript suite covers both mastery path and assisted path.
- Golden path passes from a fresh game with every action crossing a save/reload boundary.
- The exact documented compound nouns, conversation topics, custom verbs, and final accusation parse successfully.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 8
- `WRITING_ADVENTURES.md`: Testing Your Adventure
