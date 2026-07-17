---
name: zil-implementation
description: Implement game logic in ZIL with clean dungeon.zil / actions.zil split, clock daemons, and the critical rules that prevent compilation and gameplay bugs
---

Implement game logic in ZIL with clean split between world data and routines.

## Inputs
- All prior stage outputs

## Required Actions
1. Implement `dungeon.zil` for rooms, objects, and declarative world data.
2. Implement `actions.zil` for routines, daemon/clock behavior, and `GO`.
3. Implement an executable walkthrough entry.
4. Use the engine include chain consistently.
5. Apply advanced ZIL patterns where needed (GLOBAL objects, PSEUDO, FDESC/LDESC, PER exits, dynamic descriptions, transformations, daemons).
6. Implement one playable vertical slice at a time. After each room, object, puzzle, or NPC interaction, play its exact transcript through `llm.lua` before adding the next slice.
7. Grow a parser-driven walkthrough test alongside implementation.

## Outputs
- `dungeon.zil`
- `actions.zil`
- `walkthrough.zil`
- Parser-driven walkthrough test under `tests/`

## Acceptance Checks
- Parser/object/room routines compile and run.
- Puzzle state changes are explicit and traceable.
- Dynamic text and clock events are deterministic enough to test.
- Exact transcript noun phrases parse before and after a save/reload boundary.
- Each completed slice is reachable from a fresh game.

## Critical Implementation Rules

### 0. Never redefine V-LOOK or standard SYNTAX
The substrate (`infocom/zork1/`) provides V-LOOK and the standard SYNTAX definitions.

### 0a. Make parser vocabulary explicit
Object IDs and `DESC` strings are not automatically usable nouns. Every player-reachable object needs explicit SYNONYM and ADJECTIVE entries.

### 0b. Make containers reveal reachable contents
A printed "open" response is not enough. The world model must change — set `OPENBIT`, move contents inside.

### 0c. Guard one-time story progress
If TAKE, READ, and EXAMINE can all reveal a clue, route them through one guarded transition.

### 0d. Implement ASK/TELL topics for this substrate
`ASK ACTOR ABOUT TOPIC` and `TELL ACTOR ABOUT TOPIC` both reach the actor with `PRSA = V?TELL`. Test `<VERB? TELL>` and inspect `PRSI`.

### 0e. Never redispatch the same action from its default verb routine
`PERFORM` already dispatches. A default routine must produce the fallback, not call PERFORM again.

### 0f. Audit parser registration separately from action routines
A `V-USE` routine does not make the typed verb parse. Add SYNTAX declarations for genuinely new verbs.

### 0g. Keep puzzle instructions, implementation, and tests identical
For every ordered puzzle, maintain one canonical sequence and copy it exactly into clues, hints, and walkthrough.

### 0h. Treat titles as modifiers in multiword NPC names
Put the head noun in SYNONYM and titles in ADJECTIVE.

### 0i. Represent physical world state with objects, not flag-only scenery
Doors, windows, drawers, switches, ropes, vehicles, gates, and containers must be real objects.

### 1. Don't embed item descriptions in room descriptions
Room LDESC should describe the space. Objects describe themselves via FDESC/LDESC/DESCFCN.

### 2. Every `<TELL>` must close with `>` before the next form
Missing `>` is the most common and hardest-to-spot bug.

### 3. Define `ROUTINE GO ()` in actions.zil
The game entry point must exist. Set up HERE, LIT, WINNER, PLAYER, call V-LOOK, call MAIN-LOOP.

### 4. Custom SYNTAX uses `= V-ROUTINE`
Only add syntax for verbs absent from the substrate. Search `infocom/zork1/syntax.zil` first.

### 5. Bracket balance: every `<` needs a matching `>`

### 8. Custom V-GO direction handlers must mirror every conditional exit
Every conditional exit declared on a room must be replicated inside the matching V-GO routine.

### 9. NPCs and named objects need generous, overlap-tested vocabulary
Give every NPC role-based synonyms, title adjectives, and ARTICLEBIT.

### 10. No two objects in overlapping scope may share a DESC
Give every object a unique DESC text and distinct ADJECTIVE.

### 11. Dynamic room descriptions must faithfully reflect object state

### 12. NPC-given items must not be freely TAKE-able before the NPC offers them

### 13. Pronoun resolution with THIS-IS-IT
After any TELL that names an object, call THIS-IS-IT so the player can refer to it by pronoun.

### 14. Autonomous NPC movement with clock daemons

### 15. Mechanical stateful clock daemons
Every mechanical clock daemon must have visible feedback at each stage threshold and interact with EXAMINE on relevant objects.

## Reference Sources
- `skills/source_zil_text_adventure_agents.md`: section 4
- `skills/source_writing_adventures.md`: Game Structure, ZIL Syntax Reference, Advanced Techniques, Complete Example
