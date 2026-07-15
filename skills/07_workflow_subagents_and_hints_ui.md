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
4. Use layered affordances instead of full command menus:
   - story text (what to notice)
   - soft verb hints (few broad actions)
   - parent/narrator hint (private guidance)
   - progressive command hint (only after repeated failure)
5. Preserve mystery while reducing stall-outs; hints should extend play, not skip play.
6. Design for social solving: puzzle prompts and room/object naming should be easy to discuss out loud.
7. Use a vertical-slice gate: design exact commands, implement one slice, play it through `llm.lua`, add it to the automated walkthrough, then proceed.
8. After any vocabulary, containment, counter, route, NPC, or save-system change, replay both the focused slice and the golden path.

## Outputs
- Review findings per specialist pass
- Updated hint panel content
- Iteration plan for next cycle

## Acceptance Checks
- Hints are progressive and contextual.
- Review passes produce concrete fixes.
- Workflow remains slice-based, not big-bang rewrites.
- Hint UI avoids replacing parser agency with exhaustive action lists.
- Co-play flow supports parent guidance without immediate spoilers.
- No iteration batch contains multiple unplayed puzzles; each completed slice has parser-driven coverage before the next begins.

## Primary Source Coverage
- `ZIL_TEXT_ADVENTURE_AGENTS.md`: sections 9, 11, 13
- `WRITING_ADVENTURES.md`: Tips for LLM-Driven Adventure Creation
