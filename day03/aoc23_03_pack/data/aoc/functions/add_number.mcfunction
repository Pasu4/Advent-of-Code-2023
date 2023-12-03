# Macro:
#   number: The number to be added

scoreboard players operation Buffer variable *= Ten constant
$scoreboard players add Buffer variable $(number)
