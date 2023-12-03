# check if this entity is a gear
scoreboard players set Buffer2 variable 1
scoreboard players set Count variable 0

execute if block ~-1 ~-1 ~-1 red_concrete positioned ~-1 ~ ~-1 run function aoc:find_gear_base
execute if block ~ ~-1 ~-1 red_concrete positioned ~ ~ ~-1 run function aoc:find_gear_base
execute if block ~1 ~-1 ~-1 red_concrete positioned ~1 ~ ~-1 run function aoc:find_gear_base
execute if block ~-1 ~-1 ~ red_concrete positioned ~-1 ~ ~ run function aoc:find_gear_base
execute if block ~1 ~-1 ~ red_concrete positioned ~1 ~ ~ run function aoc:find_gear_base
execute if block ~-1 ~-1 ~1 red_concrete positioned ~-1 ~ ~1 run function aoc:find_gear_base
execute if block ~ ~-1 ~1 red_concrete positioned ~ ~ ~1 run function aoc:find_gear_base
execute if block ~1 ~-1 ~1 red_concrete positioned ~1 ~ ~1 run function aoc:find_gear_base

# Add to sum of ratios if count is exactly 2
execute if score Count variable matches 2 run scoreboard players operation RatioSum variable += Buffer2 variable
# Replace blue concrete with red concrete again
fill ~-10 ~-1 ~-10 ~10 ~-1 ~10 red_concrete replace blue_concrete