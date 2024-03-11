[bits 32] ; Usando modo protegido en 32 bits

; Definición de constantes
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f ; byte de color para cada carácter

print32:
    pusha
    mov edx, VIDEO_MEMORY

print32_loop:
    mov al, [ebx] ; [ebx] es la dirección del caracter
    mov ah, WHITE_ON_BLACK

    cmp al, 0 ; comprobar si es el final del string
    je print32_done

    mov [edx], ax ; guardar el carácter en memoria
    add ebx, 1 ; siguiente caracter
    add edx, 2 ; siguiente posición de memoria

    jmp print32_loop

print32_done:
    popa
    ret
