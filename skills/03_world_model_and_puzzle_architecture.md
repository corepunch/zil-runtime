# Skill 03: World Model And Puzzle Architecture

## Goal
Translate design docs into a coherent simulation plan before full implementation.

## Inputs
- `MAP.md`
- `OBJECTS.md`
- `PUZZLES.md`
- `STORY_STATE.md`

## Required Actions
1. Define parser-facing action model (verb, direct object, indirect object).
2. Validate object/room checklist coverage.
3. Validate puzzle fairness:
   - clear goal
   - discoverable information
   - guessable command vocabulary
4. Validate dependency graph and prevent softlocks.
5. Define default response strategy and custom overrides for likely wrong attempts.
6. Audit every planned noun phrase before implementation:
   - object identifiers and `DESC` do not automatically make words parseable;
   - the head noun belongs in `SYNONYM`;
   - modifiers belong in `ADJECTIVE`;
   - exact hyphenated transcript spellings belong in `SYNONYM` when supported;
   - two in-scope objects sharing a noun need distinguishing adjectives.
7. Define container visibility transitions: where contents begin, which action sets `OPENBIT`, and which flags let the parser search inside.
8. Define each one-time counter as `event flag -> guarded increment`, including which verbs can discover the same clue.

## Infocom-Quality Simulation Checks
- Build a command matrix for each major puzzle with at least ten likely player attempts; implement useful responses for the top attempts.
- Ensure common parser verbs and synonyms are covered (`look`, `examine`, `open`, `close`, `take/get`, `drop`, `read`, `put`, `unlock`, `attack`, `listen`, `smell`, `wait`, `again`, inventory shortcuts).
- Keep the puzzle challenge in idea-space, not wording-space; avoid single exact-verb bottlenecks.
- Ensure world state is physical and persistent (object movement, room state changes, blocked/unblocked routes, timed hazards).
- Preserve challenge while reducing accidental cruelty (telegraphed danger, recoverable mistakes, explicit unwinnable-risk handling).
- Prefer meaningful mazes over filler mazes; if maze-like areas exist, provide landmarks or distinct mechanics.
- Support optional mastery with alternate/risky/clever solutions where feasible.

## Outputs
- Updated puzzle dependency graph
- Object/verb response matrix
- Softlock mitigation list

## Acceptance Checks
- No puzzle depends on inaccessible prerequisites.
- Reasonable command attempts have authored responses.
- Defaults are overridden where narrative/puzzle intent requires.
- Navigation model supports player mapping and repeat travel without confusion.
- At least one long-loop puzzle requires carrying knowledge or objects between distant locations.
- The first vertical slice can be played with the exact planned commands before the next slice is implemented.
- Repeating TAKE/READ/EXAMINE or opening an already-open object cannot duplicate progress or strand contents.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 3, 4, 5
- `WRITING_ADVENTURES.md`: Part I sections 2, 3, Suggested Build Order
