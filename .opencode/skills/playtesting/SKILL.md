---
name: playtesting
description: Run organic play-throughs with @game-tester, collect bug reports, and prepare the bug ledger for the fixing stage
---

Run organic play-throughs with the game-tester agent, collect structured bug reports, and prepare the bug ledger for the next stage.

## Inputs
- Complete adventure source (`dungeon.zil`, `actions.zil`)
- Existing test suite (`test/`)

## Required Actions

### 1. Invoke game-tester

Use the `task` tool to invoke `@game-tester` with a prompt like:

```
@game-tester Play-test the <adventure-name> adventure and generate a bug report.
```

The game-tester will:
- Start a fresh game
- Play organically (no source inspection during play)
- Explore all rooms, examine all objects, try interactions
- Test edge cases, wrong commands, state persistence
- Push toward the ending if reachable
- Generate `adventure-name-bugs.md` with categorized findings and regression tests

### 2. Review the bug report

Inspect the generated bug report. Game-tester categorizes bugs as:
- **Critical** — crashes, hangs, unreachable endings, broken core mechanics
- **High** — missing objects, broken puzzles, blocked progression, state corruption
- **Medium** — missing synonyms, wrong descriptions, weak error messages
- **Low** — cosmetic issues, missing scenery responses, minor verb gaps

### 3. Verify regression tests

For every file game-tester created under `test/`:
- Run `make test-pure-zil` to confirm the test runner picks them up
- If a test is a standalone Lua walkthrough, run it directly
- Confirm each regression test is RED against the current unfixed code (reproduces the bug)

### 4. Prepare the bug ledger

Create or update `test/TESTING.md` with:
- Link to the game-tester's full bug report
- Summary table of bugs by category
- Priority ordering for the fixing stage (fix critical/high first)
- For each bug: description, exact command, expected behavior, regression test path, and test status

## Outputs
- `adventure-name-bugs.md` (from game-tester)
- Updated `test/TESTING.md` with structured bug ledger
- Regression tests under `test/` (from game-tester)

## Acceptance Checks
- Game-tester completed a full organic play session
- Every bug has a corresponding regression test that is RED
- Bug ledger is prioritized and ready for the fixing stage
- No bugs were silently skipped — even low-severity items are logged

## Relation to Other Pipeline Stages

Playtesting comes after the packaging stage (Stage 8) as a final QA gate. Bugs found here are fed into the bug-fixing stage (Stage 10). After fixing, run playtesting again to confirm no regressions.

## Reference Sources
- `.opencode/agents/game-tester.md` — full game-tester agent definition and workflow
- `PLAYING.md` — how `llm.lua` works for automated game interaction
