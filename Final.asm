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
_auxR5                        dd                  0.0                 
_auxE5                        dd                  0                   
var4                          dd                  ?                   
var6                          dd                  ?                   
var7                          dd                  ?                   
a                             dd                  ?                   
b                             dd                  ?                   
c                             dd                  ?                   
e                             dd                  ?                   
f                             dd                  ?                   
d                             dd                  ?                   
z                             dd                  ?                   
var3                          dd                  ?                   
var9                          dd                  ?                   
_ingrese_var4__               db                  "ingrese var4: "    ,'$',14 dup(?)
_ingrese_var6__               db                  "ingrese var6: "    ,'$',14 dup(?)
_10                           dd                  10                  
_5                            dd                  5                   
_3                            dd                  3                   
_0                            dd                  0                   
__repe1                       dd                  ?                   
__buscar1                     dd                  ?                   
_1                            dd                  1                   
_2                            dd                  2                   
_7                            dd                  7                   
_12                           dd                  12                  
_34                           dd                  34                  
_48                           dd                  48                  
_encontro                     db                  "encontro"          ,'$',8 dup(?)
_no_encontro                  db                  "no encontro"       ,'$',11 dup(?)

.CODE
.startup
	mov AX,@DATA
	mov DS,AX
FINIT


displayString 	_ingrese_var4__
getInteger 	var4
displayString 	_ingrese_var6__
getInteger 	var6
fild 	_10
fistp 	b
fild 	_5
fistp 	d
fild 	_3
fistp 	a
fild 	var4
fistp 	__buscar1
fild 	_0
fistp 	__repe1
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
jne	etiq1
bloqueTrue1:
fild 	_1
fistp 	__repe1
etiq1:
fild 	__buscar1
fild 	_12
fxch
fcom
fstsw	ax
sahf
jne	etiq2
bloqueTrue2:
fild 	_1
fistp 	__repe1
etiq2:
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
jne	etiq3
bloqueTrue3:
fild 	_1
fistp 	__repe1
etiq3:
fild 	__buscar1
fild 	_48
fxch
fcom
fstsw	ax
sahf
jne	etiq4
bloqueTrue4:
fild 	_1
fistp 	__repe1
etiq4:
fild 	__repe1
fild 	_1
fxch
fcom
fstsw	ax
sahf
jne	etiq5
bloqueTrue5:
fild 	c
fiadd 	_2
fistp 	_auxE5
fild 	_auxE5
fistp 	c
displayString 	_encontro
jmp	 finIf1
etiq5:
displayString 	_no_encontro
finIf1:

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

concat proc
	push ds
	push si
	call strlen
	mov dx , bx
	mov si , di
	push es
	pop ds
	call strlen
	add di, bx
	add bx, dx
	cmp bx , MAXTEXTSIZE
	jg concatSizeMal
	concatSizeOk:
	mov cx , dx
	jmp concatSigo
	concatSizeMal:
	sub bx , MAXTEXTSIZE
	sub dx , bx
	mov cx , dx
	concatSigo:
	push ds
	pop es
	pop si
	pop ds
	cld
	rep movsb
	mov al , '$'
	mov byte ptr[di],al
	ret
concat endp

END