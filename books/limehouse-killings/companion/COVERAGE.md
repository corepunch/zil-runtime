# The Limehouse Killings — Companion Coverage

## Summary

| Metric | Count |
|--------|-------|
| Declared rooms | 11 |
| Reachable rooms | 11 |
| Unreachable rooms | 0 |
| State families identified | 11 |
| State families authored | 11 |
| Unique choice IDs | 100 |
| Total CHOICE calls | 122 |

## Room Coverage

| Room | Routine | Choices | State Families | Status |
|------|---------|---------|----------------|--------|
| Gate | `SUGGEST-GATE` | 5 | 2 | AUTHORED |
| Entrance Hall | `SUGGEST-ENTRANCE-HALL` | 32 | 4 | AUTHORED |
| Study | `SUGGEST-STUDY` | 20 | 3 | AUTHORED |
| Library | `SUGGEST-LIBRARY` | 18 | 2 | AUTHORED |
| Dining Room | `SUGGEST-DINING-ROOM` | 14 | 2 | AUTHORED |
| Kitchen | `SUGGEST-KITCHEN` | 6 | 1 | AUTHORED |
| Garden | `SUGGEST-GARDEN` | 10 | 1 | AUTHORED |
| Greenhouse | `SUGGEST-GREENHOUSE` | 5 | 1 | AUTHORED |
| Servants' Quarters | `SUGGEST-SERVANTS-QUARTERS` | 10 | 1 | AUTHORED |
| Secret Passage | `SUGGEST-SECRET-PASSAGE` | 4 | 1 | AUTHORED |
| Pantry | `SUGGEST-PANTRY` | 4 | 1 | AUTHORED |

## Choice Kinds

| Kind | Count | Description |
|------|-------|-------------|
| `CHOICE-PROGRESS` | 42 | Actions that advance the investigation |
| `CHOICE-INVESTIGATE` | 35 | Examination, reading, observation |
| `CHOICE-INTERACT` | 18 | NPC conversation, sensory exploration |
| `CHOICE-EXPERIMENT` | 12 | Cipher pushes, pulling wires, trying mechanisms |
| `CHOICE-RETURN` | 15 | Navigation back to previous rooms |

## State-Aware Behavior

### Entrance Hall (4 state families)
- **Act I (study locked)**: Shows study door attempt, library, dining, kitchen, magnifier
- **Act I (study open)**: Shows study entry, library, dining, kitchen, magnifier
- **Act II (cipher solved)**: Shows study, library, dining, kitchen, bell wire
- **Act III (Lestrade present)**: Shows evidence presentation, accusation, NPC interaction

### Study (3 state families)
- **Exploration**: Take letter, poison, examine box/chalk/desk/window
- **Box puzzle**: Guide toward prerequisites (letter, poison ID, ledger)
- **Complete**: Focus on returning to hall with evidence

### Library (2 state families)
- **Act I (cipher unsolved)**: Take items, read page, ask Moriarty, push books
- **Act II (cipher solved)**: Enter secret passage, take ledger, return to hall

### Dining Room (2 state families)
- **Acts I-II**: Take seal, interview Lady Ashworth, examine cabinet
- **Act III**: Show evidence to Lady Ashworth, navigate to pantry/hall

## Known Limitations

1. **Child mode choice limit**: Default `--child` shows 3 choices. Use `--choices 6` to see all options at hub locations.
2. **Hub navigation**: Entrance hall has 5 possible moves (study, library, dining, kitchen, gate) but only 3 can display with default limit.
3. **Cipher puzzle**: Requires 4 sequential book pushes (red→yellow→green→blue) which may require multiple turns with limited display.

## Architecture Notes

- `SUGGEST-ACTIONS` dispatches to room-specific routines based on `HERE`
- `SUGGEST-SCENE` provides atmospheric descriptions for each room
- Helper routines (`SUGGEST-HALL-ACT1`, etc.) handle act-specific logic
- All helper routines are defined BEFORE `SUGGEST-ACTIONS`/`SUGGEST-SCENE` to avoid ZIL forward-reference issues
- `CHOICE-DETAILS` attaches metadata: `subject`, `once`, `learns`, `group`
