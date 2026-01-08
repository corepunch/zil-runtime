# ZIL Runtime Tests

This directory contains tests for the ZIL runtime.

## Test Types

### Unit Tests

Unit tests test individual components (parser, compiler, runtime) in isolation. They are located in the `unit/` subdirectory.

**Running unit tests:**

```bash
# Run all unit tests
lua tests/unit/run_all.lua

# Run specific component tests
lua tests/unit/test_parser.lua
lua tests/unit/test_compiler.lua
lua tests/unit/test_runtime.lua
```

**Unit test components:**

- `test_parser.lua` - Tests for `zil/parser.lua`
  - Basic type parsing (numbers, strings, identifiers, symbols)
  - Expression and list parsing
  - Special forms (comments, placeholders, etc.)
  - Complex ZIL constructs
  
- `test_compiler.lua` - Tests for `zil/compiler.lua`
  - Routine compilation
  - Object compilation
  - Constants and globals
  - Control flow structures
  - Output format validation
  
- `test_runtime.lua` - Tests for `zil/runtime.lua`
  - Environment creation
  - Code execution
  - Bootstrap loading
  - ZIL file loading
  - Error handling

- `test_framework.lua` - Simple unit testing framework
  - Assertion functions (assert_equal, assert_type, etc.)
  - Test suite organization
  - Test result reporting

### Integration Tests

Integration tests test the full ZIL runtime using the Zork1 adventure game.

## Running Integration Tests

To run all tests in a test file:

```bash
lua tests/run_tests.lua tests/zork1_basic.lua
```

If no test file is specified, it defaults to `tests/zork1_basic.lua`:

```bash
lua tests/run_tests.lua
```

## Integration Test File Format

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

## Writing Integration Tests

1. Create a new `.lua` file in the `tests/` directory
2. Define the test suite structure as shown above
3. Add commands that should be executed sequentially
4. Run the test using `run_tests.lua`

The test runner will:
- Load the ZIL runtime and specified ZIL files
- Execute each command in sequence
- Display the game output for each command
- Exit cleanly after all commands are executed

## Example Integration Tests

See `tests/zork1_basic.lua` for example tests based on the commands originally in `zil/bootstrap.lua`.

## Adding New Test Files

### Adding Unit Tests

To add new unit tests:

1. Create a new test file in `tests/unit/` (e.g., `test_mycomponent.lua`)
2. Use the test framework from `test_framework.lua`
3. Structure your tests using `test.describe()` and `t.it()`
4. Add the test file to `tests/unit/run_all.lua`

Example unit test structure:

```lua
#!/usr/bin/env lua
local test = require 'tests.unit.test_framework'
local mymodule = require 'mymodule'

test.describe("My Component - Feature X", function(t)
    t.it("should do something", function(assert)
        local result = mymodule.do_something()
        assert.assert_equal(result, expected_value)
    end)
end)

local success = test.summary()
os.exit(success and 0 or 1)
```

### Adding Integration Tests

You can create additional integration test files for different scenarios:
- `tests/zork1_movement.lua` - Test movement commands
- `tests/zork1_inventory.lua` - Test inventory management
- `tests/zork1_puzzles.lua` - Test puzzle solving
- etc.

Each test file can use different ZIL files by specifying them in the `files` array.
