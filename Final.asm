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
_ingrese_b__                  db                  "ingrese b: "       ,'$',11 dup(?)
_4                            dd                  4                   
_5                            dd                  5                   
_3                            dd                  3                   
_15                           dd                  15                  

.CODE
.startup
	mov AX,@DATA
	mov DS,AX
FINIT


displayString 	_ingrese_b__
getInteger 	b
fild 	_4
fchs 
fistp 	_auxE0
fild 	_auxE0
fimul 	_5
fistp 	_auxE1
fild 	_auxE1
fiadd 	_3
fistp 	_auxE2
fild 	_auxE2
fisub 	b
fistp 	_auxE3
fild 	_4
fild 	_15
fprem 
fistp 	_auxE4
fild 	_auxE3
fiadd 	_auxE4
fistp 	_auxE5
fild 	_auxE5
fistp 	var6
displayInteger 	var6,3

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