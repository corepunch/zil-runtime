---
name: world-model
description: Translate design docs into a coherent simulation plan — validate puzzle fairness, audit parser vocabulary, and prevent softlocks before writing ZIL
---

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
9. Audit physical nouns against the object registry. Every described fixture or obstacle that affords player actions must be a real object with vocabulary, scope, flags, and behavior; do not substitute a global Boolean for a door, window, container, switch, vehicle, or similar world entity.

## Infocom-Quality Simulation Checks
- Build a command matrix for each major puzzle with at least ten likely player attempts; implement useful responses for the top attempts.
- Ensure common parser verbs and synonyms are covered (`look`, `examine`, `open`, `close`, `take/get`, `drop`, `read`, `put`, `unlock`, `attack`, `listen`, `smell`, `wait`, `again`, inventory shortcuts).
- Keep the puzzle challenge in idea-space, not wording-space; avoid single exact-verb bottlenecks.
- Ensure world state is physical and persistent (object movement, room state changes, blocked/unblocked routes, timed hazards).
- Prefer object state (`OPENBIT`, containment, location, visibility) over parallel global state. Use globals for abstract facts and milestones, or to supplement a real object when the substrate lacks a specific state such as `LOCKEDBIT`.
- Preserve challenge while reducing accidental cruelty (telegraphed danger, recoverable mistakes, explicit unwinnable-risk handling).
- Prefer meaningful mazes over filler mazes; if maze-like areas exist, provide landmarks or distinct mechanics.
- Support optional mastery with alternate/risky/clever solutions where feasible.

## Outputs
- Updated puzzle dependency graph
- Object/verb response matrix
- Softlock mitigation list

## Puzzle Artistry: Good vs. Bad Patterns

### 1. Puzzles Should Be the Story, Not Reskinned Item Gates
Replace "find key → unlock door" with: performing a ritual, understanding a character's history, arranging objects in a pattern, choosing the right moment, or demonstrating a quality the story values.

### 2. Narrative Arc: Three Escalating Acts
Structure your game in three acts with clear threshold moments. Each act should have a different dominant challenge type (exploration → deduction → confrontation).

### 3. Room Cohesion: A Real Place, Not a Trope Checklist
Every room must either (a) subvert its apparent function, or (b) be visible/audible from at least one other room.

### 4. World State Must Change After Thresholds
Every major story event must change at least 2 existing rooms — either through updated dynamic descriptions (ACTION + M-LOOK), changed object states (FCLEAR flags), or new objects appearing.

### 5. NPC Autonomy: Characters That Move Through the World
An ACTORBIT object must have at least one autonomous behavior (movement, approach, state change) driven by a clock daemon.

### 6. Object Interaction Depth: Tool Chains and System Combinations
At least 2 major puzzles must require chaining 3+ objects or considering an object's state (hot/cold, charged/drained, wet/dry) as a puzzle variable.

### 7. Clock-Driven Mechanical Depth: Systems That Simulate, Not Just Decorate
Every clock daemon must do at least one of: (a) advance a numerical state that has gameplay consequences, (b) cause autonomous NPC behavior, or (c) modify object state that another system reads.

## Acceptance Checks
- No puzzle depends on inaccessible prerequisites.
- Reasonable command attempts have authored responses.
- Defaults are overridden where narrative/puzzle intent requires.
- Navigation model supports player mapping and repeat travel without confusion.
- At least one long-loop puzzle requires carrying knowledge or objects between distant locations.
- The first vertical slice can be played with the exact planned commands before the next slice is implemented.
- Repeating TAKE/READ/EXAMINE or opening an already-open object cannot duplicate progress or strand contents.
- Every physical noun named in room prose or a blocked-exit message resolves to an object in scope and supports the obvious generic verbs.

## Reference Sources
- `skills/source_zil_text_adventure_agents.md`: sections 3, 4, 5
- `skills/source_writing_adventures.md`: Part I sections 2, 3, Suggested Build Order
