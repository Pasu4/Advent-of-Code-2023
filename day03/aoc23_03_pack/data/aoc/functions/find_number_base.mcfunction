# Move to the left until the block is no longer red concrete
# That is the start of a number
execute unless block ~ ~-1 ~ red_concrete positioned ~1 ~ ~ run function aoc:parse_number
execute if block ~ ~-1 ~ red_concrete positioned ~-1 ~ ~ run function aoc:find_number_base