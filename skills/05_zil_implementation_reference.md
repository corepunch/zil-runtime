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

### 0. NEVER redefine V-LOOK or SYNTAX — they come from the substrate

The substrate (`infocom/zork1/`) provides V-LOOK and all SYNTAX definitions. **Do not add your own.**

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

**SYNTAX is provided by the substrate.** All standard verbs (LOOK, EXAMINE, TAKE, DROP, OPEN, etc.) are already defined in `infocom/zork1/syntax.zil`. Your `dungeon.zil` should NOT contain any `<SYNTAX ...>` forms.

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

**Detection:** If your `dungeon.zil` contains `<SYNTAX` anywhere, remove it. If your `actions.zil` contains `<ROUTINE V-LOOK`, remove it.

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

**Why**: When items describe themselves, their descriptions can change with game state. A locked box can say "locked" or "open" depending on a flag. A window can say "slightly ajar" or "open" depending on whether the player opened it. If the room description hardcodes the state, you need an ACTION routine just to vary one sentence.

**Detection**: Search your `LDESC` strings for object names that appear as objects elsewhere. If a room says "a desk" and there's an OBJECT DESK, the desk should describe itself.

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

### 4. Simplified SYNTAX uses `= ACTION`, not `ACTION` keyword

The limehouse/blackwood books use a simplified SYNTAX format. Note the differences:

**Simplified format** (books):
```zil
<SYNTAX EXAMINE OBJECT = V-EXAMINE>
<SYNTAX ASK OBJECT ABOUT TEXT = V-ASK>
```

**Infocom format** (zork1/2/3):
```zil
<SYNTAX EXAMINE OBJECT (MANY) = V-EXAMINE>
<SYNTAX ATTACK OBJECT (FIND ACTORBIT) (ON-GROUND IN-ROOM) = V-ATTACK>
```

Key rules for the simplified format:
- `= V-ROUTINE` at the end (not `ACTION V?ROUTINE`)
- Modifier keywords like `TEXT` before `=` are supported
- Use hyphenated names: `V-GO-NORTH` (not `V?GO-NORTH`)

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
