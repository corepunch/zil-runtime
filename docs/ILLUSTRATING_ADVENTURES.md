# Illustrating Adventures as Interactive Storybooks

This guide explains how to turn a finished or playable ZIL adventure into a
beat-illustrated interactive storybook. It is a production workflow for
authors and agents: it decides **what to illustrate, when an illustration
changes, how it connects to game state, and how the result is reviewed**.

It does not define a book's visual style. Keep palette, rendering technique,
character proportions, costume, and page-layout rules in the adventure's own
`ARTSTYLE.zil` and character design bible.

The governing principle is:

> **Illustrate the dramatic moment, not the room state.**

The engine tracks the room. The reader sees the moment.

## Use this guide after the adventure works

Do not use illustrations to compensate for an unfinished world model or an
unclear choice flow. Before art production begins, the relevant route should
already have:

- playable rooms, objects, puzzles, and endings;
- a tested walkthrough;
- stable story-state families;
- authored companion choices if the illustrated surface uses `companion.zil`;
- no unresolved prose or continuity defects that would change the selected
  moments.

Art planning may begin earlier with rough storyboards, but final generation
should follow functional playtesting. Otherwise every gameplay rewrite causes
avoidable art churn.

## Keep three concerns separate

An illustrated adventure has three related but distinct layers:

| Layer | Question | Recommended artifact |
|---|---|---|
| Illustration plan | Which moments deserve an image, and why? | `work/ILLUSTRATION_PLAN.md` |
| Visual identity | What do the book, characters, and locations look like? | `ARTSTYLE.zil` and `CHARACTER_DESIGN_BIBLE.md` |
| Runtime integration | Which reachable state selects which asset? | `companion.zil` plus an illustration manifest |

Do not merge these into one giant prompt. A change to watercolor texture should
not require rewriting the beat graph; a new puzzle branch should not silently
rewrite the protagonist's design.

## The visual unit is a beat, not a room or command

A narrative beat is a meaningful unit of action, reaction, discovery,
relationship, consequence, or transition. One room can contain many beats:

```text
Location: Old Library

1. Mara enters and sees shelves towering above her.
2. She notices one clean book among dusty volumes.
3. She reaches for it.
4. Green smoke bursts from the open pages.
5. A creature emerges while Mara recoils.
6. The creature speaks.
```

A room-based system might show one library image throughout. A command-based
system might try to illustrate every `EXAMINE`, `TAKE`, and `OPEN`. Both are the
wrong production unit. Select the moments whose **reader experience changes**.

An illustration can persist through several minor text or choice updates. A
new image is justified when the narrative focus changes, not whenever a flag or
inventory slot changes.

## What text and image each contribute

Text is best at thought, causality, dialogue, history, sound, smell, rules,
precise consequences, and choice meaning. Illustration is best at action,
emotion, body language, atmosphere, scale, staging, visual surprise, humor,
and relationships.

The pair should be complementary. For example:

```text
Text:  "Of course you can trust me," said the fox.
Image: The fox smiles while hiding a brass key behind his back.
```

Avoid literal pairs in which the prose says “Mara opened the red door” and the
image contributes only Mara opening a red door. Add emotion, consequence,
foreshadowing, visual comedy, or a revealing composition. Essential gameplay
information must still be available in text or accessible description; do not
make a subtle visual clue the only way to progress.

## Step-by-step production workflow

### 1. Inventory the playable story

Read the design materials, walkthrough, prose, puzzle/state documents, and
`companion.zil`. Play every route in scope. Record:

- major entrances, discoveries, choices, consequences, and endings;
- character introductions and relationship changes;
- transformations of important locations, characters, and props;
- state families that visibly or emotionally change a scene;
- branches that converge and can safely reuse an image.

Do not infer the complete story from room declarations alone. Important beats
often live in action routines, timed events, NPC responses, and endings.

### 2. Build a beat graph

Create `work/ILLUSTRATION_PLAN.md`. Give every candidate beat a stable,
semantic ID and connect it to its prerequisites and possible successors.

Use semantic IDs such as `library.book-smoke` or `fox-den.trust-offer`, not
sequence numbers such as `image-17`. Semantic IDs survive reordered routes and
are suitable as logical scene keys.

For each beat, record at least:

```yaml
id: library.book-smoke
location: old-library
trigger: ancient book is opened for the first time
preconditions:
  - book_opened = true
  - creature_released = false
function: consequence
importance: mandatory
protagonist: Mara
action: recoils from the open book
emotion: curiosity turning to alarm
primary_focus: green smoke erupting from the pages
secondary_focus: Mara's reaction
visible_continuity:
  - blue satchel
  - brass reading lamp
text_partner: The hinge sighed. Then the pages began to breathe.
next:
  - library.creature-reveal
```

The plan is an editorial graph, not a copy of every engine variable. Include
only state needed to identify or stage the beat.

### 3. Classify the dramatic function

Assign one primary function to every selected beat:

| Function | Use it for |
|---|---|
| Establishing | Introducing a major location, atmosphere, or scale |
| Intent | Showing commitment to an important player choice |
| Action | Showing a visually interesting selected action |
| Reveal | Rewarding discovery or introducing new information |
| Consequence | Showing a meaningful result of an action |
| Reaction | Making emotion or character change visible |
| Relationship | Showing trust, conflict, affection, or power between characters |
| Transition | Making travel between major phases feel narrative |
| Non-visual | Recording a beat that should remain text-only |

The function should drive framing. Establishing beats often need a wide shot;
discoveries may need a close-up; intent works well over the shoulder; reaction
usually benefits from character-centered medium or close framing.

### 4. Select illustrations by narrative value

Score a beat by counting the following values it provides:

- changes emotional tone;
- introduces a new visual idea, character, or major location;
- reveals important information;
- shows a consequence or transformation;
- exposes personality or relationship;
- creates suspense, wonder, or visual humor;
- rewards an important choice or completed puzzle;
- creates a memorable ending image.

Then assign a production priority:

- **Mandatory:** major introduction, discovery, transformation, climax,
  ending, or emotional turn.
- **Recommended:** visually interesting choice, puzzle solution, NPC exchange,
  or consequence.
- **Optional:** minor transition, scenery inspection, or simple object action.
- **None:** interface operation, bookkeeping, repeated command, or visually
  unchanged state.

This is an editorial decision, not a quota. Favor a smaller sequence of images
that each matters over exhaustive but weak coverage.

### 5. Lock continuity before final generation

Create or update the per-adventure visual identity files:

- `ARTSTYLE.zil`: medium, palette, lighting, environment treatment, page
  composition, negative direction, and any copy-space requirements;
- `CHARACTER_DESIGN_BIBLE.md`: body proportions, face, hair, costume, scale,
  recurring expressions, and character reference images;
- location references where architecture must remain recognizable;
- reference sheets for iconic, recurring props.

Use this continuity hierarchy:

1. **Critical:** protagonist and major character designs, iconic props,
   costumes, scale relationships, and signature locations.
2. **Narrative:** major damage, transformations, time of day, character
   presence, and currently important carried props.
3. **Incidental:** chair position, background books, candle count, and minor
   clutter.

Critical continuity must match. Narrative continuity must match when relevant
to the beat. Incidental continuity may vary. Do not turn illustration into an
inventory renderer.

### 6. Write a composition brief for each selected beat

Do not send raw room state to an image generator. Compose a short brief that
makes the visual hierarchy explicit:

```text
Beat: library.book-smoke — consequence
Character: Mara, using the locked character reference
Action: recoiling as green smoke erupts from the book
Emotion: startled but fascinated
Primary focus: Mara's reaction and the smoke
Environment: old library, supporting context only
Continuity props: blue satchel; brass reading lamp
Shot: low medium shot, three-quarter view
Composition: action-oriented, asymmetric, room for story text at upper left
Avoid: room overview, centered inventory layout, clickable-looking props,
       repeated eye-level framing, text rendered inside the image
```

Append the adventure's art-style and relevant character/location references at
generation time. Keep the beat brief free of long, repeated style prose.

### 7. Storyboard before producing finals

Generate or sketch inexpensive composition candidates first. Review adjacent
beats as a sequence, not as isolated pictures. Check that the sequence varies:

- wide, medium, and close framing;
- camera height and character orientation;
- foreground, middle ground, and depth;
- quiet and energetic compositions;
- visual focus and light direction.

Reject beautiful images that show the wrong beat. Fix composition and staging
before polishing texture or incidental details.

### 8. Generate and register final assets

Store generated files outside ZIL and map them through stable logical keys.
The manifest path is host-specific, but each entry should record enough to
reproduce and audit the asset:

```json
{
  "library.book-smoke": {
    "asset": "images/library-book-smoke.webp",
    "function": "consequence",
    "alt": "Mara leans away from an open book as green smoke curls toward her face.",
    "primaryFocus": "Mara and the smoke-filled book",
    "continuity": ["mara-default", "blue-satchel", "old-library"],
    "sourceBeat": "work/ILLUSTRATION_PLAN.md#librarybook-smoke"
  }
}
```

ZIL should select logical keys, not embed image paths. See
[Companion ZIL Files](COMPANION-ZIL.md#scene-illustrations) for the current
`SCENE` contract.

The existing `SCENE` API describes the presentation while the game is waiting
for a choice. A short-lived intent, action, reveal, or reaction image may need
an additional host transition or event that the current API does not yet
provide. Document that need explicitly; do not pretend a transient beat is
implemented by attaching it permanently to a room.

### 9. Verify runtime coverage

For every manifest key:

- identify the reachable state or event that selects it;
- reach that state through the actual parser or companion flow;
- verify that the selected key and alt text are correct;
- test return visits and nearby state families for stale art;
- verify branch convergence does not leak an image from the other branch;
- verify all selected keys resolve to existing assets.

Do not create an image for an unreachable plan entry merely to make a table
look complete. Do not leave a reachable selected key without an asset.

### 10. Review text and image as a pair

For every illustrated beat, review three levels:

**Image**

- Is the intended action, emotion, and focus readable?
- Does it look like a storybook moment rather than a game screenshot?
- Are irrelevant objects visually subordinate?
- Are critical and relevant narrative continuity correct?
- Is the framing sufficiently different from adjacent images?

**Text**

- Does it avoid redundantly listing obvious visible details?
- Does it still carry narrative voice, causality, and required information?
- Does it remain understandable without sight?
- Does it leave useful work for the image to do?

**Pair**

- Are they complementary rather than redundant, contradictory, or detached?
- Does the pair communicate more than either element alone?
- Does the image enrich the story rather than merely make it less textual?

The target is a mutually enriching pair. Intentional contradiction—such as a
character saying “I'm not scared” while visibly trembling—is valid when it is
clear narrative subtext.

## Accessibility rules

Every logical scene needs authored alt text. Alt text must:

- identify the visible action, characters, expression, and narratively
  relevant setting detail;
- communicate any visual information required to understand the next choice;
- avoid leaking hidden puzzle facts that a sighted reader would not yet know;
- avoid repeating adjacent prose word for word;
- change when a materially different scene key is selected.

Decorative detail does not need exhaustive transcription. Meaning does.

## Anti-patterns

Reject these patterns during planning and review:

- **The screenshot room:** fixed camera, tiny or absent protagonist, every
  object evenly visible, composition mainly useful for navigation.
- **Visual inventory:** every carried and interactable object is rendered.
- **Literal caption:** image and sentence communicate the same fact and
  nothing else.
- **AI wallpaper:** attractive art with no narrative job.
- **One image per command:** engine operations are mistaken for story beats.
- **One image per room:** the story advances while the visual layer remains
  static.
- **Style-in-every-beat:** art direction is copied into every beat record and
  inevitably drifts.
- **Untracked prompt pile:** assets have no stable keys, trigger states, alt
  text, or reproducible briefs.

## Advanced techniques

Use these sparingly after the basic sequence works:

- visual foreshadowing that rewards attentive readers without blocking play;
- reaction before explanation;
- off-screen space and partial reveal;
- visual jokes or character-perspective contradiction;
- a rare silent or image-first reveal;
- text-first suspense followed by a reveal image;
- page-like transitions as feedback for consequential choices.

These are editorial tools, not default effects. Too many special beats flatten
their impact and slow reading.

## Definition of done

An illustrated-adventure release is ready when:

- [ ] The playable route and companion coverage pass their own release gates.
- [ ] `work/ILLUSTRATION_PLAN.md` covers all mandatory beats and in-scope
      endings.
- [ ] Every selected beat has a dramatic function and an explicit reason to
      exist.
- [ ] `ARTSTYLE.zil` and the character design bible are locked and internally
      consistent.
- [ ] Every runtime scene key resolves to a reviewed asset and authored alt
      text.
- [ ] Every asset can be traced to a beat, trigger, continuity context, and
      composition brief.
- [ ] Reachable state families were tested for missing, stale, or branch-leaked
      images.
- [ ] Adjacent images were reviewed as a visual sequence.
- [ ] Every text-image pair passed image, text, pair, and accessibility review.
- [ ] Minor inventory permutations do not cause asset explosion.
- [ ] No illustration resembles a clickable object map unless direct visual
      interaction is intentionally part of the product.

The final editorial test is simple:

> If this were a page in an excellent illustrated book, is this the moment the
> illustrator would choose?

If the only reason for an image is “the player is in this room,” keep planning.

