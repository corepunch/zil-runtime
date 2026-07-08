# Skill 05: ZIL Implementation Reference

## Goal
Implement game logic in ZIL with clean split between world data and routines.

## Inputs
- All prior stage outputs

## Required Actions
1. Implement `dungeon.zil` for rooms, objects, and declarative world data.
2. Implement `actions.zil` for routines, daemon/clock behavior, and `GO`.
3. Implement `walkthrough.zil` as executable test entry file.
4. Use the engine include chain consistently.
5. Apply advanced ZIL patterns where needed (GLOBAL objects, PSEUDO, FDESC/LDESC, PER exits, dynamic descriptions, transformations, daemons).

## Outputs
- `dungeon.zil`
- `actions.zil`
- `walkthrough.zil`

## Acceptance Checks
- Parser/object/room routines compile and run.
- Puzzle state changes are explicit and traceable.
- Dynamic text and clock events are deterministic enough to test.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 4
- `WRITING_ADVENTURES.md`: Game Structure, ZIL Syntax Reference, Advanced Techniques, Complete Example
