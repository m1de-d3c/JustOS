[bits 16]
[org 0x7C00]

%define halt            jmp $
%define KERNEL_OFFSET   0x7E00

; saving disk number
mov [BOOT_DISK], dl

; setup ds
xor ax, ax
mov ds, ax

; setup stack
mov bp, 0x7E00
mov sp, bp

mov ah, 0x00
mov al, 0x13
int 10h

; read next 64 sectors in KERNEL_OFFSET
push 0x0002
push 0x0002
call disk_read
add sp, 4

; make dummy check about existence of a kernel
cmp WORD [KERNEL_OFFSET], 0x18AA
jz pass_check
; no kernel at KERNEL_OFFSET
push no_kernel_msg
call println
add sp, 2
halt
; message to print on kernel-not-exists error
no_kernel_msg: db 'NO KERNEL EXISTS, CANNOT LOAD', 0x00
pass_check:

push WORD [KERNEL_OFFSET + 2]
push 0x0002
call disk_read
add sp, 4

; switch to protected (32 bit) mode
cli
lgdt [gdt_desc]
mov eax, cr0
or eax, 0x01
mov cr0, eax
jmp CODE_SEG:init_32bit

; initialize protected mode and pass controll to kernel
[bits 32]
init_32bit:
    ; update segment registers
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    ; resetup stack
    mov ebp, 0x90000
    mov esp, ebp

    ; jump to kernel
    xor eax, eax
    mov ax, [0x7E04]
    add ax, KERNEL_OFFSET
    jmp eax
    halt

[bits 16]
; int disk_read(int starting_sector, int sectors_count)
disk_read:
    mov cl, [esp + 2]
    mov al, [esp + 4]
    mov ah, 0x02
    mov ch, 0x00
    mov dh, 0x00
    mov dl, [BOOT_DISK]
push ax
    xor ax, ax
    mov es, ax
pop ax
    mov bx, KERNEL_OFFSET
    int 13h
    jnc no_disk_error
; disk error
push ax
    push disk_error_msg
    call println
    add sp, 2
pop ax
    shr ax, 8
    push ax
    call printhex
    add sp, 2
    halt
; message to print on disk error
disk_error_msg: db 'DISK ERROR ', 0x00
no_disk_error:  ; no disk error branch
    ret

; void println(void* msg)
println:
    mov si, [esp + 2]

    xor bh, bh
    mov ah, 0x0E
println_loop:
    lodsb

    ; return at \0
    cmp al, 0x00
    jz println_ret

    int 10h
    jmp println_loop
println_ret:
    ret

; void printhex(uint8 num)
printhex:
    mov bl, [esp + 2]

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

    ret
hextable: db '0123456789ABCDEF'

; GDT
gdt_start:
    dq 0x0

gdt_code:
    dw 0xffff
    dw 0x0000
    db 0b00000000
    db 0b10011010
    db 0b11001111
    db 0b00000000

gdt_data:
    dw 0xffff
    dw 0x0000
    db 0b00000000
    db 0b10010010
    db 0b11001111
    db 0b00000000

gdt_end:

gdt_desc:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG: equ gdt_code - gdt_start
DATA_SEG: equ gdt_data - gdt_start

BOOT_DISK: db 0x00

; fill rest of mem with 0
times 510 - ($ - $$) db 0x00
; magic number
dw 0xAA55