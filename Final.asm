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
var3                          dd                  ?                   
var9                          dd                  ?                   
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
_5                            dd                  5                   
_3                            dd                  3                   

.CODE
.startup
    mov AX,@DATA
    mov DS,AX
FINIT


getInteger  a
getInteger  b
fild    a
fiadd   _5
fistp   _auxE0
fild    _auxE0
fiadd   _3
fistp   _auxE1
fild    _auxE1
fiadd   b
fistp   _auxE2
fild    _auxE2
fistp   z
displayInteger  z,3

mov ax, 4c00h
int 21h


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