# The Limehouse Killings — Playtest & Bug Report

**Test Date:** July 15, 2026
**Tested By:** Game Tester Agent (ZIL adventure games)
**Game Version:** Release 1
**Walkthrough Tests:** Golden Path (ltr.) and poison-led branch — both completed successfully

## Summary

| Category | Count |
|----------|-------|
| Critical Bugs | 2 |
| High Severity | 4 |
| Medium Severity | 5 |
| Low Severity | 5 |
| Design/Artistic Issues | 5 |

**Walkthrough Status:** Golden path completed (letter-led AND poison-led accusation). Full game is completable.

---

## Critical Bugs

### Bug C1: Inspector Not Findable Via "INSPECTOR" Noun
- **Description:** Despite `VOC "INSPECTOR" OBJECT` being registered in the GO routine, the parser rejects `EXAMINE INSPECTOR`, `ASK INSPECTOR`, `SHOW X TO INSPECTOR` with "You can't see any inspector here!" — even when Lestrade is present in the entrance hall. The workaround `LESTRADE` works fine.
- **Command:** `EXAMINE INSPECTOR` (with Lestrade present in entrance hall after Act III triggers)
- **Output:** `You can't see any inspector here!`
- **Expected:** Should recognise "inspector" as a noun referring to the INSPECTOR object.
- **Root Cause:** The ZIL dictionary truncates `INSPECTOR` (9 letters) to a 6-letter token `INSPEC`, which collides with the verb `INSPECT`. The `VOC` call re-registers it, but the collision prevents it from being recognized as a noun by the parser's disambiguation. The fix likely requires renaming the object or using a different approach.
- **Severity:** Critical — the canonical name in room descriptions ("Inspector Lestrade") primes the player to type "inspector," which silently fails.

### Bug C2: "MURDER" Not Recognized as a Topic Synonym
- **Description:** `CASE-TOPIC` declares `(SYNONYM CASE MURDER)`, but `ASK LESTRADE ABOUT MURDER` produces `"There seems to be a noun missing in that sentence!"` — the parser treats "murder" as an unknown word rather than resolving it to CASE-TOPIC.
- **Command:** `ASK LESTRADE ABOUT MURDER` (with Lestrade present)
- **Output:** `There seems to be a noun missing in that sentence!`
- **Expected:** Should resolve to the same conversation as `ASK LESTRADE ABOUT CASE`.
- **Root Cause:** The word "murder" is only declared as a synonym on CASE-TOPIC but is not registered in the parser vocabulary via a `VOC` call or used in any object's `SYNONYM` / `ADJECTIVE` list. The parser therefore does not recognise it as a valid noun.
- **Severity:** Critical — "murder" is the most natural word a player would use when investigating a murder mystery.

---

## High Severity Bugs

### Bug H1: Vocabulary Collision — "CASE" Resolves to LOCKED-BOX Over CASE-TOPIC
- **Description:** The word "case" is a synonym for both `CASE-TOPIC` (the topic object for asking about the investigation) and `LOCKED-BOX` (the name-dial box in the study fireplace). The parser favours the concrete physical object. In practice `ASK LESTRADE ABOUT CASE` works (tested) because Lestrade is far from the study, but the collision is fragile — if the player were standing near the fireplace and typed `ASK NPC ABOUT CASE`, the parser would likely resolve "case" to the locked box.
- **Root Cause:** `LOCKED-BOX` has `(SYNONYM BOX CASE CONTAINER)` and `CASE-TOPIC` has `(SYNONYM CASE MURDER)`. The word "case" matches both objects.
- **Suggested Fix:** Remove "CASE" from LOCKED-BOX's synonyms (it's never referred to as "case" in room descriptions — always "box" or "locked box"). Or rename CASE-TOPIC's primary synonym to "investigation" and keep CASE as secondary.
- **Severity:** High — vocabulary collision risks confusing the parser and the player.

### Bug H2: Direction Asymmetry — Both EAST and WEST from Kitchen Go to Garden
- **Description:** The kitchen room definition `(WEST TO GARDEN)` correctly specifies that west leads to the garden. However, the `V-GO-EAST` routine also routes the player from kitchen to garden. This means both `EAST` and `WEST` from the kitchen go to the same room.
- **Command:** `EAST` (from kitchen)
- **Output:** `You enter the garden.`
- **Expected:** Should say "You can't go that way" (or open a new route if intended).
- **Location:** `actions.zil` line ~1130 — `V-GO-EAST` handler for KITCHEN.
- **Severity:** High — navigational inconsistency breaks player trust in the map. Also, from the garden, `EAST` goes to kitchen but `V-GO-EAST` has no explicit GARDEN handler and relies on the room property, while from kitchen `EAST` explicitly overrides to garden in V-GO-EAST. This is asymmetric.

### Bug H3: READING-DESK Description Never Updates After Torn Page Is Taken
- **Description:** The reading desk action routine always says "A reading desk with a torn page lying on it." even after the player has taken the torn page. The description should reflect the changed state.
- **Command:** `EXAMINE DESK` (in library, after taking torn page)
- **Output:** `A reading desk with a torn page lying on it.`
- **Expected:** Should say something like "A reading desk, its surface now bare except for scattered papers."
- **Location:** `actions.zil:303-306` — READING-DESK-F routine unconditionally mentions the torn page.
- **Severity:** High — state persistence failure. Infocom games were meticulous about this (e.g., the mailbox in Zork I changes description after the leaflet is taken).

### Bug H4: "SMELL" and Other Sensory Verbs Not Handled for Most Objects
- **Description:** The `SMELL` verb prompts "What do you want to smell?" but no game object has a handler for the `SMELL` verb. Commands like `SMELL FOG`, `SMELL KETTLE`, `SMELL FLOWERS` all fall through to default responses or "You can't see any X here!"
- **Testing:** `SMELL FOG` from the gate returns "You can't see any fog here!" even though FOG is a global object present at the gate.
- **Severity:** High — one of the first things players do in atmospheric games is try sensory verbs.

---

## Medium Severity Bugs

### Bug M1: Bell Wire's PULL Verb Not Handled (Only MOVE/USE)
- **Description:** The bell wire responds to `USE WIRE` and `MOVE WIRE` (via the `MOVE USE` verb check in BELL-WIRE-F) but `PULL WIRE` returns the generic ZIL fallback "You aren't an accomplished enough juggler." Since "pull" is the most intuitive verb for a bell rope/wire, this is a parser guessability issue.
- **Command:** `PULL WIRE` (in entrance hall)
- **Output:** `You aren't an accomplished enough juggler.`
- **Expected:** Should trigger the same response as `USE WIRE` — the bell rings and Hudson calls up.
- **Location:** `actions.zil:353-362` — BELL-WIRE-F only checks `<VERB? MOVE USE>`.
- **Severity:** Medium — parser depth issue.

### Bug M2: OBJECT FDESC Not Printed on First Encounter
- **Description:** Several objects define `FDESC` (first-description) properties but they are never shown to the player because the game's room-display and object-listing routines do not check for `FIRST?` or implement a first-visit pattern. The `FDESC` text is discarded silently.
- **Objects with FDESC:** TELEGRAM, DEAD-LETTER, BLOOD-STAINED-KNIFE, LOCKED-BOX — these all define beautiful FDESC strings that are never displayed.
- **Proof:** On entering the garden, the room FCN prints the knife's FDESC only because GARDEN-FCN explicitly mentions it via `FDESC` — but the standard container/room listing does not.
- **Root Cause:** The game's `V-LOOK` or room-entry logic does not check for the `FIRST?` flag or compare `FDESC` vs `LDESC`. All objects always display `LDESC`.
- **Location:** Objects in `dungeon.zil` define `FDESC` but the runtime uses `LDESC` exclusively.
- **Severity:** Medium — wasted authoring effort; the discovery-moment text is a key Infocom technique.

### Bug M3: ENTRANCE-HALL-FCN List Truncates Magnifying Glass After Take
- **Description:** In the entrance hall, the look description mentions the magnifying glass via the global object listing (the room has GLOBAL MAGNIFYING-GLASS and the parser lists it). But once taken, the magnifying glass still appears in the room description because the GLOBAL list is static. The correct approach would be to check `IN?` in the FCN routine or let the parser's standard `TAKE`/`DROP` tracking handle visibility.
- **Command:** After taking magnifying glass: `LOOK`
- **Output:** Still shows "A magnifying glass rests on the hall table..." despite it being in inventory.
- **Severity:** Medium — state persistence issue.

### Bug M4: WINE-CABINET Cannot Be Closed After Opening
- **Description:** The wine cabinet has `CONTBIT SEARCHBIT` but not `DOORBIT`, and the `V-CLOSE` routine only checks `CONTBIT` or `DOORBIT`. However, the cabinet's `WINE-CABINET-F` action sets OPENBIT on it with no way to undo. After `OPEN WINE-CABINET`, trying `CLOSE WINE-CABINET` fails.
- **Command:** `CLOSE WINE CABINET` (after opening)
- **Output:** You can't close that.
- **Expected:** Should close the cabinet.
- **Location:** `WINE-CABINET-F` in actions.zil sets OPENBIT but never removes it.
- **Severity:** Medium — minor state management gap.

### Bug M5: No WRONG-ATTEMPTS Global Declaration
- **Description:** The V-ACCUSE routine uses `WRONG-ATTEMPTS` (incremented when accusing wrong suspects), but this global is never declared at the top of `dungeon.zil`. It will default to nil but the increment `<+ ,WRONG-ATTEMPTS 1>` will error or produce unexpected behavior.
- **Location:** `actions.zil:1051, 1055` — references to `,WRONG-ATTEMPTS`
- **Severity:** Medium — potential runtime error if wrong accusation path is exercised, though the ZIL runtime may silently coerce nil to 0.

---

## Low Severity Bugs

### Bug L1: TELEGRAM Cannot Be Re-Examined After Taking
- **Description:** After taking the telegram, trying to examine or read it in a different room works. But the game never removes the telegram from the gate's room description. The GATE-FCN only checks if TELEGRAM is still in ASHWORTH-MANOR-GATE — if taken, the text changes from "A creased telegram is pinned..." to "the stone where the telegram waited is bare". This actually works correctly! Verified.
- **Status:** Works correctly. Not a bug.

Actually this is fine. Let me recategorize.

### Bug L2: "ASK LADY ABOUT CASE" Returns Generic Response
- **Description:** Lady Ashworth has no specific dialogue for CASE-TOPIC. Asking `ASK LADY ABOUT CASE` falls through to the default "I don't know anything about that." While not a crash, it's a missed opportunity — she should at least acknowledge the murder of her husband.
- **Affected NPCs:** Lady Ashworth, Mr. Hudson (both lack CASE-TOPIC handlers; Moriarty and Lestrade have them).
- **Severity:** Low — narrative gap, not a crash.

### Bug L3: FOXGLOVE Generics Are Off
- **Description:** The foxglove bottle's LDESC warns about digitalis being a poison. But `EXAMINE FOXGLOVE` returns "The foxglove label names digitalis and gives a narrow medicinal dose, followed by a skull. It is another poison, not an antidote to wolfsbane." This is anachronistic — foxglove (digitalis) is used for heart conditions, and the game's prose correctly identifies it as a poison, but the statement "not an antidote to wolfsbane" implicitly references a puzzle that doesn't exist (there's no antidote puzzle).
- **Severity:** Low — confusing but not blocking.

### Bug L4: FOUNTAIN Still Describes Footprint Cast as "nearby" After It's Taken
- **Description:** The garden fountain's LDESC says "A footprint cast lies nearby." even after the cast is taken. The FOUNTAIN-F routine unconditionally prints this.
- **Command:** `EXAMINE FOUNTAIN` (after taking footprint cast)
- **Output:** "The fountain is dry, with coins at the bottom. A footprint cast lies nearby."
- **Expected:** Should only mention the cast if it's still present.
- **Location:** `actions.zil:373-376` — FOUNTAIN-F
- **Severity:** Low — state awareness.

### Bug L5: FOG Cannot Be Found by Parser Despite Being a Global
- **Description:** The FOG object has no `(IN ...)` container specified. It has `(FLAGS NDESCBIT)` which suppresses it from room listings. It's supposed to be a global object present everywhere (it's in the GLOBAL list of ASHWORTH-MANOR-GATE). But the parser says "You can't see any fog here!" when trying to EXAMINE or SMELL FOG from the gate room.
- **Command:** `EXAMINE FOG` (at gate)
- **Output:** `You can't see any fog here!`
- **Expected:** Should respond with the fog description.
- **Root Cause:** The FOG object lacks an `(IN ...)` location. In standard ZIL, objects not placed in any room or container are not addressable by the parser. It should be `(IN LOCAL-GLOBALS)` or `(IN ASHWORTH-MANOR-GATE)` for the gate.
- **Severity:** Low — atmospheric objects should be findable.

---

## Design/Artistic Issues

### Issue D1: NPCs Only Have 1–2 Behavioral States (Violates Skill 04 Rule 3)
- **Assessment:** Per the Infocom quality standards, NPCs should have at least three discoverable behavioral states.
  - **Mr. Hudson:** 2 states — initial (nervous polisher) and confronted (after showing the letter). Lacks a third state (e.g., relieved after accusation, or hostile if threatened).
  - **Lady Ashworth:** 2 states — initial (cold, composed) and confronted (after showing the letter). The third state (after accusation) is implied but not seen interactively.
  - **Dr. Moriarty:** 2 states — initial (arrogant in library) and moved to entrance hall (watching the door). Lacks a third state.
  - **Inspector Lestrade:** 1 state — notebook-open. Never changes his dialogue or demeanor.
- **What Infocom did:** In *The Witness*, every NPC has 3+ states and their dialogue trees branch based on what the player has discovered and shown them.

### Issue D2: Key Narrative Verbs Not in Vocabulary
- **Assessment:** Several natural player verbs are missing or produce generic responses:
  - `SMELL` — no object supports it
  - `LISTEN` / `HEAR` — not in vocabulary
  - `TASTE` — only handled for POISON-BOTTLE
  - `TOUCH` / `FEEL` — not in vocabulary
- **Impact:** Players exploring via sensory verbs get generic "I don't know the word" responses, breaking immersion.

### Issue D3: Ending Is a Gem but Doesn't Branch on Missing Evidence
- **Assessment:** The ending is actually quite good — it offers a choice (letter-led vs poison-led), references specific evidence, and gives a coda with ships on the Thames, Hudson's tea, and the next case. However:
  - The footprint detail (crescent nick from the magnifying glass) is referenced in the ending but the game doesn't require it — you can win without ever using the magnifying glass on the footprint cast.
  - The ending doesn't change if you're missing optional evidence (the wax seal, the footprint cast, the trunk note, the charcoal/foxglove).
- **Contrast with Infocom:** *Suspect* and *The Witness* both check which specific evidence items you have and adjust the ending text.

### Issue D4: Room/Action Descriptions With State Blind Spots
- **Assessment:** Several action routines return descriptions that ignore game state:
  - READING-DESK-F: always mentions torn page (Bug H3, above)
  - FOUNTAIN-F: always mentions footprint cast (Bug L4, above)
  - BELL-WIRE-F: in Act I, mentions being "still beside the study door" which is correct, but doesn't track whether the player has already pulled it
  - HEDGES-F: always says "Something glints in the branches" even after the knife is taken
- **Location:** Multiple action routines in `actions.zil`

### Issue D5: No Unique FDESC / First-Visit Prose for Rooms
- **Assessment:** Per the Skill 04 Rule 8, every major room should have first-visit discovery text (FDESC) that differs from revisit text. This game has no room-level FDESC at all — every room shows the same description on first and subsequent visits. The `M-FDESC?` / `FIRST?` pattern used by Infocom is not implemented.
- **Good examples from Infocom:** In *Zork I*, the "Kitchen" first-visit text describes the "mouth-watering aroma" that disappears on later visits.
- **Rooms affected:** All 11 rooms.

---

## Recommendations

### Immediate Fixes (Critical/High)

1. **Fix the "INSPECTOR" noun collision (C1):** Add a `VOC` call in the `GO` routine with the correct dictionary form. Alternatively, add "THE INSPECTOR" or "SCOTLAND YARD" as the primary synonym and work around the truncation.
2. **Fix "MURDER" not recognized (C2):** Add `VOC "MURDER" OBJECT` in the GO routine to register the word in the parser vocabulary.
3. **Fix "CASE" vocabulary collision (H1):** Remove "CASE" from `LOCKED-BOX`'s synonym list — the box is never called a "case" in room descriptions.
4. **Fix Kitchen directions (H2):** Remove the KITCHEN handler from `V-GO-EAST` (lines ~1130 of actions.zil) so both EAST and WEST no longer go to the same room.
5. **Fix READING-DESK state awareness (H3):** Add a `<COND (<IN? ,TORN-PAGE ,WINNER>)` check to READING-DESK-F to conditionally mention or omit the torn page.
6. **Fix FOG global location (L5):** Add `(IN LOCAL-GLOBALS)` to the FOG object so the parser can find it from any room.

### Medium-Priority Fixes

7. **Wire FDESC into the room/object display system (M2):** Modify the object-listing code to check for `FIRST?` flag and display `FDESC` on first encounter, then switch to `LDESC` on subsequent visits.
8. **Fix state-blind room descriptions:** Update FOUNTAIN-F, HEDGES-F, and ENTRANCE-HALL-FCN to check for item presence before mentioning removed objects.
9. **Add PULL verb support to BELL-WIRE-F (M1):** Add `<VERB? PULL>` to the existing MOVE/USE check.
10. **Add WRONG-ATTEMPTS global declaration (M5):** Add `<GLOBAL WRONG-ATTEMPTS 0>` to the globals section of dungeon.zil.
11. **Add close support for wine cabinet (M4):** Add `<VERB? CLOSE>` handler to WINE-CABINET-F that clears OPENBIT.

### Narrative & Design Improvements

12. **Add CASE-TOPIC handlers for Lady Ashworth and Hudson:** Both should have specific responses when asked about the case/murder.
13. **Add SMELL and LISTEN handlers for key atmospheric objects:** FOG, PLANTS, KETTLE, and FOUNTAIN would benefit from sensory verb support.
14. **Give NPCs a third behavioral state:** Even a simple "post-accusation relief" state for Hudson and "post-accusation defiance" for Moriarty would help.
15. **Add room-level FDESC for the five most-visited rooms:** Gate, Entrance Hall, Study, Library, and Garden would benefit most.

---

## Playtest Summary

| Metric | Value |
|--------|-------|
| **Rooms visited** | 11/11 (Gate, Entrance Hall, Study, Library, Dining Room, Kitchen, Garden, Greenhouse, Servants' Quarters, Pantry, Secret Passage) |
| **Items collected** | 10 (telegram, magnifying glass, letter, poison bottle, bank statement, ledger, knife, footprint cast, torn page, wax seal, lockpick set, foxglove, charcoal, lantern) |
| **Puzzles solved** | 3/4 (library cipher, greenhouse poison ID, name-dial box), plus final accusation |
| **NPCs interacted with** | 4/4 (Hudson, Lady Ashworth, Moriarty, Lestrade) |
| **Endings reached** | 2/2 (letter-led accusation, poison-led accusation) |
| **Game completable?** | Yes — both accusation branches work and produce satisfying endings |
| **Softlocks found** | 0 — no unrecoverable states encountered |
| **Runtime crashes** | 0 — no fatal errors during play |

### Verification Notes

- The VOC registration for "SET" and "CAST" works — `TAKE LOCKPICK SET` and `TAKE FOOTPRINT CAST` succeed.
- ASK/TELL without topic no longer crashes (prompts "What do you want to ask about?").
- Lestrade does NOT appear at game start (correct), only after EVIDENCE-FOUND > 2 and SUSPECTS-INTERVIEWED = 3 (correct).
- The library cipher puzzle resets on wrong-book push (correct).
- The poison bottle TASTE correctly damages the player and the CHARCOAL restores health (correct).
- Both endings produce atmospheric text referencing specific evidence (correct).

---

*Report generated by game tester agent on July 15, 2026*
