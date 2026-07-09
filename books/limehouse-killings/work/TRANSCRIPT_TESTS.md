# The Limehouse Killings - Transcript Tests

## Golden Path Transcript

### Test 1: Full Investigation and Correct Accusation

```
> GO TO ASHWORTH-MANOR-GATE
You stand before the iron gates of Ashworth Manor. The gravel path leads north to the entrance. Fog swirls around your feet.

> SOUTH
You pass through the gates and approach the manor. The front door is slightly ajar.

> ENTER
You step into the entrance hall. A grand chandelier hangs from the ceiling, its crystals dull with dust. Portraits line the walls. A Persian rug covers the floor.

> LOOK
Entrance Hall
A grand foyer with cracked chandelier and dusty portraits. A Persian rug covers the floor. Exits: NORTH (to gate), SOUTH (to study), EAST (to library), WEST (to dining room), DOWN (to kitchen).

> EXAMINE RUG
A fine Persian rug, now faded and worn. Something dark stains the corner near the south door.

> SOUTH
The door to the study is locked. You'll need a key or tool to enter.

> EAST
Library
Floor-to-ceiling bookshelves line the walls. A reading desk stands near the fireplace. Colored markers dot the shelves. Exits: WEST (to entrance hall).

> EXAMINE BOOKSHELF
The bookshelf is arranged by color. Red, blue, green, and yellow markers are visible on different shelves. Some books have colored spines.

> EXAMINE READING-DESK
A reading desk with a torn page lying on it.

> TAKE TORN-PAGE
You take the torn page.

> READ TORN-PAGE
The page reads: "Follow the rainbow order. Red, orange, yellow, green, blue, violet. Only then will the way open."

> EXAMINE COLORED-MARKERS
The markers are: RED on shelf 1, BLUE on shelf 3, GREEN on shelf 4, YELLOW on shelf 2.

> PUSH RED BOOK
You push a book with a red spine on shelf 1. It clicks into place.

> PUSH BLUE BOOK
You push a book with a blue spine on shelf 3. It clicks into place.

> PUSH GREEN BOOK
You push a book with a green spine on shelf 4. It clicks into place.

> PUSH YELLOW BOOK
You push a book with a yellow spine on shelf 2. It clicks into place.

A section of the bookshelf slides open, revealing a narrow stone passage.

> ENTER SECRET-PASSAGE
You step into the secret passage. Dust and cobwebs fill the air. The passage leads west to the library and east to the study.

> EAST
Study
The study is a crime scene. A body outline marks the floor near the desk. A mahogany desk stands against the wall. A fireplace contains a locked box. A window looks out to the garden. Exits: NORTH (to entrance hall).

> EXAMINE BODY-OUTLINE
A chalk outline marks where the body was found. The victim was struck from behind, then poisoned.

> EXAMINE DESK
The mahogany desk has three drawers. An unsent letter and a poison bottle lie on top.

> TAKE DEAD-LETTER
You take the unsent letter.

> READ DEAD-LETTER
The letter reads: "My dear Dr. Moriarty, I know what you did. If you do not confess by Friday, I will expose you to Scotland Yard. - Lord Ashworth"

> TAKE POISON-BOTTLE
You take the poison bottle.

> EXAMINE POISON-BOTTLE
The bottle is labeled: "Aconitum - Wolfsbane. Highly poisonous."

> EXAMINE FIREPLACE
The fireplace contains cold ashes and a locked box.

> EXAMINE LOCKED-BOX
The locked box is small and ornate. It has a keyhole.

> EXAMINE WINDOW
The window is old, with a rusty latch. It looks out to the garden.

> NORTH
Entrance Hall

> WEST
Dining Room
A long dining table dominates the room. A wine cabinet stands against the wall. Portraits of the family hang above. Exits: EAST (to entrance hall), NORTH (to pantry).

> EXAMINE TABLE
The dining table is set for two, but only one place was used. A wax seal lies near the empty plate.

> TAKE WAX-SEAL
You take the wax seal.

> EXAMINE WAX-SEAL
The wax seal bears the initial "M" - Moriarty.

> EXAMINE WINE-CABINET
The wine cabinet is locked. It contains fine wines and spirits.

> NORTH
Pantry
A small pantry with shelves of food and wine. Exits: SOUTH (to dining room).

> EXAMINE SHELVES
The shelves hold canned goods, spices, and a bottle of antidote ingredients.

> TAKE FOXGLOVE
You take the foxglove.

> TAKE CHARCOAL
You take the charcoal.

> SOUTH
Dining Room

> EAST
Entrance Hall

> DOWN
Kitchen
A kitchen with copper pots, a cold hearth, and a servant bell. A drawer in the counter is slightly open. Exits: UP (to entrance hall), WEST (to garden).

> EXAMINE POTS
Copper pots hang from the ceiling, tarnished with age.

> EXAMINE HEARTH
The hearth is cold, with ashes from yesterday's fire.

> OPEN DRAWER
You open the drawer. Inside is a lockpick set.

> TAKE LOCKPICK-SET
You take the lockpick set.

> EXAMINE BELL
A servant bell hangs from the wall. A rope leads up to the servant's quarters.

> PULL BELL
You pull the bell rope. A distant bell rings upstairs.

> WEST
Garden
An overgrown garden with a fountain at the center. Hedge mazes line the paths. A blood-stained knife lies in the hedge near the fountain. Exits: EAST (to kitchen), NORTH (to greenhouse), SOUTH (to servants' quarters).

> EXAMINE FOUNTAIN
The fountain is dry, with coins at the bottom. A footprint cast lies nearby.

> TAKE FOOTPRINT-CAST
You take the footprint cast.

> EXAMINE FOOTPRINT-CAST
The cast shows a boot print size 10 - too large for Lady Ashworth.

> EXAMINE HEDGE
The hedge is thick and overgrown. Something glints in the branches.

> TAKE BLOOD-STAINED-KNIFE
You take the blood-stained knife.

> EXAMINE BLOOD-STAINED-KNIFE
The knife is stained with dried blood. It matches the surgical tools in Dr. Moriarty's office.

> NORTH
Greenhouse
A glass greenhouse with exotic plants. Labels mark the pots. A potting bench stands near the door. Exits: SOUTH (to garden).

> EXAMINE PLANTS
Exotic plants fill the greenhouse. One plant has distinctive purple flowers - wolfsbane.

> EXAMINE LABELS
The labels read: "Aconitum - Wolfsbane" on the purple plant. "Digitalis - Foxglove" on another.

> MATCH POISON-BOTTLE TO LABEL
You match the poison bottle label to the wolfsbane plant. The poison came from this greenhouse.

> SOUTH
Garden

> SOUTH
Servants' Quarters
Sparse rooms with servant beds and a trunk. Mr. Hudson, the butler, is here. Exits: NORTH (to garden).

> EXAMINE BEDS
Simple beds for the household staff. They are empty.

> EXAMINE TRUNK
A large trunk contains servant uniforms and a letter.

> TAKE LETTER
You take the letter.

> READ LETTER
The letter is from Dr. Moriarty to Mr. Hudson: "Keep your mouth shut about the poison, or you'll join your master."

> ASK HUDSON ABOUT MASTER
"Lord Ashworth was a difficult man. He fired me last week."

> ASK HUDSON ABOUT ALIBI
"I was here in the servants' quarters all evening. You can check with the other servants."

> ASK HUDSON ABOUT KEY
"I suppose you'll need this." He hands you a key. "The study key. I kept it for safekeeping."

> TAKE KEY
You take the key.

> ASK HUDSON ABOUT MORIARTY
"Dr. Moriarty? He visited often. He and the master had... disagreements."

> NORTH
Garden

> EAST
Kitchen

> UP
Entrance Hall

> SOUTH
Study
You unlock the door with the key. The study is a crime scene.

> EXAMINE DESK (again)
The desk drawers are empty except for one. You find a secret ledger.

> TAKE SECRET-LEDGER
You take the secret ledger.

> READ SECRET-LEDGER
The ledger shows Dr. Moriarty owed Lord Ashworth £500. The debt was due this week.

> USE LOCKPICK ON LOCKED-BOX
You use the lockpick set on the locked box. It clicks open.

> TAKE BANK-STATEMENT
You take the bank statement.

> READ BANK-STATEMENT
The statement shows Dr. Moriarty's account is overdrawn. He recently withdrew a large sum for "experimental supplies."

> LOOK
You have gathered all the evidence:
1. Dead letter threatening Dr. Moriarty
2. Blood-stained knife matching Moriarty's tools
3. Bank statement showing Moriarty's debt
4. Poison bottle from Moriarty's greenhouse
5. Secret ledger showing financial motive

> GO TO ENTRANCE-HALL
You return to the entrance hall. Inspector Lestrade has arrived.

> ASK INSPECTOR ABOUT CASE
"Ah, the detective. What have you found?"

> ACCUSE DR-MORIARTY
"Dr. Moriarty, you are under arrest for the murder of Lord Ashworth."

> SHOW DEAD-LETTER TO INSPECTOR
The inspector reads the letter. "This is damning evidence."

> SHOW BLOOD-STAINED-KNIFE TO INSPECTOR
"The knife matches the wound. And it's from Moriarty's collection."

> SHOW BANK-STATEMENT TO INSPECTOR
"Moriarty owed the victim money. Motive established."

> SHOW POISON-BOTTLE TO INSPECTOR
"Wolfsbane. Rare poison. Only Moriarty had access."

> SHOW SECRET-LEDGER TO INSPECTOR
"And the ledger shows he was being blackmailed. Case closed."

> GAME OVER
Congratulations! You have solved the murder of Lord Ashworth.
Dr. Moriarty has been arrested for the crime.
Your reputation as a detective is secured.
```

## Failure Path Transcripts

### Test 2: Wrong Accusation

```
> [After gathering evidence]
> ACCUSE LADY-ASHWORTH
"Lady Ashworth has an alibi. The evidence doesn't match. Try again."

> ACCUSE MR-HUDSON
"Mr. Hudson was in servants' quarters. The knife isn't his. Try again."

> ACCUSE DR-MORIARTY
"Dr. Moriarty, you are under arrest for the murder of Lord Ashworth."
[Game continues with evidence presentation]
```

### Test 3: Missing Evidence

```
> [Without all 5 evidence items]
> ACCUSE DR-MORIARTY
"You don't have enough evidence. Gather more clues before making an accusation."
```

### Test 4: Dangerous Action

```
> TASTE POISON
You feel dizzy. Perhaps that wasn't wise.
[Health reduced]

> TASTE POISON (again)
You collapse. Everything goes dark.
GAME OVER - You have died.
```

### Test 5: Wrong Cipher Order

```
> PUSH BLUE BOOK
Nothing happens. Perhaps there's an order to follow.

> PUSH GREEN BOOK
Nothing happens.

> PUSH RED BOOK
You push a book with a red spine. It clicks into place.
```

## Room/Object Checklist Commands

### Room Visits
```
GO TO ASHWORTH-MANOR-GATE
GO TO ASHWORTH-ENTRANCE-HALL
GO TO STUDY
GO TO LIBRARY
GO TO DINING-ROOM
GO TO KITCHEN
GO TO GARDEN
GO TO GREENHOUSE
GO TO SERVANTS-QUARTERS
GO TO SECRET-PASSAGE
```

### Object Interactions
```
EXAMINE BODY-OUTLINE
EXAMINE DESK
EXAMINE FIREPLACE
EXAMINE WINDOW
EXAMINE BOOKSHELF
EXAMINE READING-DESK
EXAMINE TABLE
EXAMINE WINE-CABINET
EXAMINE POTS
EXAMINE HEARTH
EXAMINE FOUNTAIN
EXAMINE HEDGE
EXAMINE PLANTS
EXAMINE BENCH
EXAMINE BEDS
EXAMINE TRUNK
```

### Evidence Collection
```
TAKE DEAD-LETTER
TAKE BLOOD-STAINED-KNIFE
TAKE POISON-BOTTLE
TAKE SECRET-LEDGER
USE LOCKPICK ON LOCKED-BOX
TAKE BANK-STATEMENT
```

### NPC Conversations
```
ASK HUDSON ABOUT MASTER
ASK HUDSON ABOUT ALIBI
ASK HUDSON ABOUT KEY
ASK HUDSON ABOUT MORIARTY
ASK LADY ABOUT MARRIAGE
ASK LADY ABOUT ALIBI
ASK LADY ABOUT ENEMIES
ASK MORIARTY ABOUT EXPERIMENTS
ASK MORIARTY ABOUT POISON
ASK MORIARTY ABOUT RELATIONSHIP
```

## Bug Ledger

| Bug ID | Category | Description | Reproduction | Status |
|--------|----------|-------------|--------------|--------|
| BUG-001 | Parser | "TAKE LETTER" fails in servants' quarters | TAKE LETTER in SERVANTS-QUARTERS | Open |
| BUG-002 | State | LOCKED-BOX can be opened without key | USE LOCKPICK ON LOCKED-BOX without finding key | Open |
| BUG-003 | Content | INSPECTOR doesn't appear after evidence | Gather all evidence, return to entrance hall | Open |
| BUG-004 | Parser | "ACCUSE KILLER" doesn't work | ACCUSE KILLER (without naming suspect) | Open |
| BUG-005 | Softlock | Can enter study without evidence | Enter study via secret passage, skip evidence | Open |

## Fix Changelog

| Fix ID | Bug ID | Description | Files Affected | Date |
|--------|--------|-------------|----------------|------|
| FIX-001 | BUG-001 | Add LETTER to servants' quarters objects | dungeon.zil | - |
| FIX-002 | BUG-002 | Require key OR lockpick for locked box | actions.zil | - |
| FIX-003 | BUG-003 | Trigger inspector after 5 evidence | actions.zil | - |
| FIX-004 | BUG-004 | Add "ACCUSE KILLER" parser response | actions.zil | - |
| FIX-005 | BUG-005 | Block secret passage until study unlocked | dungeon.zil | - |
