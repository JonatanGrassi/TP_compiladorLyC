include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.DATA

MAXTEXTSIZE                   equ                 40                  
_auxR0                        dd                  0.0                 
_auxE0                        dd                  0                   
_auxR1                        dd                  0.0                 
_auxE1                        dd                  0                   
_auxR2                        dd                  0.0                 
_auxE2                        dd                  0                   
_auxR3                        dd                  0.0                 
_auxE3                        dd                  0                   
_auxR4                        dd                  0.0                 
_auxE4                        dd                  0                   
var8                          dd                  ?                   
var6                          dd                  ?                   
var7                          dd                  ?                   
a                             dd                  ?                   
b                             dd                  ?                   
c                             dd                  ?                   
e                             dd                  ?                   
f                             dd                  ?                   
d                             dd                  ?                   
k                             dd                  ?                   
t                             dd                  ?                   
x                             dd                  ?                   
l                             dd                  ?                   
m                             dd                  ?                   
z                             dd                  ?                   
var3                          dd                  ?                   
var9                          dd                  ?                   
_0                            dd                  0                   
__repe1                       dd                  ?                   
__buscar1                     dd                  ?                   
_1                            dd                  1                   
_2                            dd                  2                   
_7                            dd                  7                   
_12                           dd                  12                  
_34                           dd                  34                  
_48                           dd                  48                  
_hola                         db                  "hola"              ,'$',4 dup(?)
_NEWLINE                      db                  0DH,0AH,'$'         

.CODE
.startup
	mov AX,@DATA
	mov DS,AX
FINIT


fild 	a
fistp 	__buscar1
fild 	__repe1
fistp 	__buscar1
fild 	_2
fimul 	b
fistp 	_auxE0
fild 	_auxE0
fiadd 	_7
fistp 	_auxE1
fild 	__buscar1
fild 	_auxE1
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist1
BloqueTrueIn1:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue1
etiqInlist1:
fild 	__buscar1
fild 	_12
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist2
BloqueTrueIn2:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue1
etiqInlist2:
fild 	_34
fiadd 	d
fistp 	_auxE2
fild 	_auxE2
fimul 	a
fistp 	_auxE3
fild 	_auxE3
fiadd 	b
fistp 	_auxE4
fild 	__buscar1
fild 	_auxE4
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist3
BloqueTrueIn3:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue1
etiqInlist3:
fild 	__buscar1
fild 	_48
fxch
fcom
fstsw	ax
sahf
jne	etiqInlist4
BloqueTrueIn4:
fild 	_1
fistp 	__repe1
jmp 	BloqueTrue1
etiqInlist4:
fild 	__repe1
fild 	_1
fxch
fcom
fstsw	ax
sahf
jne	etiq1
BloqueTrue1:
displayString 	_hola
displayString _NEWLINE
etiq1:

mov ax, 4c00h
int 21h


ffree
strlen proc
	mov bx, 0
	strl01:
	cmp BYTE PTR [si+bx],'$'
	je strend
	inc bx
	jmp strl01
	strend:
	ret
strlen endp

copiar proc
	call strlen
	cmp bx , MAXTEXTSIZE
	jle copiarSizeOk
	mov bx , MAXTEXTSIZE
	copiarSizeOk:
	mov cx , bx
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
copiar endp

END