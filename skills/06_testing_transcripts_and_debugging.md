# Skill 06: Testing, Transcripts, And Debugging

## Goal
Prove completion path, catch regressions, and close parser/content gaps.

## Inputs
- Implemented ZIL files
- `TRANSCRIPT_TESTS.md`

## Required Actions
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

## Outputs
- Updated transcripts
- Bug ledger by category
- Fix changelog

## Acceptance Checks
- Golden path is completable end-to-end.
- No known softlocks unless intentionally documented.
- Reasonable commands no longer fail silently or generically.
- Repeated confusion points are captured and mapped to parser/content/hint fixes.
- Transcript suite covers both mastery path and assisted path.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 8
- `WRITING_ADVENTURES.md`: Testing Your Adventure
