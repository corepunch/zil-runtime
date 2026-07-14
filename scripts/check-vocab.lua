#!/usr/bin/env lua
-- check-vocab.lua: Validate that FDESC/LDESC text words are registered as synonyms/adjectives
--
-- Usage:
--   lua scripts/check-vocab.lua <file.zil> [file2.zil ...]
--   lua scripts/check-vocab.lua books/limehouse-killings/dungeon.zil
--
-- What it checks:
--   1. CRITICAL: Every word in DESC appears in SYNONYM (the parser uses SYNONYM to match)
--   2. HIGH: Nouns in FDESC/LDESC that look like they could be typed as commands
--      but aren't registered in any object's SYNONYM or ADJECTIVE list
--   3. INFO: Nouns in FDESC/LDESC resolved by other objects in the same file

-- ============================================================
-- Stop words: words to skip (articles, verbs, adjectives, context)
-- ============================================================
local STOP_WORDS = {}
local _stop_list = {
    -- Articles/determiners
    "the", "a", "an", "some", "any", "no", "every",
    "each", "both", "few", "many", "much", "several",
    -- Pronouns
    "it", "its", "he", "she", "they", "them", "him",
    "her", "his", "their", "this", "that", "these",
    "those", "ones", "you", "your",
    -- Prepositions
    "of", "in", "on", "at", "to", "for", "with",
    "by", "from", "up", "about", "into", "through",
    "during", "before", "after", "above", "below",
    "between", "under", "behind", "beside", "near",
    "against", "among", "across", "along", "around",
    -- Conjunctions
    "and", "or", "but", "nor", "yet", "so", "if",
    "then", "else", "when", "while", "because", "since",
    "although",
    -- Common verbs in descriptions
    "lies", "sits", "stands", "rests", "hangs", "contains",
    "holds", "shows", "appears", "seems", "looks", "gives",
    "leads", "provides", "fills", "covers", "marks",
    "suggests", "promises", "waiting", "using", "worn",
    "filled", "covered", "etched", "reading", "glinting",
    "is", "are", "was", "were", "be", "been", "being",
    "have", "has", "had", "do", "does", "did", "will",
    "would", "could", "should", "may", "might", "shall",
    "can", "need", "dare",
    -- Context/environment words (not object vocabulary)
    "wall", "walls", "floor", "ceiling", "room", "door", "doors",
    "window", "windows", "passage", "corridor", "hall", "hallway",
    "corner", "center", "edge", "side", "end", "top", "bottom",
    "inside", "outside", "surface", "part", "place", "way",
    -- Common descriptors (adjectives, not nouns to type)
    "old", "new", "small", "large", "big", "long",
    "short", "tall", "deep", "wide", "narrow", "thick",
    "thin", "heavy", "light", "dark", "bright", "cold",
    "hot", "warm", "cool", "dry", "wet", "soft", "hard",
    "clean", "dirty", "fresh", "clear", "plain", "sturdy",
    "fine", "sharp", "smooth", "rough", "empty", "full",
    -- Common verbs (actions, not nouns)
    "opens", "blocks", "secures", "reveals", "dominates",
    "separates", "overlooks", "burns", "casts", "pushes",
    "glints", "gleams", "glows", "shifts", "stands",
    "lies", "hangs", "rests", "sits", "crouches",
    -- ZIL/formatting
    "cr", "tell", "cond", "true", "false", "routine",
    "object", "room", "verb",
    -- Time/age references
    "ago", "years", "centuries", "recently", "long",
    -- Possessives and contractions
    "moriarty's", "ashworth's", "doesn't", "you're", "you'd",
    "lord", "mr", "mrs", "dr",
    -- Numbers
    "one", "two", "three", "first", "second", "third",
}
for _, w in ipairs(_stop_list) do
    rawset(STOP_WORDS, w, true)
end

-- ============================================================
-- Nouns that commonly appear in descriptions but are NOT
-- player-typable object names (context/environment)
-- ============================================================
local CONTEXT_NOUNS = {}
local _context_list = {
    -- Environment
    "stone", "wood", "metal", "glass", "iron", "brass", "steel",
    "leather", "cloth", "fabric", "paper", "ink",
    -- Furniture
    "table", "chair", "desk", "shelf", "shelves", "bench",
    "bed", "cabinet", "counter", "trunk",
    -- Building
    "wall", "floor", "ceiling", "door", "window", "gate",
    "staircase", "stairs", "passage", "corridor", "hall",
    "room", "corner", "center", "edge",
    -- Nature
    "tree", "bush", "hedge", "plant", "flower", "leaf", "leaves",
    "water", "stone", "rock", "earth", "soil", "dust",
    -- Body
    "hand", "hands", "eye", "eyes", "face", "head", "fingers",
    "stomach", "arm", "arms",
    -- Abstract
    "light", "darkness", "shadow", "shadows", "glow",
    "sound", "noise", "silence", "air", "breath",
    "time", "day", "night", "morning", "evening",
    "story", "secret", "secrets", "evidence", "truth",
    -- Actions
    "pull", "push", "turn", "slide", "lift", "raise",
    "mark", "marks", "pattern", "symbols",
}
for _, w in ipairs(_context_list) do
    rawset(CONTEXT_NOUNS, w, true)
end

-- ============================================================
-- Parse ZIL OBJECT definitions
-- ============================================================
local function parse_zil_objects(content)
    local objects = {}
    local pos = 1
    local len = #content
    local safety = 0

    while pos <= len do
        safety = safety + 1
        if safety > 10000 then break end

        local obj_start = content:find("<OBJECT%s+(%S+)", pos)
        if not obj_start then break end

        local obj_name = content:match("<OBJECT%s+(%S+)", obj_start)
        if not obj_name then
            pos = obj_start + 8
        else
            local depth = 1
            local search_from = obj_start
            local obj_end = nil

            while search_from <= len do
                local next_open = content:find("<", search_from + 1)
                local next_close = content:find(">", search_from + 1)
                if not next_close then break end
                if next_open and next_open < next_close then
                    depth = depth + 1
                    search_from = next_open
                else
                    depth = depth - 1
                    search_from = next_close
                    if depth == 0 then
                        obj_end = next_close
                        break
                    end
                end
            end

            if not obj_end then
                pos = obj_start + 8
            else
                local obj_block = content:sub(obj_start, obj_end)

                local function extract_property(prop_name)
                    local pattern1 = "%(" .. prop_name .. '%s+"([^"]*)"'
                    local val = obj_block:match(pattern1)
                    if val then return val end
                    local pattern2 = "%(" .. prop_name .. "%s+([^)]+)%)"
                    local words_str = obj_block:match(pattern2)
                    if words_str then
                        local words = {}
                        for w in words_str:gmatch("(%S+)") do
                            table.insert(words, w:lower())
                        end
                        return words
                    end
                    return nil
                end

                local synonyms = extract_property("SYNONYM") or {}
                local adjectives = extract_property("ADJECTIVE") or {}
                local fdesc = extract_property("FDESC")
                local ldesc = extract_property("LDESC")
                local desc = extract_property("DESC")

                local syn_set = {}
                if type(synonyms) == "table" then
                    for _, w in ipairs(synonyms) do syn_set[w] = true end
                end

                local adj_set = {}
                if type(adjectives) == "table" then
                    for _, w in ipairs(adjectives) do adj_set[w] = true end
                end

                table.insert(objects, {
                    name = obj_name,
                    synonyms = syn_set,
                    adjectives = adj_set,
                    fdesc = fdesc,
                    ldesc = ldesc,
                    desc = desc,
                })

                pos = obj_end + 1
            end
        end
    end

    return objects
end

-- ============================================================
-- Tokenize description text
-- ============================================================
local function tokenize_desc(text)
    if not text then return {} end
    local words = {}
    local cleaned = text:gsub("<[^>]+>", " ")
    cleaned = cleaned:gsub("[<>]", " ")
    cleaned = cleaned:gsub('"', " ")
    cleaned = cleaned:gsub("%-%-", " ")
    cleaned = cleaned:gsub("^%s+", ""):gsub("%s+$", "")
    for w in cleaned:gmatch("%S+") do
        local clean = w:match("^[%p]*(.-)[%p]*$")
        if clean and #clean > 0 then
            table.insert(words, clean:lower())
        end
    end
    return words
end

-- ============================================================
-- Check a single object
-- ============================================================
local function check_object(obj, all_objects)
    local issues = {}

    -- Build vocabulary sets
    local vocab = {}
    for w in pairs(obj.synonyms) do vocab[w] = true end
    for w in pairs(obj.adjectives) do vocab[w] = true end

    local all_vocab = {}
    for _, other in ipairs(all_objects) do
        for w in pairs(other.synonyms) do all_vocab[w] = true end
        for w in pairs(other.adjectives) do all_vocab[w] = true end
    end

    -- CHECK 1: CRITICAL — DESC words should be in SYNONYM
    if obj.desc then
        local desc_words = tokenize_desc(obj.desc)
        for _, word in ipairs(desc_words) do
            if not STOP_WORDS[word] and #word > 1 then
                if not vocab[word] then
                    table.insert(issues, {
                        level = "CRITICAL",
                        field = "DESC",
                        word = word,
                        msg = string.format("DESC word \"%s\" not in SYNONYM — parser won't match it", word),
                    })
                end
            end
        end
    end

    -- CHECK 2: HIGH — Nouns in FDESC/LDESC that look like typeable commands
    local function check_desc_text(text, field_name)
        if not text then return end
        local words = tokenize_desc(text)
        for _, word in ipairs(words) do
            if not STOP_WORDS[word] and #word > 2 and not CONTEXT_NOUNS[word] then
                if not vocab[word] and not all_vocab[word] then
                    table.insert(issues, {
                        level = "HIGH",
                        field = field_name,
                        word = word,
                        msg = string.format("\"%s\" in %s not in any SYNONYM/ADJECTIVE — player can't type it", word, field_name),
                    })
                end
            end
        end
    end

    check_desc_text(obj.fdesc, "FDESC")
    check_desc_text(obj.ldesc, "LDESC")

    return issues
end

-- ============================================================
-- Main
-- ============================================================
local function main()
    local files = {}
    for i = 1, #arg do
        table.insert(files, arg[i])
    end

    if #files == 0 then
        io.write("Usage: lua scripts/check-vocab.lua <file.zil> [file2.zil ...]\n")
        io.write("\nValidates that player-facing nouns in descriptions are registered\n")
        io.write("as SYNONYM or ADJECTIVE on the object.\n")
        os.exit(1)
    end

    local total_critical = 0
    local total_high = 0

    for _, filepath in ipairs(files) do
        local f = io.open(filepath, "r")
        if not f then
            io.write("Error: cannot open " .. filepath .. "\n")
            os.exit(1)
        end
        local content = f:read("*a")
        f:close()

        local objects = parse_zil_objects(content)
        local file_issues = {}

        for _, obj in ipairs(objects) do
            local issues = check_object(obj, objects)
            if #issues > 0 then
                file_issues[obj.name] = issues
            end
        end

        if next(file_issues) then
            io.write(filepath .. ":\n")
            for obj_name, issues in pairs(file_issues) do
                for _, issue in ipairs(issues) do
                    io.write(string.format("  [%s] %s: %s\n", issue.level, obj_name, issue.msg))
                    if issue.level == "CRITICAL" then
                        total_critical = total_critical + 1
                    elseif issue.level == "HIGH" then
                        total_high = total_high + 1
                    end
                end
            end
            io.write("\n")
        end
    end

    io.write(string.format("%d critical, %d high across %d file(s)\n",
        total_critical, total_high, #files))

    if total_critical > 0 then
        os.exit(1)
    end
end

main()
