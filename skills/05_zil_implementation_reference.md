# Skill 05: ZIL Implementation Reference

## Goal
Implement game logic in ZIL with clean split between world data and routines.

## Inputs
- All prior stage outputs

## Required Actions
1. Implement `dungeon.zil` for rooms, objects, and declarative world data.
2. Implement `actions.zil` for routines, daemon/clock behavior, and `GO`.
3. Implement an executable walkthrough entry. If using `walkthrough.zil` with `run-zil-test.lua`, it must load prerequisites and expose `RUN_TEST`; also maintain a parser-driven cross-process walkthrough for release confidence.
4. Use the engine include chain consistently.
5. Apply advanced ZIL patterns where needed (GLOBAL objects, PSEUDO, FDESC/LDESC, PER exits, dynamic descriptions, transformations, daemons).
6. Implement one playable vertical slice at a time. After each room, object, puzzle, or NPC interaction, play its exact transcript through `llm.lua` before adding the next slice.
7. Grow a parser-driven walkthrough test alongside implementation; do not rely only on routines invoked directly with `PERFORM`.

## Outputs
- `dungeon.zil`
- `actions.zil`
- `walkthrough.zil`
- Parser-driven walkthrough test under `tests/` when the adventure is playable through `llm.lua`

## Acceptance Checks
- Parser/object/room routines compile and run.
- Puzzle state changes are explicit and traceable.
- Dynamic text and clock events are deterministic enough to test.
- Exact transcript noun phrases parse before and after a save/reload boundary.
- Each completed slice is reachable from a fresh game and remains covered by the growing walkthrough.

## Design-Critical Implementation Reminders

These are implementation-level constraints that protect the intended Infocom-style player experience.

- Implement generous command vocabulary and abbreviations (`n/s/e/w/u/d`, `i`, `x`, `g`, `wait`, `again`) so parser friction does not become the puzzle.
- Prefer in-world failure responses over generic parse failures for obvious attempts.
- Keep first-visit descriptions evocative and revisit descriptions short/stateful.
- Expose concrete progress signals (score/rank/chapter flags/objective milestones).
- Ensure dangerous systems are telegraphed in text and testable through transcripts.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 4
- `WRITING_ADVENTURES.md`: Game Structure, ZIL Syntax Reference, Advanced Techniques, Complete Example

## Critical Implementation Rules

These rules are derived from real bugs found when running book content through the zilscript engine. Violating them will cause parse errors, broken compilation, or broken gameplay.

### 0. Never redefine V-LOOK or standard SYNTAX

The substrate (`infocom/zork1/`) provides V-LOOK and the standard SYNTAX definitions. **Do not redefine those.**

**V-LOOK is provided by the substrate.** It reads `P?LDESC` from the current room and prints exits. Your `GO` routine calls it automatically. If you redefine V-LOOK (as Limehouse Killings did), you will break room descriptions.

**Wrong** (Limehouse Killings bug — redefines V-LOOK with wrong property):
```zil
; in actions.zil — DON'T DO THIS
<ROUTINE V-LOOK ()
    <TELL <GETP ,HERE ,P?DESC> CR>  ; P?DESC is room NAME, not description!
    <TELL CR "Exits: ">
    ...>
```

**Right** (let the substrate handle it):
```zil
; in actions.zil — V-LOOK is NOT defined here
; GO calls V-LOOK which is provided by the substrate
<ROUTINE GO ()
    <SETG HERE ,STARTING-ROOM>
    ...
    <V-LOOK>      ; calls the substrate's V-LOOK
    <MAIN-LOOP>>
```

**Standard SYNTAX is provided by the substrate.** LOOK, EXAMINE, TAKE, DROP, OPEN, and other standard verbs already exist in `infocom/zork1/syntax.zil`. Your `dungeon.zil` must not contain `<SYNTAX ...>` forms and `actions.zil` must not redefine standard entries.

A genuinely new verb still needs one narrow syntax declaration in `actions.zil`, after its action routine is available:

```zil
<SYNTAX ACCUSE OBJECT (FIND ACTORBIT) (IN-ROOM) = V-ACCUSE>
```

After adding custom syntax, test the typed command through the parser. Calling `<PERFORM ,V?ACCUSE ...>` proves the routine, not the vocabulary or syntax.

**Wrong** (Limehouse Killings bug — adds SYNTAX that conflicts):
```zil
; in dungeon.zil — DON'T DO THIS
<SYNTAX LOOK = V-LOOK>
<SYNTAX EXAMINE OBJECT = V-EXAMINE>
<SYNTAX TAKE OBJECT = V-TAKE>
```

**Right** (dungeon.zil has no SYNTAX):
```zil
; in dungeon.zil — SYNTAX section does not exist
<DIRECTIONS NORTH EAST WEST SOUTH ...>
<ROOM ...>
<OBJECT ...>
```

**Detection:** If `dungeon.zil` contains `<SYNTAX`, remove it. If `actions.zil` contains `<ROUTINE V-LOOK`, remove it. Review every `actions.zil` SYNTAX entry and keep only custom verbs absent from the substrate.

### 0a. Make parser vocabulary explicit

Object IDs and `DESC` strings are not automatically usable nouns. Every player-reachable object needs explicit vocabulary matching the transcript:

```zil
<OBJECT TORN-PAGE
      (IN LIBRARY)
      (DESC "torn page")
      (SYNONYM PAGE FRAGMENT TORN-PAGE)
      (ADJECTIVE TORN)
      (FLAGS TAKEBIT READBIT)>
```

Rules:

- Put head nouns and alternate nouns in `SYNONYM`.
- Put modifiers in `ADJECTIVE`.
- If a transcript types a hyphenated compound, include that exact spelling as a synonym.
- Add canonical nouns even when they match the object ID (`FOXGLOVE` still needs `(SYNONYM FOXGLOVE ...)`).
- Test both the documented form and a natural spaced variant.
- Resolve same-room noun collisions with adjectives or different nouns.
- If FDESC or LDESC mentions a concrete noun a player might type (e.g., "leather roll", "brass lantern"), that word must resolve to the described object or another object in scope. The text the player reads IS the parser vocabulary contract. `scripts/check-vocab.lua` verifies the objective subset—that each printed `DESC` contains a registered synonym—but prose nouns still require transcript playtesting and human review.
- When FDESC describes an object inside a container (e.g., "A leather roll lies in the open drawer, its contents glinting steel"), create a separate container object for the described item. Don't put the description noun as a synonym on the contained object — that breaks the containment hierarchy.
- Every concrete noun printed by an ACTION routine's TELL must correspond to an actual in-game object. If `TRUNK-F` EXAMINE says "contains a letter", a `LETTER` object must exist inside the `TRUNK` with matching SYNONYM. Players type exactly what they read — broken promises destroy parser trust.
- Don't write manual EXAMINE handlers for containers — the Zork engine handles it automatically via `V-EXAMINE` → `V-LOOK-INSIDE` → `PRINT-CONT`. It prints "The X contains: Y, Z" when open, "The X is closed" when closed, and "The X is empty" when empty. Use `(TEXT ...)` for custom description only when you need flavor text that replaces the default listing. Place contained objects inside the container with `(IN CONTAINER)` so they appear in the automatic listing.

### 0b. Make containers reveal reachable contents

A printed “open” response is not enough. The world model must change:

```zil
<OBJECT LOCKED-BOX
      (IN STUDY)
      (SYNONYM BOX)
      (ADJECTIVE LOCKED)
      (FLAGS CONTBIT SEARCHBIT)
      (ACTION LOCKED-BOX-F)>

; in successful OPEN/UNLOCK branch
<FSET ,LOCKED-BOX ,OPENBIT>
<MOVE ,BANK-STATEMENT ,LOCKED-BOX>
```

Immediately test `OPEN BOX`, then `TAKE STATEMENT` in the next `llm.lua` process. This catches both scope and save-state errors.

### 0c. Guard one-time story progress

If TAKE, READ, and EXAMINE can all reveal a clue, route them through one guarded transition:

```zil
<COND (<NOT ,LETTER-FOUND>
       <SETG LETTER-FOUND T>
       <SETG EVIDENCE-FOUND <+ ,EVIDENCE-FOUND 1>>)>
```

Test the verbs repeatedly and in different orders. Progress must increment once.

### 0d. Implement ASK/TELL topics for this substrate

The zork1 substrate treats `ASK` as a synonym of `TELL`; `ASK ACTOR ABOUT TOPIC` reaches the actor with the topic in `PRSI`. Actor routines that support ASK should therefore handle both verbs and inspect `PRSI`:

```zil
<COND (<VERB? ASK TELL>
       <COND (<EQUAL? ,PRSI ,KEY-TOPIC>
              ... )>)>
```

Define reusable topic objects in `GLOBAL-OBJECTS` so topic words resolve when the referenced clue/person is elsewhere. Guard interview counters, and ensure an NPC needed for a later command is physically or globally accessible at that point.

### 0e. Represent physical world state with objects, not flag-only scenery

If the prose names a physical thing the player could reasonably manipulate, that thing must exist in the object tree. Doors, windows, drawers, switches, ropes, vehicles, gates, and containers are not merely conditions on room exits.

**Wrong — the prose promises a door, but only a Boolean exists:**

```zil
<GLOBAL STUDY-UNLOCKED <>>

<ROOM ENTRANCE-HALL
      (LDESC "A door to the south stands locked.")
      (SOUTH TO STUDY IF STUDY-UNLOCKED)>

; Somewhere else:
<SETG STUDY-UNLOCKED T>
```

This shortcut lets movement change, but there is no door for `EXAMINE DOOR`, `OPEN DOOR`, `UNLOCK DOOR WITH KEY`, `CLOSE DOOR`, or pronoun resolution. Prose, parser scope, generic verbs, and navigation can contradict one another.

**Right — create the door and let its object state control the exit:**

```zil
<GLOBAL STUDY-UNLOCKED <>> ; supplements the object: locked vs merely closed

<OBJECT STUDY-DOOR
      (IN LOCAL-GLOBALS)
      (DESC "study door")
      (SYNONYM DOOR)
      (ADJECTIVE STUDY OAK)
      (FLAGS DOORBIT NDESCBIT)
      (ACTION STUDY-DOOR-F)>

<ROOM ENTRANCE-HALL
      (SOUTH TO STUDY IF STUDY-DOOR IS OPEN
             ELSE "The study door is closed.")
      (GLOBAL STUDY-DOOR)>

<ROOM STUDY
      (NORTH TO ENTRANCE-HALL IF STUDY-DOOR IS OPEN
             ELSE "The study door is closed.")
      (GLOBAL STUDY-DOOR)>
```

The door routine should handle `EXAMINE`, `OPEN`, and `UNLOCK`, validate the key or lockpick, set `STUDY-UNLOCKED` when the lock is released, and set/clear `OPENBIT` when the door opens or closes. The exit reads `OPENBIT`; the supplementary global answers the separate question "is it locked?"

Use globals without objects for genuinely abstract facts such as `RIDDLE-SOLVED`, `NPC-TRUSTS-PLAYER`, or a one-time scoring guard. Do not use them to erase physical entities from the simulated world.

### 1. Don't embed item descriptions in room descriptions — let items describe themselves

Room descriptions (`LDESC`) should describe the **space**, not the objects in it. Objects describe themselves via `FDESC`, `LDESC`, or `DESCFCN`. This keeps content modular and lets objects adapt to state changes.

**Wrong** (room description embeds items):
```zil
(LDESC "The study is a crime scene. A mahogany desk stands against the wall,
its surface cluttered with papers. The fireplace contains cold ashes and
a small locked box. A window looks out to the garden.")
```

**Right** (room describes the space, items describe themselves):
```zil
; room
(LDESC "A crime scene. The chalk outline on the floor marks where the body
lay. A window looks out to the garden, its latch rusted but intact. The air
hangs heavy with the memory of violence.")

; objects in dungeon.zil
<OBJECT DESK
    (IN STUDY)
    (SYNONYM DESK TABLE)
    (DESC "mahogany desk")
    (FDESC "A mahogany desk stands against the wall, its surface cluttered with papers.")
    (FLAGS SURFACEBIT CONTBIT OPENBIT)>

<OBJECT FIREPLACE-ASHES
    (IN STUDY)
    (SYNONYM ASHES FIREPLACE)
    (DESC "fireplace")
    (FDESC "The fireplace contains cold ashes and a small locked box.")
    (FLAGS NDESCBIT)>
```

**Why**: When items describe themselves, their descriptions can change with game state. A locked box can say "locked" or "open" depending on a flag. A window can say "slightly ajar" or "open" depending on whether the player opened it. If the room description hardcodes the state, you need an ACTION routine just to vary one sentence. Most critically: if the room LDESC mentions a "door" but no door object exists, the player will type `OPEN DOOR` and get "There's no door here" — a broken promise that undermines trust in the parser.

**The door rule**: Every "door" noun in room text must correspond to an object with `SYNONYM DOOR` and an ACTION handler (even if it's always open). If you don't want a door object, say "doorway", "passage", or "opening" instead. Never use the word "door" in a room description without providing a door object.

**Detection**: Search your `LDESC` strings for object names that appear as objects elsewhere. If a room says "a desk" and there's an OBJECT DESK, the desk should describe itself. Search for the word "door" — every occurrence must have a corresponding door object. Search for any concrete noun (chair, table, bed, window) that a player might `EXAMINE`; if it exists, ensure the parser can find it.

### 2. Every `<TELL>` must close with `>` before the next form

The most common and hardest-to-spot bug. When a TELL form does not have a closing `>`, the parser treats everything after it as additional arguments to TELL—including entire COND forms, ROUTINEs, and subsequent top-level declarations.

**Wrong** (TELL swallows COND):
```zil
<ROUTINE V-LOOK ()
    <TELL CR "Exits: "          ; missing > !
    <COND (<==? ,HERE ,GARDEN>
           <TELL "NORTH">)
          (T
           <TELL "none">)>
    <TELL "." CR>
    <RTRUE>>
```

**Right** (TELL closed before COND):
```zil
<ROUTINE V-LOOK ()
    <TELL CR "Exits: ">         ; closed with >
    <COND (<==? ,HERE ,GARDEN>
           <TELL "NORTH">)
          (T
           <TELL "none">)>
    <TELL "." CR>
    <RTRUE>>
```

**Why it breaks**: When the `>` after COND is consumed by TELL (as its closing bracket), the outer ROUTINE never closes. Subsequent ROUTINEs, comments, and object declarations get nested inside the first ROUTINE as children. The compiled Lua then contains mangled code with identifiers like `HELPER`, `ROUTINES`, `===` mixed into function bodies.

**Detection**: If a ROUTINE in the AST has more than ~5 children, a TELL bracket leak is almost certainly the cause.

### 3. Define `ROUTINE GO ()` in actions.zil

The game entry point must exist. Original zork1 defines GO in `dungeon.zil`, but when a book overrides dungeon.zil, the engine only loads the book's version. Put GO in `actions.zil` instead (as blackwood-horror does).

GO must set up initial state:
```zil
<ROUTINE GO ()
    <SETG HERE ,STARTING-ROOM>
    <SETG LIT T>
    <SETG WINNER ,ADVENTURER>
    <SETG PLAYER ,WINNER>
    <MOVE ,WINNER ,HERE>
    ; Optional: clock/daemon setup
    ; <QUEUE I-WHISPER 8>
    <V-LOOK>
    <MAIN-LOOP>>
```

**Detection**: Game loads without errors but prints "Failed to start game: GO() not defined or failed."

### 4. Custom SYNTAX uses `= V-ROUTINE`

Only add syntax for verbs absent from the substrate. Use `= V-ROUTINE` at the end and include scope constraints when appropriate:

```zil
<SYNTAX ACCUSE OBJECT (FIND ACTORBIT) (IN-ROOM) = V-ACCUSE>
```

Do not copy standard LOOK/EXAMINE/TAKE/ASK entries into book content. Before adding a verb, search `infocom/zork1/syntax.zil`; after adding it, test the typed command rather than only calling its routine.

### 5. Bracket balance: every `<` needs a matching `>`

The parser uses `<...>` as expression boundaries. Common trouble spots:

- **`>>` at end of forms**: Two consecutive `>` close nested forms. Example: `<RTRUE>>` closes both RTRUE and the outer ROUTINE.
- **`)>` at clause end**: `)` closes a COND clause list, `>` closes COND. Example: `(T <TELL "ok">)>`
- **Nested TELL with COND**: If TELL contains COND as an argument, the first `>` encountered closes COND and the next `>` closes TELL. Make sure the outer form has enough `>` characters.

### 6. `;` comment lines: first atom after `;` is skipped by the parser

The zilscript parser's `;` handler calls `parse_form()` once to skip the next form, then returns. Any remaining text on the same line becomes separate top-level atoms in the AST.

```zil
; === HELPER ROUTINES ===
```

This produces three top-level Ident nodes: `HELPER`, `ROUTINES`, `===`. The compiler skips Ident nodes (they are not `"expr"` type), so they are harmless at runtime. But they pollute the AST. Keep comments to a single atom or use bare text without special characters.

### 7. Entry point files: use local paths, engine falls back to infocom/zork1/

Each book needs its own entry `.zil` file (like `blackwood-horror.zil`). Use local relative paths—INSERT_FILE first tries relative to the including file, then falls back to `infocom/zork1/` for anything not found locally:

```zil
;"Substrate (from zork1 automatically)"
<INSERT-FILE "main">
<INSERT-FILE "clock">
<INSERT-FILE "parser">
<INSERT-FILE "syntax">
<INSERT-FILE "macros">
<INSERT-FILE "verbs">
<INSERT-FILE "globals">

;"Book-specific overrides (found locally)"
<INSERT-FILE "dungeon">
<INSERT-FILE "actions">
```

### 7. zork2/zork3 use different file naming conventions

When referencing substrate files for zork2/zork3, note that they prefix files with `g` (globals → gglobals.zil, main → gmain.zil, clock → gclock.zil, etc.). The `try_open` function handles case-insensitive matching (`GMACROS` → `gmacros.zil`).
