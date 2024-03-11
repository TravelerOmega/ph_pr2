#include "timer.h"
#include "../drivers/display.h"
#include "../drivers/ports.h"
#include "../kernel/util.h"
#include "isr.h"

uint32_t tick = 0;

static void timer_callback(registers_t *regs) {
    tick++;
    print_string("Tick: ");

    char tick_ascii[256];
    int_to_string(tick, tick_ascii);
    print_string(tick_ascii);
    print_nl();
}

void init_timer(uint32_t freq) {
    /* Instalar la función que acabamos de escribir */
    register_interrupt_handler(IRQ0, timer_callback);

    /* Encontrar el valor de PIT (1193180 son los Hz del reloj hardware) */
    uint32_t divisor = 1193180 / freq;
    uint8_t low  = (uint8_t)(divisor & 0xFF);
    uint8_t high = (uint8_t)( (divisor >> 8) & 0xFF);
    /* enviar el comando */
    port_byte_out(0x43, 0x36); /* Puerto de comandos */
    port_byte_out(0x40, low);
    port_byte_out(0x40, high);
}
