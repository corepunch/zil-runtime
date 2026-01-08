#!/usr/bin/env lua
-- Run all unit tests

local test_files = {
	"tests/unit/test_parser.lua",
	"tests/unit/test_compiler.lua",
	"tests/unit/test_runtime.lua"
}

local all_passed = true

print("Running ZIL Runtime Unit Tests")
print(string.rep("=", 60))

for _, test_file in ipairs(test_files) do
	print("\n" .. test_file)
	local exit_code = os.execute("lua " .. test_file)
	if exit_code ~= 0 and exit_code ~= true then
		all_passed = false
	end
end

print("\n" .. string.rep("=", 60))
if all_passed then
	print("All unit tests passed!")
	os.exit(0)
else
	print("Some unit tests failed!")
	os.exit(1)
end
