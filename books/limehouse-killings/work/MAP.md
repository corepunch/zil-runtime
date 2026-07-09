# The Limehouse Killings - Room Map

## Room Graph

```
                    ASHWORTH-MANOR-GATE
                           |
                           ↓
                 ASHWORTH-ENTRANCE-HALL
                    /     |     \     \
                   ↓      ↓      ↓     ↓
               STUDY   LIBRARY  DINING  KITCHEN
                 ↑       |       |       |
                 |       ↓       ↓       ↓
                 |    SECRET   PANTRY   GARDEN
                 |    PASSAGE            /    \
                 |       |              ↓      ↓
                 └───────┘        GREENHOUSE  SERVANTS
                                         QUARTERS
```

## Room Details

### ASHWORTH-MANOR-GATE
- **Exits:** SOUTH (to entrance hall)
- **Description:** Iron gates, gravel path, fog
- **Objects:** GATES, PATH, FOG
- **Role:** Starting area, establishes atmosphere

### ASHWORTH-ENTRANCE-HALL
- **Exits:** NORTH (to gate), SOUTH (to study - locked), EAST (to library), WEST (to dining room), DOWN (to kitchen)
- **Description:** Grand foyer, cracked chandelier, portraits
- **Objects:** CHANDELIER, PORTRAITS, RUG
- **Role:** Central hub, connecting all areas
- **Locked Exit:** SOUTH to STUDY (requires KEY or LOCKPICK)

### STUDY
- **Exits:** NORTH (to entrance hall)
- **Description:** Crime scene, body outline, desk, fireplace
- **Objects:** BODY-OUTLINE, DESK, FIREPLACE, WINDOW, LOCKED-BOX, DEAD-LETTER, POISON-BOTTLE
- **Role:** Primary evidence location
- **Access:** Locked until KEY found or LOCKPICK used

### LIBRARY
- **Exits:** WEST (to entrance hall), EAST (to secret passage - hidden)
- **Description:** Floor-to-ceiling books, reading desk, fireplace
- **Objects:** BOOKSHELF, READING-DESK, FIREPLACE, TORN-PAGE, COLORED-MARKERS
- **Role:** Cipher puzzle location
- **Hidden Exit:** EAST to SECRET-PASSAGE (requires solving book cipher)

### DINING-ROOM
- **Exits:** EAST (to entrance hall), NORTH (to pantry)
- **Description:** Long table, wine cabinet, portraits
- **Objects:** TABLE, WINE-CABINET, PORTRAITS, CANDLESTICK
- **Role:** NPC encounter (Lady Ashworth), wine cabinet puzzle
- **Access:** Always open

### KITCHEN
- **Exits:** UP (to entrance hall), WEST (to garden)
- **Description:** Copper pots, cold hearth, servant bell
- **Objects:** POTS, HEARTH, BELL, KNIFE-RACK
- **Role:** Tool acquisition, servant bell
- **Access:** Always open

### GARDEN
- **Exits:** EAST (to kitchen), NORTH (to greenhouse), SOUTH (to servants' quarters)
- **Description:** Overgrown paths, fountain, hedge maze
- **Objects:** FOUNTAIN, HEDGES, PATH, BLOOD-STAINED-KNIFE
- **Role:** Evidence location, connects outdoor areas
- **Access:** Always open

### GREENHOUSE
- **Exits:** SOUTH (to garden)
- **Description:** Glass panels, exotic plants, potting bench
- **Objects:** PLANTS, BENCH, POTS, POISON-PLANT, LABELS
- **Role:** Poison identification puzzle
- **Access:** Always open

### SERVANTS-QUARTERS
- **Exits:** NORTH (to garden)
- **Description:** Sparse rooms, servant beds, trunk
- **Objects:** BEDS, TRUNK, UNIFORMS, LETTER
- **Role:** NPC encounter (Mr. Hudson), additional evidence
- **Access:** Always open

### SECRET-PASSAGE
- **Exits:** WEST (to library), EAST (to study)
- **Description:** Narrow stone passage, dusty, cobwebs
- **Objects:** STONE-WALLS, COBWEBS, DUST
- **Role:** Alternate study access, hidden route
- **Access:** Requires solving library cipher

## Blocked Exits & Rationale

| Exit | Block | Rationale |
|------|-------|-----------|
| ENTRANCE-HALL → STUDY | Locked door | Requires KEY or LOCKPICK |
| LIBRARY → SECRET-PASSAGE | Hidden wall | Requires book cipher solution |

## Room Count

- **Total Rooms:** 10
- **Starting Room:** ASHWORTH-MANOR-GATE
- **Final Room:** STUDY (for final confrontation)

## Navigation Complexity

- **Hub-and-spoke:** ENTRANCE-HALL connects to most rooms
- **Linear chains:** GARDEN → GREENHOUSE, GARDEN → SERVANTS-QUARTERS
- **Hidden path:** LIBRARY → SECRET-PASSAGE → STUDY
- **No dead ends:** All rooms have at least 2 exits (except GREENHOUSE and SERVANTS-QUARTERS which have 1, but connect back to GARDEN)

## Atmospheric Notes

- Fog obscures distant views from GATE
- Gas lamps flicker in hallway
- Candles gutter in wind (DINING-ROOM)
- Shadows move in GARDEN at night
- Greenhouse glass rattles in wind
- Servants' quarters feel cramped and poor
