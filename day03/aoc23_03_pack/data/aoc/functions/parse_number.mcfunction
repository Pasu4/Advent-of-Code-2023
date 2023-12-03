# Parse the number.
# Start with the leftmost digit.
execute if block ~ ~ ~ white_concrete run function aoc:add_number {number:0}
execute if block ~ ~ ~ orange_concrete run function aoc:add_number {number:1}
execute if block ~ ~ ~ magenta_concrete run function aoc:add_number {number:2}
execute if block ~ ~ ~ light_blue_concrete run function aoc:add_number {number:3}
execute if block ~ ~ ~ yellow_concrete run function aoc:add_number {number:4}
execute if block ~ ~ ~ lime_concrete run function aoc:add_number {number:5}
execute if block ~ ~ ~ pink_concrete run function aoc:add_number {number:6}
execute if block ~ ~ ~ gray_concrete run function aoc:add_number {number:7}
execute if block ~ ~ ~ light_gray_concrete run function aoc:add_number {number:8}
execute if block ~ ~ ~ cyan_concrete run function aoc:add_number {number:9}

# If the number is at the end
execute unless block ~ ~ ~ air run fill ~ ~ ~ ~ 0 ~ black_concrete replace red_concrete
# Next digit is ~1 ~1 ~
execute unless block ~ ~ ~ air positioned ~1 ~1 ~ run function aoc:parse_number
# Add number to part sum
execute if block ~ ~ ~ air run scoreboard players operation PartSum variable += Buffer variable
# Clear buffer
execute if block ~ ~ ~ air run scoreboard players set Buffer variable 0