# Generating `companion.zil`

## A Repeatable Authoring and Validation Process

This document explains how to add a companion choice layer to an existing ZIL
adventure. It covers discovery, play, choice design, implementation, validation,
and release evidence.

The companion API and file format are specified in
[COMPANION-ZIL.md](COMPANION-ZIL.md). This document answers a different
question: how do we produce a complete and trustworthy `companion.zil` for a
particular adventure?

For agent-assisted generation, invoke:

```text
@companion-author Generate, validate, and document companion coverage for <game-name>.
```

The agent definition is in
[`../.opencode/agents/companion-author.md`](../.opencode/agents/companion-author.md).

## The Short Version

Generating a companion is not a source-to-source conversion and not a single
playthrough. It is a coverage exercise:

1. Locate the adventure's entry point, sources, tests, walkthroughs, and load
   path.
2. Inventory rooms, exits, objects, puzzle state, NPC phases, hazards, and
   endings.
3. Play a clean golden path one parser command at a time.
4. Divide the adventure into **state families**: situations in which the useful
   choices are materially different.
5. Design candidate cards for each reachable state family.
6. Implement those cards in `companion.zil`, one vertical slice at a time.
7. Execute every card's hidden command through the real parser.
8. Replay meaningful routes using only numbered choices.
9. Test save/restore, restart, query purity, grouping, and fallback behavior.
10. Publish a coverage matrix and transcript evidence with the companion.

The shipped `companion.zil` is deterministic ZIL. An agent can help author and
test it, but no model, network call, or generated text is required at runtime.

## What Generation Produces

The preferred output is:

```text
<adventure-directory>/
├── companion.zil
├── companion/
│   ├── COVERAGE.md
│   └── TRANSCRIPTS.md
└── test/
    └── <repository-specific companion regression>
```

Use the repository's established test location and naming convention if it
differs. The four deliverables have distinct purposes:

| Deliverable | Purpose |
|---|---|
| `companion.zil` | The deterministic, state-aware candidate generator |
| `COVERAGE.md` | The rooms and state families inspected, implemented, and validated |
| `TRANSCRIPTS.md` | Exact commands, observed output, and choice-driven routes |
| Regression test | Automated checks for important visibility and transition rules |

Do not treat the implementation alone as proof of coverage. A plausible command
can still be unrecognized, ambiguous, blocked in the relevant state, or produce
misleading results.

## Core Concepts

### Candidate, selected card, and parser action

`companion.zil` emits a pool of **candidates**. The host ranks and selects a
small visible set:

- `--child` shows three cards and accepts only a numbered selection.
- `--story` shows up to five of the same candidates and also permits typing.

Child and story modes do not require separate authored trees. They use the same
candidate profile. The difference is presentation capacity and whether free
text input is allowed.

When a player selects a card, its hidden `COMMAND` is sent through the original
game parser. The parser and world model remain authoritative.

### State family

A room alone is not an adequate unit of coverage. Useful choices often change
after acquiring an item, learning a fact, moving an object, changing an NPC's
attitude, or starting a timed threat.

A practical state-family key is:

```text
room
+ story or puzzle milestone
+ relevant inventory
+ player knowledge
+ hazard or NPC phase
```

Only include distinctions that materially change the visible choices. For
example:

```text
Workshop door / unopened / no key / lock not diagnosed
Workshop door / known locked / no key or lockpick
Workshop door / known locked / lockpick carried
Workshop door / open
```

These are four useful state families even if the player stands in the same
room throughout.

### Authored coverage and fallback coverage

Automatic fallback suggestions keep an uncovered game operable. They do not
prove that the companion offers good narrative guidance or recognizes the
adventure's puzzle state.

Use these coverage statuses:

| Status | Meaning |
|---|---|
| `AUTHORED` | Explicit state-aware candidates exist |
| `VALIDATED` | Every important emitted command was executed in the matching state |
| `FALLBACK-REVIEWED` | No authored cards, but fallback output was inspected and accepted |
| `NOT-COVERED` | Reachable state needs companion work |
| `UNREACHABLE` | Source state cannot occur in normal play |
| `EXEMPT` | Deliberately omitted, with a recorded reason |

“The UI displayed something” is not equivalent to authored or validated
coverage.

## Before Starting

Read:

1. [`../ARCHITECTURE.md`](../ARCHITECTURE.md)
2. [`../PLAYING.md`](../PLAYING.md)
3. [`COMPANION-ZIL.md`](COMPANION-ZIL.md)
4. The target adventure's source, tests, walkthrough, and design materials

Record:

- Adventure name and directory
- Module passed to `--game`
- Game entry file and load order
- Existing `companion.zil`, if any
- Test runner and smallest relevant test target
- Known walkthroughs or transcript tests
- Save-file location used during exploration

Start from a clean game and keep generation saves outside committed content
unless they are intentional test fixtures.

## Stage 1: Resolve the Load Path

Before authoring choices, establish exactly how the adventure starts and how a
companion file is loaded.

Confirm:

1. The game runs in ordinary text mode.
2. Companion mode starts without an error.
3. The game module selected by `--game` is the expected module.
4. The companion file is loaded after the game objects and globals it reads.
5. An absent companion falls back cleanly instead of breaking startup.

Capture the opening output in `TRANSCRIPTS.md`. This gives later failures a
known-good baseline.

If the game does not currently load, stop companion authoring and report the
underlying adventure or loader defect separately.

## Stage 2: Build a Static World Inventory

Source inspection finds branches that one walkthrough will miss. Inventory the
adventure before drafting cards.

### Rooms and exits

For each room, record:

- Normal exits
- Conditional exits
- Door-backed exits
- One-way travel
- Vehicle or transport transitions
- Returns from special scenes
- Endgame or death transitions

### Objects and parser vocabulary

Record:

- Portable objects
- Containers and supporters
- Doors, switches, mechanisms, and readable objects
- Scenery that implies useful investigation
- Object synonyms and adjectives needed by hidden commands
- Objects whose availability or location changes

### State

Find the globals, flags, properties, and object locations that represent:

- Puzzle milestones
- Facts learned by the player
- Scores or chapter transitions
- NPC attitude, dialogue, or schedule phases
- Hazards and clocks
- Door, container, light, and power state
- Consumable resources
- Death, victory, and alternate endings

### Existing evidence

Collect:

- Walkthrough commands
- Transcript assertions
- Design puzzle dependencies
- Map and object documentation
- Known bugs and intentional parser limitations

This inventory is not yet the companion design. It defines the state space that
the design must account for.

## Stage 3: Play and Checkpoint a Golden Path

Use `llm.lua` as documented in [`../PLAYING.md`](../PLAYING.md). Send one
command per invocation so every observation has an exact preceding action.

Typical setup:

```bash
lua5.4 llm.lua \
  --game <game-name> \
  --new-game \
  --save /tmp/<game-name>-companion.sav

lua5.4 llm.lua \
  --game <game-name> \
  --action "look" \
  --save /tmp/<game-name>-companion.sav
```

During play:

- Use `look` after significant transitions.
- Use `inventory` after acquiring or losing an item.
- Examine objects named in prose.
- Attempt blocked actions before satisfying their condition.
- Preserve checkpoints before puzzle branches, hazards, and irreversible acts.
- Record the exact output that establishes knowledge.

The goal is not merely to finish. The golden path identifies the normal order
of discovery, the vocabulary that actually works, and useful places to branch
state-family testing.

## Stage 4: Create the State-Family Matrix

Turn the static inventory and play transcript into `companion/COVERAGE.md`.

A useful table is:

| Area | State family | Entry evidence | Desired support | Status | Validation |
|---|---|---|---|---|---|
| West of House | mailbox closed | new game | inspect, open, move | `AUTHORED` | transcript §1 |
| West of House | mailbox open, leaflet present | open mailbox | take/read, move | `VALIDATED` | test X |
| Cellar | dark, lamp absent | enter cellar | safety, retreat | `NOT-COVERED` | — |

For each row, answer:

1. How can the player enter this state?
2. What can the player reasonably know?
3. What immediate progress actions exist?
4. What investigation action reveals the next missing fact?
5. What movement actions should remain available?
6. Is there a danger or recovery action that must outrank everything else?
7. Can the state persist across save/restore?

Avoid a Cartesian explosion. Merge states whose candidate set and priority
would be the same. Split states whenever the useful or honest choice changes.

## Stage 5: Design the Candidate Worksheet

Draft candidates before encoding large routines. Each row should include:

| Field | Question |
|---|---|
| ID | Is it stable, unique, and specific? |
| Label | Does it express player intent in natural language? |
| Command | Does the parser accept this exact text? |
| Kind | Is it progress, investigation, interaction, experiment, return, or safety? |
| Group | Is it a scene action or movement? |
| Priority | Should it survive selection when the pool is crowded? |
| Condition | Is it true only when the action is relevant and honest? |
| Once/history | Should it remain visible after selection? |
| Learns | Does executing it establish player knowledge? |
| Expected result | What output or state transition validates it? |

Example:

| ID | Label | Command | Kind | Group | Condition |
|---|---|---|---|---|---|
| `yard.try-door` | Try the workshop door | `open workshop door` | investigate | scene | door untried |
| `yard.pick-lock` | Unlock it with the lockpick | `unlock workshop door with lockpick` | progress | scene | locked and lockpick carried |
| `yard.go-garden` | Follow the path into the garden | `north` | return/progress | move | north exit available |

### Labels and commands serve different audiences

The label is for the player:

```text
Listen at the workshop door
```

The command is for the parser:

```text
listen to workshop door
```

Do not expose parser awkwardness in the label. Do not put prose in the hidden
command.

### Scene actions and movement

Use two groups:

- `scene`: examine, manipulate, converse, read, wait, use inventory, and take
  context-specific action.
- `move`: traverse an exit, return to another area, enter or leave a scene.

This split keeps navigation from crowding out interaction while preserving an
escape route from exhausted scenes. Mark movement explicitly:

```zil
<CHOICE "yard.go-garden"
        "Follow the path into the garden"
        "north"
        ,CHOICE-RETURN
        40>
<CHOICE-DETAILS "group" "move">
```

Do not classify “open the door” as movement merely because it enables travel.
The actual traversal card belongs in `move`.

### Candidate richness

Author more candidates than the UI displays. A healthy story-mode state often
has:

- One likely progress action
- One investigation or information action
- One optional interaction or experiment
- One or two useful movements
- A safety action when danger is immediate

Child mode selects three from this same pool. Therefore its essential progress
or recovery action must rank highly enough to survive the smaller capacity.

### Spoiler control

A card must not use knowledge the player has not acquired. Prefer:

```text
Try the brass key
```

over:

```text
Use the workshop key
```

until the game has established what the key opens.

Failure can be a useful information action. Offering “Try the door” before the
player knows it is locked lets the game reveal the obstacle in its own voice.
Afterward, the card can change to “Look for another way inside.”

## Stage 6: Implement One Vertical Slice at a Time

Start with the opening room and the first small puzzle. For each slice:

1. Add state predicates.
2. Emit scene candidates.
3. Emit movement candidates.
4. Start the game in that state.
5. Inspect the visible child and story sets.
6. Select every card.
7. Add or update tests.
8. Mark the coverage row only after validation.

Then advance to the next room or milestone.

Vertical slices expose errors in API use, ranking, conditions, and hidden
commands before those errors are copied throughout the adventure.

Keep companion routines observational during candidate generation. They may
read game state and emit temporary candidate metadata, but must not advance
clocks, move objects, set story flags, or consume random numbers merely because
the UI refreshed.

## Stage 7: Validate Every Hidden Command

Never approve a command by inspection alone.

For every important candidate:

1. Reach the exact state in which the card appears.
2. Select the card through companion mode.
3. Capture the parser output.
4. Confirm the expected state transition or information.
5. Run `look` or `inventory` when needed to observe the result.
6. Verify the card disappears, changes, or remains appropriately afterward.

Record failures such as:

- Parser does not recognize the verb or noun
- Command becomes ambiguous
- Object is not visible in this state
- Action succeeds but the label promises something else
- Action reveals a spoiler
- Card persists after becoming irrelevant
- State changes correctly but the next useful card never appears

If the parser itself has a genuine defect, report and test it separately. Do
not silently modify the original adventure merely to make a proposed card work
when a valid existing command would suffice.

## Stage 8: Run Choice-Only Playthroughs

The defining accessibility test is whether a player can make meaningful
progress without typing.

Run at least:

### Child route

- Fresh game
- `--child`
- Numeric input only
- Verify exactly the available numbered choices are accepted
- Reach all required story milestones or explicitly record uncovered gaps
- Confirm no puzzle requires free text

### Story route

- Fresh game
- `--story`
- Numeric input only
- Confirm richer choice sets do not hide essential progress
- Inspect the balance between scene and movement groups

### Mixed story route

- Fresh game
- `--story`
- Alternate typed commands with selected cards
- Confirm typed exploration does not put companion logic into an unhandled
  state

Test at least one non-golden branch: wrong turn, optional object order,
backtracking, or a failed puzzle attempt. Companion support that works only
after the canonical walkthrough is too brittle.

## Stage 9: Persistence, Purity, and Edge Cases

### Save and restore

Save in states where choices depend on:

- Inventory
- An opened or moved object
- Learned information
- A selected-once card
- An NPC or clock phase

Restore and verify the same relevant candidate set appears.

### Restart

Restart must clear choice history and game-dependent companion state. Opening
cards should behave as they do in a brand-new process.

### Query purity

Refresh or query choices repeatedly without acting. Confirm:

- No turns pass
- No clocks fire
- No random outcome changes
- No object moves
- No score or story flag changes
- The returned set is stable for unchanged state

### Danger and dead ends

In timed or dangerous states:

- Safety choices outrank flavor.
- A retreat or recovery route remains visible when one exists.
- The card does not imply a safe action when the parser outcome is fatal.
- Unavoidable death or ending states are documented rather than disguised.

### Fallback boundaries

Temporarily inspect states without authored candidates:

- Are fallback moves valid?
- Is a useful scene action present?
- Does fallback expose internal object names or nonsensical verbs?
- Is the gap acceptable, exempt, or still `NOT-COVERED`?

## Stage 10: Editorial and Accessibility Review

After functional correctness, review the visible experience.

### Narrative quality

- Labels describe intentions, not parser syntax.
- Cards do not repeat the room prose verbatim.
- Choices vary in rhythm and purpose.
- Optional actions add atmosphere or character without displacing progress.
- Failure cards teach something or create a deliberate dramatic beat.

### Choice clarity

- Labels are distinguishable at a glance.
- Pronouns have an obvious referent.
- The outcome is not falsely guaranteed.
- Vocabulary suits the target age.
- Essential actions do not depend on subtle color, order, or prior parser
  knowledge.

### Group balance

- Scene and movement headings match the action type.
- A room with interesting content is not reduced to a list of exits.
- A room with exhausted content still offers useful movement.
- Story mode uses its extra capacity for meaningful richness, not duplicates.

### Spoilers and knowledge

- Labels use only established facts.
- A solution appears only after the intended clue or experimentation.
- Repeated failed actions evolve into a better hint where appropriate.
- A child-mode player receives enough support without the card narrating the
  entire solution in advance.

## Automated Testing Strategy

Automated tests should target logic that is costly or fragile to recheck
manually.

Recommended assertions:

- A key card appears when its condition becomes true.
- It does not appear before the player can know or perform it.
- It disappears or changes after success.
- Movement cards carry the `move` group.
- Essential child-mode actions survive the three-card selection.
- Story mode can expose additional candidates from the same pool.
- Repeated choice queries do not mutate adventure state.
- Save/restore preserves relevant visibility and history.
- Restart resets companion history.
- A choice executes the exact parser command expected.

Prefer parser-level transcript assertions plus separate state assertions. A
successful coroutine or function call alone does not prove the intended world
change occurred.

Use the smallest adventure-specific test target while iterating, then run the
broader relevant gates:

```bash
lua5.4 tests/test_companion.lua
make test-unit
make test-pure-zil
git diff --check
```

Not every adventure requires every broad target for a documentation-only
change, but a completed companion should exercise its own regressions and the
ordinary adventure tests.

## Coverage Report Template

Create `companion/COVERAGE.md` from this template:

```markdown
# <Adventure> Companion Coverage

## Summary

| Metric | Count |
|---|---:|
| Reachable rooms | 0 |
| State families | 0 |
| Authored | 0 |
| Validated | 0 |
| Fallback-reviewed | 0 |
| Not covered | 0 |
| Exempt | 0 |

## Matrix

| Area | State family | Entry evidence | Desired support | Status | Evidence |
|---|---|---|---|---|---|
| Opening | Initial state | New game | investigate, progress, movement | NOT-COVERED | — |

## Known Gaps

- None, or list each reachable unsupported state and its player impact.

## Exemptions

- None, or explain why each state does not need authored support.
```

Counts make incomplete work visible. Descriptions make it resumable by another
author or agent.

## Transcript Evidence Template

Create `companion/TRANSCRIPTS.md` from this template:

```markdown
# <Adventure> Companion Validation Transcripts

## Environment

- Date:
- Revision:
- Lua version:
- Game module:
- Mode:

## Scenario: <name>

### Prerequisite state

Exact commands used to reach the state.

### Visible cards

1. Label — hidden command — group
2. Label — hidden command — group

### Selection

Selected card:

Observed output:

Expected output or state:

Follow-up observation:

Result: PASS / FAIL
```

Preserve exact parser text for failures. Summaries are useful for navigation,
but they cannot replace evidence.

## Handling Large Adventures

For a large imported adventure, full coverage may require several passes.
Partition by a stable player-facing boundary:

- Region or chapter
- Major puzzle chain
- NPC arc
- Pre- and post-milestone world state
- Endgame

Each pass should still be a vertical slice: discover, implement, validate, and
document that partition before moving on.

Recommended order:

1. Opening and onboarding
2. Mandatory golden-path rooms
3. Required puzzle branches
4. Recovery and backtracking states
5. Optional content
6. Rare hazards, deaths, and alternate endings

Never report “complete” when only the walkthrough corridor is covered. Report
the exact matrix status instead.

## What the Agent May Infer

An authoring agent may infer:

- Likely useful actions from room prose and object state
- Candidate labels from observed parser outcomes
- State-family boundaries from source flags and walkthrough transitions
- Reasonable priority and diversity
- Missing coverage from the world inventory

It must validate, not merely infer:

- That a command parses
- That the referenced object is in scope
- That a transition succeeds in the claimed state
- That the player has learned facts used by the label
- That a card remains correct after typed detours
- That save/restore and restart preserve the intended behavior

Source inspection and play complement one another. Source alone misses the
experienced narrative order; play alone misses unvisited branches.

## Change Boundaries

The companion layer should preserve the original adventure:

- Do not rewrite puzzle logic to simplify companion generation.
- Do not bypass the parser with direct object mutations.
- Do not encode an alternate branching story in the companion.
- Do not use an online model at runtime.
- Do not hide a parser defect by claiming an untested command works.

An underlying defect discovered during generation may be fixed as a separate,
focused change with its own regression. Record it explicitly in the completion
report.

## Release Gate

A companion is ready when:

- [ ] The adventure and companion load together.
- [ ] Every reachable room is represented in the coverage matrix.
- [ ] Materially distinct puzzle, inventory, knowledge, NPC, and hazard states
      are represented as state families.
- [ ] Every important hidden command has matching-state parser evidence.
- [ ] A fresh child-mode run can progress using numbered choices only.
- [ ] A fresh story-mode run can progress using numbered choices only.
- [ ] A mixed typed-and-choice story run does not expose stale assumptions.
- [ ] Scene and movement cards are grouped correctly.
- [ ] Essential choices survive child mode's smaller visible set.
- [ ] Save/restore and restart behavior is validated.
- [ ] Repeated choice queries are observational.
- [ ] Spoilers, labels, diversity, and audience clarity received editorial
      review.
- [ ] Adventure-specific companion regressions pass.
- [ ] Remaining fallback, exempt, and uncovered states are explicitly reported.

## Completion Report

The author or agent should finish with:

- Adventure and module
- Files created or changed
- Reachable rooms inventoried
- State families identified
- State families authored and validated
- Candidate commands executed
- Child, story, and mixed routes completed
- Tests run and their results
- Underlying adventure defects found
- Fallback-reviewed, exempt, and uncovered states
- Known limitations and recommended next slice

This makes companion generation repeatable, reviewable, and honest about its
coverage.
