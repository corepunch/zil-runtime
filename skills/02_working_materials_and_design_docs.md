# Skill 02: Working Materials And Design Docs

## Goal
Create the design artifacts that externalize world structure and puzzle logic.

## Inputs
- `DESIGN.md`

## Required Actions
1. Build `MAP.md` with room graph, blocked exits, and rationale.
2. Build `OBJECTS.md` with IDs, synonyms, flags, locations, puzzle role.
3. Build `PUZZLES.md` with goal, clue chain, wrong attempts, hint tiers, softlock prevention.
4. Build `STORY_STATE.md` with globals, counters, milestones.
5. Build `TRANSCRIPT_TESTS.md` with golden path and failure-path plans.
6. Keep a dungeon report/changelog for iterative memory.

## Outputs
- `MAP.md`
- `OBJECTS.md`
- `PUZZLES.md`
- `STORY_STATE.md`
- `TRANSCRIPT_TESTS.md`

## Acceptance Checks
- Every room has a role.
- Every puzzle has clue chain and reasonable-failure responses.
- Every critical state transition is represented in `STORY_STATE.md`.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 1, sections 2.3-2.4, section 5.3
- `WRITING_ADVENTURES.md`: Working Materials section
