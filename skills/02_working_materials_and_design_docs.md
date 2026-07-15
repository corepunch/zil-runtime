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
7. Add an opening-scene spec to `DESIGN.md`/`MAP.md` (landmark, object, blocker, first reward).
8. Annotate `MAP.md` with hubs, loops, landmarks, and any one-way/non-Euclidean transitions.
9. Tag each important object with at least two roles: practical use, clue, worldbuilding, joke, risk, score marker.
10. Record at least one alternate or fallback approach for major puzzles when feasible.
11. Add explicit unwinnable-state prevention notes to puzzle and state docs.
12. Define progress structure (score/chapter/rank/objective milestones) in `STORY_STATE.md`.
13. Add co-play and discussion surfaces (shared vocabulary, parent hints, printable notes/log prompts).
14. Treat `TRANSCRIPT_TESTS.md` as an exact command contract, not pseudocode. For every critical step record:
    - exact typed command, including spaces or hyphens;
    - expected room/object output;
    - required noun synonyms and adjectives;
    - state change and inventory/location change;
    - a likely alternate wording and wrong-order attempt.
15. Keep `OBJECTS.md` parser-facing: list the canonical head noun, exact compound spelling, adjectives, ambiguity risks, containment flags, and discovery command for every object.
16. Populate `OBJECTS.md` from every concrete noun promised by room prose, blocked exits, and puzzle responses. Do not list a door, window, drawer, switch, rope, vehicle, gate, or container only in `STORY_STATE.md` as a Boolean; give the physical entity its own object row and reserve globals for supplementary or abstract state.

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
- Geography is mostly mappable and room naming is consistent enough for player notes.
- Opening setup is concrete and testable in under one minute of play.
- Object and puzzle docs support both mastery play and hint-assisted completion.
- Every golden-path command is valid player input rather than an internal object ID or direct `PERFORM` shorthand.
- Every noun in the opening slice has an explicit parser-vocabulary plan before ZIL implementation begins.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 1, sections 2.3-2.4, section 5.3
- `WRITING_ADVENTURES.md`: Working Materials section
