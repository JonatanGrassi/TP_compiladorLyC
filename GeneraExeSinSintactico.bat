flex lexicoSinReturns.l
gcc lex.yy.c -o tp.exe
tp.exe prueba.txt
pause
del lex.yy.c
del tp.exe
del tabla_de_simbolos.txt

