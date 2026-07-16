# Blackwood Horror — Playtest Report

**Test Date:** July 15, 2026  
**Tested By:** Game Tester Agent  
**Game Version:** Release 1  
**Build:** ZIL (via zilscript compiler/runtime)  
**Source:** `books/blackwood-horror/`

**Walkthrough Test Result:** 134/134 PASS  
**Manual Playthrough:** Full completion achieved (twice — first attempt died to cold exposure, second attempt won)

---

## Summary

| Category | Count |
|----------|-------|
| Critical Bugs | 1 |
| High Severity | 3 |
| Medium Severity | 6 |
| Low Severity | 5 |
| Narrative Quality Issues | 7 |

---

## Critical Bugs

### Bug 1: PSEUDO Scenery Words Are Non-Functional (Parser Gap)

- **Description:** Room objects listed via `(PSEUDO ...)` directive are not parsed by the Zork1-based parser imported by this game. The PSEUDO directive was introduced in Zork3 and is not supported by the Zork1 parser. Any `PSEUDO` declaration has no effect — the words are never registered in the dictionary.

  **Affected rooms/words:**
  - **RECEPTION-ROOM:** `NEST`, `ASHES`, `ASH` — all unrecognized
  - **OPERATING-THEATER:** `INSTRUMENTS`, `SCALPELS`, `TRAYS`, `BENCHES`, `BENCH`, `TIERS` — all unrecognized

  Example conversation:
  ```
  > examine nest
  I don't know the word "nest".
  >
  > examine instruments
  I don't know the word "instruments".
  ```

- **Command:** `examine nest`, `examine instruments`, etc.
- **Expected:** The PSEUDO system should register these words as parsable object references, routing them to their designated pseudo-routines (NEST-PSEUDO, ASHES-PSEUDO, INSTRUMENTS-PSEUDO, etc.)
- **Reproduction:** Start a new game. Go to Reception Room. Type `examine nest` or `examine ashes`. Go to Operating Theater. Type `examine instruments`.
- **Severity:** High (blocks a planned atmosphere feature; see IMPROVEMENTS.md §8 which added these PSEUDO entries)
- **Root cause:** The Zork1 parser (`infocom/zork1/parser.zil`) has no PSEUDO support. PSEUDO was introduced in Zork3's parser (`infocom/zork3/gparser.zil` lines 1203-1215). The blackwood-horror game imports the Zork1 parser, so PSEUDO declarations are silently ignored.

---

## High Severity Bugs

### Bug 2: "TURN VALVE" Requires Non-Obvious Prepositional Syntax

- **Description:** The standard `turn valve` or `turn the valve` command does not work. The Zork1 parser defines `TURN` as requiring a `WITH`/`FOR`/`TO` prepositional object. Players must type `turn valve with hands` (or `turn valve with bare hands`) to operate the valve. This is extremely unintuitive — most players will try `turn valve` first.

  ```
  > turn valve
  What do you want to turn the valve for?
  >
  > turn the valve
  What do you want to turn the valve for?
  >
  > turn valve with hands
  You grip the metal valve and turn with all your strength...
  ```

- **Command:** `turn valve`, `turn the valve`
- **Expected:** `turn valve` should work without additional preposition. The parser should accept `TURN <object>` as a valid syntax when the object has the `TURNBIT` flag. The walkthrough.md even says "turn valve" in step 33 — a test that new players following the walkthrough would fail.
- **Reproduction:** After reaching BASEMENT-CORRIDOR with the valve, type `turn valve`.
- **Severity:** High (core puzzle is undiscoverable via natural commands)
- **Root cause:** Zork1 syntax.zil defines TURN as `TURN <obj> WITH <obj>`, `TURN <obj> TO <obj>`, and `TURN <obj> FOR <obj>`. There is no bare `TURN <obj>` syntax. See `infocom/zork1/syntax.zil` lines 505-514.

### Bug 3: Cold Exposure Death Is Too Easy to Trigger, Only Death State

- **Description:** The cold-exposure daemon (I-COLD-EXPOSURE, actions.zil lines 1211-1225) ticks every turn in MORGUE, FLOODING-CHAMBER, and HYDROTHERAPY-ROOM. On my first playthrough, I died after just ~12 turns in cold rooms total. The death threshold is 11+ exposure ticks (warning at 4, severe at 8, death at 12). But the game requires multiple visits to these rooms: you must enter MORGUE to get the serum + journal (2+ turns), then later visit FLOODING-CHAMBER + HYDROTHERAPY-ROOM for the syringe puzzle (3+ additional turns). On my first playthrough I died simply by taking the normal walkthrough route.

  Additionally, this is the **only** death state in the entire game. There are no deaths for:
  - Electrocution (touching the shock machine/chair)
  - Patient-189 aggression
  - Falling/flooding
  - Using ether/serum incorrectly

- **Command:** Any movement or action in MORGUE, FLOODING-CHAMBER, or HYDROTHERAPY-ROOM
- **Expected:** Either longer exposure tolerance (15-20 turns before death), or at least a warming mechanic (returning to the boiler room should reset exposure). And ideally more death states for a horror game.
- **Reproduction:** Follow the walkthrough quickly — the morgue section alone takes 3-5 turns, then basement takes another 3-4 turns in flooding/hydrotherapy areas. Total cold exposure is ~8-10 on a normal playthrough.
- **Severity:** High (first-time players will likely die without warning and lose progress)

---

## Medium Severity Bugs

### Bug 4: Atmospheric Clock Events Fire After Game Win

- **Description:** After the game is won (GAME-WON = T), all clock-driven atmospheric events continue to fire. The whisper, cold draft, and other clock routines still trigger in the chapel and other rooms. The player sees messages like "A voice, barely audible, rasps: 'help... me...'" and "A cold draft makes you shiver" in a chapel that should be "just a room now" with "ordinary, living air."

  ```
  (After winning, in chapel)
  > look
  The chapel is just a room now...
  
  (On next turn)
  A voice, barely audible, rasps: 'help... me...'
  A cold draft makes you shiver, though there are no open windows.
  ```

- **Commands:** Any action after GAME-WON is set
- **Expected:** Clock routines should check GAME-WON and skip their output. The ending text says "The air suddenly smells like rain and grass — ordinary, living air" — atmospheric horror events contradict this.
- **Reproduction:** Win the game, then take one more turn.
- **Severity:** Medium (breaks immersion in the ending moment)

### Bug 5: CHAPEL-DOOR LDESC Does Not Update When Unlocked

- **Description:** After unlocking the chapel door (CHAPEL-UNLOCKED = T), the room M-LOOK correctly shows "The chapel door stands open, darkness visible beyond." But the object LDESC for CHAPEL-DOOR still says "The chapel door is secured with a heavy lock." Both descriptions are shown in `look` output — the correct dynamic one and the incorrect static one, creating a contradiction.

  ```
  > look
  Overgrown Garden
  Broken benches lie among the overgrowth. A stone path, barely visible,
  leads to a small chapel to the north. The chapel door stands open,
  darkness visible beyond.        ← correct (from room M-LOOK)
  ...
  The chapel door is secured with a heavy lock.   ← incorrect (object LDESC)
  ```

- **Command:** `look` in OVERGROWN-GARDEN after unlocking the door
- **Expected:** The LDESC of CHAPEL-DOOR should reflect the unlocked state (e.g., "The chapel door stands open, darkness visible beyond.") or the object should use `NDESCBIT` flag to suppress its LDESC when state changes.
- **Reproduction:** Unlock the chapel door, then `look` in OVERGROWN-GARDEN.
- **Severity:** Medium (contradictory state display)

### Bug 6: GREEN-CANDLES LDESC Does Not Update After Game Win

- **Description:** After winning, the GREEN-CANDLES object's LDESC still says "Candles burn with an unnatural green flame." The room description correctly says "The candles are dark," but the listed object still describes green flames.

  ```
  > look
  The chapel is just a room now. The candles are dark. ← correct
  ...
  Candles burn with an unnatural green flame. ← incorrect
  ```

- **Command:** `look` in CHAPEL after GAME-WON
- **Expected:** Either the candle LDESC should update or the object should have NDESCBIT after the win
- **Severity:** Medium (contradicts the ending description)
- **Note:** The object's EXAMINE handler does check GAME-WON and returns correct text, but the LDESC shown in the room listing does not.

### Bug 7: BELL Ringing Message Is Location-Invariant

- **Description:** Ringing the bell (BELL-F) always says "The tinny sound echoes through the empty cafeteria. No one comes." — even when the player is in the chapel or other rooms. The bell's action routine doesn't check the current room context.

  ```
  (In Chapel)
  > ring bell
  You ring the bell. The tinny sound echoes through the empty cafeteria.
  No one comes.
  ```

- **Command:** `ring bell` while in a room other than CAFETERIA
- **Expected:** The message should be context-aware: "You ring the bell. The tinny sound echoes through the chapel" or similar.
- **Severity:** Medium (immersion break, but the bell is an optional fluff item)

### Bug 8: Disambiguation on "KEY" When Multiple Keys in Inventory

- **Description:** When the player holds multiple keys (brass key, safe key, chapel key), commands like `drop key` or `unlock safe with key` trigger disambiguation prompts. This is acceptable behavior, but the walkthrough.md doesn't account for it, and new players may be confused. Specifically:
  - `drop key` in Director's Office (after opening safe) disambiguates between safe key and chapel key
  - `take key` from the reception floor works fine (only one key present)
  - `take key` from the hollow book also works (only safe key)
  - But then the player must type `take chapel key` explicitly after dropping the safe key

- **Actually observed behavior:** The test walkthrough uses separate `drop key` commands after each key usage, which avoids disambiguation by keeping only one key at a time. But following the non-test walkthrough (horror-walkthrough.md) would lead to confusion at disambiguation prompts.
- **Severity:** Medium (documentation mismatch, could confuse players)

### Bug 9: "TAKE VIAL" Disambiguates But Synonyms Are Unclear

- **Description:** When both STRANGE-SERUM and MORPHINE-VIAL are in scope (serum in inventory, morphine in medical bag in inventory), `take vial` triggers: "Which vial do you mean, the morphine vial or the vial of serum?" The player might not know MORPHINE-VIAL exists (they never examined the bag contents). Similarly `examine papers` disambiguates between SCATTERED-PAPERS and MEDICAL-RECORDS when both are present.

- **Severity:** Medium (acceptable parser behavior but potentially confusing)

---

## Low Severity Bugs

### Bug 10: "CLIMB TREE" Returns Generic "You can't do that!" Instead of Custom Message

- **Description:** DEAD-OAK-TREE-F has a `<VERB? CLIMB>` handler, but the parser routes `climb tree` to the generic "You can't do that!" response instead of using the custom CLIMB handler in the object's action routine. This is because the Zork1 parser doesn't recognize CLIMB as a verb with standard syntax.

- **Command:** `climb tree` at SANITARIUM-GATE or OVERGROWN-GARDEN
- **Output:** "You can't do that!"
- **Expected:** "The lower branches are too high to reach, and you have no desire to scramble up a dead tree in an abandoned sanitarium grounds."
- **Reproduction:** Go to SANITARIUM-GATE, type `climb tree`
- **Severity:** Low (minor immersion break)

### Bug 11: "LISTEN" Verb Parsing Issues

- **Description:** `listen` (without object) prompts "What do you want to listen for?" — the parser doesn't recognize bare LISTEN. `listen to tree` doesn't reach the DEAD-OAK-TREE handler (but `listen to crows` does, via the CROWS synonym). The bare LISTEN verb should probably produce a room-specific ambient sound description.

- **Commands:** `listen`, `listen to tree`
- **Output:** 
  - `listen` → "What do you want to listen for?"
  - `listen to tree` → no visible output (parser mismatch)
  - `listen to crows` → "The crows in the upper branches are utterly silent. They watch you."
- **Severity:** Low

### Bug 12: "SMELL" Without Object is Unhandled

- **Description:** `smell` asks "What do you want to smell?" — but many rooms mention smells in their descriptions (entrance hall "reeks of mildew", storage room "sour smell", padded cell "reeks of decay"). A bare SMELL command should produce room-specific ambient scent text.

- **Command:** `smell`
- **Output:** "What do you want to smell?"
- **Expected:** Room-specific scent description (e.g., "The air is thick with mildew and decay.")
- **Severity:** Low

### Bug 13: "SIT" Without Object is Awkward

- **Description:** `sit` asks "What do you want to sit with?" — which is strange. In Zork1, `sit` without object is not a recognized syntax.

- **Command:** `sit`
- **Output:** "What do you want to sit with?"
- **Expected:** Either "You sit down on the floor." or a better prompt
- **Severity:** Low

### Bug 14: "HELLO" Triggers Game Quit Instead of Helpful Response

- **Description:** The Zork1 convention where typing `hello` (without SAY) triggers `Goodbye.` and quits the game is disorienting for new players. The game has a custom `V-SAY-HELLO` for `say hello`, but bare `hello` still quits. This is a Zork1 legacy behavior.

- **Command:** `hello`
- **Output:** "Goodbye." (game exits)
- **Expected:** Either redirected to the SAY HELLO logic, or a gentle "If you want to greet someone, try SAY HELLO."
- **Severity:** Low (annoying but documented Zork1 behavior)

---

## Narrative Quality Issues

### Issue 1: Overuse of Emotion-Label Adjectives ("Show, Don't Tell")

Several room and object descriptions use emotion-label adjectives instead of concrete sensory details:

- OPERATING-THEATER LDESC: "The air here is thick with an **oppressive dread**." — tells the emotion rather than evoking it
- MORGUE LDESC: "This place **feels wrong**, as though something lingers here still." — tells the feeling
- SHOCK-CHAIR-F: "You **feel sick looking at it**." — tells the emotion
- PADDED-CELL LDESC: "The small room **reeks of decay**." — OK, smell is sensory, but "reeks of decay" appears verbatim in STORAGE-ROOM too: "A sour smell permeates the air" — more concrete but "sour" is still a label

By contrast, the strongest descriptions use concrete detail:
- OPERATING-TABLE FDESC: "A single overhead lamp, long dead, still points down at the table like an accusation." — good
- MIRROR-F: "In the glass, your reflection is barely visible — a dark shape that seems to shift when you try to focus on it." — excellent

**Recommendation:** Replace "oppressive dread" with specific physical sensations (e.g., "The air here is still and heavy, as if the room itself holds its breath.")

**Affected files:** `dungeon.zil` lines 67, 84; `actions.zil` lines 388, 404

### Issue 2: Uniformly Grim Tone with No Contrast

The game is 100% grim — every room is decaying, rotting, or stained. There are no moments of beauty, humor, or warmth. Per the Infocom standards (skills/04_content_writing_and_npc_layer.md), horror needs contrast to land effectively. The IMPROVEMENTS.md (§16) identifies this issue explicitly.

**What's missing:**
- A moment of beauty (moonlight in the garden, a single flower)
- A moment of dark humor (the "Employee of the Month" photo idea from IMPROVEMENTS.md)
- A moment of warmth (child's drawing is the closest, but it's framed as "would be sweet if..." — the gratitude is hypothetical)

**Recommendation:** Implement the tonal range improvements from IMPROVEMENTS.md §16. The child's drawing is a good start but should not be prefaced with "it would be sweet if you didn't know" — let it be genuinely sweet, then let the context make it poignant.

**Affected files:** `dungeon.zil` (all room LDESCs), `actions.zil`

### Issue 3: Too Many Readables, Not Enough Environmental Story

The game has 12+ readable objects (plaque, file, journal, records, notebook, logbook, notes, padding, scratches, jacket, scattered papers, child-drawing). Many deliver the same information from different angles — Patient 189 is described as "resistant to pain" or violent in 4-5 separate documents.

**Per the walkthrough.md's own description:** "Learns about Patient 189's transfer to isolation" (file), "learn about the terrible experiment" (journal), "learn about Patient 189" (records), "learn about water torture" (notebook), "learn about Patient 189's treatment Session 47" (logbook), "learn Patient 189 transcended death" (notes).

A better approach per Infocom standards: show the story through observation of the environment, not just text dumps. The padded cell message on the wall and the wall scratches are good examples of environmental storytelling — there should be more of that and fewer papers.

### Issue 4: The "You Are Patient 189" Twist Is Telegraphed But Never Landed

The game sets up the identity twist through:
1. Straitjacket with your name (dated 1947)
2. Wall scratches with "YOU ARE 189" in your handwriting
3. Logbook saying patient "claims to be someone else"
4. Mirror showing reflection that shifts

But these clues don't affect the ending! Whether or not you've read any of them, the ending text says: "Its eyes pass over you without recognition. You freed it, but it never knew you." This phrasing completely misses the identity twist — if "you" are Patient 189, then the figure being freed IS you, and there should be a different ending path.

**The PATIENT-189-RESOLUTION-F does check PATIENT-LORE:** if `PATIENT-LORE > 2`, the entity "looks at you with recognition — not as a stranger, but as someone who understands what it endured." But this is framed as the entity recognizing *you*, not as you recognizing *yourself*.

**Recommendation:** If the player has discovered all three identity clues (PATIENT-LORE >= 3), the ending text should change significantly — perhaps the entity doesn't crumble but merges with the player, or the player realizes they ARE Patient 189 and the chapel was their prison all along.

### Issue 5: No Choice in the Ending

The ending is completely linear — `say hello` with the three items produces the same result every time. There's no choice, no alternate resolution, no moral decision. Classic Infocom games often had multiple endings or choices in the finale.

**Potential alternate endings:**
- Inject yourself with the serum instead (death ending)
- Destroy the relic instead of using it
- Leave without freeing Patient 189 ("You walk away. The chapel waits.")

### Issue 6: Patient 189 Has Limited Behavioral Depth

Patient 189 has:
- EXAMINE responses (2 stages based on PATIENT-STATE)
- TELL handlers for 5 topics (Mordecai, treatment, identity, sanitarium, chapel)
- ATTACK/KILL prevention
- Post-win removal
- The I-PATIENT-AUTONOMY movement clock

This is good! But:
- TELL only works via `tell patient about <topic>`, not `ask patient about <topic>` — the latter gives "Those things aren't here!"
- No dialogue tree progression — each topic fires once (with a repeat response) and doesn't build toward anything
- No consequence for bringing the relic early vs late (PATIENT-STATE tracks lore but the ending check is just "do you have the items")

**Recommendation:** Add ASK synonyms, and make the topic responses reference each other (e.g., asking about Mordecai first changes what happens when you ask about treatment).

### Issue 7: Several Described Scenery Items Are Invisible to Parser

Beyond the PSEUDO bug (Bug 1), these items are mentioned in room descriptions but have no parser-recognized synonyms:
- **"rusted iron gates"** at SANITARIUM-GATE — `examine gate` → "I don't know the word 'gate'"
- **"grand staircase"** at SANITARIUM-ENTRANCE — no synonym
- **"coal dust"** at BOILER-ROOM — no synonym
- **"broken stone benches"** in OVERGROWN-GARDEN — no synonym (though "benches" should route to DEAD-GARDEN)

---

## Narrative Strengths

1. **Strong environmental storytelling moments:**
   - The wall scratches in Isolation Ward ("PATIENT 189 STILL ALIVE IN THE CHAPEL")
   - The padded cell blood message
   - The straitjacket with the name tag
   - The child's drawing with "HOME"
   - The dissection table bundle hinting at Patient 237

2. **FDESC discovery moments:** Several objects have excellent FDESC entries that fire on first visit — the operating table, the shock chair, the iron boiler, the canvas bundle, the ancient relic, and Patient 189. These add genuine "wow" moments.

3. **Clock-driven atmosphere system:** Multiple clock routines (whispers, footsteps, flickering shadows, cold drafts, creaking, boiler heat, cold exposure, patient autonomy) create a living world. The implementation is sophisticated for a ZIL game.

4. **Progressive lore tracking:** PATIENT-LORE counter and PATIENT-STATE give the game awareness of how much the player has discovered, affecting later dialogs and the ending.

5. **Parser responses for unusual verbs:** The game handles RUB (on multiple objects), PRAY (on pews/relic), RING/SHAKE (bell), SIT (on shock chair), BOARD (on shock chair), ATTACK (on chains/portrait), SWING (shovel), DIG (garden with shovel), etc. — good verb coverage.

6. **Boiler heat puzzle:** The multi-state boiler system (coal → fuel → kindle → heat → thaw cabinet) is the most sophisticated puzzle in the game and works well mechanically.

7. **Earned ending with staged rejections:** The SAY HELLO handler checks three states — no relic, relic without serum, and full set — with escalating hints. This is a well-designed progressive puzzle.

---

## Specific Improvement Recommendations

### Critical Fix: PSEUDO Support
- **File:** `books/blackwood-horror/dungeon.zil` lines 62, 70
- **Issue:** PSEUDO declarations are dead code — not supported by the imported Zork1 parser.
- **Fix:** Either (a) port PSEUDO handling from the Zork3 parser (`infocom/zork3/gparser.zil` lines 1203-1215) into the game's own parser additions, or (b) replace PSEUDO with actual OBJECT declarations for scenery items with `NDESCBIT` flag and appropriate action routines.

### High Priority Fix: TURN Verb Bare Syntax
- **File:** `infocom/zork1/syntax.zil` (or game-specific syntax additions)
- **Issue:** No `TURN <object>` syntax exists in the Zork1 verb set.
- **Fix:** Add `<SYNTAX TURN OBJECT (FIND TURNBIT) (HELD CARRIED ON-GROUND IN-ROOM) = V-TURN PRE-TURN>` to the game's own `syntax.zil` override file or to `actions.zil`.

### High Priority Fix: Cold Exposure Balance
- **File:** `books/blackwood-horror/actions.zil` lines 1211-1225
- **Issue:** Death threshold at 12 ticks is too tight for a normal playthrough. Current tick increments every turn in MORGUE, FLOODING-CHAMBER, and HYDROTHERAPY-ROOM.
- **Fix:** Either (a) increase death threshold to 20+, (b) add a reset mechanic (returning to boiler room or entrance hall resets counter), (c) add warming objects (the lit lantern could halve cold accumulation), or (d) delay the clock to tick every 2 turns instead of every turn.

### Medium Priority Fix: Post-Win Clock Deactivation
- **File:** `books/blackwood-horror/actions.zil` lines 1162-1191
- **Issue:** I-WHISPER, I-FOOTSTEPS, I-FLICKERING, I-COLD-DRAFT, I-CREAKING don't check GAME-WON.
- **Fix:** Add `<COND (,GAME-WON <RTRUE>)>` at the start of each routine, or add a wrapper in the GO entry point that disables clock queues when the game ends.

### Medium Priority Fix: Dynamic LDESC for CHAPEL-DOOR and GREEN-CANDLES
- **File:** `books/blackwood-horror/dungeon.zil` lines 842-848 (CHAPEL-DOOR), 858-865 (GREEN-CANDLES)
- **Issue:** Static LDESCs don't update with game state.
- **Fix:** Remove LDESC from these objects and rely entirely on their ACTION routines for descriptions (like PADDING and other objects that don't have LDESCs), or use FCLEAR/FSET of NDESCBIT to control visibility.

### Low Priority: Descriptive Verb Handlers
- **File:** `books/blackwood-horror/actions.zil`
- **Add bare SMELL handler** that checks room for ambient scents based on location
- **Add CLIMB handler registration** (SYNTAX CLIMB OBJECT = V-CLIMB) so DEAD-OAK-TREE-F's CLIMB handler can fire
- **Add SIT without object handler** that gives room-specific resting description

### Narrative: Ending Variation Based on Lore Discovery
- **File:** `books/blackwood-horror/actions.zil` lines 623-647
- **Issue:** The ending has only two variants (PATIENT-LORE > 2 vs not), and neither fully lands the identity twist.
- **Fix:** Add a third path when PATIENT-LORE >= 5 (all identity clues found + all TELL topics discussed) where the ending text directly references "remembering who you were" in the first person.

---

## Playthrough Summary

| Metric | Value |
|--------|-------|
| Rooms visited | 17/22 (all accessible rooms) |
| Items collected | 24 unique items (full playthrough) |
| Puzzles solved | 8/8 (all: key puzzles, steam valve, chains, boiler, safe, chapel door, box, ending) |
| Deaths encountered | 1 (cold exposure on first playthrough) |
| Walkthrough completion | SUCCESS (134/134 automated tests passed) |
| Manual completion | SUCCESS (full ending achieved on second playthrough) |
| Cold exposure deaths first playthrough | Yes (spent ~12 cumulative turns in morgue + flooding chamber + hydrotherapy) |
| Game-winnable | Yes, with the standard route |

### Save file used during manual testing
- `/tmp/blackwood-test.sav` (full completion)
- `/tmp/blackwood-test2.sav` (edge case testing)

---

*Report generated by game tester agent*
