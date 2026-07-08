# Horror.zil Improvement Plan

## Problem Statement

The current adventure is structurally sound (22 rooms, 57 objects, working puzzles) but lacks the richness that makes Infocom games memorable. It reads like a haunted house tour — go room to room, read static descriptions, collect keys. The twist (Patient 189) is hinted but never lands. Most objects are inert red herrings. No scoring, no randomization, no dynamic descriptions.

---

## Planned Improvements

### 1. GLOBAL Objects (Shared Scenery)

**Why:** The player can see the sanitarium from outside and from the garden, but it's invisible to the parser. Same for the dead oak tree mentioned nowhere but implied by the setting.

**What:**
- `SANITARIUM-BUILDING` in `LOCAL-GLOBALS` — visible from SANITARIUM-GATE, OVERGROWN-GARDEN. EXAMINE produces different text depending on whether CHAPEL-UNLOCKED (the building "feels" different once you've been deep inside).
- `DEAD-OAK-TREE` in `LOCAL-GLOBALS` — visible from SANITARIUM-GATE, OVERGROWN-GARDEN, SANITARIUM-ENTRANCE. EXAMINE, CLIMB (can't), LISTEN (crows).

Add `(GLOBAL SANITARIUM-BUILDING DEAD-OAK-TREE)` to those rooms.

---

### 2. FDESC Discovery Moments

**Why:** FDESC fires only the first time. This creates memorable "wow" moments for key objects.

**What:**
- `IRON-BOILER` FDESC: "The room's centerpiece is a massive iron boiler, cold and silent as a tomb. Its hulking form crouches in the darkness like some dormant beast."
- `SHOCK-CHAIR` FDESC: "In the center of the room, bolted to the floor, sits the chair. Leather restraints dangle from every joint. You know immediately what this is, and your stomach turns."
- `PATIENT-189` FDESC: "Something is standing at the altar. It doesn't move. It doesn't breathe. But somehow, horribly, you know it knows you're here."

---

### 3. PICK-ONE Randomized Atmosphere

**Why:** The same whisper firing every 8 turns becomes wallpaper. Variety keeps dread alive.

**What:**
```zil
<GLOBAL WHISPER-TABLE
    <LTABLE 0
        "A voice, barely audible, rasps: 'help... me...'"
        "You hear your name whispered — impossible, you never told anyone you were coming."
        "A child's voice whispers something in a language you don't recognize."
        "The walls seem to breathe a single word: 'run.'">>
```
Replace I-WHISPER body with `<TELL <PICK-ONE ,WHISPER-TABLE> CR>`.

---

### 4. The Identity Twist — You Are Patient 189

**Why:** The game hints at Patient 189's identity but never delivers the twist. The straitjacket in the padded cell is the perfect vehicle — it has a name tag.

**What:**
- STRAITJACKET EXAMINE: "A heavy canvas straitjacket. Stiff buckles, dark stains. And on the collar — a name tag. Your name. YOUR name is on this straitjacket."
- STRAITJACKET gets READBIT. TEXT/READ: "The tag reads a name you know. Your name. Dated 1947. Five years before the sanitarium closed."
- WALL-SCRATCHES READ: append below existing messages: "'YOU ARE 189. YOU ALWAYS WERE.' — scratched in handwriting that looks disturbingly like your own."

This doesn't change the game's mechanics — it recontextualizes the player's motivation.

---

### 5. Earned Ending — Serum + Syringe + Relic

**Why:** Saying "hello" to win is anticlimactic. The game has STRANGE-SERUM, SYRINGE, and ANCIENT-RELIC as objects but no purpose for two of them.

**What:**
Replace `<VERB? HELLO>` win condition in PATIENT-189-F:
- If player lacks ANCIENT-RELIC: "Patient 189 tilts its head. Green light flares in its eyes. Something cold reaches into your chest. You are not ready."
- If player has relic but not serum+syringe: "The relic glows warm. Patient 189 shivers, eyes flickering. But something still binds it. The serum — if returned to its source..."
- If player has all three: Multi-line victory text. Inject the serum. The green light dies. Patient 189 looks at you with human eyes and whispers 'I remember who I was.' It crumbles to ash. The candles go out. You're free.

Add `<GLOBAL GAME-WON <>>`, set on victory, `<REMOVE ,PATIENT-189>`.

---

### 6. Hide the Safe Key Better

**Why:** Currently SAFE-KEY sits on top of MASSIVE-DESK. Trivial. The director's office has bookshelves described but not interactive.

**What:**
- Remove SAFE-KEY from MASSIVE-DESK.
- Add HOLLOW-BOOK object in DIRECTORS-OFFICE:
  - FDESC: "Among the medical texts, one book stands out — a red leather tome, its spine blank where all others are labeled."
  - Requires OPEN (it has a latch, not pages). Inside: SAFE-KEY.
  - READ: "The pages are glued together. It's a hollow hiding place, not a real book."
- MASSIVE-DESK-F examine text: remove mention of hidden compartment with key.

---

### 7. Room VALUE Scoring

**Why:** Gives a sense of progress. Rewarding exploration of the darkest rooms.

**What:**
| Room | VALUE | Rationale |
|------|-------|-----------|
| MORGUE | 10 | First corpse discovery |
| ISOLATION-WARD | 5 | Deep basement exploration |
| PADDED-CELL | 5 | The identity twist room |
| ELECTROSHOCK-THEATER | 8 | Horror set-piece |
| CHAPEL | 15 | Final confrontation |

---

### 8. PSEUDO Objects (Scenery Words)

**Why:** The fireplace description mentions "a bird's nest." If the player types `examine nest`, nothing happens. PSEUDO fixes this cheaply.

**What:**
- RECEPTION-ROOM gets `(PSEUDO "NEST" NEST-PSEUDO "ASHES" ASHES-PSEUDO)`
- NEST-PSEUDO: "An old bird's nest tucked into the fireplace grate. Long abandoned — like everything else here."
- ASHES-PSEUDO: "Cold grey ashes. Nothing of value."

---

### 9. Dynamic Room Description for CHAPEL (M-LOOK)

**Why:** After winning, the chapel description should change. Static LDESC can't do this.

**What:**
- Remove LDESC from CHAPEL, add `(ACTION CHAPEL-FCN)`.
- CHAPEL-FCN handles M-LOOK:
  - Before win: "The chapel is small and suffocating. Cold green light from unnatural candles makes everything look like a corpse. At the far end, before the altar, something stands perfectly still."
  - After win (GAME-WON): "The chapel is just a room now. The candles are dark. The altar is bare. Whatever was here is gone — and so is whatever held you."

---

### 10. Additional Clock Routine

**Why:** More atmospheric variety, especially for the mid-game exploration phase.

**What:**
```zil
<ROUTINE I-CREAKING ()
    <COND (<EQUAL? ,HERE ,OPERATING-THEATER ,PATIENT-WARD ,ELECTROSHOCK-THEATER>
           <TELL "The building settles with a deep structural groan, as if exhaling." CR>)>
    <RTRUE>>
```
Queue in GO: `<QUEUE I-CREAKING 9>`.

---

## Challenges in Writing ZIL Adventures

### Challenge 1: Tracking World State Across 1000+ Lines

As the file grows, it's hard to remember what objects exist, where they are, what flags they have, and how puzzles interlock.

**Solution:** ZIL file + grep is sufficient. Key queries:
- `grep "IN " horror.zil` — object locations
- `grep "GLOBAL " horror.zil` — all state flags
- `grep "VERB?" horror.zil` — all handled verbs
- `grep "IF " horror.zil` — conditional exits and their gate flags
- `grep "SETG " horror.zil` — where state changes happen

A summary tool would add overhead without adding signal. The file IS the source of truth — grep gives instant answers.

### Challenge 2: Puzzle Dependency Chains

It's easy to create dead ends where the player needs object X to reach area Y, but object X is IN area Y.

**Solution:** Draw the dependency graph mentally:
```
brass-key (RECEPTION floor) → desk-drawer → patient-file (clue only)
scalpel (OPERATING cabinet) → chains (PATIENT-WARD) → MORGUE access
valve (BASEMENT-CORRIDOR) → steam-door (FLOODING) → HYDROTHERAPY
safe-key (DIRECTORS-OFFICE book) → wall-safe → chapel-key → CHAPEL
serum (MORGUE drawers) + syringe (HYDROTHERAPY) + relic (CHAPEL box) → WIN
```
Rule: every key must be reachable BEFORE its gate. Verify with a topological sort of the dependency edges.

### Challenge 3: Verb Coverage

Players try everything. If a description says "blood-stained", they'll try SMELL. If it says "heavy", they'll try PUSH. Missing responses break immersion.

**Solution:** After writing each object's ACTION routine, re-read its LDESC and TEXT. Every adjective/noun implies verbs:
- "heavy" → PUSH, PULL, TAKE (with rejection message)
- "liquid" → DRINK, POUR
- "written" → READ
- "locked" → OPEN, UNLOCK
- "stained" → SMELL, RUB

### Challenge 4: Keeping the File Parseable

ZIL is parenthesis-heavy. One missing `)` or `>` breaks parsing silently.

**Solution:** Run the test after every batch of changes:
```bash
lua5.4 run-zil-test.lua books.blackwood-horror.walkthrough
```
The parser will report the first syntax error with a line number.

---

## Implementation Order

1. Add GLOBAL GAME-WON and WHISPER-TABLE globals
2. Add LOCAL-GLOBALS objects (SANITARIUM-BUILDING, DEAD-OAK-TREE)
3. Add GLOBAL property to rooms that reference them
4. Add FDESC to IRON-BOILER, SHOCK-CHAIR, PATIENT-189
5. Replace I-WHISPER with PICK-ONE version
6. Add I-CREAKING routine and queue it in GO
7. Modify STRAITJACKET (READBIT, new EXAMINE/READ text)
8. Modify WALL-SCRATCHES (extended READ response)
9. Rewrite PATIENT-189-F for earned ending
10. Create HOLLOW-BOOK, move SAFE-KEY into it, update MASSIVE-DESK-F
11. Add PSEUDO to RECEPTION-ROOM
12. Add VALUE to rooms (MORGUE, ISOLATION-WARD, PADDED-CELL, ELECTROSHOCK-THEATER, CHAPEL)
13. Replace CHAPEL LDESC with ACTION CHAPEL-FCN + M-LOOK handler
14. Update walkthrough test to match new win condition
15. Run test, fix any parse/logic errors
