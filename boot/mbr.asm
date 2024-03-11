[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; La misma que en el kernel

mov [BOOT_DRIVE], dl ; La BIOS establece el drive de boot en dl durante el boot
mov bp, 0x9000
mov sp, bp

mov bx, MSG_16BIT_MODE
call print16
call print16_nl

call load_kernel ; Se lee el kernel de disco
call switch_to_32bit ; Se apagan interrupciones, etc
jmp $ ; No se ejecuta

%include "boot/print-16bit.asm"
%include "boot/print-32bit.asm"
%include "boot/disk.asm"
%include "boot/gdt.asm"
%include "boot/switch-to-32bit.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print16
    call print16_nl

    mov bx, KERNEL_OFFSET ; Lee de disco y lo guarda en 0x1000
    mov dh, 31
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_32BIT:
    mov ebx, MSG_32BIT_MODE
    call print32
    call KERNEL_OFFSET ; Cede control al kernel
    jmp $ ; Se mantiene aquí cuando el kernel nos devuelve el control


BOOT_DRIVE db 0
MSG_16BIT_MODE db "Started in 16-bit Real Mode", 0
MSG_32BIT_MODE db "Landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; padding
times 510 - ($-$$) db 0
dw 0xaa55
