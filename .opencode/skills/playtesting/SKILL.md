---
name: playtesting
description: Run blind functional play-throughs with @tester-game, collect player-visible evidence, and prepare functional regressions
---

Run blind functional play-throughs with the tester-game agent, collect structured bug reports, and prepare functional defects for remediation. Artistic judgment and audience/accessibility testing are separate passes coordinated by `skill quality-assurance`.

## Inputs
- Complete adventure source (`dungeon.zil`, `actions.zil`)
- Existing test suite (`test/`)

## Required Actions

### 1. Confirm tester-technical pre-flight

The tester-technical must complete its structural audit (prose-to-noun, vocabulary, exit matrix) before the tester-game begins. Review its report for any High-severity findings. Do not pass technical findings to the tester-game — its session must remain blind. If the technical report has unresolved High-severity structural defects, consider remediating them first so the tester-game's time is spent on emergent bugs rather than re-discovering known issues.

### 2. Invoke tester-game

Use the `task` tool to invoke `@tester-game` with a prompt like:

```
@tester-game Play-test the <adventure-name> adventure and generate a bug report.
```

The tester-game will:
- Start a fresh game
- Play organically (no source inspection during play)
- Explore all rooms, examine all objects, try interactions
- Test edge cases, wrong commands, state persistence
- Push toward the ending if reachable
- Generate `adventure-name-bugs.md` with categorized findings and regression tests

### 3. Review the bug report

Inspect the generated bug report. tester-game categorizes bugs as:
- **Critical** — crashes, hangs, unreachable endings, broken core mechanics
- **High** — missing objects, broken puzzles, blocked progression, state corruption
- **Medium** — missing synonyms, wrong descriptions, weak error messages
- **Low** — cosmetic issues, missing scenery responses, minor verb gaps

### 4. Verify regression tests

For every file tester-game created under `test/`:
- Run `make test-pure-zil` to confirm the test runner picks them up
- If a test is a standalone Lua walkthrough, run it directly
- Confirm each regression test is RED against the current unfixed code (reproduces the bug)
- Inspect the oracle, not just the color: issue `<CO-RESUME ...>` separately and assert a single observable postcondition. Reject tests that combine coroutine success and state checks as multiple `ASSERT` arguments.
- For silent-command bugs, assert state/location/inventory or expected text; coroutine resume success alone is not evidence that the verb worked.

### 5. Prepare the bug ledger

Create or update `test/TESTING.md` with:
- Link to the tester-game's full bug report
- Summary table of bugs by category
- Priority ordering for the fixing stage (fix critical/high first)
- For each bug: description, exact command, expected behavior, regression test path, and test status

## Outputs
- `adventure-name-bugs.md` (from tester-game)
- Updated `test/TESTING.md` with structured bug ledger
- Regression tests under `test/` (from tester-game)

## Acceptance Checks
- Tester-game completed a full organic play session
- Every reproducible functional bug requiring a regression has a corresponding RED test
- Bug ledger is prioritized and ready for the fixing stage
- No functional findings were silently skipped; subjective writing observations may remain report-only

## Relation to Other Pipeline Stages

Blind functional playtesting is one part of the post-packaging quality-assurance gate. Bugs found here are fed into the remediation stage. After fixing, rerun the affected focused scenarios and a fresh organic smoke pass.

## Reference Sources
- `.opencode/agents/tester-game.md` — full tester-game agent definition and workflow
- `.opencode/skills/quality-assurance/SKILL.md` — coordination with technical, artistic, and accessibility passes
- `PLAYING.md` — how `llm.lua` works for automated game interaction
