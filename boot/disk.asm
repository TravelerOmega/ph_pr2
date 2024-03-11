; carga 'dh' sectoress del drive 'dl' a ES:BX
disk_load:
    pusha
    ; Leer del disco requiere valores específicos en todos los registros
    ; por lo que se sobreescriben los parámetros de entrada de DX, pero se guardan
    ; en la pila para uso posterior.
    push dx

    mov ah, 0x02 ; ah <- int 0x13. 0x02 = 'read'
    mov al, dh   ; al <- número de sectores a leer (0x01 .. 0x80)
    mov cl, 0x02 ; cl <- sector (0x01 .. 0x11)
                 ; 0x01 es el sector de booteo, 0x02 es el primer sector libre
    mov ch, 0x00 ; ch <- cilindro
    ; dl <- drive number. Lo obtiene como parámetro y lo llama desde la BIOS
    mov dh, 0x00 ; dh <- head number (0x0 .. 0xF)

    ; [es:bx] <- puntero al buffer donde se guardarán los datos
    int 0x13      ; BIOS interrupt
    jc disk_error ; por si hay un error

    pop dx
    cmp al, dh    ; se compara al con el número de sectores leídos, por si hay un error
    jne sectors_error
    popa
    ret


disk_error:
    mov bx, DISK_ERROR
    call print16
    call print16_nl
    mov dh, ah 
    call print16_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print16

disk_loop:
    jmp $

DISK_ERROR: db "Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
