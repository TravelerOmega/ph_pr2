# $@ = fichero objetivo
# $< = primera dependencia
# $^ = todas las dependencias

# Detecta todos los archivos .o en base a su archivo .c
C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS = $(wildcard kernel/*.h  drivers/*.h cpu/*.h)
OBJ_FILES = ${C_SOURCES:.c=.o cpu/interrupt.o}

# La primera regla se ejecuta si no se pasan parámetros (regla por defecto del comando make)
all: run

# Las dependencias se construyen en base a qué se necesita
kernel.bin: boot/kernel_entry.o ${OBJ_FILES}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: boot/mbr.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -drive file=$<,format=raw,index=0,if=floppy

echo: os-image.bin
	xxd $<

%.o: %.c ${HEADERS}
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

%.dis: %.bin
	ndisasm -b 32 $< > $@

clean:
	$(RM) *.bin *.o *.dis *.elf
	$(RM) kernel/*.o
	$(RM) boot/*.o boot/*.bin
	$(RM) drivers/*.o
	$(RM) cpu/*.o
