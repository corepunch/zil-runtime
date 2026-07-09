#!/usr/bin/env lua
-- generate-test-from-transcript.lua
-- Parses a transcript file and generates a ZIL test file

local function parse_transcript(filename)
    local commands = {}
    local responses = {}
    local current_response = {}
    local in_response = false
    local seen_command = false
    
    local file = io.open(filename, "r")
    if not file then
        print("Error: Could not open " .. filename)
        os.exit(1)
    end
    
    for line in file:lines() do
        -- Check if line starts with > (command)
        if line:match("^>(.*)") then
            -- Save previous response if any
            if in_response and #current_response > 0 then
                table.insert(responses, table.concat(current_response, "\n"))
                current_response = {}
            end
            -- Extract command
            local cmd = line:match("^>(.*)")
            if cmd and cmd ~= "" then
                table.insert(commands, cmd)
                in_response = false
                seen_command = true
            end
        else
            -- Response line (including empty lines within a response)
            if seen_command then
                in_response = true
                table.insert(current_response, line)
            end
        end
    end
    
    -- Save last response
    if in_response and #current_response > 0 then
        table.insert(responses, table.concat(current_response, "\n"))
    end
    
    file:close()
    
    return commands, responses
end

local function extract_key_phrase(response)
    -- Extract just the first line or a key phrase
    if not response or response == "" then
        return ""
    end
    
    -- Get first line
    local first_line = response:match("^([^\n]+)")
    if not first_line then
        return ""
    end
    
    -- Clean up the response
    first_line = first_line:gsub("^%s+", ""):gsub("%s+$", "")
    
    -- Truncate if too long
    if #first_line > 80 then
        first_line = first_line:sub(1, 80) .. "..."
    end
    
    return first_line
end

-- Game-specific file mappings
local game_files = {
    zork1 = {
        globals = "infocom/zork1/globals",
        clock = "infocom/zork1/clock",
        parser = "infocom/zork1/parser",
        verbs = "infocom/zork1/verbs",
        actions = "infocom/zork1/actions",
        syntax = "infocom/zork1/syntax",
        dungeon = "infocom/zork1/dungeon",
        main = "infocom/zork1/main",
    },
    zork2 = {
        globals = "infocom/zork2/gglobals",
        clock = "infocom/zork2/gclock",
        parser = "infocom/zork2/gparser",
        verbs = "infocom/zork2/gverbs",
        actions = "infocom/zork2/2actions",
        syntax = "infocom/zork2/gsyntax",
        dungeon = "infocom/zork2/2dungeon",
        main = "infocom/zork2/gmain",
    },
    zork3 = {
        globals = "infocom/zork3/gglobals",
        clock = "infocom/zork3/gclock",
        parser = "infocom/zork3/gparser",
        verbs = "infocom/zork3/gverbs",
        actions = "infocom/zork3/3actions",
        syntax = "infocom/zork3/gsyntax",
        dungeon = "infocom/zork3/3dungeon",
        main = "infocom/zork3/gmain",
    },
    planetfall = {
        globals = "infocom/planetfall/globals",
        clock = nil,
        parser = "infocom/planetfall/parser",
        verbs = "infocom/planetfall/verbs",
        actions = nil,
        syntax = "infocom/planetfall/syntax",
        dungeon = nil,
        main = "infocom/planetfall/planetfall",
    },
    lurkinghorror = {
        globals = "infocom/lurkinghorror/globals",
        clock = nil,
        parser = "infocom/lurkinghorror/parser",
        verbs = "infocom/lurkinghorror/verbs",
        actions = nil,
        syntax = "infocom/lurkinghorror/syntax",
        dungeon = nil,
        main = "infocom/lurkinghorror/misc",
    },
    spellbreaker = {
        globals = "infocom/spellbreaker/globals",
        clock = nil,
        parser = "infocom/spellbreaker/parser",
        verbs = "infocom/spellbreaker/verbs",
        actions = "infocom/spellbreaker/actions",
        syntax = "infocom/spellbreaker/syntax",
        dungeon = nil,
        main = "infocom/spellbreaker/z6",
    },
}

local function generate_zil_test(commands, responses, game_name)
    local files = game_files[game_name]
    if not files then
        print("Error: No file mapping found for game: " .. game_name)
        os.exit(1)
    end
    
    local zil = string.format([[
"TEST-%s.ZIL - Auto-generated test from transcript"

<INSERT-FILE "%s">
]], game_name, files.globals)
    
    if files.clock then
        zil = zil .. string.format('<INSERT-FILE "%s">\n', files.clock)
    end
    
    zil = zil .. string.format('<INSERT-FILE "%s">\n', files.parser)
    zil = zil .. string.format('<INSERT-FILE "%s">\n', files.verbs)
    
    if files.actions then
        zil = zil .. string.format('<INSERT-FILE "%s">\n', files.actions)
    end
    
    zil = zil .. string.format('<INSERT-FILE "%s">\n', files.syntax)
    
    if files.dungeon then
        zil = zil .. string.format('<INSERT-FILE "%s">\n', files.dungeon)
    end
    
    zil = zil .. string.format('<INSERT-FILE "%s">\n', files.main)
    
    zil = zil .. string.format([[
<CONSTANT RELEASEID 1>

<GLOBAL CO <CO-CREATE GO>>

<ROUTINE RUN-TEST ()
	<TELL "Testing %s transcript..." CR>
]], game_name)
    
    for i, cmd in ipairs(commands) do
        local resp = responses[i] or ""
        -- Extract key phrase from response
        local key_phrase = extract_key_phrase(resp)
        -- Escape quotes in response
        key_phrase = key_phrase:gsub('"', '\\"')
        
        -- Skip commands that might cause issues
        if cmd:match("^save$") or cmd:match("^restore$") or cmd:match("^quit$") then
            zil = zil .. string.format([[
	;<ASSERT-TEXT "%s" <CO-RESUME ,CO "%s">>
]], key_phrase, cmd)
        else
            zil = zil .. string.format([[
	<ASSERT-TEXT "%s" <CO-RESUME ,CO "%s">>
]], key_phrase, cmd)
        end
    end
    
    -- Add closing - note: >> must be on same line as last statement
    zil = zil .. "\t<TELL CR \"" .. game_name .. " transcript test completed!\" CR>>\n"
    
    return zil
end

-- Main
local transcript_file = arg[1]
if not transcript_file then
    print("Usage: lua5.4 generate-test-from-transcript.lua <transcript-file>")
    print("Example: lua5.4 generate-test-from-transcript.lua infocom/zork1/test/zork1.txt")
    os.exit(1)
end

-- Extract game name from path
local game_name = transcript_file:match("infocom/([^/]+)/")
if not game_name then
    print("Error: Could not extract game name from path")
    os.exit(1)
end

print("Parsing transcript: " .. transcript_file)
print("Game name: " .. game_name)

local commands, responses = parse_transcript(transcript_file)
print(string.format("Found %d commands", #commands))

-- Generate ZIL test
local zil = generate_zil_test(commands, responses, game_name)

-- Write output file
local output_file = string.format("infocom/%s/test/test-auto-generated.zil", game_name)
local file = io.open(output_file, "w")
if not file then
    print("Error: Could not create " .. output_file)
    os.exit(1)
end

file:write(zil)
file:close()

print("Generated test file: " .. output_file)
print("Run with: lua5.4 run-zil-test.lua " .. output_file:gsub("%.zil$", ""):gsub("/", "."))
