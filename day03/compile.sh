rm -f lex.yy.c
rm -f lexer.exe

flex lexer.l
cc lex.yy.c -o lexer.exe -lfl

cat input.txt | ./lexer.exe | sed '$s/green/brown/' > ./aoc23_03_pack/data/aoc/functions/input.mcfunction