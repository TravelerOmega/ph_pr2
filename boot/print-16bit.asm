print16:
    pusha

; Los strings terminan con un 0 en memoria
print16_loop:
    mov al, [bx] ; bx es la dirección base del string
    cmp al, 0
    je print16_done

    mov ah, 0x0e ; tty
    int 0x10 ; al contiene el caracter

    ; se incrementa el puntero y se va a la siguiente iteración
    add bx, 1
    jmp print16_loop

print16_done:
    popa
    ret

print16_nl:
    pusha

    mov ah, 0x0e
    mov al, 0x0a 
    int 0x10
    mov al, 0x0d 
    int 0x10

    popa
    ret

print16_cls:
    pusha

    mov ah, 0x00
    mov al, 0x03  ; Modo con colores
    int 0x10

    popa
    ret

; recibir los datos de dx
print16_hex:
    pusha

    mov cx, 0 

; Se toma el último carácter de DX y se convierte en ASCII
; Se suma una cantidad determinada a cada valor para conseguir los valores ASCII
print16_hex_loop:
    cmp cx, 4 ; loop 4 veces
    je print16_hex_end

    ; 1. Convertir el último caracter a ASCII
    mov ax, dx ; usamos AX como registro
    and ax, 0x000f ; Tomamos el último caracter volviendo los previos 0
    add al, 0x30 ; Sumamos 0x30
    cmp al, 0x39 ; comparamos para saber si es un número o una letra
    jle print16_hex_step2
    add al, 7 ; restamos para conseguir el valor

print16_hex_step2:
    ; 2. Encontrar la posición en la que colocar el caracter
    ; bx <- dirección base + longitud del string - índice del caracter
    mov bx, PRINT16_HEX_OUT + 5 
    sub bx, cx  
    mov [bx], al 
    ror dx, 4 

    add cx, 1
    jmp print16_hex_loop

print16_hex_end:
    ; Se prepara el parámetro y se llama la función
    ; print recibe parámetros en BX
    mov bx, PRINT16_HEX_OUT
    call print16

    popa
    ret

PRINT16_HEX_OUT:
    db '0x0000',0 ; Reserva memoria para un nuevo string
