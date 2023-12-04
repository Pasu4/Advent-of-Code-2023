# Day 4

Scratch cards in Scratch. This was not even intentional.

## Instructions for running

1. Visit [scratch.mit.edu](scratch.mit.edu). Creating an account is not necessary.
2. Click on "Create".
3. Under "File", select "Load from your computer" and choose the "Advent of Code 2023 Day 4.sb3" file.
4. In the Variables tab, check the box next to `inputL` and `inputR`.
5. Right click on the `inputL` list on the stage (top right window) and select import. Choose your input file. When prompted which column to use, type "1" and confirm.
6. Do the same for `inputR`, but select column 2.
7. Shift click the green flag. Technically optional, but it will take a few minutes to calculate if you don't.
8. Click the green flag.

If you are not prompted to select a column, make sure that your input file does **not** have a trailing newline.

If you want to run an example, you have to change the value of the line `set firstDigit to 11` (in the stage script) to the one-based index of the first digit in the left column that is not part of the card number.