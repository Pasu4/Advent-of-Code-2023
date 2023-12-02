#!/bin/bash

rm -f lex.yy.c
rm -f lexer.exe

flex lexer.l
cc lex.yy.c -o lexer.exe -lfl

split -a 1 --additional-suffix=.txt -d -l 50 input.txt input

cat input0.txt | ./lexer.exe | sed '$s/write -3/write -1/' > input0.mlog
echo -e "print \"Insert disk 2\"\nprintflush message1\nstop" >> input0.mlog

# echo -e "control enabled switch 1\nwait 0.1\n$(cat input1.txt | ./lexer.exe | sed '1d')" > input1.mlog
cat input1.txt | ./lexer.exe | sed '2d' > input1.mlog
echo -e "control enabled switch1 0\nstop" >> input1.mlog

rm input0.txt
rm input1.txt

# str=$(cat input.mlog)                       # get input.mlog as string
# regex="(\d+)$"
# [[ $str =~ (\d+)$ ]]                        # match the last number in the array
# number="${BASH_REMATCH[1]}"

# echo "write -1 bank1 ${str: -1}"            # Write -3 (end of file) to bank
# echo "stop"                                 # Stop the processor from looping
