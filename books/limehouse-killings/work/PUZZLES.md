# The Limehouse Killings - Puzzle Design

## Puzzle Overview

| # | Puzzle | Location | Difficulty | Time |
|---|--------|----------|------------|------|
| 1 | Study Entry | ENTRANCE-HALL | Easy | 10 min |
| 2 | Library Cipher | LIBRARY | Medium | 20 min |
| 3 | Greenhouse Poison | GREENHOUSE | Medium | 15 min |
| 4 | Final Confrontation | STUDY | Hard | 15 min |

## Puzzle 1: Study Entry

### Goal
Enter the locked study where the murder occurred.

### Solution Path
**Primary:** Get key from Mr. Hudson
1. ASK HUDSON ABOUT KEY
2. Hudson refuses initially
3. ASK HUDSON ABOUT MASTER
4. Hudson reveals he was fired by Lord Ashworth
5. ASK HUDSON ABOUT ALIBI
6. Hudson provides alibi (in servants' quarters)
7. ASK HUDSON ABOUT KEY (again)
8. Hudson gives key, wants case solved

**Secondary:** Use lockpick on window
1. FIND LOCKPICK-SET in KITCHEN
2. GO TO GARDEN
3. EXAMINE WINDOW (from outside)
4. USE LOCKPICK ON WINDOW
5. Window opens, can enter study

### Clues
- Butler mentioned carrying key in servants' quarters
- Window visible from garden, latch appears old
- TORN-PAGE mentions "study locked from inside"

### Wrong Attempts
- **BREAK DOOR:** "The door is solid oak. You'd need a battering ram."
- **CLIMB WINDOW (without lockpick):** "The window is too high. You need a tool."
- **ASK LADY ABOUT KEY:** "I don't have such things. Ask the butler."

### Hint Tiers
1. **Attention:** "The study door is locked. Perhaps someone has the key."
2. **Direction:** "The butler might know where the key is kept."
3. **Action:** "Ask Mr. Hudson about the key, but be persistent."
4. **Command:** `ASK HUDSON ABOUT KEY`

### Dependencies
- None (can be solved first)

### Softlock Prevention
- Lockpick alternative ensures butler isn't required
- Window accessible from multiple garden paths
- No time limit on getting key

## Puzzle 2: Library Cipher

### Goal
Decode the hidden message in the bookshelf arrangement to reveal secret passage.

### Solution Path
1. EXAMINE BOOKSHELF
2. Notice COLORED-MARKERS on shelves (red, blue, green, yellow)
3. FIND TORN-PAGE on reading desk
4. READ TORN-PAGE: "Follow the rainbow order"
5. EXAMINE COLORED-MARKERS
6. Apply rainbow order to the colors that are actually marked: red, yellow, green, blue
7. Push books in rainbow order on marked shelves
8. Wall slides open, revealing SECRET-PASSAGE

### Clues
- TORN-PAGE mentions "rainbow order"
- COLORED-MARKERS visible on bookshelf
- Some books have colored spines matching markers
- DR-MORIARTY mentions "hidden study entrance" if asked

### Wrong Attempts
- **PUSH RANDOM BOOKS:** "Nothing happens. Perhaps there's an order to follow."
- **READ ALL BOOKS:** "The books are unremarkable Victorian literature."
- **ASK HUDSON ABOUT PASSAGE:** "I know of no such thing."

### Hint Tiers
1. **Attention:** "The bookshelf has colored markers. Perhaps they mean something."
2. **Direction:** "The torn page mentions 'rainbow order'."
3. **Action:** "Push the books with colored spines in rainbow order."
4. **Command:** `PUSH RED BOOK THEN PUSH YELLOW BOOK THEN PUSH GREEN BOOK THEN PUSH BLUE BOOK`

### Dependencies
- None (parallel to Puzzle 1)

### Softlock Prevention
- Torn page provides clear hint
- Colored markers are visible without magnification
- Multiple attempts allowed
- No penalty for wrong order

## Puzzle 3: Greenhouse Poison

### Goal
Identify the poison used to kill Lord Ashworth and find antidote ingredients.

### Solution Path
1. EXAMINE POISON-BOTTLE in STUDY
2. Read label: "Aconitum - Wolfsbane"
3. GO TO GREENHOUSE
4. EXAMINE PLANTS
5. FIND POISON-PLANT (wolfsbane)
6. EXAMINE LABELS on pots
7. MATCH POISON-BOTTLE to plant label
8. Take antidote ingredients (foxglove, charcoal)

### Clues
- POISON-BOTTLE label matches plant in greenhouse
- DR-MORIARTY specializes in rare poisons
- LADY-ASHWORTH mentions husband's "experimental treatments"
- TORN-PAGE mentions "wolfsbane remedy"

### Wrong Attempts
- **SMELL POISON:** "The scent is faint but distinctive. Best not to inhale."
- **TASTE POISON:** "You feel dizzy. Perhaps that wasn't wise." (lose health)
- **ASK LADY ABOUT POISON:** "I know nothing of such things." (lying)

### Hint Tiers
1. **Attention:** "The poison bottle has a label. Greenhouse plants have labels too."
2. **Direction:** "Match the poison bottle to a plant in the greenhouse."
3. **Action:** "Find the wolfsbane plant and take the antidote ingredients."
4. **Command:** `EXAMINE POISON-BOTTLE THEN FIND WOLFSBANE IN GREENHOUSE`

### Dependencies
- Requires access to STUDY (Puzzle 1)
- Requires GREENHOUSE exploration

### Softlock Prevention
- Poison bottle has readable label
- Plant labels are visible
- Antidote ingredients are takeable
- No permanent damage from wrong attempts

## Puzzle 4: Final Confrontation

### Goal
Present correct evidence to Inspector Lestrade to accuse the killer.

### Solution Path
1. Gather all 5 evidence items:
   - DEAD-LETTER (threat from victim)
   - BLOOD-STAINED-KNIFE (murder weapon)
   - LOCKED-BOX (with BANK-STATEMENT)
   - POISON-BOTTLE (rare poison)
   - SECRET-LEDGER (financial records)
2. GO TO ENTRANCE-HALL (Inspector arrives)
3. ASK INSPECTOR ABOUT CASE
4. ACCUSE DR-MORIARTY
5. SHOW EVIDENCE TO INSPECTOR (one by one)
6. Game ends with arrest

### Clues
- DEAD-LETTER threatens Dr. Moriarty
- BLOOD-STAINED-KNIFE matches Moriarty's surgical tools
- BANK-STATEMENT shows Moriarty owed victim money
- POISON-BOTTLE is rare, only Moriarty has access
- SECRET-LEDGER shows Moriarty was being blackmailed

### Wrong Attempts
- **ACCUSE LADY-ASHWORTH:** "Lady Ashworth has an alibi. The evidence doesn't match."
- **ACCUSE MR-HUDSON:** "Mr. Hudson was in servants' quarters. The knife isn't his."
- **ACCUSE UNKNOWN:** "You must name a specific suspect."
- **SHOW EVIDENCE TO WRONG PERSON:** "That's not the Inspector."

### Hint Tiers
1. **Attention:** "The evidence must point to one suspect."
2. **Direction:** "Consider who had means, motive, and opportunity."
3. **Action:** "Dr. Moriarty had poison, owed money, and no alibi."
4. **Command:** `ACCUSE DR-MORIARTY`

### Dependencies
- Requires all 5 evidence items
- Requires all NPCs interviewed
- Requires INSPECTOR present

### Softlock Prevention
- Evidence is findable in multiple orders
- Inspector arrives after sufficient investigation
- Wrong accusations provide clear feedback
- Can retry accusation if wrong first time

## Puzzle Dependency Graph

```
PUZZLE 1 (Study Entry)
    ↓
PUZZLE 3 (Greenhouse Poison) ← requires study access
    ↓
PUZZLE 4 (Final Confrontation) ← requires all evidence

PUZZLE 2 (Library Cipher) ← parallel, no dependencies
```

## Verb/Object Response Matrix

| Verb | Object | Response |
|------|--------|----------|
| EXAMINE | POISON-BOTTLE | "Label reads: Aconitum - Wolfsbane" |
| READ | DEAD-LETTER | "My dear Dr. Moriarty, I know what you did..." |
| TAKE | BLOOD-STAINED-KNIFE | "You take the knife carefully." |
| USE | LOCKPICK ON DOOR | "The lock clicks open." |
| ASK | HUDSON ABOUT KEY | "I suppose you'll need this." (gives key) |
| SHOW | DEAD-LETTER TO LADY | "Where did you get that?" (surprised) |
| ACCUSE | DR-MORIARTY | "Dr. Moriarty, you are under arrest." |

## Softlock Mitigation List

1. **Study Entry:** Lockpick alternative to key
2. **Library Cipher:** Clear hint on torn page
3. **Greenhouse Poison:** Labels match visibly
4. **Final Confrontation:** Inspector arrives automatically
5. **No Dead Ends:** All rooms have exit paths
6. **No Time Limits:** Player explores at own pace
7. **Multiple Solutions:** Some puzzles have alternatives
8. **Hint System:** Available for stuck players
