#pragma once

#include <stdint.h>

/* Selección de segmentos */
#define KERNEL_CS 0x08

/* Se define cómo se maneja cada interrupción */
typedef struct {
    uint16_t low_offset; /* Primeros 16 bits de la función que maneja las interrupciones */
    uint16_t sel; /* Selector del segmento del kernel */
    uint8_t always0;
    uint8_t flags;
    uint16_t high_offset; /* Últimos 16 bits de la función */
} __attribute__((packed)) idt_gate_t;

/* Puntero al vector de funciones de manejo. */
typedef struct {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed)) idt_register_t;

#define IDT_ENTRIES 256

void set_idt_gate(int n, uint32_t handler);

void load_idt();
