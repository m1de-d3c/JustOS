[bits 16]
[org 0x7C00]

%define halt jmp $

; setup ds
xor ax, ax
mov ds, ax

; setup stack
mov bp, 0x9000
mov sp, bp

; read next 64 sectors in 0x7E00
mov ah, 0x02
mov al, 0x40
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
mov bx, 0x7E00
int 13h

halt

; void print(void* msg)
println:
    mov si, [bp - 2]
push ax
push bx

    xor bh, bh
    mov ah, 0x0E
println_loop:
    lodsb

    ; return at \0
    cmp al, 0x00
    jz println_ret

    int 10h
    call println_loop
println_ret:
pop bx
pop ax
    ret

; void printhex(uint8 num)
printhex:
    mov bl, [bp - 2]
push ax
push bx

    xor bh, bh
    mov ah, 0x0E
push bx
    ; print first part of hex
    and bl, 0xF0
    shr bl, 4
    mov al, [hextable + bx]
    int 10h
pop bx
    ; second part of hex
    and bl, 0x0F
    mov al, [hextable + bx]
    int 10h

pop bx
pop ax
    ret
hextable: db '0123456789ABCDEF'

; fill rest of mem with 0
times 510 - ($ - $$) db 0x00
; magic number
dw 0xAA55