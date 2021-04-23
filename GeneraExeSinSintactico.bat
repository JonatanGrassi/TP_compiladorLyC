flex lexicoSinReturns.l
gcc lex.yy.c -o tp.exe
tp.exe pruebaLexico.txt
pause
del lex.yy.c
del tp.exe
del tabla_de_simbolos.txt

