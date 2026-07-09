# Adventure Skills Pipeline

This folder splits adventure creation into stage-oriented skills.
Each stage consumes intermediate artifacts from prior stages and emits files for the next stage.

## Stage Order

1. `01_foundation_and_premise.md`
2. `02_working_materials_and_design_docs.md`
3. `03_world_model_and_puzzle_architecture.md`
4. `04_content_writing_and_npc_layer.md`
5. `05_zil_implementation_reference.md`
6. `06_testing_transcripts_and_debugging.md`
7. `07_workflow_subagents_and_hints_ui.md`
8. `08_packaging_checklists_and_release.md`

## Canonical Source Mirrors

To preserve all source information verbatim, these full mirrors are included:

- `source_zil_text_adventure_agents.md`
- `source_writing_adventures.md`

## Adventure Folder Structure

All adventures should follow this directory organization:

```
adventure-name/
├── DESIGN.md              # Stage 1: Premise, tone, win/lose
├── PLAN.md                # Implementation plan (optional)
├── dungeon.zil            # Stage 5: Rooms, objects, world data
├── actions.zil            # Stage 5: Routines, puzzle logic, NPCs
├── work/                  # Stages 2-4, 7: Working materials
│   ├── MAP.md             # Room graph and navigation
│   ├── OBJECTS.md         # Object registry with flags
│   ├── PUZZLES.md         # Puzzle design with solutions
│   ├── STORY_STATE.md     # Game state variables
│   ├── TRANSCRIPT_TESTS.md # Test transcript plans
│   ├── PROSE.md           # Room/object descriptions, NPC topics
│   ├── HINTS.md           # Progressive hint system
│   └── ITERATION.md       # Development roadmap
├── test/                  # Stage 6: Testing materials
│   ├── TESTING.md         # Regression tests, bug ledger
│   └── walkthrough.zil    # Golden path test file
└── package/               # Stage 8: Packaging & release
    ├── COVER.md           # Visual description
    ├── TAGLINE.md         # Marketing taglines
    ├── SYNOPSIS.md        # Story summaries
    ├── REVIEWS.md         # Critical reviews
    └── METADATA.md        # Technical details
```

## Intermediate Artifact Contract

### Stage 1 output
- `DESIGN.md` (premise, tone, win/lose, core fantasy)

### Stage 2 output (goes in `work/`)
- `MAP.md`
- `OBJECTS.md`
- `PUZZLES.md`
- `STORY_STATE.md`
- `TRANSCRIPT_TESTS.md`

### Stage 3 output
- Dependency graph updates in `PUZZLES.md`
- Verb/object coverage matrix
- Softlock prevention notes

### Stage 4 output (goes in `work/`)
- `PROSE.md` (draft room/object prose, NPC topic tables)
- `HINTS.md` (layered hint copy)

### Stage 5 output
- `dungeon.zil`
- `actions.zil`

### Stage 6 output (goes in `test/`)
- `TESTING.md` (regression transcripts, bug ledger, fix list)

### Stage 7 output (goes in `work/`)
- `ITERATION.md` (iteration plan and subagent prompts)
- Updated `HINTS.md` (parent-child hint panel text)

### Stage 8 output (goes in `package/`)
- `COVER.md`
- `TAGLINE.md`
- `SYNOPSIS.md`
- `REVIEWS.md`
- `METADATA.md`

## Notes

- Stage files are intentionally scoped so an agent can run one stage at a time.
- Full source mirrors remain available for exact wording and complete reference.
- The `work/`, `test/`, and `package/` subfolders keep adventures organized as they grow.

## Critical: Room and Object Flags

**This is a common source of bugs. Always set flags correctly.**

### Room Flags

Every room MUST have `(IN ROOMS)` and appropriate flags:

| Flag | Meaning | When to Use |
|------|---------|-------------|
| `RLANDBIT` | Land-based room (standard) | **Always** for normal rooms |
| `ONBIT` | Room is lit (no light source needed) | Omit for dark rooms |
| `SACREDBIT` | Cannot be touched/destroyed | For rooms that should be immune to player actions |

**Examples:**
```zil
; Lit outdoor room
<ROOM GARDEN
      (IN ROOMS)
      (FLAGS RLANDBIT ONBIT)>

; Dark room (needs light source)
<ROOM BASEMENT
      (IN ROOMS)
      (FLAGS RLANDBIT)>  ; No ONBIT = dark room
```

### Vehicle Rooms

For rooms that can be entered only via vehicle (boats, etc.):
- Room should NOT have `RLANDBIT` (use `NONLANDBIT` instead)
- Vehicle object needs `VEHBIT` flag

### Object Flags

| Flag | Meaning | When to Use |
|------|---------|-------------|
| `TAKEBIT` | Can be picked up | For portable objects |
| `READBIT` | Can be READ | For readable items |
| `CONTBIT` | Is a container | For boxes, bags, etc. |
| `OPENBIT` | Container is open | For open containers/doors |
| `OPENABLEBIT` | Can be opened/closed | For containers that open |
| `LIGHTBIT` | Can provide light | For lanterns, torches |
| `ONBIT` | Light source is on | For active light sources |
| `ACTORBIT` | Is an NPC | For talkable characters |
| `WEAPONBIT` | Can be used as weapon | For swords, knives |
| `TOOLBIT` | Can be used as tool | For keys, lockpicks |
| `SCENERY` | Don't auto-describe | For background objects |
| `NDESCBIT` | Don't auto-describe | For objects described in room text |
| `VEHBIT` | Is a vehicle | For boats, carts |
| `SURFACEBIT` | Things can be put on it | For tables, benches |
| `TRANSBIT` | Container is transparent | For glass containers |

### Common Flag Mistakes

1. **Missing `RLANDBIT`**: Room may not work for navigation
2. **Missing `ONBIT`**: Room is dark when it should be lit
3. **Extra `ONBIT` on dark room**: Room is always lit
4. **Missing `TAKEBIT`**: Object can't be picked up
5. **Missing `CONTBIT`**: Container doesn't work
6. **Missing `OPENBIT`**: Container starts closed when it should be open

### Testing Flags

After setting flags, test:
1. Can player enter the room?
2. Is the room lit (if ONBIT) or dark (if no ONBIT)?
3. Can player take objects (if TAKEBIT)?
4. Can player open containers (if CONTBIT + OPENABLEBIT)?
5. Can player talk to NPCs (if ACTORBIT)?
