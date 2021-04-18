flex lexico.l
gcc lex.yy.c -o tp.exe
tp.exe prueba.txt
pause
del lex.yy.c
del tp.exe
