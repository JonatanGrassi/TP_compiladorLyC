include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.DATA

MAXTEXTSIZE                   equ                 40                  
_auxR0                        dd                  0.0                 
_auxE0                        dd                  0                   
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
_5                            dd                  6                   
_4                            dd                  6                   
_2                            dd                  5                   
_NEWLINE                      db                  0DH,0AH,'$'         

.CODE
.startup
    mov AX,@DATA
    mov DS,AX
FINIT


fild    _5
fistp   b
fild    _2
fidivr  _4
fistp   _auxE0
fild    _auxE0
fistp   var4
displayInteger  var4,3

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