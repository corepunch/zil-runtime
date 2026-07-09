#!/usr/bin/env lua5.4

local games = {
	zork1 = {
		story = "infocom/zork1/zork1.z3",
		source = "infocom/zork1/test/zork1.txt",
		output = "infocom/zork1/test/zork1-frotz.txt",
	},
	zork2 = {
		story = "infocom/zork2/zork2.z3",
		source = "infocom/zork2/test/zork2.txt",
		output = "infocom/zork2/test/zork2-frotz.txt",
	},
	zork3 = {
		story = "infocom/zork3/zork3.z3",
		source = "infocom/zork3/test/zork3.txt",
		output = "infocom/zork3/test/zork3-frotz.txt",
	},
	planetfall = {
		story = "infocom/planetfall/planetfall.z3",
		source = "infocom/planetfall/test/planetfall.txt",
		output = "infocom/planetfall/test/planetfall-frotz.txt",
	},
	spellbreaker = {
		story = "infocom/spellbreaker/z6.z3",
		source = "infocom/spellbreaker/test/spellbreaker.txt",
		output = "infocom/spellbreaker/test/spellbreaker-frotz.txt",
	},
	lurkinghorror = {
		story = "infocom/lurkinghorror/h1.z3",
		source = "infocom/lurkinghorror/test/lurkinghorror.txt",
		output = "infocom/lurkinghorror/test/lurkinghorror-frotz.txt",
	},
}

local script_path = arg[0] or "record-frotz-transcript.lua"
local script_dir = script_path:match("^(.*)/[^/]+$") or "."

local function trim(text)
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function shell_quote(text)
	return "'" .. text:gsub("'", "'\\''") .. "'"
end

local function absolute_path(path)
	if path:sub(1, 1) == "/" then
		return path
	end
	if script_dir == "." then
		return path
	end
	return script_dir .. "/" .. path
end

local function read_commands(path)
	local commands = {}
	for line in io.lines(path) do
		local command = line:match("^>%s*(.*)$")
		if command and command ~= "" then
			table.insert(commands, trim(command))
		end
	end
	if #commands == 0 then
		error("No commands found in " .. path)
	end
	return commands
end

local function write_lines(path, lines)
	local file = assert(io.open(path, "w"))
	for _, line in ipairs(lines) do
		file:write(line, "\n")
	end
	file:close()
end

local function copy_file(source, destination)
	local input = assert(io.open(source, "rb"))
	local output = assert(io.open(destination, "wb"))
	output:write(assert(input:read("*a")))
	input:close()
	output:close()
end

local function ensure_parent_dir(path)
	local dir = path:match("^(.*)/[^/]+$")
	if dir and dir ~= "" then
		local ok = os.execute("mkdir -p " .. shell_quote(dir))
		if ok ~= true and ok ~= 0 then
			error("Failed to create directory " .. dir)
		end
	end
end

local function run_game(game_name)
	local spec = assert(games[game_name], "Unknown game: " .. game_name)
	local story = absolute_path(spec.story)
	local source = absolute_path(spec.source)
	local output = absolute_path(spec.output)
	local commands = read_commands(source)

	local tmpdir_handle = assert(io.popen("mktemp -d", "r"))
	local tmpdir = trim(assert(tmpdir_handle:read("*l")))
	tmpdir_handle:close()
	if tmpdir == "" then
		error("Failed to create temporary directory")
	end

	local cmdfile = tmpdir .. "/commands.txt"
	local transcript_base = "session"
	local transcript_path = tmpdir .. "/" .. transcript_base .. ".scr"
	local log_path = tmpdir .. "/dfrotz.log"
	local lines = {"script", transcript_base}
	for _, command in ipairs(commands) do
		table.insert(lines, command)
	end
	if trim(commands[#commands]):lower() ~= "unscript" then
		table.insert(lines, "unscript")
	end
	if trim(commands[#commands]):lower() ~= "quit" then
		table.insert(lines, "quit")
		table.insert(lines, "y")
	end
	write_lines(cmdfile, lines)

	local command = string.format(
		"cd %s && dfrotz -p -m -q %s < %s > %s 2>&1",
		shell_quote(tmpdir),
		shell_quote(story),
		shell_quote(cmdfile),
		shell_quote(log_path)
	)
	local ok = os.execute(command)
	if ok ~= true and ok ~= 0 then
		error("dfrotz replay failed for " .. game_name .. "; see " .. log_path)
	end

	ensure_parent_dir(output)
	copy_file(transcript_path, output)
	os.execute("rm -rf " .. shell_quote(tmpdir))
	print(string.format("Recorded %s -> %s", game_name, spec.output))
end

local requested = {}
if #arg == 0 then
	for name in pairs(games) do
		table.insert(requested, name)
	end
	table.sort(requested)
else
	for _, name in ipairs(arg) do
		table.insert(requested, name)
	end
	end

local failures = {}
for _, game_name in ipairs(requested) do
	local ok, err = pcall(run_game, game_name)
	if not ok then
		print(string.format("FAILED %s: %s", game_name, tostring(err)))
		table.insert(failures, game_name)
	end
end

if #failures > 0 then
	error("Transcript recording failed for: " .. table.concat(failures, ", "))
end