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

## Intermediate Artifact Contract

### Stage 1 output
- `DESIGN.md` (premise, tone, win/lose, core fantasy)

### Stage 2 output
- `MAP.md`
- `OBJECTS.md`
- `PUZZLES.md`
- `STORY_STATE.md`
- `TRANSCRIPT_TESTS.md`

### Stage 3 output
- Dependency graph updates in `PUZZLES.md`
- Verb/object coverage matrix
- Softlock prevention notes

### Stage 4 output
- Draft room/object prose
- NPC topic tables
- Layered hint copy

### Stage 5 output
- `dungeon.zil`
- `actions.zil`
- `walkthrough.zil`

### Stage 6 output
- Regression transcripts
- Bug ledger by category
- Fix list mapped to parser/world/content

### Stage 7 output
- Iteration plan and subagent prompts
- Parent-child hint panel text

### Stage 8 output
- Shipping checklist completion
- Asset/copy files (`COVER.md`, `TAGLINE.md`, `SYNOPSIS.md`, `REVIEWS.md`, `METADATA.md`)

## Notes

- Stage files are intentionally scoped so an agent can run one stage at a time.
- Full source mirrors remain available for exact wording and complete reference.
