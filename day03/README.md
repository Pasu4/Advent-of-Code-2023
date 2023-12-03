# Day 3

## Instructions for running

1. Run `compile.sh` on a Linux (sub-)system. Flex and build-essential must be installed. This step is only needed if you replace the data in `input.txt`.
2. Start Minecraft Java Edition and create a new superflat world. In the world creation menu, import the data pack `aoc23_03_pack` and activate it. Commands must be allowed.
3. While standing on the ground (not *underground*), run the command `/function aoc:start`.
4. Wait until a message appears in the chat announcing the result.

Minecraft has a command limit of 65536 commands in a single tick.
For my input, it runs 62866 commands in the first tick.
Since this is already very close to that limit, it might not work for all input data.