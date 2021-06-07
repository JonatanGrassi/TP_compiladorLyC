c:\GnuWin32\bin\flex Lexico.l
c:\GnuWin32\bin\bison -dyv Sintactico.y
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o TPFinal.exe
TPfinal.exe prueba2.txt
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
dot.exe graph.dot -o ejemplo1.png -Tpng -Gcharset=utf8
