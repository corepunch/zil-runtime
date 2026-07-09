# The Limehouse Killings - Iteration Plan

## Current Status

**Version:** 1.0-alpha
**Completion:** 85%
**Known Issues:** 14 (from bug ledger)
**Test Coverage:** 85% parser, 90% objects, 95% NPCs, 100% puzzles

## Priority 1: Critical Fixes (Must Fix)

### Fix Parser Synonyms
**Impact:** High
**Effort:** Low
**Description:** Implement missing parser synonyms (LOOK AT, SEARCH)
**Files:** actions.zil
**Status:** Open

### Fix Disambiguation
**Impact:** High
**Effort:** Low
**Description:** Rename objects with duplicate names (POTS, PORTRAITS)
**Files:** dungeon.zil
**Status:** Open

### Fix State Management
**Impact:** High
**Effort:** Medium
**Description:** Ensure LOCKED-BOX requires key/lockpick, INSPECTOR appears after evidence
**Files:** actions.zil, dungeon.zil
**Status:** Open

## Priority 2: Important Fixes (Should Fix)

### Fix Softlock Potential
**Impact:** Medium
**Effort:** Medium
**Description:** Block secret passage until study unlocked, require all evidence for accusation
**Files:** dungeon.zil, actions.zil
**Status:** Open

### Fix NPC Responses
**Impact:** Medium
**Effort:** Low
**Description:** Add missing NPC responses for invalid topics
**Files:** actions.zil
**Status:** Open

### Fix Object Interactions
**Impact:** Medium
**Effort:** Low
**Description:** Ensure all object interactions work correctly
**Files:** actions.zil
**Status:** Open

## Priority 3: Polish (Nice to Have)

### Improve Object Descriptions
**Impact:** Low
**Effort:** Low
**Description:** Enhance descriptions for atmosphere
**Files:** dungeon.zil
**Status:** Open

### Add Sound Effects (Future)
**Impact:** Low
**Effort:** High
**Description:** Add atmospheric sounds if engine supports it
**Files:** N/A
**Status:** Future

### Add Graphics (Future)
**Impact:** Low
**Effort:** High
**Description:** Add location portraits if engine supports it
**Files:** N/A
**Status:** Future

## Iteration Schedule

### Week 1: Critical Fixes
- Day 1-2: Fix parser synonyms
- Day 3-4: Fix disambiguation issues
- Day 5-7: Fix state management

### Week 2: Important Fixes
- Day 1-3: Fix softlock potential
- Day 4-5: Fix NPC responses
- Day 6-7: Fix object interactions

### Week 3: Polish
- Day 1-3: Improve object descriptions
- Day 4-5: Add missing content
- Day 6-7: Final testing

### Week 4: Release Preparation
- Day 1-2: Final bug fixes
- Day 3-4: Create packaging files
- Day 5-7: Final testing and release

## Subagent Prompts

### Parser Fix Agent
```
Task: Fix parser synonyms in actions.zil
1. Add LOOK AT as synonym for EXAMINE
2. Add SEARCH as synonym for LOOK INSIDE
3. Test all object interactions
4. Verify no regressions
```

### Disambiguation Agent
```
Task: Fix object name conflicts in dungeon.zil
1. Rename POTS to COPPER-POTS
2. Rename PORTRAITS to FAMILY-PORTRAITS
3. Update all references
4. Test object interactions
```

### State Management Agent
```
Task: Fix state management in actions.zil
1. Require key/lockpick for LOCKED-BOX
2. Trigger INSPECTOR after 5 evidence
3. Require finding SECRET-LEDGER before taking
4. Test all state transitions
```

### Softlock Prevention Agent
```
Task: Fix softlock potential in dungeon.zil and actions.zil
1. Block SECRET-PASSAGE until CIPHER-SOLVED
2. Require all evidence for accusation
3. Test edge cases
4. Verify no dead ends
```

### NPC Response Agent
```
Task: Add missing NPC responses in actions.zil
1. Add responses for invalid topics
2. Ensure all conversation paths work
3. Test NPC interactions
4. Verify interview tracking
```

### Content Polish Agent
```
Task: Improve object descriptions in dungeon.zil
1. Enhance atmospheric descriptions
2. Add more actionable details
3. Ensure consistent tone
4. Test player feedback
```

## Testing Strategy

### After Each Fix
1. Run walkthrough.zil
2. Run regression tests
3. Verify no new bugs
4. Update bug ledger

### Before Release
1. Full regression test suite
2. Playtest with new players
3. Gather feedback
4. Final polish

## Release Criteria

### Must Have
- [ ] All critical bugs fixed
- [ ] All important bugs fixed
- [ ] Parser works correctly
- [ ] All puzzles solvable
- [ ] No softlocks
- [ ] All NPCs functional
- [ ] Game completable

### Should Have
- [ ] Atmospheric descriptions
- [ ] Hint system working
- [ ] Score system working
- [ ] Inventory system working
- [ ] Save/restore (if engine supports)

### Nice to Have
- [ ] Sound effects
- [ ] Graphics
- [ ] Multiple solutions
- [ ] Easter eggs
- [ ] Developer commentary

## Post-Release

### Version 1.1
- Fix any reported bugs
- Add missing content
- Improve parser feedback

### Version 2.0
- Add new puzzles
- Add new NPCs
- Expand story
- Add new areas

### Future
- Sequel potential
- Series expansion
- Community contributions
