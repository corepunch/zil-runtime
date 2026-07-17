---
name: content-writing
description: Write player-facing prose, NPC dialogue trees, layered hints, and ensure every noun in text resolves through the parser
---

Write player-facing text and interactions that teach play and maintain tone.

## Inputs
- Prior stage artifacts

## Required Actions
1. Write first-visit and revisit room text with actionable nouns.
2. **Ensure every mentioned noun is handled** — every object, person, or feature mentioned in room or object text must be reachable through the parser. Use objects for interactive items (doors, containers, NPCs), PSEUDO for scenery that players might EXAMINE (paintings, fireplaces, rubble), and NDESCBIT for background atmosphere.
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
13. For every actionable compound noun used in prose, choose and record a canonical command plus natural variants.
14. Write NPC topic rows as executable commands (`ASK HUDSON ABOUT KEY`), with listener, topic noun, response, state change, repeat response, and where the listener is accessible.

## Outputs
- Draft room and object prose set
- NPC topic/reaction matrix
- Hint tiers per puzzle

## Artistic Quality Patterns

### Prose: Show, Don't Tell the Mood
Every room description must contain at least one concrete sensory detail (sight, sound, smell, texture, temperature). Never use emotion-label adjectives as a substitute for description.

### Atmosphere: Systems, Not Backdrops
Atmosphere must be interactive. Before writing flavor text, ask: can the player do something about this?

### NPCs: Characters, Not Props
Every NPC must have at least three behavioral states that the player can discover and affect.

### Emotional Range: Contrast Makes Horror Hit Harder
A horror game must have moments of beauty, humor, or warmth. Without contrast, the player desensitizes.

### Environmental Storytelling: Clues in the World, Not Files in a Drawer
Cut text-dump objects by half. Move their information into room descriptions, object examines, environmental details, and NPC dialogue.

### Twist Delivery: Earn It, Don't Telegraph It
A twist should be discoverable, not stated. The reveal should be the first moment the player truly understands.

### Endings: Interactive Resolution, Not Held-Item Check
An ending must: (1) reference at least two specific discoveries, (2) give the player a choice, (3) imply what comes next.

### Discovery Text: FDESC on Everything Worth Finding
Every major room and every important object should have FDESC discovery text.

### Parser Depth: Pronoun Resolution, GWIM, OOPS
At minimum, implement pronoun resolution (`THIS-IS-IT`) and GWIM defaults for your game.

### NPC Dialogue Trees: Back-and-Forth Conversation
Each NPC must have at least 3 topics that change based on game state.

### Unique Death Text: Every Death a Discovery Moment
Every distinct death type must have unique text. Generic "You have died" is never acceptable.

### Tonal Range
Divide your game into thirds. In the first third, the player should encounter at least ONE thing that is beautiful, ONE thing that is funny, and ONE thing that is warm.

## Acceptance Checks
- Tone remains consistent.
- Room prose implies meaningful actions.
- Wrong-but-reasonable attempts are informative.
- Revisited text is concise and state-aware.
- NPC interactions produce observable world or puzzle consequences.
- Every emphasized clue noun and every noun used in a hint resolves through the parser exactly as written.

## Reference Sources
- `skills/source_zil_text_adventure_agents.md`: sections 6, 7, 11, 14
- `skills/source_writing_adventures.md`: Crafting Great Adventures section
