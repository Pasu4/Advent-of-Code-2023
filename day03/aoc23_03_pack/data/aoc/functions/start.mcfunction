# Set up variables
scoreboard objectives add variable dummy "Variables"
scoreboard objectives add constant dummy "Constants"
scoreboard objectives setdisplay sidebar variable
scoreboard players set PartSum variable 0
scoreboard players set Buffer variable 0
scoreboard players set Buffer2 variable 0
scoreboard players set Count variable 0
scoreboard players set RatioSum variable 0
scoreboard players set ExecutionTime variable 1
scoreboard players set Ten constant 10

# Align player
execute align xyz run tp ~.5 ~ ~.5

function aoc:clear
function aoc:input
execute at @e[tag=gear] run function aoc:check_gear

# Place command blocks

setblock ~ ~ ~-2 repeating_command_block[facing=up]{auto:true,Command:"scoreboard players add ExecutionTime variable 1"}
setblock ~ ~1 ~-2 chain_command_block[facing=up]{auto:true,Command:"execute unless entity @e[tag=symbol] run function aoc:announce"}
setblock ~ ~2 ~-2 chain_command_block[facing=up]{auto:true,Command:"execute as @e[tag=symbol,limit=100] at @s run function aoc:count"}
