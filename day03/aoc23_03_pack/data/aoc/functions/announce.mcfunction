tellraw @a ["",{"text":"The sum of parts is "},{"score":{"name":"PartSum","objective":"variable"},"color": "green"},{"text":"."}]
tellraw @a ["",{"text":"The sum of gear ratios is "},{"score":{"name":"RatioSum","objective":"variable"},"color": "green"},{"text":"."}]
tellraw @a ["",{"text":"Execution time: "},{"score":{"name":"ExecutionTime","objective":"variable"},"color": "green"},{"text":" game ticks"}]
# Remove command block
fill ~ ~-1 ~ ~ ~1 ~ air