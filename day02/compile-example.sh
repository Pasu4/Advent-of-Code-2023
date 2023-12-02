#!/bin/bash

rm -f lex.yy.c
rm -f lexer.exe

flex lexer.l
cc lex.yy.c -o lexer.exe -lfl

cat input.txt | ./lexer.exe > input.mlog
echo -e "control enabled switch1 0\nstop" >> input.mlog