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
17. Treat command transport and game-state verification as separate assertions. With the current ZIL runner, execute `<CO-RESUME ...>` as its own form, then use a single-condition `<ASSERT>` for the resulting location, inventory, flag, or output. Never write `<ASSERT "..." <CO-RESUME ...> <state-check>>`: `ASSERT` is not an all-conditions combinator, and an earlier truthy coroutine result can mask an unevaluated state check.
18. Add a default-verb smoke matrix for every object with an `ACTION` routine. Verify that unhandled verbs fall through: TAKE/DROP for `TAKEBIT` objects; OPEN/CLOSE/LOOK-IN/SEARCH for containers; and other obvious substrate verbs implied by flags.
19. Add a prose-to-world transcript pass: follow every direction named in room prose, examine every named fixture from the room where it is described, and type each player-facing head noun verbatim.
20. Test every conversation topic via parser commands in every room where the NPC interaction can occur; direct routine calls do not prove topic scope.
21. Test syntax variants separately when the parser has distinct grammar lines or flag gates, including bare versus prepositional forms such as `CLIMB BENCH` and `CLIMB UP BENCH`.
22. **Test description ownership through rendered output:** Capture `LOOK` on first entry, immediate repeat, after examining/taking/opening focal objects, and after every relevant state transition. Verify each feature is introduced once, remains spatially understandable, and never contradicts current state. A noun may appear briefly in room prose and still own a separate object line, but the two paths must not repeat the same facts.
23. **Audit `FDESC`/`NDESCBIT` combinations:** Treat an object with both as suspicious. Prove its `FDESC` is printed deliberately by code; otherwise the prose is dead and must move to the room/room action or the suppression flag must be removed.
24. **Test scenery affordances:** For every concrete noun in room or object prose, issue at least `EXAMINE <noun>` in the described scope. Use real, GLOBAL, grouped, or PSEUDO scenery rather than forcing every noun into an automatic `LOOK` line.
25. **Test untouched dynamic objects:** On this substrate, an untouched object's `FDESC` bypasses `DESCFCN`. For every object with `DESCFCN`, test a changed state before any command touches that object and ensure no static `FDESC` shadows the dynamic text.

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

For direct ZIL tests, keep each assertion atomic. A successful coroutine resume proves only that the command loop ran; it does not prove that the command parsed, printed useful output, moved the player, moved an object, or changed state.

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
- No test combines a coroutine resume and its postcondition as multiple arguments to `ASSERT`.
- Every object action routine has at least one test proving an unhandled generic verb still reaches the substrate default.
- Every room has rendered-output checks showing one coherent description owner per feature on first entry, repeat `LOOK`, and relevant post-state views.
- No intended automatic `FDESC` is silently suppressed by `NDESCBIT`, and no room-owned scenery noun is parser-dead.

## Reference Sources
- `skills/source_zil_text_adventure_agents.md`: section 8
- `skills/source_writing_adventures.md`: Testing Your Adventure
