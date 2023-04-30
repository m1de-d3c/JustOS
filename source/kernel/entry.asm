[bits 32]
[extern entry]

; ==== JustLoader signature ====
signature_start:

dw 0x18AA                           ; Signature (proves that system exists)
dw 0x0040                           ; Size in sectors
dw signature_end - signature_start  ; Signature size
db 'JustOS v1.0', 0x00              ; Name

signature_end:
; ==============================

xor eax, eax
mov eax, signature_end - signature_start
add eax, 0x7E00
push eax
call entry                          ; Call the entry

jmp $