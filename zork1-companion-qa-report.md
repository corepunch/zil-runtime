# Zork I — Companion Interface (`--child` mode) QA Report

**Date:** 2026-07-28
**Tested By:** Unified QA Tester
**Interface:** `lua5.4 main.lua infocom.zork1.zork1 --child`
**Game Version:** Infocom Zork I Release 0 / Serial 000000

---

## 1. Executive Summary

The Zork I companion interface in `--child` mode loads successfully, operates correctly, and provides an age-appropriate intent-card interface for young players. The authored companion coverage (325-line `companion.zil`) covers the six starting-area rooms with well-written, state-aware suggestions. When the player ventures outside these rooms, a fallback system generates safe but sometimes unhelpful automatic suggestions.

**Status: READY WITH MINOR ISSUES**

---

## 2. Does Companion Load Successfully?

**YES.** `main.lua infocom.zork1.zork1 --child` launches without errors:

```
ZORK I: The Great Underground Empire
Infocom interactive fiction - a fantasy story
...
West of House
You are standing in an open field west of a white house...
There is a small mailbox here.

What will you do?

In this scene
  1. Open the little mailbox
  2. Try the boarded front door

Go somewhere
  3. Walk around the north side of the house

Choose a number:
```

The companion module (`infocom.zork1.companion`) is loaded automatically. No "No authored companion file was found" fallback message appeared — authored content is present and active.

---

## 3. Are `--child` Mode Cards Appropriate?

### 3.1 Simplicity (limited to 3)

**YES.** The `--child` flag correctly sets `choice_limit = 3`, and the interface shows exactly 3 numbered choices on every turn. The prompt reads `Choose a number:` (not `Choose a number, or type any command`), confirming typed-command mode is disabled.

### 3.2 Kid-Friendly Language

**YES.** Authored card labels use simple, active language:

| Room | Card Label | Tone |
|------|-----------|------|
| West of House | "Open the little mailbox" | Warm, diminutive ("little") |
| West of House | "Take the leaflet from the mailbox" | Specific, clear |
| West of House | "Read the leaflet" | Simple imperative |
| Behind House | "Open the slightly ajar kitchen window" | Descriptive but plain |
| Behind House | "Climb through the open kitchen window" | Action-focused |
| Kitchen | "Take the brown sack from the table" | Concrete |
| Living Room | "Take the brass lantern" | Straightforward |
| Living Room | "Move the large rug aside" | Puzzle-appropriate |

Fallback-generated labels are more mechanical but functional: "Examine the white house", "Go to Canyon View", "Take the water".

### 3.3 Grouping

Cards are split into "In this scene" (exploration/interaction) and "Go somewhere" (movement) sections. This is appropriate: movement choices are clearly separated from action choices, reducing cognitive load.

---

## 4. Do Cards Update Intelligently After Each Action?

**YES.** State tracking works correctly throughout the session. Key demonstrations:

| Action | Before | After |
|--------|--------|-------|
| `open mailbox` | "Open the little mailbox" | "Take the leaflet from the mailbox" |
| `take leaflet` | "Take the leaflet" | "Read the leaflet" |
| `read leaflet` | "Read the leaflet" | Stays available (re-readable) |
| `open kitchen window` | "Open the slightly ajar kitchen window" | "Climb through the open kitchen window" |
| `enter window` (kitchen) | N/A (was Behind House) | Kitchen cards appear: "Take the brown sack", "Take the glass bottle", "Go into the living room" |
| `take bottle` | "Take the glass bottle" shown | Card disappears from list |
| `take lamp` | "Take the brass lantern" shown | Card replaced by "Turn on the brass lantern" |
| `take sword` | "Take the elvish sword" shown | Card disappears |
| `turn on lamp` | "Turn on the brass lantern" | Card replaced by "Move the large rug aside" |

The `CHOICE-DETAILS "once" T` mechanism correctly suppresses one-time suggestions (e.g., "Examine the boarded windows" at North of House appears once, then disappears after selection). The priority-decay mechanism (`adjusted_priority = priority - (count * 15)`) promotes variety over repeated selections.

### Priority Decay Verified

After "Read the leaflet" is selected once (priority drops from 85 to 70), "Try the boarded front door" (75) becomes the higher-priority scene choice and appears first. This prevents the same card from dominating the list.

---

## 5. Where Does Authored Coverage End vs Fallback?

### 5.1 Rooms with Authored Coverage

The `companion.zil` `SUGGEST-ACTIONS` routine handles exactly **7 rooms**:

| Room | Room Variable | Lines |
|------|--------------|-------|
| West of House | `WEST-OF-HOUSE` | 24-71 |
| North of House | `NORTH-OF-HOUSE` | 73-100 |
| South of House | `SOUTH-OF-HOUSE` | 102-129 |
| East of House (Behind House) | `EAST-OF-HOUSE` | 131-172 |
| Kitchen | `KITCHEN` | 174-212 |
| Living Room | `LIVING-ROOM` | 214-272 |
| Attic | `ATTIC` | 274-296 |

Additionally, `SUGGEST-SCENE` provides scene descriptions for these same 7 rooms (lines 298-325).

### 5.2 Rooms with NO Authored Coverage (Fallback Only)

Any room not in the above list falls through to the automatic fallback system (`companion_fallback_choices()` in `bootstrap.lua`). These include:

- **Clearing** — Fallback suggested "Examine the white house" (unhelpful — player gets "You're not at the house.")
- **Forest** — Fallback suggested "Examine the white house" (same problem)
- **Canyon View** — Fallback generated only movement choices
- **Rocky Ledge** — Fallback generated only movement choices (2 available)
- **Canyon Bottom** — Fallback suggested "Take the water" (game says "The water slips through your fingers")
- **End of Rainbow** — Fallback suggested "Take the pot of gold" (game says "You can't see any gold here!") and "Take the water"
- **Cellar / Troll Room / Underworld** — No authored content; entirely fallback-dependent
- **All underground locations** (the majority of the game) — No authored coverage

### 5.3 Fallback Behavior Assessment

The fallback system (`companion_fallback_choices`) uses a heuristic: for each item in the current room (via `add_items(HERE)`), it picks a verb (OPEN > READ > TAKE > EXAMINE) and generates a CHOICE. For exits, it generates "Go to <destination>" cards.

**Strengths:**
- Produces valid, executable commands
- Prevents the player from getting stuck with no options
- Movement choices always provide safe navigation

**Weaknesses:**
- "Examine the white house" persists in rooms where "white house" is returned as a room item but the game parser says "You're not at the house"
- "Take the pot of gold" is a classic phantom-noun trap — mentioned in prose but not a real parser object
- "Take the water" at Canyon Bottom executes but the result ("slips through your fingers") may confuse a child
- Fallback choices all have group="scene" (default), which means they appear in "In this scene" even when they're more like movement or generic interaction

---

### 6.3 Naming Inconsistency

The `--child` flag in `main.lua` (line 45) sets `companion_mode = "story"` rather than `"child"`. It works correctly because `MODE_CHILD` and `MODE_STORY` share the same numeric value (1) in `bootstrap.lua` (lines 150-151). However, this is misleading for debugging — a developer inspecting the options would see mode "story" when "child" was requested. Recommend changing to `companion_mode = "child"` for clarity.

---

## 6. Bugs, Confusions, and Regressions

### 6.1 Issues Found

| # | Issue | Severity | Evidence | Location |
|---|-------|----------|----------|----------|
| 1 | **"Examine the white house" persists in non-house rooms** | Medium | In Clearing, Forest, and other outdoor rooms, the card "Examine the white house" appears. Executing it returns "You're not at the house." The fallback system picks up "white house" as a room item even when it's contextually inappropriate. | `bootstrap.lua` fallback `add_items(HERE)` |
| 2 | **"Take the pot of gold" — phantom noun** | Medium | At End of Rainbow, fallback generates "Take the pot of gold" but the game responds "You can't see any gold here!" because "pot of gold" is only described in prose, not backed by a parser object. | `bootstrap.lua` fallback |
| 3 | **No authored coverage for entire underground** | Low | All rooms after the Living Room cellar/trap-door have no authored companion content. Discoverability of trap door, rug, etc. is authored, but the vast underground (Troll Room, Maze, etc.) is fallback-only. | `companion.zil` SUGGEST-ACTIONS |
| 4 | **"Once" flag on wrong choice?** | Low | `CHOICE-DETAILS "once" T` is applied to "Try the boarded front door" rather than "Read the leaflet." Reading the leaflet is re-playable, which is fine, but trying the door is one-time (it always fails). This is actually correct behavior — no need to keep showing a failed action. | `companion.zil` line 49 |
| 5 | **After taking last scene item, only move choices remain** | Low | In the Kitchen after taking the bottle and sack: only 3 movement choices are shown. Authored "Climb the dark stairs" is available as a move, but the player can't examine/know what to do next without exploring. This is an intentional design constraint of 3-choice limit. | companion.zil Kitchen |
| 6 | **Priority 0 or negative can cause choices to never display** | Low | The priority-decay formula `priority - (count * 15)` can make a choice's adjusted priority very low after multiple selections. Combined with the 3-choice limit, some choices may become permanently invisible after enough re-selections. This is unlikely to manifest in normal play. | `bootstrap.lua` select_companion_candidates |

### 6.2 Child Mode Input Validation

All edge cases handled without crashes:

| Input | Response | Assessment |
|-------|----------|------------|
| `5` (out of range of 1-3) | "Please choose one of the displayed numbers." | ✅ Correct |
| `0` | "Please choose one of the displayed numbers." | ✅ Correct |
| `-1` | "Please choose one of the displayed numbers." | ✅ Correct |
| `abc` (non-numeric text) | "Child mode accepts only one of the displayed numbers." | ✅ Correct |
| empty line | "Child mode accepts only one of the displayed numbers." | ⚠️ Misleading — empty input is not a "typed command." Should say "Please choose a number." |

The empty-line issue is a minor bug: `main.lua` line 211's `not options.allow_typed_commands` branch fires for ANY non-numeric input, including empty strings. An empty line should more appropriately prompt "Please choose a number." This is a **low-severity UI bug**.

No crash conditions detected.

### 6.3 Regressions

No regressions found. The companion interface is self-contained and does not interact with the core ZIL game state except through `COMPANION_QUERY`/`COMPANION_SELECT`/`CHOICE`/`SUGGEST-ACTIONS`/`SUGGEST-SCENE` calls that read from and write to save-game globals.

---

## 7. Scene Description Integration

`SUGGEST-SCENE` provides location-aware scene descriptions that appear to be loaded but the current `--child` mode interface does not display them. The scene key and alt text are returned as part of the `COMPANION_QUERY` response but `main.lua`'s `print_choices` function does not render them. This is a **missed opportunity** — scene descriptions could provide orientation text between location changes.

**Suggestion:** In `--child` mode, print the scene alt text when the location changes, to help the child understand where they are.

---

## 8. Overall Assessment

The Zork I companion interface in `--child` mode is **functional and well-designed** for its target audience. Key strengths:

- **Clear intent labels** that translate parser commands into narrative actions
- **Accurate state tracking** — cards react to game state changes immediately
- **Appropriate constraints** — 3 choices, no typed commands, movement separated from actions
- **Robust error handling** — invalid inputs produce clear error messages without crashes
- **Graceful fallback** — when authored coverage ends, automatic suggestions prevent deadlock

The main limitation is **coverage scope**: authored content covers only the starting 7 rooms of a much larger game. Once a child ventures into the underground, they lose curated guidance and get generic fallback suggestions. For the starting area (the "Zork I demo experience"), the companion is excellent.

### Recommendations

1. **Expand authored coverage** to at least the Cellar, Troll Room, and Maze — key early underground areas
2. **Fix fallback phantom nouns** — filter items that return "You're not at..." or "You can't see..." responses
3. **Add scene descriptions** to `--child` mode UI for location-change orientation
4. **Consider difficulty-level filtering** — some fallback suggestions ("Take the water", "Take the pot of gold") may frustrate young players

### Recommendation

`READY WITH MINOR ISSUES`
