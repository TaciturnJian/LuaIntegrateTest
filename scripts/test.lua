if PATH_EXE == nil then
    PATH_EXE = ""
end

if PATH_DIR == nil then
    PATH_DIR = string.match(PATH_EXE, "^.*\\")
end

if PATH_SCRIPT_DIR == nil then
    PATH_SCRIPT_DIR = PATH_DIR.."/scripts"
end

dofile(PATH_SCRIPT_DIR.."/Sango.lua")

if PATH_EXE == nil then
    PATH_EXE = ""
end

print("ACK_executable_path: "..PATH_EXE)

local t = {}

t["a"] = 10
t["b"] = t["a"] + 2
t["c"] = "a".."b"
table.insert(t, tostring(t.b))

tar = Sango.Table.ToString.List(t, true)
