# Skill 03: World Model And Puzzle Architecture

## Goal
Translate design docs into a coherent simulation plan before full implementation.

## Inputs
- `MAP.md`
- `OBJECTS.md`
- `PUZZLES.md`
- `STORY_STATE.md`

## Required Actions
1. Define parser-facing action model (verb, direct object, indirect object).
2. Validate object/room checklist coverage.
3. Validate puzzle fairness:
   - clear goal
   - discoverable information
   - guessable command vocabulary
4. Validate dependency graph and prevent softlocks.
5. Define default response strategy and custom overrides for likely wrong attempts.
6. Audit every planned noun phrase before implementation:
   - object identifiers and `DESC` do not automatically make words parseable;
   - the head noun belongs in `SYNONYM`;
   - modifiers belong in `ADJECTIVE`;
   - exact hyphenated transcript spellings belong in `SYNONYM` when supported;
   - two in-scope objects sharing a noun need distinguishing adjectives.
7. Define container visibility transitions: where contents begin, which action sets `OPENBIT`, and which flags let the parser search inside.
8. Define each one-time counter as `event flag -> guarded increment`, including which verbs can discover the same clue.
9. Audit physical nouns against the object registry. Every described fixture or obstacle that affords player actions must be a real object with vocabulary, scope, flags, and behavior; do not substitute a global Boolean for a door, window, container, switch, vehicle, or similar world entity.

## Infocom-Quality Simulation Checks
- Build a command matrix for each major puzzle with at least ten likely player attempts; implement useful responses for the top attempts.
- Ensure common parser verbs and synonyms are covered (`look`, `examine`, `open`, `close`, `take/get`, `drop`, `read`, `put`, `unlock`, `attack`, `listen`, `smell`, `wait`, `again`, inventory shortcuts).
- Keep the puzzle challenge in idea-space, not wording-space; avoid single exact-verb bottlenecks.
- Ensure world state is physical and persistent (object movement, room state changes, blocked/unblocked routes, timed hazards).
- Prefer object state (`OPENBIT`, containment, location, visibility) over parallel global state. Use globals for abstract facts and milestones, or to supplement a real object when the substrate lacks a specific state such as `LOCKEDBIT`.
- Preserve challenge while reducing accidental cruelty (telegraphed danger, recoverable mistakes, explicit unwinnable-risk handling).
- Prefer meaningful mazes over filler mazes; if maze-like areas exist, provide landmarks or distinct mechanics.
- Support optional mastery with alternate/risky/clever solutions where feasible.

## Outputs
- Updated puzzle dependency graph
- Object/verb response matrix
- Softlock mitigation list

## Puzzle Artistry: Good vs. Bad Patterns

These patterns are drawn from a direct comparison between Zork III (infocom/zork3/) and Blackwood Horror (books/blackwood-horror/). Each section contrasts key-and-lock mechanics with narrative-integrated puzzle design.

### 1. Puzzles Should Be the Story, Not Reskinned Item Gates

**BAD (Blackwood — key daisy chain):**
```
brass-key → desk-drawer → patient-file (lore only, no gate)
scalpel → chains → morgue access
valve → steam-door → hydrotherapy access
safe-key (in hollow book) → wall-safe → chapel-key → chapel access
scalpel → wooden-box → relic
serum + syringe + relic → held during HELLO → win
```

Every step is "find key → unlock next area → find next key." You could reskin this exact chain as a space station, pirate ship, or wizard's tower by renaming the keys and rooms. The horror setting is wallpaper.

**GOOD (Zork III — `3actions.zil:1429-1436`):**
The Dungeon door requires becoming the Dungeon Master — wearing cloak, hood, amulet, staff, ring, and carrying the lore book and key. This is the culmination of collecting identity-granting items across all three Zork games. The puzzle *is* the story: you must literally become what you seek to understand.

**GOOD (Zork III — `3actions.zil:1112-1175`):**
The mirror box is a navigational puzzle that requires rotating a magical structure via colored panels. Completely novel mechanics that feel like operating a mysterious device. No keys, no locks — just spatial reasoning within the fiction.

**Rule:** At least 2 of your major gates must be solved by understanding the fiction rather than finding a key. Replace "find key → unlock door" with: performing a ritual, understanding a character's history, arranging objects in a pattern, choosing the right moment, or demonstrating a quality the story values. A key should have *identity* — "the chapel key" is generic; "the key Patient-189 carved from his restraints" is a story.

### 2. Narrative Arc: Three Escalating Acts

**BAD (Blackwood):**
Linear room-by-room exploration. The player moves from entrance → basement → admin wing → garden → chapel with no structural breaks, no points of no return, and no escalation in challenge type. The same clock routines fire at fixed intervals regardless of progress. Nothing in earlier rooms changes as the player advances.

**GOOD (Zork III):**
- **Act 1 (Arrival):** Dream sequence, museum, Royal Puzzle. Establishes the quest.
- **Act 2 (Dungeon Gates):** Mirror maze, beam room, Guardians. Tests spatial reasoning and stealth.
- **Act 3 (The Dungeon Master):** Flaming pit, prison cells, Treasury. Tests cleverness, compassion, and identity.

Each act is gated by a different *type* of challenge, not just a different key. The dungeon physically changes (earthquake opens the cleft, doors unlock after tests). The Dungeon Master appears, disappears, and reappears in escalating forms.

**Rule:** Structure your game in three acts with clear threshold moments. Each act should have a different dominant challenge type (exploration → deduction → confrontation). At each act boundary, the world should visibly change. Earlier rooms should show different descriptions after the player passes through major story beats.

### 3. Room Cohesion: A Real Place, Not a Trope Checklist

**BAD (Blackwood — 20 rooms):**
entrance hall → reception → operating theater → patient ward → morgue → basement stairs → boiler room → storage room → flooded chamber → hydrotherapy room → isolation ward → electroshock theater → padded cell → observation deck → administrative wing → director's office → staff quarters → cafeteria → garden → chapel

This reads like a Wikipedia article on "rooms in a mental hospital." Each room is exactly what its name promises. The operating theater has an operating table. The morgue has refrigerated drawers. There are no surprises. The chapel ("beyond the garden") has no institutional relationship to a sanitarium — why would a 1950s mental hospital have an ancient stone chapel?

**GOOD (Zork III):**
The Royal Museum feeds into the Royal Puzzle (a museum exhibit), which feeds into dungeon corridors. The Land of Shadow is a completely different biome but shares compass-rose and channel features with the mirror maze. The flaming pit is visible from multiple rooms (cells, parapet, north corridor), creating spatial grounding. The Engravings Room's runes foreshadow the guardians, flames, and old man. Every location belongs to a single fictional geography with internal logic.

**Rule:** Every room must either (a) subvert its apparent function, or (b) be visible/audible from at least one other room. No room should exist just because the setting "should have one." The fictional geography must answer: why is this room HERE, in relationship to its neighbors? If the answer is only "it's a spooky hospital and hospitals have those," delete it or give it a specific institutional reason to exist.

### 4. World State Must Change After Thresholds

**BAD (Blackwood):**
After the player discovers the identity twist, earlier rooms show the same descriptions. After cutting chains, the door object's LDESC still says "sealed with chains." After opening the steam door, the sealed door's LDESC still says "sealed shut." After the game is won, the chapel still lists burning green candles. The world is static.

**GOOD (Zork III — `3actions.zil:2451-2477`):**
The earthquake (I-CLEFT) dynamically alters the dungeon, opening new passages and changing room descriptions. The dungeon door panels change their message after tests are completed. The time machine sequence changes museum exhibits based on player actions in the past.

**Rule:** Every major story event must change at least 2 existing rooms — either through updated dynamic descriptions (ACTION + M-LOOK), changed object states (FCLEAR flags), or new objects appearing. Use the pattern from Zork I's `EAST-HOUSE` and the skill 04 rule 7: never freeze mutable state into LDESC. Rooms with state changes should omit LDESC and use ACTION routines with M-LOOK.

### 5. NPC Autonomy: Characters That Move Through the World

**BAD (Blackwood — `actions.zil:568-598`):**
Patient-189 handles five verbs and is permanently static. It never moves, never approaches, never wanders. It is a puzzle object with ACTORBIT.

**GOOD (The Lurking Horror — `frob.zil:346-435`):**
The urchin uses a true pathfinding routine (`I-URCHIN`) that evaluates all available exits from its current room and moves to a valid adjacent room not occupied by another NPC. It has states (scared, armed, fleeing), responds differently based on what the player holds, and operates on an independent clock schedule.

**GOOD (The Lurking Horror — `hacker.zil`):**
The hacker has a full 12-topic dialogue tree, a multi-stage help sequence (takes over terminal → mumbles → fixes file system → wanders away), food preferences (will only accept properly heated Chinese food), and a corruption arc (if player reaches inner lair, the hacker follows, gets absorbed, and emerges transformed).

**Rule:** An ACTORBIT object must have at least one autonomous behavior (movement, approach, state change) driven by a clock daemon. It must change state based on player actions AND on purely internal triggers (time passing, other puzzles solved). The weakest NPC in a commercial Infocom game has more autonomy than Blackwood's only NPC.

### 6. Object Interaction Depth: Tool Chains and System Combinations

**BAD (Blackwood):**
Every puzzle is a single verb on a single object: USE SCALPEL ON CHAINS, UNLOCK DOOR WITH KEY, OPEN BOX WITH SCALPEL. No puzzle requires chaining two objects together or considering object state (temperature, power, saturation) as a puzzle variable.

**GOOD (The Lurking Horror):**
- The liquid nitrogen puzzle: find nitrogen flask → pour on slime curtain → nitrogen freezes slime → shatter frozen slime → open ancient door. Four steps, two objects, one state change (temperature).
- The Chinese food puzzle: find Chinese food carton (frozen) → heat in microwave at specific setting (2 minutes, HIGH) → give to hacker → receive master key. Objects have temperature states that affect NPC behavior.
- The power line puzzle: find axe → cross water while wearing rubber boots + gloves → cut high-voltage line → plug into repeater box → electrocute boss. Requires tool, protective equipment, environmental navigation, and correct ordering.

**Rule:** At least 2 major puzzles must require chaining 3+ objects or considering an object's state (hot/cold, charged/drained, wet/dry) as a puzzle variable. Every object that can hold state should have visible EXAMINE feedback showing its current state. A game where no object has plural states and every puzzle is single-step is a fetch quest, not an adventure.

### 7. Clock-Driven Mechanical Depth: Systems That Simulate, Not Just Decorate

**BAD (Blackwood — `actions.zil:854`):**
Clock routines (I-WHISPER, I-CREAKING, I-FOOTSTEPS, I-FLICKERING, I-COLD-DRAFT) fire atmospheric flavor text on timers. None of them interact with game state. None create mechanical consequences. They are wallpaper that the player tunes out after the third repetition.

**GOOD (The Lurking Horror):**
- **Flashlight battery drain** (`cs.zil:1407-1434`): I-FLASHLIGHT daemon dims the flashlight through 5 stages (FRESH → DIM → VERY-DIM → ALMOST-GONE → OUT). Each stage has unique descriptive text and affects whether the player can see in dark rooms. Running out of light at the wrong moment is a real danger.
- **Freeze-to-death clock** (`cs.zil:60-80`): I-FREEZE-TO-DEATH tracks cumulative exposure to cold. First warning at 3 ticks, then 6, then 9, then death at 12. The player must find shelter or warm clothing before the timer expires.
- **NPC AI scheduling** (`frob.zil:346-435`): The urchin moves on a clock daemon, not on player triggers. It enters rooms, steals objects, and flees independently, creating a dynamic world where NPCs have agendas.
- **Temperature decay** (`cs.zil:130-148`): I-COOL tracks object temperature. The Chinese food cools over time, becoming less appealing to the hacker. The nitrogen flask warms, affecting how much slime it can freeze.

**Rule:** Every clock daemon must do at least one of: (a) advance a numerical state that has gameplay consequences, (b) cause autonomous NPC behavior, or (c) modify object state that another system reads. Atmosphere-only daemons may exist but should be outnumbered 2:1 by mechanical daemons. The player should be able to observe clock effects through EXAMINE and gameplay consequences, not just read flavor text.

## Acceptance Checks
- No puzzle depends on inaccessible prerequisites.
- Reasonable command attempts have authored responses.
- Defaults are overridden where narrative/puzzle intent requires.
- Navigation model supports player mapping and repeat travel without confusion.
- At least one long-loop puzzle requires carrying knowledge or objects between distant locations.
- The first vertical slice can be played with the exact planned commands before the next slice is implemented.
- Repeating TAKE/READ/EXAMINE or opening an already-open object cannot duplicate progress or strand contents.
- Every physical noun named in room prose or a blocked-exit message resolves to an object in scope and supports the obvious generic verbs.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 3, 4, 5
- `WRITING_ADVENTURES.md`: Part I sections 2, 3, Suggested Build Order
