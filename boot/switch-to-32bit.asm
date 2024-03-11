[bits 16]
switch_to_32bit:
    cli ; 1. desactivar interrupciones
    lgdt [gdt_descriptor] ; 2. cargar DGT
    mov eax, cr0
    or eax, 0x1 ; 3. Establecer el modo de 32 bits
    mov cr0, eax
    jmp CODE_SEG:init_32bit ; 4. Saltar a otro segmento

[bits 32]
init_32bit: ; Ahora estamos en 32 bits
    mov ax, DATA_SEG ; 5. Actualizar los registros del segmento
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. Actualizar la pila a la zona sin usar
    mov esp, ebp

    call BEGIN_32BIT ; 7. Llamar al modo con 32 bits
