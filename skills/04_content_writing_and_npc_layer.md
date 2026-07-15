# Skill 04: Content Writing And NPC Layer

## Goal
Write player-facing text and interactions that teach play and maintain tone.

## Inputs
- Prior stage artifacts

## Required Actions
1. Write first-visit and revisit room text with actionable nouns.
2. **Ensure every mentioned noun is handled** — every object, person, or feature mentioned in room or object text must be reachable through the parser. If a room description says "a heavy door to the north," there must be an object with `SYNONYM DOOR` so `OPEN DOOR` works. Use objects for interactive items (doors, containers, NPCs), PSEUDO for scenery that players might EXAMINE (paintings, fireplaces, rubble), and NDESCBIT for background atmosphere. Never promise the player an interactable noun that isn't there — it breaks trust in the parser.
3. Author object text to support puzzle affordances.
4. Author NPC behavior scope and conversation patterns (ASK/TELL/GIVE/SHOW).
5. Author layered hints (attention, direction, action, command).
6. Author clear success feedback and useful failure feedback.
7. Keep prose brief and concrete: room descriptions should usually be 1-4 sentences with one strong anchor.
8. Balance tone intentionally: clear spatial prose, dry humor, and credible danger.
9. Add custom responses for obvious silly commands so humor is systemic, not just decorative.
10. Ensure major objects act as more than props (tool, clue, world detail, joke, risk, trophy, or memory marker).
11. Give key NPCs behavior loops (move, block, steal, help, react, change state), not only static dialogue.
12. **Player identity belongs in SYNOPSIS.md/DESIGN.md, not in PLAYER object LDESC** — Infocom never explicitly states who the player is in game text.
13. For every actionable compound noun used in prose, choose and record a canonical command plus natural variants (for example `reading desk`, `reading-desk`, `desk`). Make the ZIL vocabulary support what the prose teaches.
14. Write NPC topic rows as executable commands (`ASK HUDSON ABOUT KEY`), with listener, topic noun, response, state change, repeat response, and where the listener is accessible.

## Outputs
- Draft room and object prose set
- NPC topic/reaction matrix
- Hint tiers per puzzle

## Artistic Quality: Good vs. Bad Patterns

These patterns are drawn from a direct comparison between Zork III (infocom/zork3/) and Blackwood Horror (books/blackwood-horror/). Each section shows a concrete weakness found in Blackwood, the Zork III counterexample, and the rule to follow.

### 1. Prose: Show, Don't Tell the Mood

**BAD (Blackwood — `dungeon.zil:54`):**
> "The air here is thick with an oppressive dread."

Telling the player what to feel. The word "dread" is a conclusion, not a sensation. Repeated across multiple rooms ("reeks of decay," "feels wrong," "oppressive dread"), this numbs the player — if every room "feels wrong," no room truly does.

**BAD (Blackwood — `dungeon.zil:33`):**
> "The entrance hall reeks of mildew and decay."

Formulaic gothic-horror signifiers reappear across rooms: "reek of mildew," "hollow eye sockets," "gaping mouths," "rotting." The vocabulary narrows to a grim checklist instead of building a specific place.

**GOOD (Zork III — `3actions.zil:2104-2108`):**
> "Mighty stalagmites form crystalline-encrusted rock formations. Phosphorescent mosses, fed by a trickle of water from above, make the crystals glow and sparkle with every color of the rainbow."

Concrete sensory details (phosphorescent moss, trickling water, sparkling crystals). The wonder is earned through observation, not stated. The player *feels* awe because the description paints it — it never says "this room is beautiful."

**GOOD (Zork III — `3dungeon.zil:550-563`):**
> "A wide stone channel steeply descends into the room from the south. It is covered with slippery moss and lichen."

Spatially precise, texturally rich. "Slippery moss and lichen" implies danger, age, and dampness without ever saying "this place is creepy."

**Rule:** Every room description must contain at least one concrete sensory detail (sight, sound, smell, texture, temperature). Never use emotion-label adjectives ("dread," "ominous," "creepy," "wrong") as a substitute for description. If you need to remove the mood word and the room still evokes it, you wrote well.

### 2. Atmosphere: Systems, Not Backdrops

**BAD (Blackwood — `actions.zil:854`):**
> "Distant footsteps echo from somewhere above you."

Clock-driven flavor text that fires on a timer. It plays regardless of game state, never changes content, and the player cannot investigate, interact with, or do anything about it. After the third repetition it becomes wallpaper.

**BAD (Blackwood — `dungeon.zil:13-18`):**
A whisper table with four fixed entries selected by PICK-ONE. None change based on game progress — the whispers are identical before and after discovering Patient-189's file, opening the chapel, or confronting the truth.

**GOOD (Zork III — `3actions.zil:9-38`):**
The SWORD glows faint blue near danger, more brightly near enemies. This is a *mechanical system* — not text telling you to feel threatened, but a game object whose state reflects actual danger. The player learns to read the sword's glow as a risk indicator. Atmosphere emerges from gameplay.

**GOOD (Zork III — `3actions.zil:80-87`):**
The lantern has a fuel system with multiple warning states: "flickering," "growing dim," "about to go out." The threat of darkness is mechanical, not atmospheric — the player can run out of light, and the fear is real because the consequence is real.

**Rule:** Atmosphere must be interactive. Before writing flavor text, ask: can the player do something about this? Does it change based on game state? If the answer to both is no, either: (a) make it interactive, or (b) fire it once as FDESC discovery text and then retire it.

### 3. NPCs: Characters, Not Props

**BAD (Blackwood — `actions.zil:568-598`):**
Patient-189 handles five verbs (EXAMINE, ATTACK, HELLO, RUB, GIVE). It has no dialogue, no movement, no intermediate states. It never speaks until the final text-dump win. All lore about it comes from reading files elsewhere. It is a puzzle object with ACTORBIT, not a character.

**GOOD (Zork III — `3actions.zil:1380`):**
> "I'm willing to accompany you, but not ride in your pocket!"

The Dungeon Master has personality, humor, and clear behavioral rules (follows, refuses containers, won't enter the cell). He speaks, reacts to specific verbs, and his dialogue changes based on what the player has done (`3actions.zil:1446-1482` — DMISH counts collected items and selects from DM-REASONS table).

**GOOD (Zork III — `3actions.zil:1789-1863`):**
The old man in the Engravings Room is the Dungeon Master's earlier form. He starts asleep, wakes when fed waybread, reveals a secret door, and when attacked says "Not yet" before vanishing in smoke. He is one NPC with *multiple behavioral states* — sleeping, grateful, threatened, transcendent.

**Rule:** Every NPC must have at least three behavioral states that the player can discover and affect. At minimum: (1) initial encounter, (2) a state changed by player action, (3) a state triggered by story progress elsewhere. Dialogue must change based on game state. An NPC with ACTORBIT that only handles EXAMINE and the win-condition verb is a prop wearing a character mask.

### 4. Emotional Range: Contrast Makes Horror Hit Harder

**BAD (Blackwood):**
Every description filters through horror. The garden is "dead," the walls "reek of decay," the chapel "makes everything look like a corpse," the wallpaper is "grotesquely warped by moisture and black mold." There is not a single moment of humor, beauty, warmth, or relief in 890 lines of source.

**GOOD (Zork III — `3actions.zil:73`):**
> "Who do you think you are? Arthur?" — when you try to pull the sword from the stone.

**GOOD (Zork III — `3actions.zil:2104`):**
The Crystal Grotto's "breathtaking beauty" — a room that exists purely for wonder, amid a game of deadly puzzles and flaming pits.

**GOOD (Zork III — `3dungeon.zil:690-698`):**
The Treasury of Zork: "chests containing precious jewels, mountains of zorkmids, rare paintings, ancient statuary" — a moment of pure triumph and awe after hours of challenge.

**Rule:** A horror game must have moments of beauty, humor, or warmth. Without contrast, the player desensitizes and every room feels the same. Aim for at least 3 moments outside the primary tone. The darkest room should come after the player has seen something worth protecting.

### 5. Environmental Storytelling: Clues in the World, Not Files in a Drawer

**BAD (Blackwood):**
Lore is delivered through NINE text-dump objects: patient file (`actions.zil:74-77`), ledger (`629-631`), Mordecai's journal (`129-135`), observation logbook (`643-644`), medical records (`498-499`), soggy notebook (`536-537`), scattered papers (`324-326`), Mordecai's notes (`725-726`), staff photograph (`413-414`). The player learns the story by finding and reading flat text, not by observing the environment.

**GOOD (Zork III — `3actions.zil:1864-1868`):**
The runes on the Engravings Room wall show "flames, stone statues, and an old man" — a visual clue that foreshadows three upcoming challenges (the flaming pit, the Guardians, the Dungeon Master). The player decodes meaning from symbols, not from reading a document. This rewards attention without requiring a ledger.

**GOOD (Zork III — `3actions.zil:1719-1724`):**
The Dungeon Master's speech at the end references the player's actions: "You have shown kindness to the old man, and compassion toward the hooded one. You displayed patience in the puzzle and trust at the cliff." The story *recounts* what the player *did*, making them the author, not just the reader.

**Rule:** Cut text-dump objects by half. Move their information into room descriptions, object examines, environmental details, and NPC dialogue. Information discovered through observation ("the straps on the operating table are worn thin at the wrists") is always stronger than information discovered through reading ("the file says the patient struggled"). The player should feel like an archaeologist, not a file clerk.

### 6. Twist Delivery: Earn It, Don't Telegraph It

**BAD (Blackwood):**
The "you are Patient-189" twist is revealed explicitly at least THREE times before the chapel:
1. Straitjacket tag (`dungeon.zil:616`): "Your name. Dated 1947."
2. Wall scratches (`actions.zil:252`): "YOU ARE 189. YOU ALWAYS WERE."
3. Observation logbook (`dungeon.zil:643-644`): "Memory loss total. Subject claims to be 'someone else' now."

By the time the player reaches Patient-189, there is nothing left to discover. The twist is a checklist item, not a revelation.

**GOOD (Zork III):**
The Dungeon Master's identity twist is revealed gradually across three separate encounters:
1. The old man in the Engravings Room — a seemingly helpless NPC.
2. The dungeon door panels: "we have met before, although I may not appear as I did then" (`3actions.zil:1463-1464`).
3. The final transformation in the Treasury — the player *becomes* the new Dungeon Master.

Each encounter deepens the mystery rather than resolving it. The player pieces together the identity over hours, not paragraphs. The reveal is earned.

**Rule:** A twist should be discoverable, not stated. Replace explicit reveals with clues the player must synthesize: dates that match, physical descriptions that align, behaviors that echo. The chapel confrontation should be the *first* moment the player truly understands — not the third confirmation.

### 7. Endings: Interactive Resolution, Not Held-Item Check

**BAD (Blackwood — `actions.zil:587-592`):**
> "You hold out the relic. Patient 189 stills completely. You draw the serum into the syringe and step forward... inject it. The green light gutters... 'I remember... who I was.' It crumbles to ash... You're free."

The player must hold 3 items and type HELLO. The relic and serum have no thematic purpose — they're *required held items* for a verb gate. Patient-189 says one line. "You're free" is the narrative equivalent of "YOU WIN." No callback to discoveries made. No choice.

**GOOD (Zork III — `3actions.zil:1719-1724`):**
> "Now that you have solved all the mysteries of the Dungeon, it is time for you to assume your rightly earned place in the scheme of things... For a moment there are two identical mages standing among the treasure, then your counterpart dissolves into a mist and disappears, a sardonic grin on his face. You begin to feel the vast powers and lore at your command and thirst for an opportunity to use them."

Multi-stage climax. The Dungeon Master references specific player actions. The player is *transformed* — not just told they won. The ending opens a new future rather than closing the story.

**Rule:** An ending must: (1) reference at least two specific discoveries the player made, (2) give the player a choice (even a small one), and (3) imply what comes next rather than stopping at "you win." The items required for victory should have thematic purpose — the relic should *do* something in the fiction, not just be a held-object flag check.

### 8. Discovery Text: FDESC on Everything Worth Finding

**BAD (Blackwood):**
Only 4 objects have FDESC: iron boiler, shock chair, straitjacket, ancient relic. The chapel has no LDESC at all (only a dynamic action routine). The padded cell, observation deck, and most other rooms lack first-visit discovery text.

**GOOD (Zork III — `3dungeon.zil:192-193`):**
> "Nestled inside the niche is an old and dusty book."

**GOOD (Zork III — `3dungeon.zil:99`):**
> "Your old friend, the brass lantern, is at your feet."

Nearly every object has a FIRST?/FDESC discovery moment. Revisiting a room after solving a puzzle often reveals new text. The player is constantly rewarded for looking.

**Rule:** Every major room (15+) and every important object should have FDESC discovery text. Discovery text should only appear *once* — it creates a moment. After that, revisit text should be concise and state-aware.

## Acceptance Checks
- Tone remains consistent.
- Room prose implies meaningful actions.
- Wrong-but-reasonable attempts are informative.
- Revisited text is concise and state-aware.
- NPC interactions produce observable world or puzzle consequences.
- Every emphasized clue noun and every noun used in a hint resolves through the parser exactly as written.
- Conversation topics are testable parser objects/words, not documentation-only labels.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 6, 7, 11, 14
- `WRITING_ADVENTURES.md`: Crafting Great Adventures section
