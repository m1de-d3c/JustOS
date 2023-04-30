#include "util.h"

void outb(uint16_t port, uint8_t val) {
    __asm__("out %%al, %%dx" : : "a" (val), "d" (port));
}

uint8_t inb(uint16_t port) {
    uint8_t res;
    __asm__("in %%dx, %%al" : "=a" (res) : "d" (port));
    return res;
}

void outw(uint16_t port, uint16_t val) {
    __asm__("out %%ax, %%dx" : : "a" (val), "d" (port));
}

uint16_t inw(uint16_t port) {
    uint16_t res;
    __asm__("in %%dx, %%ax" : "=a" (res) : "d" (port));
    return res;
}