# ph_pr2
### Práctica 2 de programación hardware - E/S y Bootloader

En esta segunda práctica, se pedía la implementación de algunas funcionalidades de E/S y Bootloader. 
Para cumplir con los requisitos de la práctica, se han llevado a cabo diversas implementaciones:

Carpeta boot:
- Archivo mbr.asm que contiene el master boot record, encargado de cargar todos los módulos necesarios y cargar el kernel (512 bytes)
- Archivo disk.asm que lee y establece en disco los parámetros necesarios para el bootloader.
- Archivo gdt.asm que contiene la global descriptor table, que contiene información sobre la propia GDT y sobre segmentos, así como constantes, para saber dónde está el código y dónde están los datos en memoria.
- Archivo switch-to-32bit.asm, encargado de cambiar el modo de ejecución a protegido (32 bits).
- Archivo kernel_entry.asm, que contiene el código necesario para ceder el control al kernel.
- Archivo print-16bit.asm: Permite imprimir por pantalla caracteres mientras el modo de ejecución es 16bits.
- Archivo print-32bit.asm: Ídem pero en modo protegido

Carpeta drivers:
- Archivos display.c y display.h: un driver de pantalla que permite mostrar en esta caracteres del sistema. Incluye scrolling y una función para limpiar la pantalla.
- Archivos keyboard.c y keyboard.h: driver de teclado para leer el buffer de teclado y traducir los códigos a ASCII.
- Archivos ports.c y ports.h: Código auxiliar para leer los puertos correspondientes a entradas por teclado y salidas por pantalla.

Carpeta kernel:
- Archivos kernel.c y kernel.h: Archivo del kernel con la mayor parte de la funcionalidad. Carga todo lo necesario y aguarda para recbir comandos.
- Archivos mem.c y mem.h: Archivos para cargar y emplear memoria dinámica.
- Archivos util.c y util.h: Archivos con funcionalidad auxiliar, mayormente para trabajar con cadenas de caracteres.

Carpeta cpu:
- Archivos idt.c e idt.h: Define la estructura del IDT, interrupt descriptor table
- Archivo interrupt.asm: Código a ejecutar cuando se recibe una interrupción, llamando al ISR
- Archivos isr.c e isr.h: Define el servicio de ISR y determina los valores de IDT en base a la interrupción a llamar.
- Archivos timer.c y timer.h: Definen el temporizador del sistema de cara a interrupciones.

Cada archivo tiene comentarios explicando su funcionamiento. Para ejecutar el sistema, basta con hacer el comando make sobre el fichero makefile.
