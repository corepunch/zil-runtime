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

## Outputs
- Updated puzzle dependency graph
- Object/verb response matrix
- Softlock mitigation list

## Acceptance Checks
- No puzzle depends on inaccessible prerequisites.
- Reasonable command attempts have authored responses.
- Defaults are overridden where narrative/puzzle intent requires.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 3, 4, 5
- `WRITING_ADVENTURES.md`: Part I sections 2, 3, Suggested Build Order
