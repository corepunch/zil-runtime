# The Lurking Horror — Player Experience Report

**Test Date:** July 15, 2026
**Tested By:** Game Tester Agent (AdventureArena ZIL runtime)
**Game Version:** Release 15
**Platform:** AdventureArena ZIL compiler + runtime (llm.lua)

---

## Executive Summary

| Category | Count |
|----------|-------|
| Critical Bugs (crash/memory corruption) | 4 |
| High Severity (game-blocking) | 3 |
| Medium Severity (impairs play) | 5 |
| Low Severity (cosmetic) | 3 |
| **Overall Verdict** | **Unplayable** — CLOCKER crashes and broken save/restore prevent any meaningful play session exceeding ~8 turns |

---

## 1. Opening Experience

The game opens with a beautifully written introductory paragraph that establishes mood immediately:

> *"You've waited until the last minute again. This time it's the end of the term, so all the TechNet terminals in the dorm are occupied. So, off you go to the old Comp Center. Too bad it's the worst storm of the winter (Murphy's Law, right?), and you practically froze to death slogging over here from the dorm. Not to mention jumping at every shadow, what with all the recent disappearances."*

The hook is effective: you're a student with a 20-page paper due tomorrow, it's a snowstorm night, and people have been disappearing on campus. The game immediately grounds you in a recognizable but uneasy reality.

The initial ROOM (Terminal Room) is vividly described: "a large room crammed with computer terminals, small computers, and printers... Banners, posters, and signs festoon the walls. Most of the tables are covered with waste paper, old pizza boxes, and empty Coke cans."

You start with an ASSIGNMENT object already in your inventory (the paper you need to write). The room contains a CHAIR (molded plastic) and a PC (computer).

**First impressions in the AdventureArena port:** The text renders cleanly and the atmosphere is conveyed. The opening works as intended.

---

## 2. Prose and Atmosphere

The writing in *The Lurking Horror* is outstanding — it's Dave Lebling (co-author of Zork) at his best. Key observations:

- **Tone:** The game blends academic satire ("why a technical school requires you to endure this sort of stuff") with genuine Lovecraftian horror.
- **Descriptive density:** Every room has a full LDESC that paints a picture. Objects get careful, characterful descriptions. The computer is described as a "beyond-state-of-the-art personal computer" with "1024 by 1024 pixel color monitor" — very late-80s futurism.
- **Horror elements:** The "paper" the player discovers on the computer is a facsimile overlaid with "Olde English," combining "incomprehensible gibberish, latinate pseudowords, debased Hebrew and Arabic scripts, and an occasional disquieting phrase in English." This is classic Lovecraft pastiche.
- **Dark humor:** NPC dialogue has a sardonic wit. The hacker says things like "Greetingage" and "No snarfage, loser!" The parser responds to "hello" with "Cheery, aren't you?" and to "yes" with "That was a rhetorical question."

**In the port:** The prose renders correctly (except for some `nil` artifacts — see bugs below). The humor and atmosphere survive translation.

---

## 3. Parser Quality

### Tested against the AdventureArena ZIL runtime:

| Command | Result |
|---------|--------|
| `look` / `l` | Works |
| `i` (inventory) | Works ("You are empty-handed.") |
| `inventory` | ❌ "You used the word 'inventory' in a way that I don't understand." |
| `examine computer` | ❌ "You can't see any computer here." (intermittent) |
| `examine pc` | ✅ (shows detailed description) |
| `x pc` / `x computer` | ❌ "x" not recognized as a verb |
| `examine chair` | ❌ "You already are." (strange response) |
| `take chair` | Works (blank output, likely success) |
| `turn on pc` | ✅ (powers up the computer) |
| `turn on computer` | ❌ intermittent |
| `turn off pc` | ✅ (turns it off) |
| `read assignment` | ✅ (shows full assignment text) |
| `examine assignment` | ❌ "You can't see any assignment here." |
| `hello` | ✅ "Cheery, aren't you?" |
| `yes` | ✅ "That was a rhetorical question." |
| `help` | ✅ "Well, nothing happens. Perhaps you should turn on the computer?" |
| `wait` | ✅ "Time passes..." |
| `listen` | ✅ "You hear nothing unsettling." |
| `score` / `time` / `verbose` | Intermittent (blank output) |
| `sit` | ✅ "What do you want to sit at?" (prompts for object) |
| `sit chair` | Works |
| `ask hacker` | ✅ "What do you want to ask the hacker about?" |
| `ask hacker about <topic>` | Intermittent (blank output) |
| `talk to hacker` | ❌ "You used the word 'talk' in a way that I don't understand." |
| `type 872325412` | ❌ "You used the word '872325412' in a way that I don't understand." |
| `south` | ❌ **CRASH** — PUTP with nil |
| `examine outlet` | ❌ **Memory dump corruption** |
| `banners` / `posters` / `signs` | ❌ None recognized |
| `take chair` | ❌ "You can't see any chair here." (bizarre) |

### Critical parser observations:

1. **No `x` abbreviation:** The classic Infocom `x` for "examine" is not recognized. Players must type `examine` in full.

2. **Synonym coverage is inconsistent:** `pc` works but `computer` doesn't (intermittently). `i` works but `inventory` doesn't. `read assignment` works but `examine assignment` doesn't.

3. **Parsing of numbers fails:** The command `type 872325412` (which is essential for logging into the computer — the test transcript confirms this is the user ID) is not parsed. The number token isn't recognized as a valid noun.

4. **IT/HIM pronoun substitution:** The game setup code sets `P-IT-OBJECT` to `,PC` and `P-HIM-OBJECT` to `,HACKER` in GO(). This enables pronoun commands like `examine it` or `ask him about...`, but the pronoun system could not be tested due to the save/restore corruption.

5. **ALL/GWIM:** Not tested due to instability.

6. **OOPS:** Not tested.

---

## 4. World Model

Based on source code analysis and the reference walkthrough, the game world is rich:

| Element | Present? | Notes |
|---------|----------|-------|
| Furniture interaction | ✅ | CHAIR can be sat in, moved |
| Container objects | ✅ | Refrigerator, microwave, flask, cartons |
| Open/close mechanics | ✅ | Microwave, fridge, valve, hatch |
| Lock/unlock | ✅ | Padlock with master key |
| Vehicle (forklift) | ✅ | Can be boarded and driven |
| Light/dark | ✅ | Flashlight, pitch black rooms |
| Readable objects | ✅ | Letters, paper, signs |
| Food/eating | ✅ | Funny Bones, Chinese food, Coke |
| Wearable items | ✅ | Gloves, parka |
| Container hierarchy | ✅ | Items inside containers inside rooms |
| Surface support | ✅ | Tables, counters |

### In the AdventureArena port:

The world model is technically implemented (these are ZIL primitives that compile to Lua). However:

- **State persistence across save/restore is broken.** Objects that were described in the opening room become "cannot see" on subsequent commands. The PC is recognized or not recognized depending on... some unknown factor.
- **"examine outlet" triggers massive memory corruption** — raw bytes are printed to screen.
- **"examine chair" responds "You already are"** — a nonsensical response that suggests the parser is confusing the chair with the player or the room.

---

## 5. NPC Behavior

From the source code and reference walkthrough, the game has two major NPCs:

### The Hacker
- Present in the Terminal Room from the start
- Has dialogue: greets with "Greetingage," responds to questions
- Can be bribed with food (hot Chinese food triggers giving the master key)
- Prevents stealing Tech property ("No snarfage, loser!")
- Responds to ASK ABOUT and SHOW commands

### The Urchin
- Found in the Aero Basement area
- Wears a ski hat and parka
- Nervous, doesn't trust strangers
- Can be bribed with Funny Bones

### In the AdventureArena port:
- `ask hacker` triggers "What do you want to ask the hacker about?" — parsing works
- `ask hacker about <topic>` returns blank output — the response text is not captured
- The hacker object exists but dialogue interaction fails silently
- `tell hacker` also returns blank

The NPC system appears to be present but output capture fails for dialogue responses in the save/restore cycle.

---

## 6. Puzzle Design

From the walkthrough, the game's puzzle chain is elaborate and fair:

1. **Log in to the computer:** Type 872325412 as the user ID, then uhlersoth as the password. This is a "guess the ID" puzzle that expects you to find clues around the game.

2. **Read the weird paper:** After logging in, edit the Classics paper to reveal Lovecraftian content. Multiple "pages" revealed through MORE button.

3. **Bribe the hacker:** Heat Chinese food in the microwave (a multi-step puzzle involving the microwave's controls — press HI, set time with number buttons, press START, WAIT for the timer). Give the food to the hacker in exchange for the master key.

4. **Navigate the Comp Center:** Use the elevator (push call buttons, press floor numbers).

5. **Explore the basement/storage area:** Operate the forklift, move pallets, find the manhole.

6. **Descend into the tunnels:** Use the crowbar to open the manhole, navigate the brick tunnels.

7. **The altar and sacrifice:** Various Lovecraftian altar puzzles, comparing symbols, using the stone.

8. **Dead storage / steam tunnels:** Valve puzzles, brick wall breaking, cable climbing.

These are multi-step, logic-based puzzles with foreshadowing. The microwave puzzle, for example, has a setup (put food in), timing (set the timer), and payoff (warm food trades for key). This is classic Infocom puzzle design — fair, logical, but requiring exploration.

---

## 7. Reactivity

The game is highly reactive:
- Room descriptions update (verbose/ brief/ super-brief modes)
- Container states change (open/closed)
- NPCs move (the hacker may leave if scared off)
- The game tracks state: the hacking timer, the urchin's bribe state, what's in the microwave
- LIGHT status changes (going from lit to dark triggers danger)

**In the port:** Reactivity cannot be assessed because the CLOCKER crash and save/restore bugs prevent sustained play.

---

## 8. Death and Danger

Death is atmospheric and interesting:

- **Dark room death:** "One should never assume the dark is safe. Something just grabbed you from behind and dragged you off to its lair." — 80% probability when moving in darkness.
- **JIGS-UP routine:** The death sequence is flavorful: "At first, you think 'Maybe it was all just a bad dream,' but no such luck."
- **Tiredness:** The I-TIRED interrupt tracks fatigue. After 200 turns, you collapse from exhaustion.
- **Rats and monsters:** References to "ghoulish excitement" and "rats attacking" in the sound definitions suggest creature encounters.

**In the port:** The dark-room death cannot trigger because the `south` movement command crashes.

---

## 9. Clock/Daemon Systems

The game uses a sophisticated interrupt system defined in `interrupts.zil`:

| Interrupt | Ticks | Purpose |
|-----------|-------|---------|
| `I-URCHIN` | 10 | Timed urchin behavior |
| `I-TIRED` | 200 | Player fatigue tracking |

The CLOCKER (defined in `misc.zil` lines 831-878) runs every turn. It:
1. Decrements all timer ticks
2. Fires routines when ticks reach zero
3. Supports negative tick values for special timing

**CRITICAL BUG:** The CLOCKER crashes after approximately 8 turns. The error is:

```
bootstrap:1136: attempt to call a nil value (field '?')
```

This occurs at `APPLY(.RTN)` in the CLOCKER code (misc.zil line 868). The ZIL routine index stored in the C-TABLE (memory) does not map to a valid entry in the compiled Lua FUNCTIONS table. The root cause is that after SAVE/RESTORE, the FUNCTIONS table is rebuilt with different indices, but the memory-resident C-TABLE still references the old indices.

---

## 10. What's Great (About the Game Itself)

1. **Atmosphere:** The Lovecraftian academic horror is pitch-perfect. The mundane details (Coke cans, pizza boxes, deadlines) contrast brilliantly with the cosmic horror.

2. **Writing quality:** Dave Lebling's prose is evocative, witty, and efficient. Every description serves both atmosphere and gameplay.

3. **Puzzle integration:** Puzzles are diegetic — you're not solving arbitrary puzzles, you're:
   - Writing a paper → using a computer → finding weird files
   - Needing to eat → using the kitchen → discovering the microwave
   - An engineering student → operating a forklift feels natural

4. **Scope and density:** The walkthrough is ~300+ commands long. The game is substantial, with multiple distinct locations, NPCs, and puzzle chains.

5. **Humor:** The game balances horror with genuine wit. The hacker, the urchin's "momma said" dialogue, the parser sass — it's a very *playful* horror game.

---

## 11. What's Not So Great (About the AdventureArena Port)

### Critical Bugs

#### Bug 1: CLOCKER crash after ~8 turns
- **Impact:** **Game-breaking.** The game crashes after approximately 8 player commands with `attempt to call a nil value (field '?')`.
- **Root cause:** The CLOCKER system stores ZIL routine indices in memory (C-TABLE). After SAVE/RESTORE, the compiled FUNCTIONS table is rebuilt but with different indices, so stored indices point to nil.
- **Commands before crash:** ~8 commands from game start.

#### Bug 2: PUTP crash when moving south from Terminal Room
- **Impact:** **Game-breaking.** `south` crashes with `Only numbers are supported in PUTP, not nil`.
- **Root cause:** The HACKER-EXIT function for the south exit returns CS-2ND, which should be a valid room. PUTP receives nil, likely because the room object is not properly resolved after restore.
- **Reproduction:** 100% reproducible.

#### Bug 3: "examine outlet" produces memory dump
- **Impact:** **Critical.** Examining the outlet object prints hundreds of bytes of raw memory instead of a description.
- **Root cause:** The PRINTB/PRINTD functions are reading from corrupted or uninitialized memory, likely due to the save/restore cycle overwriting string pointers incorrectly.

#### Bug 4: Nil in screen display
- **Impact:** **High.** `examine pc` after turning it on prints: "On the screen you see nil6." instead of describing the screen contents.
- **Root cause:** The `<FIRST? ,PC>` call returns nil instead of the actual contents, and Lua concatenation converts nil to the string "nil".

### High Severity

#### Bug 5: Save/restore cycle corrupts game state
- **Impact:** **Game-blocking.** Objects that were visible at game start become invisible on subsequent commands. The PC is alternately recognized or not by "computer" vs "pc" names.

#### Bug 6: Number token parsing fails
- **Impact:** **Game-blocking.** The command `type 872325412` needed for computer login is rejected. The parser doesn't recognize number tokens as valid input.

#### Bug 7: NPC dialogue output not captured
- **Impact:** **High.** `ask hacker about <topic>` triggers the parser prompt but returns blank output. The NPC response text exists (confirmed in walkthrough) but is lost.

### Medium Severity

#### Bug 8: Verb coverage gaps
- `x` (examine abbreviation) not supported
- `inventory` not supported
- `talk` verb not supported
- `banners`/`posters`/`signs` from room description not implemented as objects
- Pseudo-objects (banner, poster, sign) defined in cs.zil:242 but not interactable

#### Bug 9: "You already are" response to examine chair
- The parser confuses the chair object with the player or room action.

### Low Severity

#### Bug 10: Missing serial number
- `Serial number 000000` in version output — the release/serial bytes are nil.

#### Bug 11: Blank output for some game verbs
- `score`, `time`, `verbose` return blank output instead of their text.

#### Bug 12: Missing sound support
- Sound effects (`$SOUND` toggle) are defined but have no hardware support, so the sound flag shows errors about missing sound resources.

---

## 12. Overall Player Feeling (in the AdventureArena Port)

The experience of *trying* to play The Lurking Horror through the AdventureArena port is frustrating. The game *wants* to be good — the opening paragraph pulls you in, the descriptions are rich, the parser works for basic commands — but every path forward is blocked by crashes or corruption.

**The emotional arc:**
1. **Curiosity:** "This is a cool opening, I want to explore."
2. **Encouragement:** Basic commands work. "i" shows inventory. "examine pc" gives a detailed description. "turn on pc" boots the computer.
3. **Frustration:** "south" crashes. "examine outlet" prints garbage. "read computer" crashes. "type 872325412" doesn't work.
4. **Despair:** After 8 commands, the CLOCKER fires and the game dies with a traceback.

It's like being given a beautifully wrapped present that disintegrates when you try to open it.

---

## 13. What I Would Recommend

For this game to be playable in AdventureArena, the following must be fixed in priority order:

1. **CLOCKER system:** Ensure that routine indices stored in the C-TABLE remain valid across SAVE/RESTORE cycles. Either:
   - Store routine names/strings instead of indices, or
   - Rebuild the C-TABLE with correct indices after RESTORE, or
   - Serialize the FUNCTIONS table as part of the save.

2. **PUTP nil guard:** Ensure that MOVE/GOTO never passes nil as a destination. Add error handling or default behavior for unresolved exits.

3. **PRINTB/memory string handling:** Fix the string property reader to gracefully handle nil or zero pointers instead of reading garbage bytes.

4. **Number token parsing:** Register number tokens in the parser vocabulary so typed numbers can be used as nouns.

5. **Save/restore reliability:** The entire save/restore cycle needs debugging — objects lose their location properties after restore.

---

## 14. Test Environment Details

```
Platform: macOS (Darwin)
Lua: lua5.4
Runtime: AdventureArena ZIL compiler (zilscript/)
Game: infocom.lurkinghorror.h1 (Release 15)
Interface: llm.lua (process-per-command save/restore model)
```

---

## Appendix: Reference Walkthrough Results

The game comes with a reference walkthrough in `test/lurkinghorror.txt` (947 lines) and an auto-generated test file at `test/test-auto-generated.zil` (389 assertions) covering:

- Computer login and document editing
- Kitchen exploration (refrigerator, microwave puzzles)
- NPC bribery (hacker with hot Chinese food, urchin with Funny Bones)
- Elevator navigation
- Lock/unlock mechanics
- Vehicle operation (forklift)
- Sub-basement and tunnel exploration
- Altar and Lovecraftian puzzles
- Item combination and comparison
- Inventory management

None of these paths can be tested in the current port due to the critical bugs above.

---

*Report generated by game tester agent after ~60 test commands across 10+ save files*
