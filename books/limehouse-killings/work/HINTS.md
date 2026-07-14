# The Limehouse Killings - Hint Panel Content

## Hint System Overview

The hint system provides progressive assistance for each puzzle. Players can request hints at any time by typing HINTS. Hints are presented in 4 tiers, from vague to specific.

## Hint Panel Structure

### How to Use Hints
- Type HINTS to see available hint topics
- Type HINTS [TOPIC] to get a hint for that puzzle
- Each hint topic has 4 tiers
- Type HINTS [TOPIC] again for the next tier
- Hints reset when puzzle is solved

## Puzzle Hints

### Puzzle 1: Study Entry

**Topic:** STUDY

**Tier 1 (Attention):**
"The study door is locked. Perhaps someone has the key."

**Tier 2 (Direction):**
"The butler might know where the key is kept. Or perhaps there's another way in."

**Tier 3 (Action):**
"Ask Mr. Hudson about the key, but be persistent. Alternatively, check the garden for another entrance."

**Tier 4 (Command):**
`ASK HUDSON ABOUT KEY` or `USE LOCKPICK ON WINDOW`

---

### Puzzle 2: Library Cipher

**Topic:** CIPHER

**Tier 1 (Attention):**
"The bookshelf has colored markers. Perhaps they mean something."

**Tier 2 (Direction):**
"The torn page mentions 'rainbow order'. The markers are colored."

**Tier 3 (Action):**
"Push the marked books in their rainbow order: red, yellow, green, blue."

**Tier 4 (Command):**
`PUSH RED BOOK THEN PUSH YELLOW BOOK THEN PUSH GREEN BOOK THEN PUSH BLUE BOOK`

---

### Puzzle 3: Greenhouse Poison

**Topic:** POISON

**Tier 1 (Attention):**
"The poison bottle has a label. Greenhouse plants have labels too."

**Tier 2 (Direction):**
"Match the poison bottle to a plant in the greenhouse."

**Tier 3 (Action):**
"Find the wolfsbane plant and take the antidote ingredients."

**Tier 4 (Command):**
`EXAMINE POISON-BOTTLE THEN FIND WOLFSBANE IN GREENHOUSE`

---

### Puzzle 4: Final Confrontation

**Topic:** ACCUSE

**Tier 1 (Attention):**
"The evidence must point to one suspect."

**Tier 2 (Direction):**
"Consider who had means, motive, and opportunity."

**Tier 3 (Action):**
"Dr. Moriarty had poison, owed money, and no alibi."

**Tier 4 (Command):**
`ACCUSE DR-MORIARTY`

---

## General Hints

### Topic: GENERAL

**Tier 1:**
"If you're stuck, try examining everything in the current room. Look for objects that might be useful."

**Tier 2:**
"Have you talked to all the NPCs? They might have information you need."

**Tier 3:**
"Some doors are locked. You'll need a key or tool to open them."

**Tier 4:**
"Try reading any notes or letters you've found. They might contain clues."

---

### Topic: INVENTORY

**Tier 1:**
"You can carry up to 7 items. Use INVENTORY to see what you have."

**Tier 2:**
"Some items are useful for specific puzzles. Think about what each item might do."

**Tier 3:**
"The lockpick set can open locked doors. The keyring has the study key."

**Tier 4:**
"Use USE [ITEM] ON [OBJECT] to use items on specific objects."

---

### Topic: NPCs

**Tier 1:**
"Each NPC has different information. Try asking them about various topics."

**Tier 2:**
"ASK [NPC] ABOUT [TOPIC] to learn new information."

**Tier 3:**
"Some NPCs lie. Compare what they say with the evidence you find."

**Tier 4:**
"SHOW [ITEM] TO [NPC] to see their reaction to evidence."

---

## Wrong Attempt Responses

### Study Entry
- **BREAK DOOR:** "The door is solid oak. You'd need a battering ram."
- **CLIMB WINDOW (without lockpick):** "The window is too high. You need a tool."
- **ASK LADY ABOUT KEY:** "I don't have such things. Ask the butler."

### Library Cipher
- **PUSH RANDOM BOOKS:** "Nothing happens. Perhaps there's an order to follow."
- **READ ALL BOOKS:** "The books are unremarkable Victorian literature."
- **ASK HUDSON ABOUT PASSAGE:** "I know of no such thing."

### Greenhouse Poison
- **SMELL POISON:** "The scent is faint but distinctive. Best not to inhale."
- **TASTE POISON:** "You feel dizzy. Perhaps that wasn't wise." (lose health)
- **ASK LADY ABOUT POISON:** "I know nothing of such things." (lying)

### Final Confrontation
- **ACCUSE LADY-ASHWORTH:** "Lady Ashworth has an alibi. The evidence doesn't match."
- **ACCUSE MR-HUDSON:** "Mr. Hudson was in servants' quarters. The knife isn't his."
- **ACCUSE UNKNOWN:** "You must name a specific suspect."
- **SHOW EVIDENCE TO WRONG PERSON:** "That's not the Inspector."

---

## Success Feedback

### Evidence Found
- "You take the [evidence item] carefully. This could be important."
- "This [evidence item] might connect to the murder."

### Clue Connected
- "You make a connection: [clue] points to [suspect]."
- "The pieces are falling into place."

### Puzzle Solved
- "The lock clicks open. You can now enter the study."
- "The wall slides open, revealing a secret passage."
- "You've identified the poison. Now to find the antidote."

### Accusation Correct
- "Dr. Moriarty, you are under arrest for the murder of Lord Ashworth."
- "The inspector reads the evidence. 'Case closed.'"

### Game Won
- "Congratulations! You have solved the murder of Lord Ashworth."
- "Your reputation as a detective is secured."

---

## Hint Writing Guidelines

### Progressive Disclosure
1. **Tier 1:** Draw attention to the problem area
2. **Tier 2:** Point toward the solution path
3. **Tier 3:** Describe the specific action needed
4. **Tier 4:** Provide exact command syntax

### Tone
- Maintain Victorian atmosphere in hints
- Be encouraging, not condescending
- Avoid spoiling other puzzles
- Keep hints concise

### Fairness
- Don't give away the solution too easily
- Make hints relevant to current progress
- Update hints based on game state
- Reset hints when puzzle is solved

---

## Implementation Notes

### Hint State Tracking
- Track current hint tier per puzzle
- Reset tier when puzzle solved
- Allow players to request specific hint topics
- Provide GENERAL hints for stuck players

### Hint Delivery
- Display hints in response to HINTS command
- Allow HINTS [TOPIC] for specific hints
- Show available topics in HINTS response
- Limit hint requests per game session (optional)

### Integration
- Hints should not break immersion
- Avoid mechanical language in hints
- Maintain consistent tone with game text
- Provide feedback when hint is used
