# Disney Children's Books Follow-Up

Date: 2026-08-01

## Goal

Use Disney children's books as a writing model for our own children's-book work, with two output modes in mind:

1. Illustrated versions, where the art carries most of the scene-setting.
2. Text-only versions, closer to Zork, where prose has to carry the room, action, and player-facing meaning.

I focused on official publisher pages and lawful publisher-provided companion material. I did not download full copyrighted books: the titles below are commercial editions and no full public edition or publisher excerpt was available to verify their complete prose. Claims about page count, age range, format, and stated features are therefore catalog facts; conclusions about the downloadable activity pack come from direct inspection.

## Exact Source Material Checked

| Material | What was checked | What it establishes |
| --- | --- | --- |
| [Moana Activity Sheets](research-source-material/moana-activity-sheets.pdf) | Official nine-page PDF linked by Disney beside the `Moana Read-Along Storybook & CD` page. Downloaded 2026-08-01; SHA-256 `b9267afba9c30f5a844657f1f46163607962e2ebbcdc852df19b3b94af373069`. | Disney uses a single sentence to set up a pictured scene, then turns scene knowledge into coloring, hidden-object, maze, line-following, and jigsaw activities. It is a companion pack, not the book's complete text. |
| [Moana Read-Along Storybook & CD](https://books.disney.com/book/moana-read-along-storybook-cd/) | Official Disney catalog record. | Exact edition: 32 pages, ISBN `9781484743614`, ages 6-8. |
| [Disney's Movie Night Read-Along Storybook and CD Collection](https://books.disney.com/book/disneys-movie-night-read-along-storybook-and-cd-collection/) | Official Disney catalog record. | Exact format claim: the three stories, including Moana, use word-for-word narration, character voices, and sound effects. |
| [Moana: The Junior Novelization](https://www.penguinrandomhouse.com/books/534904/moana-the-junior-novelization-disney-moana-by-rh-disney/) | Official publisher catalog record. | Exact edition: 144 pages, ISBN `9780736436007`, complete-film retelling, eight pages of full-color film scenes. |
| [5-Minute Moana Stories](https://books.disney.com/book/5-minute-moana-stories/) | Official Disney catalog record. | Exact edition: 208 pages, ISBN `9781368081689`, twelve original short stories designed for five-minute read-aloud sessions, ages 3-5. |

### What the downloadable pack adds

The activity PDF makes the illustrated-to-interactive link more concrete than catalog information alone:

- A brief caption tells the child whose moment this is and what changes.
- The image supplies identity, setting, pose, objects, and emotional reading.
- Activities turn recognition into action: find an object, trace the right route, choose the correct puzzle piece, or color a character.

For a child-friendly text adventure, preserve that sequence even when there is no illustration:

1. State the immediate situation in one short sentence.
2. Name the two or three visible, usable things.
3. Offer a goal that can be understood before the child types.
4. Let the action produce an obvious consequence.

Example of the shape, not Disney text: `The little boat is drifting toward the rocks. A paddle and a coil of rope lie beside you. How will you steer it?`

## What The Disney Material Shows

Disney publishes at least two clearly different children's-book patterns:

1. Picture-book/storybook formats for ages roughly 0-7.
2. Junior novelization and chapter-book formats for ages roughly 6-12.
3. Read-along editions, where an illustrated book is paced by narration, character voices, and sound effects.

That split is useful because it maps cleanly to our own design problem:

- Illustrated mode: the picture establishes the space, character look, and background state.
- Text-only mode: the prose has to establish the same information explicitly.

In other words, Disney storybooks behave a lot like a split between a visual adventure and a text adventure. That makes them a good reference point for a Zork-style children's project.

## Research Findings

### 1. Illustrated storybooks are short, direct, and action-led

Examples:

- [We Are Voyagers! (Disney Moana 2)](https://www.penguinrandomhouse.com/books/750205/we-are-voyagers-disney-moana-2-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [The Ocean is Our Friend! (Disney Moana)](https://www.penguinrandomhouse.com/books/812030/the-ocean-is-our-friend-disney-moana-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [Disney Moana Storybook Collection](https://www.penguinrandomhouse.com/books/812028/disney-moana-storybook-collection-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [Sweet and Spooky Halloween (Disney Princess)](https://www.penguinrandomhouse.com/books/141414/sweet-and-spooky-halloween-disney-princess-by-rh-disney/)
- [M Is for Monster](https://www.penguinrandomhouse.com/books/141198/m-is-for-monster-by-disney-book-group-illustrated-by-disney-book-group-disney-book-group/)

What these have in common:

- 24 to 32 page lengths for stand-alone storybooks.
- Age bands around preschool through early elementary.
- Very compact story beats.
- A lot of emotional and physical information is left to the art.
- The text mainly does three jobs: advance the plot, deliver dialogue, and point to the key narrative change on the page.

### 2. Junior novelizations are prose-first, but still keep some visual support

Examples:

- [Moana: The Junior Novelization](https://www.penguinrandomhouse.com/books/534904/moana-the-junior-novelization-disney-moana-by-rh-disney/)
- [Disney/Pixar Luca: The Junior Novelization](https://www.penguinrandomhouse.com/books/668146/disneypixar-luca-the-junior-novelization-disneypixar-luca-by-steve-behling/)
- [Disney Lilo & Stitch: The Junior Novelization](https://www.penguinrandomhouse.com/books/141154/disney-lilo-and-stitch-the-junior-novelization-by-rh-disney/)
- [Disney Moana 2: The Junior Novelization](https://www.penguinrandomhouse.com/books/751327/disney-moana-2-the-junior-novelization-by-elizabeth-rudnick/)

What these have in common:

- Much longer page counts, often around 128 to 144 pages.
- Age bands around 6-12.
- They retell the story in complete prose.
- They usually include a small full-color insert rather than depending on illustrations throughout.

This is the closest Disney gets to a text-dominant mode. For our purposes, it is the useful bridge to a Zork-like experience.

### 3. The same property can exist in both modes

Moana is a good example:

- Picture-book style titles: `We Are Voyagers!`, `The Ocean is Our Friend!`, `Sisters Are Forever!`
- Prose-first title: `Moana: The Junior Novelization`

That matters because it shows the franchise can support both:

- A child who wants visual immersion.
- A reader who wants a story-first, text-first experience.

### 4. Read-along is the useful middle mode

The Moana read-along materials point to a third surface we should consider:

- The book remains visual and compact.
- Narration controls pacing for an adult reading with a child or for independent listening.
- Character voices and sound effects mark emotion and action without adding harder prose.

For our project, this could become an optional `read-aloud` mode: the game reads a short room description, plays a light sound cue, then waits for a choice or command. It should remain fully playable with text alone; audio should support comprehension, not hide required information.

## How To Apply This To Children's Books

### For illustrated versions

Use the art to do the heavy lifting.

- Let the illustration establish location, scale, costume, and mood.
- Keep the text short enough that it does not repeat everything the page already shows.
- Make each spread do one main story job.
- Prefer one clear emotional or narrative turn per page.
- Use sound effects, typographic emphasis, and dialogue sparingly for energy.

Practical writing rule:

- If the image already shows the room, do not spend text describing every object in it.
- If the image already shows the action, use the text for meaning, motive, or consequence.

This is the big Disney lesson: the page should not explain the picture; it should complete it.

### For text-only versions

Treat the story like a compact adventure game.

- Open with a strong setting line.
- Anchor the reader in a place, then move them through a sequence of actions.
- Use concrete nouns and active verbs.
- Repeat important spatial information when it matters for navigation.
- Keep paragraph length short enough for young readers.
- End sections on a decision, a reveal, or a small cliffhanger.

Practical writing rule:

- If there is no image, every important scene detail must be translated into text.
- The text has to replace the picture's job, not just narrate around it.

### For a Zork-style children's adaptation

This is the most interesting hybrid.

We can treat the world as having two layers:

1. Storybook layer: art-first, short prose, emotional beats.
2. Adventure layer: text-first, interactive, object-focused, puzzle-aware.

Suggested design pattern:

- Each illustrated spread becomes one interactive location or story beat.
- Each location gets a short room description, one or two salient objects, and one action hook.
- The illustrated edition can omit many room details because the image supplies them.
- The text-only edition must spell out those same details in parser-friendly language.

Use the activity-sheet pattern as a rule for early puzzles:

- Make the goal visible before the puzzle begins.
- Put only a few meaningful objects in the scene.
- Use one obvious verb family per goal, such as `find`, `follow`, `match`, `help`, or `steer`.
- Give immediate, concrete feedback for a correct action.
- Do not require the child to know a hidden verb or infer an unseen object.

That means we can write one underlying story bible, then express it in two surfaces:

- `picture-book` surface for younger children and read-aloud mode.
- `text-adventure` surface for older children or Zork-style play.

## Working Rules I Would Use

1. One scene, one job.
2. Never duplicate what the art already says.
3. In text-only mode, always anchor the player in space before asking for action.
4. Use dialogue to deliver character and emotion.
5. Use description to deliver navigation and consequence.
6. Keep the same core plot across both versions, but rewrite the surface language for the medium.

## Recommended Source Set

Best starting points for continued research:

- [Disney Moana Storybook Collection](https://www.penguinrandomhouse.com/books/812028/disney-moana-storybook-collection-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [We Are Voyagers! (Disney Moana 2)](https://www.penguinrandomhouse.com/books/750205/we-are-voyagers-disney-moana-2-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [The Ocean is Our Friend! (Disney Moana)](https://www.penguinrandomhouse.com/books/812030/the-ocean-is-our-friend-disney-moana-by-rh-disney-illustrated-by-the-disney-storybook-art-team/)
- [Moana: The Junior Novelization](https://www.penguinrandomhouse.com/books/534904/moana-the-junior-novelization-disney-moana-by-rh-disney/)
- [Disney Moana 2: The Junior Novelization](https://www.penguinrandomhouse.com/books/751327/disney-moana-2-the-junior-novelization-by-elizabeth-rudnick/)
- [Disney Chapter Book Series overview](https://www.penguinrandomhouse.com/the-read-down/disney-chapter-book-series/)

## Rights and Evidence Boundary

- The downloaded PDF is an official Disney Publishing Worldwide activity sheet. It is retained as research reference material, with the source URL recorded above; it is not an asset to republish, modify, or ship with our project.
- Full Disney storybooks and junior novelizations should be read through purchase, a library loan, or other authorized access before we make claims about their exact wording, scene order, or prose technique.
- Until then, use this document's catalog-derived findings for format decisions only, and use the inspected activity-sheet observations for interaction design.

## Bottom Line

Disney children's books suggest a simple but useful rule:

- Illustrated books let the art describe the scene.
- Text-first books let prose describe the scene.
- A Zork-like children's project should deliberately support both, instead of trying to make one format do the work of the other.
