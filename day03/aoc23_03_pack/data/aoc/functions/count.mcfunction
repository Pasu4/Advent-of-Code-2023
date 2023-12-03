# execute if entity @s[tag=gear] run function aoc:check_gear
# scoreboard players add ExecutionTime variable 1

execute if block ~-1 ~-1 ~-1 red_concrete positioned ~-1 ~ ~-1 run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~ ~-1 ~-1 red_concrete positioned ~ ~ ~-1 run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~1 ~-1 ~-1 red_concrete positioned ~1 ~ ~-1 run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~-1 ~-1 ~ red_concrete positioned ~-1 ~ ~ run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~1 ~-1 ~ red_concrete positioned ~1 ~ ~ run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~-1 ~-1 ~1 red_concrete positioned ~-1 ~ ~1 run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~ ~-1 ~1 red_concrete positioned ~ ~ ~1 run function aoc:find_number_base {func:"aoc:parse_number"}
execute if block ~1 ~-1 ~1 red_concrete positioned ~1 ~ ~1 run function aoc:find_number_base {func:"aoc:parse_number"}
kill @s