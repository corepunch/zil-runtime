# Wondertown (The Last Toymaker's Apprentice) - Bug Report

**Test Date:** 2026-07-17
**Tested By:** Game Tester Agent

## Summary

| Category | Count |
|----------|-------|
| Critical Bugs | 2 |
| High Severity | 1 |
| Medium Severity | 2 |
| Low Severity | 3 |

---

## Critical Bugs

### Bug 1: TAKE/DROP Completely Broken — Action Routines Swallow All Default Verbs

- **Description:** Every object action routine in `actions.zil` ends with `<RTRUE>`, which tells the parser "I handled this verb" even when the routine didn't actually handle it. This silently swallows TAKE, DROP, OPEN, CLOSE, LOOK-IN, and all other default Zork verb behaviors. Items cannot be picked up, dropped, or interacted with in any way that relies on the parser's built-in verb handling. This makes the game completely unwinnable.
- **Command:** `take string` (or any TAKE command on any object)
- **Output:** *(empty — no response at all)*
- **Expected:** `Taken.` message and the item moves to inventory.
- **Root Cause:** In `actions.zil`, every `-F` routine (e.g., `KEY-STRING-F`, `OIL-CAN-F`, `SWEEP-BROOM-F`, etc.) follows this pattern:

  ```zil
  <ROUTINE KEY-STRING-F ()
      <COND (<VERB? EXAMINE>
             <TELL "..." CR>)>
      <RTRUE>>  ; <-- THIS IS THE BUG
  ```

  The trailing `<RTRUE>` tells the parser that the action routine handled the verb, so the parser skips calling `V-TAKE`, `V-DROP`, `V-OPEN`, etc. In Zork1, action routines that don't handle a verb simply return RFALSE (by not matching any condition and not having a trailing RTRUE), letting the default behavior proceed.

- **Reproduction:** Start any game session, type `take string` or `take broom` or `take oil can`. No response. Type `inventory` — empty-handed.
- **Regression Test:** `books/wondertown/test/test-take-deep.zil`
- **Test Command:** `lua5.4 run-zil-test.lua books/wondertown/test/test-take-deep`
- **Regression Status:** RED — reproduces the bug
- **Severity:** Critical

### Bug 2: Existing Test Suite Masked by ASSERT Short-Circuit Logic

- **Description:** The existing test files (`test-take.zil`, `walkthrough.zil`) use the pattern `<ASSERT "msg" <CO-RESUME ,CO "cmd" T> <state-check>>`. The `ASSERT` function in `run-zil-test.lua` returns on the *first* truthy condition. Since `CO-RESUME` always returns `true` (the coroutine resumed successfully), the state check is **never evaluated**. This means the tests "pass" even when TAKE is completely broken.
- **Command:** Any test using `<ASSERT "msg" <CO-RESUME ...> <state-check>>`
- **Output:** `[PASS]` despite TAKE not working
- **Expected:** `[FAIL]` because the state check should also be evaluated
- **Regression Test:** `books/wondertown/test/test-assert-logic.zil`
- **Test Command:** `lua5.4 run-zil-test.lua books/wondertown/test/test-assert-logic`
- **Regression Status:** RED — demonstrates the masked bug
- **Severity:** Critical

---

## High Severity Bugs

### Bug 3: MAILBOX-CORNER Missing East Exit — Misleading Room Description

- **Description:** The Mailbox Corner room description says *"More fox footprints continue east, toward what looks like the old scrap-yard"* but the room has no east exit. The only exit is west back to Clock Square. To reach the Scrap-Yard, the player must go west to Clock Square, then south. This traps players who follow the described footprints.
- **Command:** `go east` (from Mailbox Corner)
- **Output:** `You can't go that way.`
- **Expected:** Either an east exit to the Scrap-Yard, or the description should say *"west"* instead of *"east"*. According to the dungeon map, the Scrap-Yard is south of Clock Square, not east of Mailbox Corner.
- **Reproduction:** Go north → east → east (Mailbox Corner) → east
- **Regression Test:** `books/wondertown/test/test-exit-mailbox.zil`
- **Test Command:** `lua5.4 run-zil-test.lua books/wondertown/test/test-exit-mailbox`
- **Regression Status:** RED — confirms the missing exit
- **Severity:** High

---

## Medium Severity Bugs

### Bug 4: ASK/TELL About Topics Fails — Topic Objects Not in Scope

- **Description:** The `tell <npc> about <topic>` and `ask <npc> about <topic>` commands fail with "You can't see any [topic] here!" because the topic objects (`TOPIC-FOX`, `TOPIC-KEY`, `TOPIC-TOLLIVER`, etc.) are in `LOCAL-GLOBALS` but the rooms don't list them in their `GLOBAL` property. For example, `MAILBOX-CORNER` has `(GLOBAL MOON)` but not `TOPIC-FOX`, so `ask mailbox about fox` fails. The mailbox handler checks for `NUTMEG` and `FOOTPRINTS` directly, but these aren't accessible via the `ABOUT` syntax.
- **Command:** `ask mailbox about fox` or `tell nutcracker about tolliver`
- **Output:** `You can't see any fox here!` / `You can't see any tolliver here!`
- **Expected:** The mailbox should respond with dialogue about the fox, or the nutcracker should discuss Tolliver.
- **Reproduction:** Go to Mailbox Corner, type `ask mailbox about fox`
- **Severity:** Medium

### Bug 5: Container Interactions Broken (LOOK-IN, OPEN) for Mailbox

- **Description:** The mailbox is defined as `(FLAGS CONTBIT OPENBIT ACTORBIT)` but `look in mailbox`, `open mailbox`, `close mailbox` all return empty output because the `MAILBOX-F` action routine catches all verbs and returns `<RTRUE>` without handling LOOK-IN, OPEN, or CLOSE.
- **Command:** `look in mailbox` or `open mailbox`
- **Output:** *(empty)*
- **Expected:** `look in mailbox` should describe the letters inside. `open mailbox` should describe the flap opening. Since the mailbox is already open (OPENBIT is set), `open mailbox` could say "The mailbox is already open."
- **Reproduction:** Go to Mailbox Corner, type `look in mailbox`
- **Severity:** Medium

---

## Low Severity Bugs

### Bug 6: CLIMB Without "UP" Fails for Workbench

- **Description:** `climb workbench` returns empty output, but `climb up workbench` works correctly. The WORKBENCH object has `(FLAGS SURFACEBIT CONTBIT OPENBIT SEARCHBIT)` but not `CLIMBBIT`, so the parser's `CLIMB OBJECT (FIND CLIMBBIT)` syntax doesn't match. The WORKBENCH-F handler does handle `CLIMB` but the parser never reaches it.
- **Command:** `climb workbench`
- **Output:** *(empty)*
- **Expected:** `You scramble up the workbench leg...` (same as `climb up workbench`)
- **Reproduction:** In Workshop Floor, type `climb workbench`
- **Severity:** Low

### Bug 7: "bundle" Not Recognized as Synonym for MAILBOX-LETTERS

- **Description:** The MAILBOX-LETTERS object has `(SYNONYM LETTERS MAIL)` and `(ADJECTIVE UNSENT OLD)` but "bundle" is not registered as a synonym. The room description and object description both say "bundle of letters" but `examine bundle` returns "I don't know the word 'bundle'."
- **Command:** `examine bundle` or `take bundle`
- **Output:** `I don't know the word "bundle".`
- **Expected:** Should match MAILBOX-LETTERS since the object is described as "bundle of letters"
- **Reproduction:** Go to Mailbox Corner, type `examine bundle`
- **Severity:** Low

### Bug 8: SPOOL-STAIRS Object in Wrong Room

- **Description:** The SPOOL-STAIRS object is defined `(IN WORKSHOP-FLOOR)` but the Tool Bench room description says *"The spool staircase leads up toward the countertop"*. When the player is in Tool Bench, `examine staircase` returns "You can't see any staircase here!" because the stairs are in the Workshop Floor, not the Tool Bench.
- **Command:** `examine staircase` (from Tool Bench)
- **Output:** `You can't see any staircase here!`
- **Expected:** Should describe the spool staircase, or the stairs should be moved to the Tool Bench room
- **Reproduction:** Go to Tool Bench, type `examine staircase`
- **Severity:** Low

---

## Recommendations

1. **Remove trailing `<RTRUE>` from all action routines** in `actions.zil`. Each routine should only return `<RTRUE>` (or `<RTRUE>` within a `<COND>` branch) when it explicitly handles a verb. For unhandled verbs, let the routine fall through to the implicit RFALSE.

2. **Fix the ASSERT function** in `run-zil-test.lua` to evaluate ALL conditions, not just the first truthy one. Change the loop to check all conditions and only PASS if all are truthy.

3. **Add east exit from MAILBOX-CORNER to SCRAP-YARD** or change the room description to say "west" instead of "east".

4. **Add topic objects to room GLOBAL properties** so that `ask/tell NPC about TOPIC` works. Alternatively, change the NPC handlers to check for the topic objects directly.

5. **Add CLIMBBIT to WORKBENCH** or change the CLIMB syntax handling.

6. **Add "bundle" as a synonym** for MAILBOX-LETTERS.

7. **Move SPOOL-STAIRS to TOOL-BENCH** or change its location to a global.

---

*Report generated by game tester agent*
