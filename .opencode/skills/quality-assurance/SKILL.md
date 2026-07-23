---
name: quality-assurance
description: Coordinate independent technical, blind functional, artistic, and audience-accessibility release passes for a packaged ZIL adventure
---

Run four independent release perspectives and synthesize them without collapsing different kinds of evidence into one generic bug list.

## Inputs

- Completed Stages 1-8 of the adventure workflow
- Packaged playable build and current tests
- Declared genre, artistic intent, and target audience

## Pass Order

### 1. Technical release gate — `@technical-tester`

Invoke `@technical-tester` first. It may inspect source and design materials and must follow `skill testing`. Block later passes for crashes, startup failure, corrupted persistence, or an unreachable golden path. Lesser technical findings can proceed to the shared remediation ledger while review continues.

Expected output: `<game-name>-technical-report.md` plus focused RED regressions. The report must contain a complete room-exit matrix proving opposite-direction returns, including documented intentional one-way or non-Euclidean exceptions.

### 2. Blind functional playtest — `@game-tester`

Use a new agent context. The tester must follow the blindness boundary in `.opencode/agents/game-tester.md`; do not pass it technical findings, design rationale, source discoveries, or walkthrough knowledge before its organic findings are frozen.

**Information flow:** The technical-tester's report flows to the shared remediation ledger, not to the game-tester. The game-tester runs blind; it must discover issues through play rather than inherit known structural defects. After the game-tester's organic findings are frozen, its bug report is merged with the technical-tester's findings in `test/QUALITY.md`.

Expected output: `<game-name>-bugs.md` plus focused RED regressions for reproducible functional bugs.

### 3. Artistic review — `@artistic-tester`

Use another fresh context and follow `skill artistic-review`. Preserve its first-experience pass before it reads authored intent.

Expected output: `<game-name>-artistic-review.md`.

### 4. Audience-fit and accessibility — `@accessibility-tester`

Use a fresh context and follow `skill accessibility-testing`. Supply the declared target audience, not technical or artistic verdicts. Require independent fresh saves for its personas.

Expected output: `<game-name>-accessibility-review.md`.

## Synthesis

Create or update `test/QUALITY.md` with separate sections for:

- technical invariants and regressions;
- functional bugs and regressions;
- artistic findings and revision decisions;
- audience/accessibility barriers and persona evidence;
- cross-cutting findings observed independently by more than one pass;
- prioritized remediation owners and verification method.

Use these classes:

| Class | Typical evidence | Verification |
|-------|------------------|--------------|
| Technical defect | Failed invariant, state, test, or walkthrough | Automated regression |
| Functional play defect | Exact organic command/output and expected behavior | Parser-level regression |
| Artistic finding | Transcript evidence compared with stated intent | Targeted replay and editorial review |
| Accessibility barrier | Persona-specific stall or loss of operability/perceivability | Repeat persona scenario; regression only for stable mechanics |

Deduplicate shared root causes but retain each perspective's evidence. For example, a missing synonym may be one source fix with both a functional regression and an accessibility impact note.

## Release Decision

The QA gate is not complete until:

- critical/high technical and functional defects are fixed and GREEN;
- the golden path passes from a fresh save;
- every artistic `REVISE` finding has a documented revision or an explicit design decision;
- every material accessibility barrier has a mitigation, accepted limitation, or revised audience claim;
- affected specialist scenarios have been rerun after remediation.

After synthesis, invoke `skill bug-fixing` for code defects and the relevant authoring skill for artistic or accessibility revisions. Then run a short confirmation pass from every affected perspective.

## Anti-Patterns

- One context plays organically after already reading the walkthrough or design solution.
- A single severity table mixes crashes, pacing opinions, and access barriers without type or evidence.
- Trope counting substitutes for artistic judgment.
- “The walkthrough passes” substitutes for novice usability.
- Subjective preferences become brittle text regressions.
- Accessibility is reduced to easier puzzles or more hints.
