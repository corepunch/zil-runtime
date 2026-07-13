# Skill 08: Packaging, Checklists, And Release

## Goal
Prepare final adventure package and verify definition-of-done criteria.

## Inputs
- Tested adventure files
- Design/test documentation

## Required Actions
1. Verify full structural/object/puzzle/verb/polish/testing checklist completion.
2. Prepare package artifacts:
   - `COVER.md`
   - `TAGLINE.md`
   - `SYNOPSIS.md`
   - `REVIEWS.md`
   - `METADATA.md`
3. Confirm walkthrough test location and command remain valid.
4. Ensure final copy/style consistency with target tone and audience.
5. Include modern "feelies" equivalents where appropriate (printable map, in-world letters, logs, clue cards).
6. Verify progress communication is legible (score/rank/chapter/objective summaries).
7. If producing episodic content, design ending/start transition for narrative continuity even without save import.
8. Confirm optional accessibility supports for modern play (transcript visibility, note surfaces, hint controls).
9. Run the dedicated parser-driven walkthrough target from a fresh save and confirm final progress counters and win output.
10. Run unit, LLM persistence, and broad pure-ZIL regressions after the final content change.

## Outputs
- Release-ready adventure folder
- Completed checklist state

## Acceptance Checks
- Definition of done satisfied for room/object/puzzle/game levels.
- Packaging files present and coherent with game content.
- Supplemental artifacts support immersion and optional hinting, not just decoration.
- Episode hooks and transition text preserve emotional continuity.
- The release walkthrough uses the exact commands published in testing/hint materials and passes across separate saved invocations.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: section 12
- `WRITING_ADVENTURES.md`: Adventure Folder Files, Checklist
