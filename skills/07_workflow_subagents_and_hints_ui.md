# Skill 07: Workflow, Subagents, And Hint UX

## Goal
Operationalize iterative development with specialized passes and parent-child hint UX.

## Inputs
- Stable playable build
- Current transcripts and bug list

## Required Actions
1. Follow staged workflow for incremental changes.
2. Run specialized review passes:
   - puzzle fairness
   - transcript naivety testing
   - vocabulary audit
   - state audit
   - hint writing
3. Maintain parent-child hint strategy:
   - avoid full verb dumps
   - expose progressive hints
   - keep wrong attempts playful and informative

## Outputs
- Review findings per specialist pass
- Updated hint panel content
- Iteration plan for next cycle

## Acceptance Checks
- Hints are progressive and contextual.
- Review passes produce concrete fixes.
- Workflow remains slice-based, not big-bang rewrites.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 9, 11, 13
- `WRITING_ADVENTURES.md`: Tips for LLM-Driven Adventure Creation
