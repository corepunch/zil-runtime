# Skill 04: Content Writing And NPC Layer

## Goal
Write player-facing text and interactions that teach play and maintain tone.

## Inputs
- Prior stage artifacts

## Required Actions
1. Write first-visit and revisit room text with actionable nouns.
2. Ensure every mentioned noun is handled (object, pseudo object, or scenery response).
3. Author object text to support puzzle affordances.
4. Author NPC behavior scope and conversation patterns (ASK/TELL/GIVE/SHOW).
5. Author layered hints (attention, direction, action, command).
6. Author clear success feedback and useful failure feedback.
7. Keep prose brief and concrete: room descriptions should usually be 1-4 sentences with one strong anchor.
8. Balance tone intentionally: clear spatial prose, dry humor, and credible danger.
9. Add custom responses for obvious silly commands so humor is systemic, not just decorative.
10. Ensure major objects act as more than props (tool, clue, world detail, joke, risk, trophy, or memory marker).
11. Give key NPCs behavior loops (move, block, steal, help, react, change state), not only static dialogue.
12. **Player identity belongs in SYNOPSIS.md/DESIGN.md, not in PLAYER object LDESC** — Infocom never explicitly states who the player is in game text.
13. For every actionable compound noun used in prose, choose and record a canonical command plus natural variants (for example `reading desk`, `reading-desk`, `desk`). Make the ZIL vocabulary support what the prose teaches.
14. Write NPC topic rows as executable commands (`ASK HUDSON ABOUT KEY`), with listener, topic noun, response, state change, repeat response, and where the listener is accessible.

## Outputs
- Draft room and object prose set
- NPC topic/reaction matrix
- Hint tiers per puzzle

## Acceptance Checks
- Tone remains consistent.
- Room prose implies meaningful actions.
- Wrong-but-reasonable attempts are informative.
- Revisited text is concise and state-aware.
- NPC interactions produce observable world or puzzle consequences.
- Every emphasized clue noun and every noun used in a hint resolves through the parser exactly as written.
- Conversation topics are testable parser objects/words, not documentation-only labels.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 6, 7, 11, 14
- `WRITING_ADVENTURES.md`: Crafting Great Adventures section
