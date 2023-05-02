#include "idt.h"

struct idt_gate {
    uint16_t loffset;
    uint16_t sel;
    uint8_t a0;
    uint8_t flags;
    uint16_t hoffset;
};

struct idt_gate idts[256];

void set_idt_gate(int index, uint32_t handler) {
    idts[index].loffset = low16(handler);
    idts[index].sel = 0x08;
    idts[index].a0 = 0;
    // 1  00  0  1  110
    // P  DPL 0  D  TYPE
    idts[index].flags = 0b10001110;
    idts[index].hoffset = high16(handler);
}