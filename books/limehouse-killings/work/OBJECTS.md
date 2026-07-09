# The Limehouse Killings - Object Registry

## Global Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| FOG | Fog | mist, haze | SCENERY | ASHWORTH-MANOR-GATE | Atmosphere |
| GATES | Iron Gates | gate, bars | SCENERY | ASHWORTH-MANOR-GATE | Entry barrier |
| PATH | Gravel Path | walkway, drive | SCENERY | ASHWORTH-MANOR-GATE | Navigation |
| CHANDELIER | Chandelier | light, crystal | SCENERY | ENTRANCE-HALL | Atmosphere |
| PORTRAITS | Portraits | paintings, pictures | SCENERY | ENTRANCE-HALL | Atmosphere |
| RUG | Persian Rug | carpet, mat | SCENERY | ENTRANCE-HALL | Hidden item? |

## Evidence Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| DEAD-LETTER | Unsent Letter | letter, note, paper | TAKEBIT READBIT | STUDY (on desk) | Key evidence #1 |
| BLOOD-STAINED-KNIFE | Blood-Stained Knife | knife, blade, weapon | TAKEBIT | GARDEN (in hedge) | Murder weapon |
| LOCKED-BOX | Locked Box | box, case, container | CONTAINERBIT | STUDY (in fireplace) | Key evidence #2 |
| POISON-BOTTLE | Poison Bottle | bottle, vial, poison | TAKEBIT READBIT | STUDY (in desk) | Key evidence #3 |
| SECRET-LEDGER | Secret Ledger | ledger, book, account | TAKEBIT READBIT | LIBRARY (hidden in shelf) | Key evidence #4 |

## Tool Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| MAGNIFYING-GLASS | Magnifying Glass | glass, lens, magnifier | TAKEBIT | ENTRANCE-HALL (on table) | Examine small clues |
| LOCKPICK-SET | Lockpick Set | picks, tools | TAKEBIT | KITCHEN (in drawer) | Open locked doors |
| LANTERN | Lantern | lamp, light | TAKEBIT LIGHTBIT | SERVANTS-QUARTERS | Illuminate dark areas |
| KEYRING | Keyring | keys, key | TAKEBIT | MR. HUDSON (gives freely) | Open locked study |

## Clue Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| TORN-PAGE | Torn Page | page, fragment | TAKEBIT READBIT | LIBRARY (on desk) | Cipher clue |
| COLORED-MARKERS | Colored Markers | markers, ribbons, tags | SCENERY | LIBRARY (on shelves) | Cipher clue |
| FOOTPRINT-CAST | Footprint Cast | cast, mold, footprint | TAKEBIT | GARDEN (near fountain) | Alibi evidence |
| WAX-SEAL | Wax Seal | seal, stamp | TAKEBIT | DINING-ROOM (on table) | Identifies letter writer |
| BANK-STATEMENT | Bank Statement | statement, receipt | TAKEBIT READBIT | STUDY (in locked box) | Financial motive |

## Furniture/Scenery Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| DESK | Mahogany Desk | desk, table | SCENERY | STUDY | Evidence location |
| FIREPLACE | Fireplace | hearth, fire | SCENERY | STUDY | Hidden items |
| WINDOW | Window | glass, pane | SCENERY | STUDY | Alternate entry |
| BOOKSHELF | Bookshelf | shelves, books | SCENERY | LIBRARY | Cipher puzzle |
| READING-DESK | Reading Desk | lectern, stand | SCENERY | LIBRARY | Torn page location |
| TABLE | Dining Table | table, board | SCENERY | DINING-ROOM | NPC encounter |
| WINE-CABINET | Wine Cabinet | cabinet, cupboard | SCENERY | DINING-ROOM | Hidden compartment |
| POTS | Copper Pots | pans, cookware | SCENERY | KITCHEN | Atmosphere |
| HEARTH | Cold Hearth | stove, oven | SCENERY | KITCHEN | Tool location |
| BELL | Servant Bell | bell, rope | SCENERY | KITCHEN | Summon NPCs |
| FOUNTAIN | Fountain | well, basin | SCENERY | GARDEN | Evidence location |
| HEDGES | Hedge Maze | hedges, bushes | SCENERY | GARDEN | Knife location |
| PLANTS | Exotic Plants | plants, flowers | SCENERY | GREENHOUSE | Poison identification |
| BENCH | Potting Bench | bench, table | SCENERY | GREENHOUSE | Label location |
| POTS | Flower Pots | pots, containers | SCENERY | GREENHOUSE | Poison source |
| BEDS | Servant Beds | beds, cots | SCENERY | SERVANTS-QUARTERS | Atmosphere |
| TRUNK | Trunk | chest, box | SCENERY | SERVANTS-QUARTERS | Hidden items |
| UNIFORMS | Servant Uniforms | clothes, livery | SCENERY | SERVANTS-QUARTERS | Atmosphere |

## NPC Objects

| ID | Name | Synonyms | Flags | Location | Puzzle Role |
|----|------|----------|-------|----------|-------------|
| MR-HUDSON | Mr. Hudson | butler, hudson | NPC | SERVANTS-QUARTERS | Info provider, key holder |
| LADY-ASHWORTH | Lady Ashworth | lady, wife | NPC | DINING-ROOM | Suspect, alibi provider |
| DR-MORIARTY | Dr. Moriarty | doctor, moriarty | NPC | LIBRARY | Suspect, poison expert |
| INSPECTOR | Inspector Lestrade | inspector, lestrade | NPC | ENTRANCE-HALL (final) | Case resolution |

## Object Count

- **Total Objects:** 35
- **Takeable Objects:** 12
- **Scenery Objects:** 18
- **NPC Objects:** 4
- **Evidence Objects:** 5 (key to winning)

## Object Relationships

- **LOCKED-BOX** contains: BANK-STATEMENT, SECRET-LEDGER
- **DESK** holds: DEAD-LETTER, POISON-BOTTLE
- **BOOKSHELF** hides: SECRET-LEDGER, COLORED-MARKERS
- **GARDEN** contains: BLOOD-STAINED-KNIFE, FOOTPRINT-CAST
- **WINE-CABINET** contains: WAX-SEAL

## Object States

- **STUDY door:** LOCKED → UNLOCKED (with KEY or LOCKPICK)
- **SECRET-PASSAGE:** HIDDEN → REVEALED (with cipher solution)
- **LOCKED-BOX:** CLOSED → OPENED (with KEY)
- **LANTERN:** UNLIT → LIT (with matches)
- **WINE-CABINET:** CLOSED → OPENED (with KEY)

## Parser Expectations

- **EXAMINE:** Detailed description of object
- **TAKE:** Pick up object (if TAKEBIT)
- **DROP:** Put down object
- **USE:** Context-dependent action
- **OPEN/CLOSE:** For containers
- **READ:** For readable objects
- **ASK/TELL:** For NPCs
- **SHOW:** Show item to NPC

## Object Interactions

- **MAGNIFYING-GLASS + FOOTPRINT-CAST:** Reveals boot size
- **LOCKPICK-SET + STUDY DOOR:** Opens locked door
- **KEY + LOCKED-BOX:** Opens box
- **POISON-BOTTLE + GREENHOUSE PLANTS:** Identifies poison type
- **DEAD-LETTER + LADY-ASHWORTH:** Confrontation
- **BLOOD-STAINED-KNIFE + DR-MORIARTY:** Accusation
