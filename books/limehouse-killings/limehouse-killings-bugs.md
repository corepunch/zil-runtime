# The Limehouse Killings - Bug Report

**Test Date:** July 15, 2026
**Tested By:** Game Tester Agent (ZIL adventure games)
**Game Version:** Release 1

## Walkthrough Status

| Test | Result |
|------|--------|
| Golden Path (walkthrough.zil, 492 tests) | 492/492 PASS |
| Organic playthrough (full investigation + accusation) | COMPLETE |

## Summary

| Category | Count |
|----------|-------|
| Critical Bugs | 2 |
| High Severity | 3 |
| Medium Severity | 6 |
| Low Severity | 5 |
| Design/Artistic Issues | 5 |

---

## Critical Bugs

### Bug 1: ASK/TELL Without Topic Causes Runtime Crash
- **Description:** Typing `ASK <NPC>` or `TELL <NPC>` without an ABOUT topic causes a nil-pointer crash. The game terminates immediately with a Lua runtime error.
- **Command:** `ASK MORIARTY`, `ASK HUDSON`, `ASK LESTRADE`, `ASK LADY` (any NPC without a topic)
- **Output:**
  ```
  Runtime error: .../actions.zil:1558: INSPECTOR_F
  bootstrap:665: attempt to perform arithmetic on a nil value (local 'num')
  ```
- **Expected:** The game should respond with something like "What do you want to ask about?" or a polite refusal.
- **Reproduction:**
  1. Start a new game
  2. Go to any NPC (e.g., `NORTH` to entrance hall, `EAST` to library standing near Dr. Moriarty)
  3. Type `ASK MORIARTY` (no topic)
  4. Game crashes 100% of the time
- **Root Cause:** All NPC FCN routines (MR-HUDSON-F, LADY-ASHWORTH-F, DR-MORIARTY-F, INSPECTOR-F) handle `<VERB? TELL>` by checking PRSI against various topic objects using `(IN? ,PRSI ,INTQUOTE)`. When no topic is provided, PRSI is nil, and calling `IN?` on nil crashes the runtime.
- **Affected NPCs:** All 4 NPCs
- **Severity:** Critical

### Bug 2: "ASK INSPECTOR ABOUT CASE" Fails With Generic Error
- **Description:** Despite prior fixes claiming to add ASK/TELL syntax support, `ASK INSPECTOR ABOUT CASE` produces "Please consult your manual for the correct way to talk to other people or creatures." — the generic parser error.
- **Command:** `ASK INSPECTOR ABOUT CASE`
- **Output:** `Please consult your manual for the correct way to talk to other people or creatures.`
- **Expected:** "Bring me five solid pieces of evidence and interview all three suspects. Then make your accusation." (as defined in INSPECTOR-F)
- **Reproduction:**
  1. Start a new game, go to entrance hall
  2. Type `ASK INSPECTOR ABOUT CASE`
  3. Gets generic error
- **Notes:** `TELL INSPECTOR ABOUT CASE` gives the same error. However, `ASK MORIARTY ABOUT POISON` and `ASK HUDSON ABOUT KEY` work correctly. The syntax specifically fails for the INSPECTOR, suggesting the issue is with how the CASE-TOPIC object resolves, or that INSPECTOR-F's VERB? TELL check doesn't trigger. This is a regression — the prior fix B4 claimed to address this.
- **Severity:** Critical

---

## High Severity Bugs

### Bug 3: Compound Noun Parsing Failure ("set" and "cast")
- **Description:** The parser fails to handle compound nouns whose second word is "set" or "cast" — these words are interpreted as verbs rather than noun modifiers.
- **Commands:**
  - `TAKE LOCKPICK SET` → "You used the word 'set' in a way that I don't understand."
  - `TAKE FOOTPRINT CAST` → "You used the word 'cast' in a way that I don't understand."
  - `TAKE LOCKPICK-SET` (with hyphen) → "You used the word 'set' in a way that I don't understand."
- **Workarounds:**
  - `TAKE PICKS` or `TAKE LOCKPICK` — works
  - `TAKE FOOTPRINT` or `TAKE MOLD` — works
- **Reproduction:**
  1. Obtain the leather roll from kitchen drawer, open it
  2. `TAKE LOCKPICK SET` — fails
  3. `TAKE PICKS` — succeeds
- **Root Cause:** The ZIL parser tokenizes hyphenated words and compound nouns, but "set" and "cast" exist as verb entries in the default vocabulary, so the parser interprets them as verbs instead of as the second half of a compound noun.
- **Severity:** High

### Bug 4: Inspector Present From Game Start
- **Description:** Inspector Lestrade is in the entrance hall from the very first moment the game begins (before the player has gathered any evidence). The design document (DESIGN.md, PLAN.md) states he should appear after sufficient evidence is gathered. His presence is not mentioned in the room description, so the player doesn't realize he's there until they happen to try `EXAMINE LESTRADE`.
- **Command:** `EXAMINE LESTRADE` (from entrance hall at game start)
- **Output:** "Inspector Lestrade of Scotland Yard stands in the entrance hall, his expression professional and skeptical."
- **Expected:** Inspector should not appear until the player has gathered significant evidence (e.g., evidence-found >= 5 or after interviewing all suspects).
- **Reproduction:** Start new game, go north, type `EXAMINE LESTRADE`. He's there.
- **Severity:** High

### Bug 5: NPCs Not Listed in Room Descriptions
- **Description:** None of the NPCs are listed in their room's descriptions. When the player enters a room containing an NPC, the room description provides no indication that anyone is present. The player must blindly try `EXAMINE <NPC-NAME>` or `ASK <NPC-NAME>` to discover they exist.
- **Examples:**
  - Servants' Quarters: Mr. Hudson is present but not mentioned
  - Dining Room: Lady Ashworth is present but not mentioned
  - Library: Dr. Moriarty is present but not mentioned
  - Entrance Hall: Inspector Lestrade is present but not mentioned
- **Reproduction:** Enter any room containing an NPC. The NPC is invisible to the room description.
- **Expected:** NPCs should be listed in room descriptions with a brief presence note, e.g., "Mr. Hudson, the butler, stands nearby looking troubled."
- **Severity:** High

---

## Medium Severity Bugs

### Bug 6: No FDESC (First-Visit Discovery Text) on Major Rooms
- **Description:** Most rooms have no first-visit discovery text (FDESC). The same LDESC is shown every time the player enters or looks at the room. The skill standard (Skill 04 Rule 8) requires every major room to have unique discovery text that appears only on the first visit.
- **Rooms without FDESC:**
  - ASHWORTH-MANOR-GATE (uses LDESC directly, same every visit)
  - ASHWORTH-ENTRANCE-HALL (ACTION-based but no FIRST?/FDESC logic)
  - DINING-ROOM (uses LDESC, same every visit)
  - GREENHOUSE (uses LDESC, same every visit)
  - SERVANTS-QUARTERS (uses LDESC, same every visit)
  - PANTRY (uses LDESC, same every visit)
  - SECRET-PASSAGE (uses LDESC, same every visit)
- **Contrast:** Only 3 objects have FDESC (DEAD-LETTER, BLOOD-STAINED-KNIFE, LOCKED-BOX). Most objects lack discovery text.
- **Reproduction:** Visit any room listed above multiple times. The description is identical every time.
- **Severity:** Medium

### Bug 7: No FDESC on Most Important Objects
- **Description:** Only 3 of the major objects have FDESC (DEAD-LETTER, BLOOD-STAINED-KNIFE, LOCKED-BOX). Key objects like POISON-BOTTLE, SECRET-LEDGER, MAGNIFYING-GLASS, LANTERN, KEYRING, FOOTPRINT-CAST, WAX-SEAL, BANK-STATEMENT, and TORN-PAGE lack FDESC.
- **Severity:** Medium

### Bug 8: Room Descriptions Don't Update (Static World)
- **Description:** After major story events, most room descriptions don't update to reflect the changed world state. The skill standard (Skill 03 Rule 4) requires every major story event to change at least 2 existing rooms.
- **Examples:**
  - After solving the library cipher and opening the secret passage, the Library's LDESC still says "A doorway leads west back to the entrance hall" (the ACTION routine does update to mention the passage, but most rooms don't have ACTION routines)
  - After opening the study door, rooms connected to the entrance hall don't change
  - After winning the game, room descriptions remain static
- **Rooms with state-aware descriptions:** Study (via STUDY-FCN), Library (via LIBRARY-FCN), Kitchen (via KITCHEN-FCN), Garden (via GARDEN-FCN), Entrance Hall (via ENTRANCE-HALL-FCN)
- **Rooms without any dynamic description:** Gate, Dining Room, Greenhouse, Servants' Quarters, Pantry, Secret Passage
- **Severity:** Medium

### Bug 9: "Open door" Without Specific Context Fails
- **Description:** Typing `OPEN DOOR` in the entrance hall doesn't work because the parser can't disambiguate which door. However, since "study door" is the only door most players encounter, `OPEN DOOR` should at least suggest that.
- **Command:** `OPEN DOOR` (in entrance hall)
- **Output:** "You can't see any door here!"
- **Expected:** Should say something like "Which door do you mean?" or refer to the study door specifically.
- **Severity:** Medium

### Bug 10: GIVE Verb Not Handled
- **Description:** The GIVE verb falls through to the default NPC response ("The Dr. Moriarty refuses it politely.") rather than being routed to NPC-specific SHOW/ASK handling.
- **Command:** `GIVE MAGNIFYING GLASS TO MORIARTY`
- **Output:** "The Dr. Moriarty refuses it politely."
- **Note:** The pre-existing bug report (B7) mentions fixing "the Moriarty" grammar issue, but it still appears in some contexts.
- **Severity:** Medium

### Bug 11: Duplicate object "POTS" in GLOBAL lists removed, but READ action auto-TAKES some items
- **Description:** Reading certain objects (DEAD-LETTER, SECRET-LEDGER) automatically takes them via the READ handler. This is inconsistent with how TAKE works otherwise and can confuse players who type READ first and then try to TAKE.
- **Command:** `READ DEAD-LETTER` then `TAKE DEAD-LETTER`
- **Output:** "(Taken)" then "You already have that!"
- **Expected:** Either the READ should not auto-TAKE, or the TAKE should acknowledge the item is already held.
- **Severity:** Medium

---

## Low Severity Bugs

### Bug 12: "servant's quarters" vs "servants' quarters" Inconsistency
- **Description:** Room naming and descriptions are inconsistent between "Servants' Quarters" (room DESC) and "servant's quarters" / "servant bell rope leading up to the servant's quarters" in various texts.
- **Locations:** Multiple — the room DESC says "Servants' Quarters" but other text uses different forms.
- **Severity:** Low

### Bug 13: Magnifying Glass Has No Practical Use
- **Description:** The magnifying glass is one of the first objects the player finds (entrance hall table), but it has no gameplay use. It can be EXAMINEd and TAKEn, and "USE" gives a description, but it never interacts with any puzzle or evidence item.
- **Severity:** Low

### Bug 14: Lantern Has No Practical Use
- **Description:** The lantern in the servants' quarters has LIGHTBIT and can be lit with USE, but there are no dark rooms in the game. All rooms are permanently lit. The lantern is a red herring that does nothing.
- **Severity:** Low

### Bug 15: Pantry-Only Items Are Never Required
- **Description:** Foxglove and charcoal are in the pantry and described as "antidote ingredients." But no puzzle requires them — there's no poison antidote puzzle that uses them. The poison identification puzzle (Puzzle 3) just requires matching the bottle label to the greenhouse plant, not using antidotes.
- **Severity:** Low

### Bug 16: Wine Cabinet Has No Use
- **Description:** The wine cabinet in the dining room is described as locked and containing fine wines. But there's no way to open it (no key in the game fits it), and it serves no puzzle purpose. It's a dead-end scenery object.
- **Severity:** Low

---

## Design/Artistic Issues (Against Skill Standards)

### Issue 1: Puzzles Are Item Gates (Violates Skill 03 Rule 1)
- **Assessment:** The game's major "puzzles" are fundamentally item gates rather than narrative challenges.
  - Study Entry: Find key or lockpick → unlock door
  - Locked Box: Find key or lockpick → open box
  - Greenhouse Poison: Match bottle label to plant label (the only puzzle that requires understanding the fiction)
  - Final Confrontation: Accumulate 5 evidence items → accuse correct NPC
- **The exception:** Library Cipher is the only puzzle that requires understanding a pattern (rainbow order) rather than finding an item.
- **Standard Required:** "At least 2 of your major gates must be solved by understanding the fiction rather than finding a key."
- **Verdict:** FAIL — 3 of 4 major puzzles are item gates.

### Issue 2: No Three Escalating Acts (Violates Skill 03 Rule 2)
- **Assessment:** The game plays as a flat investigation with no act boundaries, no escalation in challenge type, and no structural breaks. All rooms are accessible from the start (except the study and secret passage), and the player moves linearly through exploration → evidence collection → accusation with no visible act transitions.
- **Standard Required:** "Structure your game in three acts with clear threshold moments. Each act should have a different dominant challenge type (exploration → deduction → confrontation). At each act boundary, the world should visibly change."
- **Verdict:** FAIL — no act structure, no visible world changes.

### Issue 3: NPCs Are Props (Violates Skill 04 Rule 3)
- **Assessment:** NPCs have dialogue but only one behavioral state:
  - Mr. Hudson: Always nervous, always in servants' quarters. His key-giving is the only state change.
  - Lady Ashworth: Always cold and calculating, always in the dining room.
  - Dr. Moriarty: Always arrogant, always in the library (except after poison topic, he moves to entrance hall — one behavioral change).
  - Inspector Lestrade: Static from beginning to end.
- **Standard Required:** "Every NPC must have at least three behavioral states that the player can discover and affect. At minimum: (1) initial encounter, (2) a state changed by player action, (3) a state triggered by story progress elsewhere."
- **Verdict:** FAIL — NPCs have 1-2 states at most.

### Issue 4: Prose Tells Rather Than Shows (Violates Skill 04 Rule 1)
- **Assessment:** Multiple room descriptions use emotion-label language instead of concrete sensory details:
  - "The air is thick with the scent of old wood and regret" — tells emotion abstractly
  - "The air hangs heavy with the memory of violence" — tells rather than shows
  - "The study remains as you found it, a testament to the crime committed here" — interpretive, not sensory
- **Positive examples:**
  - "Copper pots hang from the ceiling, tarnished with age" — concrete and sensory
  - "The fog swirls around your feet, cold and damp" — sensory and specific
  - "The fountain is dry, with coins at the bottom" — concrete and visual
- **Standard Required:** "Every room description must contain at least one concrete sensory detail (sight, sound, smell, texture, temperature). Never use emotion-label adjectives ('dread,' 'ominous,' 'creepy,' 'wrong') as a substitute."
- **Verdict:** MIXED — some rooms succeed, others use emotion labels.

### Issue 5: Ending Is a Held-Item Counter Check (Violates Skill 04 Rule 7)
- **Assessment:** The ending is triggered by `ACCUSE DR-MORIARTY`, which simply checks if `EVIDENCE-FOUND == 5` and `SUSPECTS-INTERVIEWED == 3`. It never references specific discoveries the player made (the dead letter's content, the knife's origin, the poison's type). It gives the player no choice. It stops at "You won" with no implication of what comes next.
- **Standard Required:** "An ending must: (1) reference at least two specific discoveries the player made, (2) give the player a choice (even a small one), and (3) imply what comes next rather than stopping at 'you win.'"
- **Verdict:** FAIL — ending is a numeric counter check with no personalization.

### Issue 6: Environmental Storytelling Relies on Text Dumps (Violates Skill 04 Rule 5)
- **Assessment:** Almost all lore is delivered through readable text-dump objects:
  - DEAD-LETTER: text dump
  - SECRET-LEDGER: text dump
  - BANK-STATEMENT: text dump
  - TORN-PAGE: text dump (cipher clue)
  - FOLDED-NOTE (in trunk): text dump
  - POISON-BOTTLE label: text dump
- Environmental reveals are rare:
  - Chalk outline (good — shows method of murder)
  - Wax seal with initial "M" (good — shows Moriarty's involvement visually)
  - Colored markers on books (good — visual cipher clue)
  - Footprint cast size (mixed — told via examine text, not purely environmental)
- **Standard Required:** "Cut text-dump objects by half. Move their information into room descriptions, object examines, environmental details, and NPC dialogue."
- **Verdict:** MIXED — some environmental storytelling exists, but reliance on text dumps is heavy.

### Issue 7: No Emotional Range (Violates Skill 04 Rule 4)
- **Assessment:** The game is uniformly dark Victorian noir with no moments of beauty, humor, warmth, or relief. Every room description filters through grimness: "fog-choked sky," "memory of violence," "air smells of old wood and regret," "overgrown garden choked with weeds," "servant beds worn but clean."
- **Standard Required:** "A horror game must have moments of beauty, humor, or warmth. Without contrast, the player desensitizes and every room feels the same. Aim for at least 3 moments outside the primary tone."
- **Verdict:** FAIL — no moments of contrast anywhere.

### Issue 8: Opening Scene Missing Components (Violates Skill 01)
- **Assessment:** The opening scene at Ashworth Manor Gate has landmarks (gates, path, fog) but:
  - **One landmark:** ✓ (iron gates)
  - **One visible object:** ✗ (no takeable/usable object in the first room; the magnifying glass is in the entrance hall, one room away)
  - **One blocker:** ✓ (locked study door, two rooms away)
  - **One quick reward:** ✗ (no immediate reward in the first room; player must navigate to entrance hall, then library to find the torn page)
- **Standard Required:** "Define a memorable opening with one landmark, one visible object, one blocker, and one quick reward."
- **Verdict:** PARTIAL — missing the visible object and quick reward in the opening room.

---

## Files Affected (For Fixes)

### Critical Fixes Needed:
- `actions.zil` — NPC FCN routines: add nil-guard for PRSI before `IN?` and `EQUAL?` checks in TELL handlers
- `actions.zil` — INSPECTOR-F: fix ASK syntax routing or CASE-TOPIC resolution

### High Priority Fixes:
- `actions.zil` — Add NPC presence listing to room ACTION routines (ENTRANCE-HALL-FCN, etc.)
- `actions.zil` — Trigger INSPECTOR arrival based on EVIDENCE-FOUND counter rather than starting in entrance hall

### Medium Priority Fixes:
- `dungeon.zil` — Add FDESC to all major rooms and objects
- `dungeon.zil` — Add FIRST?/FDESC discovery text patterns to room ACTION routines
- `actions.zil` — Add state-aware text to all room ACTION routines
- `dungeon.zil` — Add SYNONYM entries for compound nouns to handle parser tokenization (e.g., LOCKPICK-SET needs SET as separate synonym)

### Design/Content Improvements:
- Add at least one puzzle that requires understanding the fiction (in addition to cipher)
- Create three-act structure with visible world changes at act boundaries
- Give NPCs behavioral states that change with player actions
- Add moments of emotional contrast
- Replace emotion-label prose with concrete sensory details
- Make ending reference specific player discoveries
- Add practical uses for magnifying glass, lantern, foxglove, charcoal, and wine cabinet
- Move lore from text-dump objects into environmental observation

---

*Report generated by game tester agent on July 15, 2026*
