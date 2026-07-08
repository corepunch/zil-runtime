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

## Outputs
- Updated transcripts
- Bug ledger by category
- Fix changelog

## Acceptance Checks
- Golden path is completable end-to-end.
- No known softlocks unless intentionally documented.
- Reasonable commands no longer fail silently or generically.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 8
- `WRITING_ADVENTURES.md`: Testing Your Adventure
