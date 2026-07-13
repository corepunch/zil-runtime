# Playing Games Programmatically

This document explains how agents (or scripts) can play ZIL games to evaluate playability, test game content, or run walkthroughs.

## Overview

Use `llm.lua` to interact with games one command at a time. Each invocation loads a save, executes a command, captures the response, and saves state. This works across separate process invocations — no persistent Lua state needed.

## Quick Start

```bash
# Start a new game (creates savefile.sav and savefile.sav.actions)
lua5.4 llm.lua --new-game --save zork1.sav

# Send a command
lua5.4 llm.lua --action "look" --save zork1.sav

# Play through a sequence
lua5.4 llm.lua --action "open mailbox" --save zork1.sav
lua5.4 llm.lua --action "take leaflet" --save zork1.sav
lua5.4 llm.lua --action "read leaflet" --save zork1.sav
```

## Output

Each command returns JSON:

```json
{
  "ok": true,
  "output": "Opening the small mailbox reveals a leaflet.\n",
  "room": "West of House",
  "savefile": "zork1.sav",
  "historyfile": "zork1.sav.actions",
  "restored": true
}
```

- `ok` — whether the command executed without engine error
- `output` — the game's text response (ANSI stripped)
- `room` — current room name (if available)
- `restored` — whether state was restored from a previous save

## How State Continuity Works

1. `--new-game` starts fresh, saves initial state, and resets the action history.
2. Each `--action` call restores state from the save file, replays the command, then saves the new state.
3. A JSONL action history (`savefile.sav.actions`) is maintained as a fallback if the binary save is unavailable.
4. Each invocation is a separate OS process — no Lua state persists between calls.

## Agent Play Loop

To play N turns of a game:

```bash
SAVE="zork1.sav"

# Initialize
lua5.4 llm.lua --new-game --save "$SAVE"

# Play turns
for i in $(seq 1 10); do
  # Choose an action based on current game state
  RESPONSE=$(lua5.4 llm.lua --action "look" --save "$SAVE")
  echo "$RESPONSE" | jq -r '.output'

  # Decide next action, then execute
  lua5.4 llm.lua --action "go north" --save "$SAVE"
done
```

## Using With an LLM Agent

An agent can play the game in a loop:

1. **Start**: `lua5.4 llm.lua --new-game --save game.sav`
2. **Observe**: Parse the `output` field from the JSON response
3. **Decide**: Choose the next command based on game state
4. **Act**: `lua5.4 llm.lua --action "<command>" --save game.sav`
5. **Repeat** from step 2

The agent should:
- Use `look` or `examine` frequently to understand the current state
- Track inventory with `inventory`
- Try multiple approaches if a puzzle doesn't yield results
- Read any text the game presents (signs, leaflets, etc.)

## Command Reference

See [TESTING.md § How to Play](TESTING.md#how-to-play) for the full command reference (movement, examination, inventory, taking/dropping, using objects).

## Available Games

Pass `--game <name>` to play different games:

| Game | Module |
|------|--------|
| zork1 (default) | `infocom.zork1.zork1` |
| lurkinghorror | `infocom.lurkinghorror.h1` |
| spellbreaker | `infocom.spellbreaker.z6` |

## Command-Line Reference

```
lua5.4 llm.lua [options]

Options:
  --action, -a "cmd"   Execute this command
  --save, -s file      Save file path (default: savefile.sav)
  --game, -g name      Game module (default: zork1)
  --new-game           Start fresh, ignoring existing save
  --help, -h           Show help
```

## Evaluating Playability

To assess whether an LLM can play and beat a game:

1. Start a new game
2. Give the LLM the game output and ask it to choose actions
3. Feed each action back via `llm.lua`
4. Track: rooms visited, items collected, puzzles solved, deaths
5. A game is "playable" if the LLM can make meaningful progress without getting stuck in loops

Example evaluation script:

```bash
SAVE="eval.sav"
lua5.4 llm.lua --new-game --save "$SAVE" | jq -r '.output' > eval.log

for turn in $(seq 1 50); do
  # In practice, an LLM would decide the action here
  ACTION="look"
  RESULT=$(lua5.4 llm.lua --action "$ACTION" --save "$SAVE")
  OUTPUT=$(echo "$RESULT" | jq -r '.output')
  ROOM=$(echo "$RESULT" | jq -r '.room')

  echo "Turn $turn [$ROOM]: $OUTPUT" >> eval.log

  # Check for game end conditions
  if echo "$OUTPUT" | grep -qi "game has ended\|you have died\|score is"; then
    break
  fi
done
```
