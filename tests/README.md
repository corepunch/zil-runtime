# ZIL Runtime Tests

This directory contains tests for the ZIL runtime using the Zork1 adventure game.

## Running Tests

To run all tests in a test file:

```bash
lua tests/run_tests.lua tests/zork1_basic.lua
```

If no test file is specified, it defaults to `tests/zork1_basic.lua`:

```bash
lua tests/run_tests.lua
```

## Test File Format

Test files are Lua scripts that return a table with the following structure:

```lua
return {
    name = "Test Suite Name",
    
    -- Optional: List of ZIL files to compile and load
    -- If omitted, defaults to the standard Zork1 file set
    files = {
        "zork1/globals.zil",
        "zork1/parser.zil",
        "zork1/verbs.zil",
        "zork1/syntax.zil",
        "adventure/horror.zil",
        "zork1/main.zil",
    },
    
    -- List of commands to execute in sequence
    commands = {
        {
            input = "examine mailbox",
            description = "Optional description of what this command tests"
        },
        {
            input = "open mailbox",
            description = "Open the mailbox"
        },
        -- Add more commands...
    }
}
```

## Writing Tests

1. Create a new `.lua` file in the `tests/` directory
2. Define the test suite structure as shown above
3. Add commands that should be executed sequentially
4. Run the test using `run_tests.lua`

The test runner will:
- Load the ZIL runtime and specified ZIL files
- Execute each command in sequence
- Display the game output for each command
- Exit cleanly after all commands are executed

## Example Tests

See `tests/zork1_basic.lua` for example tests based on the commands originally in `zil/bootstrap.lua`.

## Adding New Test Files

You can create additional test files for different scenarios:
- `tests/zork1_movement.lua` - Test movement commands
- `tests/zork1_inventory.lua` - Test inventory management
- `tests/zork1_puzzles.lua` - Test puzzle solving
- etc.

Each test file can use different ZIL files by specifying them in the `files` array.
