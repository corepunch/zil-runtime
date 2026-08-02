# Wondertown Storybook Art Direction

Use this guide as a short, priority-ordered prompt. Preserve the game’s exact
scene, characters, objects, and clue states, but reinterpret the image with
stronger cinematic storybook art direction. Do not copy a reference image’s
text, layout, or visual clutter.

## Priority rules

### 1. Reserve text space first

Every page must contain one intentional text region. Compose it before adding
detail.

The preferred treatment is **integrated out-of-focus negative space**: a quiet
area of the real environment—wall, haze, shadow, sky, softly lit floor, or
defocused shelves—with low contrast and no faces, clues, or strong edges. It
must occupy **25–30% of the image**, feel like part of the scene, and never
look like a panel, box, parchment, or blank hole.

Keep the entire text footprint on one broadly consistent color and value field,
such as open sky, grass, a softly lit wall, or an out-of-focus area. Gentle
gradients are welcome, but avoid mixing bright windows or highlights with dark
corners, silhouettes, or other abrupt value changes behind the text. White text
must remain clearly readable at every point in the region.

Keep the region large and calm enough for several lines of text. Let nearby
foreground objects overlap or frame its edge naturally. Do not fill it with
texture, props, high-frequency detail, or bright highlights.

### 2. Make the lighting cinematic

Use one clear motivated warm key light, cool ambient or moonlight fill, visible
falloff, colored shadows, selective rim light, and small pools of reflected
light. Add restrained bloom only around lamps, windows, metal, glass, or magical
light. Never illuminate every object equally.

### 3. Build atmosphere

Make the air visible without obscuring the scene: dust motes, sawdust in light
shafts, warm haze near lamps, cool haze in recesses, and soft atmospheric
perspective in the distance. Atmosphere should create depth, not become a
generic fog overlay.

### 4. Increase material richness

Use tactile but painterly material cues:

- wood grain, scratches, dents, worn edges, amber-to-brown variation;
- tarnished brass and copper with bright edge highlights;
- glass thickness, colored transparency, and reflections;
- cloth folds, seams, weave, and soft shadowing;
- worn leather creases and scuffs;
- layered sawdust, wood shavings, dust, and small debris.

Keep broad readable shapes. Avoid photographic noise and glossy CGI.

### 5. Stage depth and scale

Use a clear foreground, middle ground, and background with overlap, leading
lines, asymmetrical balance, and strong perspective. Keep important clues
legible while allowing distant shelves and walls to soften.

For Wondertown, Pip is no taller than a teacup—approximately 8–12 cm in-world.
He must look genuinely tiny beside benches, drawers, tools, doors, oil cans,
brooms, and floorboards. Use low eye-level perspective and enlarged foreground
forms; never depict Pip as a normal child or 60–70 cm toy.

### 6. Character integration

Characters use the same painterly digital rendering, atmospheric light,
material richness, and depth as the environment. Do not use a separate cel-
shaded, flat, outlined, sticker-like, or graphic character style. Pip’s edges
may remain readable through lighting and value contrast, but he must feel
physically inside the room, with matching light, shadow, haze, texture, and
scale.

## Description audit: mandatory

Before generating an image, inventory every object named in the room
description and place it according to the text. Treat the game description as
the source of truth, not the reference image or the generator’s assumptions.

- Do not invent replacements, hybrids, or props that change object identity.
- Keep spatial relationships explicit: a door is part of the wall, never part
  of the workbench; the tool bench is separate from the workbench.
- Preserve exact states: the brass key hook is empty and has only leftover
  frayed string or rope; the key itself is absent.
- Do not add characters that are not present in the current room.
- Do not add a character lineup to make a scene feel populated.
- After generation, inspect the image against the object inventory and reject
  it if a major described item is missing, merged with another object, or in
  the wrong state.

## Wondertown opening-room checklist

For the `WORKSHOP-FLOOR` image, preserve these exact clues:

- enormous workbench towering over teacup-sized Pip;
- tools and half-finished toys on the workbench;
- separate workshop wall with an empty brass key hook and leftover frayed string;
- soft golden sawdust across the floorboards;
- workshop’s main door in the wall, with a small pet door cut into it;
- ordinary old cuckoo clock on the wall;
- separate tool bench stretching east;
- giant wooden spool staircase with rusty ironwork;
- tiny copper oil can and tiny broom near the workbench.

Include only characters that the game places in the current room. Do not add a
character lineup for atmosphere.

## Compact reusable prompt

> High-end illustrated children’s storybook, cinematic and tactile but not
> photorealistic. Preserve the exact scene, gameplay clues, object states, and
> character relationships. Compose one large integrated out-of-focus text
> region in the real environment before adding detail; keep its full footprint
> on one broadly consistent color and value field, low-contrast, quiet, and free
> of faces or important objects. Avoid bright-to-dark transitions behind white
> text, and let foreground forms gently frame the region's edge. Use strong
> foreground/middle/background depth, motivated
> warm key light, cool fill, visible falloff, colored shadows, rim light,
> restrained bloom, dust or sawdust motes, atmospheric perspective, rich wood,
> brass, copper, glass, cloth, leather, and ground-debris materials. Use crisp
> painterly characters rendered in the same light and atmosphere as the
> environment. Exaggerate scale so Pip is genuinely teacup-sized. No text, no
> UI panel, no parchment box, no generic fog, no glossy CGI, no anime, no
> separate cel-shaded character layer, no invented or merged room objects.
