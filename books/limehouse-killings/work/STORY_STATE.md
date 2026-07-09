# The Limehouse Killings - Story State

## Global Variables

### Game Progress

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| GAME-WON | BOOLEAN | FALSE | Set TRUE when killer correctly accused |
| GAME-LOST | BOOLEAN | FALSE | Set TRUE when wrong accusation or death |
| GAME-ENDED | BOOLEAN | FALSE | Set TRUE when game over (win or lose) |

### Investigation Progress

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| EVIDENCE-FOUND | COUNTER | 0 | Number of key evidence items found (0-5) |
| SUSPECTS-INTERVIEWED | COUNTER | 0 | Number of suspects interviewed (0-3) |
| CLUES-CONNECTED | COUNTER | 0 | Number of clue connections made (0-4) |

### Room Access

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| STUDY-UNLOCKED | BOOLEAN | FALSE | Set TRUE when study door opened |
| SECRET-PASSAGE-FOUND | BOOLEAN | FALSE | Set TRUE when passage discovered |
| SECRET-PASSAGE-OPEN | BOOLEAN | FALSE | Set TRUE when passage wall opened |

### NPC States

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| HUDSON-INTERVIEWED | BOOLEAN | FALSE | Set TRUE after talking to butler |
| LADY-INTERVIEWED | BOOLEAN | FALSE | Set TRUE after talking to Lady Ashworth |
| MORIARTY-INTERVIEWED | BOOLEAN | FALSE | Set TRUE after talking to Dr. Moriarty |
| HUDSON-KEY-GIVEN | BOOLEAN | FALSE | Set TRUE when butler gives key |
| HUDSON-MOTIVE-REVEALED | BOOLEAN | FALSE | Set TRUE when butler's motive revealed |
| LADY-ALIBI-CLAIMED | BOOLEAN | FALSE | Set TRUE when Lady claims alibi |
| MORIARTY-POISON-KNOWN | BOOLEAN | FALSE | Set TRUE when Moriarty's poison expertise known |
| INSPECTOR-PRESENT | BOOLEAN | FALSE | Set TRUE when Inspector arrives |

### Evidence Found

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| DEAD-LETTER-FOUND | BOOLEAN | FALSE | Key evidence #1 |
| KNIFE-FOUND | BOOLEAN | FALSE | Key evidence #2 |
| LOCKED-BOX-OPENED | BOOLEAN | FALSE | Key evidence #3 (contains BANK-STATEMENT) |
| POISON-BOTTLE-FOUND | BOOLEAN | FALSE | Key evidence #4 |
| SECRET-LEDGER-FOUND | BOOLEAN | FALSE | Key evidence #5 |

### Puzzle States

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| CIPHER-SOLVED | BOOLEAN | FALSE | Set TRUE when bookshelf cipher solved |
| POISON-IDENTIFIED | BOOLEAN | FALSE | Set TRUE when poison type known |
| ANTIDOTE-FOUND | BOOLEAN | FALSE | Set TRUE when antidote ingredients found |
| KILLER-ACCUSED | BOOLEAN | FALSE | Set TRUE when accusation made |
| CORRECT-ACCUSATION | BOOLEAN | FALSE | Set TRUE if accusation is correct |

### Timer/Counter States

| Variable | Type | Initial | Description |
|----------|------|---------|-------------|
| ROOMS-VISITED | COUNTER | 0 | Number of unique rooms visited |
| ITEMS-TAKEN | COUNTER | 0 | Number of items taken |
| WRONG-ATTEMPTS | COUNTER | 0 | Number of failed puzzle attempts |
| HINT-LEVEL | COUNTER | 0 | Current hint level (0-4) |

## State Transitions

### Study Entry
```
STUDY-UNLOCKED = FALSE → STUDY-UNLOCKED = TRUE
  Triggers: USE KEY ON DOOR or USE LOCKPICK ON WINDOW
  Effects: Can now enter STUDY from ENTRANCE-HALL
```

### Library Cipher
```
CIPHER-SOLVED = FALSE → CIPHER-SOLVED = TRUE
  Triggers: Push books in correct rainbow order
  Effects: SECRET-PASSAGE-FOUND = TRUE, SECRET-PASSAGE-OPEN = TRUE
  Can now: ENTER SECRET-PASSAGE from LIBRARY
```

### Evidence Collection
```
EVIDENCE-FOUND = N → EVIDENCE-FOUND = N+1
  Triggers: TAKE specific evidence item
  Effects: Corresponding *-FOUND = TRUE
  When EVIDENCE-FOUND = 5: INSPECTOR-PRESENT = TRUE (after delay)
```

### NPC Interview
```
SUSPECTS-INTERVIEWED = N → SUSPECTS-INTERVIEWED = N+1
  Triggers: Complete conversation with NPC
  Effects: Corresponding *-INTERVIEWED = TRUE
  When SUSPECTS-INTERVIEWED = 3: Can make accusation
```

### Final Confrontation
```
KILLER-ACCUSED = FALSE → KILLER-ACCUSED = TRUE
  Triggers: ACCUSE [SUSPECT] with all evidence
  Effects: 
    If CORRECT-ACCUSATION = TRUE: GAME-WON = TRUE
    If CORRECT-ACCUSATION = FALSE: GAME-LOST = TRUE
  GAME-ENDED = TRUE
```

## Milestone Flags

### Early Game
- [ ] Arrived at ASHWORTH-MANOR-GATE
- [ ] Entered ASHWORTH-ENTRANCE-HALL
- [ ] Met MR-HUDSON
- [ ] Received KEY from MR-HUDSON

### Mid Game
- [ ] Entered STUDY
- [ ] Found DEAD-LETTER
- [ ] Found POISON-BOTTLE
- [ ] Solved LIBRARY CIPHER
- [ ] Found SECRET-PASSAGE
- [ ] Interviewed LADY-ASHWORTH
- [ ] Interviewed DR-MORIARTY

### Late Game
- [ ] Found BLOOD-STAINED-KNIFE
- [ ] Found LOCKED-BOX
- [ ] Found SECRET-LEDGER
- [ ] Identified POISON
- [ ] Found ANTIDOTE
- [ ] Gathered all 5 evidence items
- [ ] INSPECTOR-PRESENT = TRUE

### End Game
- [ ] Accused killer
- [ ] Presented evidence to Inspector
- [ ] GAME-WON = TRUE or GAME-LOST = TRUE

## Consequence Mapping

### Wrong Accusation
```
ACCUSE LADY-ASHWORTH
  Result: "Lady Ashworth has an alibi. The evidence doesn't match."
  Effect: WRONG-ATTEMPTS += 1
  Can retry: YES

ACCUSE MR-HUDSON
  Result: "Mr. Hudson was in servants' quarters. The knife isn't his."
  Effect: WRONG-ATTEMPTS += 1
  Can retry: YES

ACCUSE DR-MORIARTY (with all evidence)
  Result: "Dr. Moriarty, you are under arrest for the murder of Lord Ashworth."
  Effect: GAME-WON = TRUE
```

### Dangerous Actions
```
TASTE POISON
  Result: "You feel dizzy. Perhaps that wasn't wise."
  Effect: PLAYER-HEALTH -= 1
  Can continue: YES (if health > 0)

CONFRONT KILLER UNARMED
  Result: "The killer attacks you. Everything goes dark."
  Effect: GAME-LOST = TRUE
  Can continue: NO
```

### Missed Evidence
```
END GAME WITH EVIDENCE-FOUND < 5
  Result: "The case goes cold. Insufficient evidence."
  Effect: GAME-LOST = TRUE
  Can continue: NO
```

## Save/Restore Points

The game does not implement save/restore. All state is held in memory during play.

## Testing State Assertions

### Golden Path Assertions
```
ASSERT STUDY-UNLOCKED = TRUE
ASSERT CIPHER-SOLVED = TRUE
ASSERT EVIDENCE-FOUND = 5
ASSERT SUSPECTS-INTERVIEWED = 3
ASSERT GAME-WON = TRUE
```

### Failure Path Assertions
```
ASSERT GAME-LOST = TRUE (wrong accusation)
ASSERT GAME-LOST = TRUE (death)
ASSERT EVIDENCE-FOUND < 5 (missed evidence)
```
