function printTable(t, lf)
    lf = (lf == nil) or lf -- default true
    io.write("{ ")
    for i = 1, #t-1, 1 do
        if type(t[i]) == "table" then
            printTable(t[i], false) -- nesting
        else
            io.write(tostring(t[i]))
        end
        io.write(", ")
    end

    if type(t[#t]) == "table" then
        printTable(t[#t], false)
        io.write(" }")
    else
        io.write(tostring(t[#t]) .. " }")
    end
    if lf then io.write("\n") end
end

function minElement(t)
    local min = math.huge
    for i = 1, #t do
        min = math.min(min, t[i])
    end
    return min
end

-- main

file = io.open("input.txt", "r")
io.input(file)

seeds = {}
-- seeds = string.sub(io.read(), 8)
for seed in string.gmatch(io.read(), "%d+") do
    table.insert(seeds, tonumber(seed))
end

-- Parse file

maps = {}

line = io.read() -- read first line

while line do
    if string.find(line, "^%d") then -- if the line starts with a digit
        map = {}
        while line and string.find(line, "^%d") do -- for every following line that starts with a digit
            entry = {}
            for s in string.gmatch(line, "%d+") do -- for every number in the line
                table.insert(entry, tonumber(s)) -- Add number to entry
            end
            table.insert(map, entry) -- Add entry to map
            line = io.read()
        end
        table.insert(maps, map) -- Add map to maps
    end
    line = io.read() -- already checked this line in while loop
end

-- Calculations

for mapKey,map in pairs(maps) do -- for each conversion map
    for seedKey,seed in ipairs(seeds) do -- for each seed or current converted value
        for entryKey,entry in pairs(map) do -- for each entry in the map
            if seed >= entry[2] and seed < entry[2] + entry[3] then -- if seed is in the source range
                seeds[seedKey] = seed - entry[2] + entry[1] -- convert to destination range
                print(seed .. " in range " .. entry[2] .. ".." .. entry[2] + entry[3] - 1 .. 
                    " -> " .. seeds[seedKey] .. " in range " .. entry[1] .. ".." .. entry[1] + entry[3] - 1)
                break -- Break if seed matched this range
            else
                print(seed .. " not in range " .. entry[2] .. ".." .. entry[2] + entry[3] - 1)
            end
        end
        print()
    end
    printTable(seeds)
    print()
end

-- Output result

print("Nearest seed location: " .. minElement(seeds))

io.close(file);