# Testing Guide

This repository uses two execution modes and four common test patterns:

1. Direct state tests that construct a tiny world and assert on globals, flags, locations, tables, clock state, and save/restore behavior.
2. Parser/gameplay tests that run a real `GO()` loop in a coroutine and send commands through the parser.

This file documents the patterns already used in the current suite. Zork II is intentionally excluded here because its test setup is still work in progress.

## Running Tests

### Main entrypoints

```bash
make test
make test-unit
make test-integration
make test-pure-zil
```

### Common focused targets

```bash
make test-simple-new
make test-insert-file
make test-let
make test-save
make test-containers
make test-directions
make test-light
make test-pronouns
make test-take
make test-turnbit
make test-clock
make test-clock-direct
make test-assertions
make test-check-commands
make test-zork1
make test-horror
make test-horror-all
```

### Run one ZIL test file directly

```bash
lua5.4 run-zil-test.lua zil/test-simple-new
lua5.4 run-zil-test.lua infocom/zork1/test/test-containers
lua5.4 run-zil-test.lua books/blackwood-horror/test/test-walkthrough
```

`run-zil-test.lua` loads the target module, expects a ZIL routine named `RUN-TEST`, then invokes it through the compiled Lua symbol `RUN_TEST()`.

## What The Test Runner Actually Provides

The generic runner in `run-zil-test.lua` provides:

- `ASSERT(msg, condition)` for boolean assertions.
- `ASSERT_TEXT(expected, ok, actual)` for parser output matching.
- A deterministic `RANDOM(max)` override so test runs are repeatable.
- Standard loader/bootstrap setup via `require "zilscript"` and `require "zilscript.bootstrap"`.

Important detail: `ASSERT` currently returns on the first truthy or falsy condition it receives. In practice, that means you should treat it as a single-condition assertion. Some older tests pass multiple predicates to one `ASSERT`, but that is not a reliable pattern for new tests.

Recommended style:

```zil
<ASSERT "Take lamp command succeeds" <CO-RESUME ,CO "take lamp" T>>
<ASSERT "Lamp moved to inventory" <==? <LOC ,LAMP> ,ADVENTURER>>
```

For transcript text checks:

```zil
<ASSERT-TEXT "Taken." <CO-RESUME ,CO "take lamp">>
<ASSERT "Lamp moved to inventory" <==? <LOC ,LAMP> ,ADVENTURER>>
```

## The Verified Way To Set The Current Room

For direct setup or teleport-style test control, set both the room global and the player location.

The pattern used across the suite is:

```zil
<SETG HERE ,TARGET-ROOM>
<SETG WINNER ,ADVENTURER>
<SETG PLAYER ,WINNER>
<MOVE ,WINNER ,HERE>
```

Equivalent older tests sometimes move `,ADVENTURER` directly:

```zil
<SETG HERE ,TARGET-ROOM>
<MOVE ,ADVENTURER ,HERE>
```

If the test depends on visibility, also set light state:

```zil
<SETG LIT T>
```

This is the repo's current answer to “set current room for testing.” Updating only `,HERE` is not enough. Updating only the adventurer location is also not enough. Keep them in sync.

### Reusable setup helper

Several small tests define a helper like this:

```zil
<ROUTINE TEST-SETUP (ROOM-OBJ)
   <SETG HERE .ROOM-OBJ>
   <SETG LIT T>
   <SETG WINNER ,ADVENTURER>
   <SETG PLAYER ,WINNER>
   <MOVE ,ADVENTURER ,HERE>>
```

Use that helper whenever a file needs to reposition the player more than once.

## Test Styles In This Repo

### 1. Tiny Direct State Tests

Use this style when you want to verify engine semantics without depending on a full game.

Common examples:

- `zil/test-simple-new.zil`
- `zil/test-insert-file.zil`
- `zil/test-save.zil`
- `infocom/zork1/test/test-clock-direct.zil`

Typical structure:

```zil
<DIRECTIONS NORTH SOUTH>
<CONSTANT RELEASEID 1>

<OBJECT ADVENTURER
      (DESC "you")
      (SYNONYM ADVENTURER ME SELF)>

<ROOM TESTROOM
     (IN ROOMS)
     (DESC "Test Room")
     (FLAGS RLANDBIT ONBIT)>

<ROUTINE RUN-TEST ()
   <SETG HERE ,TESTROOM>
   <SETG WINNER ,ADVENTURER>
   <SETG PLAYER ,WINNER>
   <MOVE ,WINNER ,HERE>
   <ASSERT "Adventurer is in TESTROOM" <==? <LOC ,ADVENTURER> ,TESTROOM>>>
```

Use this style for:

- Global state
- Object location
- Flags with `FSET?`
- Save/restore behavior
- Clock internals
- Compiler/runtime support features like `INSERT-FILE` and `LET`

### 2. Inline Parser Tests With A Minimal GO Loop

Use this style when you need parser behavior, but do not want to load a full adventure.

Common examples:

- `infocom/zork1/test/test-containers.zil`
- `infocom/zork1/test/test-pronouns.zil`
- `infocom/zork1/test/test-light.zil`
- `infocom/zork1/test/test-turnbit.zil`

Typical structure:

```zil
<INSERT-FILE "infocom/zork1/globals">
<INSERT-FILE "infocom/zork1/clock">
<INSERT-FILE "infocom/zork1/parser">
<INSERT-FILE "infocom/zork1/verbs">
<INSERT-FILE "infocom/zork1/syntax">
<INSERT-FILE "infocom/zork1/main">

<ROOM STARTROOM ...>
<OBJECT APPLE ...>

<ROUTINE GO ()
   <SETG HERE ,STARTROOM>
   <SETG LIT T>
   <SETG WINNER ,ADVENTURER>
   <SETG PLAYER ,WINNER>
   <MOVE ,WINNER ,HERE>
   <V-LOOK>
   <MAIN-LOOP>
   <AGAIN>>

<GLOBAL CO <CO-CREATE GO>>
```

Then drive commands with:

```zil
<ASSERT-TEXT "Taken." <CO-RESUME ,CO "take apple">>
<ASSERT "Apple moved to inventory" <==? <LOC ,APPLE> ,ADVENTURER>>
```

Use this style for:

- Parser vocabulary
- Container semantics
- Pronoun resolution
- Lighting behavior
- Verb dispatch
- Flag-controlled command availability

### 3. Full Adventure Tests With INSERT-FILE

Use this when the behavior depends on real game content.

Common examples:

- `infocom/zork1/test/zork1-walkthrough.zil`
- `books/blackwood-horror/test/test-helpers.zil`
- `books/blackwood-horror/test/test-failures.zil`
- `books/blackwood-horror/test/test-walkthrough.zil`
- `infocom/test-zork1.zil`
- `infocom/test-zork3.zil`
- `infocom/test-planetfall.zil`
- `infocom/test-lurkinghorror.zil`
- `infocom/test-spellbreaker.zil` if added later

Typical pattern:

```zil
<INSERT-FILE "infocom/zork1/globals">
<INSERT-FILE "infocom/zork1/clock">
<INSERT-FILE "infocom/zork1/parser">
<INSERT-FILE "infocom/zork1/verbs">
<INSERT-FILE "infocom/zork1/actions">
<INSERT-FILE "infocom/zork1/syntax">
<INSERT-FILE "infocom/zork1/dungeon">
<INSERT-FILE "infocom/zork1/main">

<GLOBAL CO <CO-CREATE GO>>
```

For Blackwood Horror, the current tests use Zork I parser/runtime pieces plus the local dungeon/actions files.

Use this style for:

- Real walkthroughs
- Regression tests against authored content
- Failure-path checks in a live game
- Multi-step puzzle validation

### 4. Transcript-Derived Tests

The repo also contains transcript-style tests that are effectively command scripts expressed as repeated `ASSERT-TEXT` calls.

Common examples:

- `infocom/zork1/test/test-auto-generated.zil`
- `infocom/test-zork1.zil`
- `infocom/test-zork3.zil`
- `infocom/test-planetfall.zil`

These are useful when you have a known-good transcript and want quick regression coverage for output and command flow.

## Frotz Workflow

This section documents a repeatable way to record fresh walkthrough transcripts from compiled Infocom story files on macOS.

### Required Files

For each game, you need:

- A compiled story file (`.z3` or `.zip`) in that game folder, for example `infocom/zork2/zork2.z3`.
- A command transcript source file with one command per `>` line, for example `infocom/zork2/test/zork2.txt`.
- The recorder script `record-frotz-transcript.lua`.

The recorder currently maps these game keys:

- `zork1`
- `zork2`
- `zork3`
- `planetfall`
- `spellbreaker`
- `lurkinghorror`

### Install Frotz

On macOS with Homebrew:

```bash
brew install frotz
```

Verify binaries:

```bash
command -v dfrotz
command -v frotz
```

Use `dfrotz` for scripted replay and transcript generation.

### Run A Game Manually

```bash
dfrotz infocom/zork2/zork2.z3
```

### Record A Walkthrough Manually

Inside the game:

1. Run `SCRIPT`.
2. Enter a base filename (for example `session`).
3. Play the walkthrough commands.
4. Run `UNSCRIPT`.
5. Quit normally (`QUIT`, then `Y` when prompted).

Frotz writes `<name>.scr` (for example `session.scr`).

### Record Walkthroughs From Existing Command Files

Use the repo helper to replay commands from `infocom/<game>/test/<game>.txt` and save a new transcript as `*-frotz.txt`:

```bash
lua5.4 record-frotz-transcript.lua zork2
```

Record all configured games:

```bash
lua5.4 record-frotz-transcript.lua
```

Typical outputs:

- `infocom/zork1/test/zork1-frotz.txt`
- `infocom/zork2/test/zork2-frotz.txt`
- `infocom/zork3/test/zork3-frotz.txt`
- `infocom/spellbreaker/test/spellbreaker-frotz.txt`
- `infocom/lurkinghorror/test/lurkinghorror-frotz.txt`

On failure, the script prints a per-game error and the `dfrotz` log path.

### Turn Fresh Transcript Into Test Assertions

Generate a new transcript-derived test file:

```bash
lua5.4 generate-test-from-transcript.lua infocom/zork2/test/zork2-frotz.txt
```

Run it:

```bash
lua5.4 run-zil-test.lua infocom/zork2/test/test-auto-generated
```

### How To Record A Successful Walkthrough

For stable transcript replay, keep these constraints:

1. Use a story build whose release matches the walkthrough transcript.
2. Start from a fresh game state.
3. Keep command text exact (same verbs, object names, and sequencing).
4. End cleanly (`UNSCRIPT`, then `QUIT`, then `Y`).

If you hit broad divergence (many `You can't go that way.` lines), stop early and verify story release before regenerating tests.

### Release-Mismatch Warning

Walkthrough command files are release-sensitive. If transcript source and story build differ, command flow can diverge quickly.

Check story metadata:

```bash
file infocom/zork2/zork2.z3
```

Compare release/serial with the transcript header before relying on generated assertions.

## Assertion Techniques Used In The Current Suite

### Boolean state assertions

```zil
<ASSERT "Drawer is open" <FSET? ,BOTTOM-DRAWER ,OPENBIT>>
<ASSERT "Candle is off" <NOT <FSET? ,CANDLE ,ONBIT>>>
<ASSERT "Player is in room" <==? <LOC ,ADVENTURER> ,TESTROOM>>
<ASSERT "Object is not in inventory" <N==? <LOC ,APPLE> ,ADVENTURER>>
```

### Transcript text assertions

```zil
<ASSERT-TEXT "Taken." <CO-RESUME ,CO "take lamp">>
<ASSERT-TEXT "pitch black" <CO-RESUME ,CO "look">>
```

`ASSERT-TEXT` is the right tool when the primary contract is player-facing output.

### Command success plus state verification

Recommended new style:

```zil
<ASSERT "Take lamp command succeeds" <CO-RESUME ,CO "take lamp" T>>
<ASSERT "Lamp is in inventory" <==? <LOC ,LAMP> ,ADVENTURER>>
```

### Inventory and location checks

Current tests commonly use `LOC`:

```zil
<ASSERT "Plaque in inventory" <==? <LOC ,BRASS-PLAQUE> ,ADVENTURER>>
<ASSERT "Ledger in drawer" <==? <LOC ,PATIENT-LEDGER> ,BOTTOM-DRAWER>>
<ASSERT "Player moved north" <==? ,HERE ,SANITARIUM-ENTRANCE>>
```

### Flag checks

```zil
<ASSERT "Valve has TURNBIT" <FSET? ,VALVE ,TURNBIT>>
<ASSERT "Wall safe opened" <FSET? ,WALL-SAFE ,OPENBIT>>
```

### Save/restore checks

`zil/test-save.zil` demonstrates how to verify:

- globals survive save/restore
- `,HERE` survives save/restore
- object locations survive save/restore
- flags survive save/restore
- multiple save files remain independent

### Clock/demon checks

`infocom/zork1/test/test-clock-direct.zil` uses direct function calls like:

- `INT`
- `QUEUE`
- `ENABLE`
- `CLOCKER`

Use that style when validating interrupt scheduling rather than player commands.

## CO-CREATE And CO-RESUME Semantics

Coroutine-based gameplay tests use:

```zil
<GLOBAL CO <CO-CREATE GO>>
```

`CO-CREATE` starts the game coroutine immediately.

To send commands:

```zil
<CO-RESUME ,CO "look">
```

That returns the normal coroutine results, which `ASSERT-TEXT` expects.

If you pass a third argument of `T`:

```zil
<CO-RESUME ,CO "north" T>
```

then `CO-RESUME` returns only the coroutine success flag. Use that for pure success/failure checks, but pair it with a separate state assertion if you care where the player ended up.

## Recommended File Skeletons

### Small direct state test

```zil
<DIRECTIONS NORTH SOUTH>
<CONSTANT RELEASEID 1>

<OBJECT ADVENTURER
      (DESC "you")
      (SYNONYM ADVENTURER ME SELF)>

<ROUTINE TEST-SETUP (ROOM-OBJ)
   <SETG HERE .ROOM-OBJ>
   <SETG LIT T>
   <SETG WINNER ,ADVENTURER>
   <SETG PLAYER ,WINNER>
   <MOVE ,ADVENTURER ,HERE>>

<ROOM TESTROOM
     (IN ROOMS)
     (DESC "Test Room")
     (FLAGS RLANDBIT ONBIT)>

<ROUTINE RUN-TEST ()
   <TEST-SETUP ,TESTROOM>
   <ASSERT "HERE is TESTROOM" <==? ,HERE ,TESTROOM>>>
```

### Minimal parser test

```zil
<INSERT-FILE "infocom/zork1/globals">
<INSERT-FILE "infocom/zork1/clock">
<INSERT-FILE "infocom/zork1/parser">
<INSERT-FILE "infocom/zork1/verbs">
<INSERT-FILE "infocom/zork1/syntax">
<INSERT-FILE "infocom/zork1/main">

<DIRECTIONS NORTH SOUTH>
<CONSTANT RELEASEID 1>

<ROOM STARTROOM
     (IN ROOMS)
     (DESC "Start Room")
     (FLAGS RLANDBIT ONBIT)>

<OBJECT APPLE
      (IN STARTROOM)
      (SYNONYM APPLE)
      (DESC "apple")
      (FLAGS TAKEBIT)>

<ROUTINE GO ()
   <SETG HERE ,STARTROOM>
   <SETG LIT T>
   <SETG WINNER ,ADVENTURER>
   <SETG PLAYER ,WINNER>
   <MOVE ,WINNER ,HERE>
   <V-LOOK>
   <MAIN-LOOP>
   <AGAIN>>

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
   <ASSERT-TEXT "Taken." <CO-RESUME ,CO "take apple">>
   <ASSERT "Apple moved to inventory" <==? <LOC ,APPLE> ,ADVENTURER>>>
```

### Full-game walkthrough test

```zil
<INSERT-FILE "infocom/zork1/globals">
<INSERT-FILE "infocom/zork1/clock">
<INSERT-FILE "infocom/zork1/parser">
<INSERT-FILE "infocom/zork1/verbs">
<INSERT-FILE "infocom/zork1/actions">
<INSERT-FILE "infocom/zork1/syntax">
<INSERT-FILE "infocom/zork1/dungeon">
<INSERT-FILE "infocom/zork1/main">

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
   <ASSERT-TEXT "West of House" <CO-RESUME ,CO "look">>
   <ASSERT-TEXT "Taken." <CO-RESUME ,CO "take leaflet">>
   <ASSERT "Leaflet in inventory" <==? <LOC ,LEAFLET> ,ADVENTURER>>>
```

## Choosing The Right Test Style

Use direct state tests when the behavior is runtime-level or data-structure-level.

Use minimal parser tests when you need command parsing, but do not need the full game world.

Use full-game tests when behavior depends on authored content, real room links, or puzzle sequencing.

Use transcript tests when you already have a walkthrough and want broad regression coverage quickly.

## Existing Techniques Worth Reusing

- Build a `TEST-SETUP` routine if you need to reposition the player repeatedly.
- Use `INSERT-FILE` to assemble only the modules needed for the test.
- Use `ASSERT-TEXT` for user-visible copy.
- Use `LOC`, `HERE`, and `FSET?` for world-state checks.
- Split command success and state verification into separate assertions.
- Use direct teleporting with `SETG HERE` plus `MOVE` to jump to a scenario quickly.
- For long walkthroughs, drop no-longer-needed items to keep inventory manageable.
- For clock tests, call engine routines directly instead of driving them only through parser commands.
- For transcript-derived tests, prefer many small assertions over one giant summary check.

## Adding A New Test File

1. Put the file in the correct folder.
   Direct engine tests usually live under `zil/` or `infocom/zork1/test/`.
   Adventure-specific tests should live under that adventure's `test/` directory.

2. Choose the right style.
   Use one of the skeletons above instead of inventing a new harness.

3. Define `RUN-TEST`.
   The runner expects that routine to exist.

4. Add a focused Make target in `Makefile`.

5. Add the target to the right aggregate group such as `test-parser`, `test-horror-all`, or `test-pure-zil`.

6. Update `help` text in `Makefile`.

7. If CI runs the surrounding group, no extra workflow change is needed.

## Troubleshooting

### The test needs to start in a specific room

Use:

```zil
<SETG HERE ,ROOM>
<SETG WINNER ,ADVENTURER>
<SETG PLAYER ,WINNER>
<MOVE ,WINNER ,HERE>
```

### The parser test hangs or waits for input

Make sure your `GO()` routine enters `MAIN-LOOP` and your test drives it through `CO-RESUME`.

### The room is wrong after a manual jump

You probably changed `,HERE` without moving the player, or moved the player without changing `,HERE`.

### Text assertion passes but state is wrong

Add a separate state assertion after the command. Do not rely on a multi-condition `ASSERT` call.

### A test needs deterministic randomness

The generic runner already overrides `RANDOM(max)` deterministically.

### A transcript test is too long to debug

Split it into thematic chunks or add intermediate `HERE`, `LOC`, and flag assertions around the puzzle transitions.
