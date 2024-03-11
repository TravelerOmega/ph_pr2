global _start;
[bits 32]

_start:
    [extern start_kernel] ; Define el punto de llamada. Debe tener el mismo nombre que la función main de kernel.c
    call start_kernel ; Llama a la función.
    jmp $
