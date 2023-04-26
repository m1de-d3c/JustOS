#include "vga.h"

static char color = 0;

void VGA::set_char(VGA::Rect pos, char chr)  {
    VMEMCHR(pos.width, pos.height) = chr;
    VMEMCOLOR(pos.width, pos.height) = color;
}

uint16_t VGA::get_char(VGA::Rect pos)  {
    return (uint16_t) (VMEMCOLOR(pos.width, pos.height) << 8) | VMEMCHR(pos.width, pos.height);
}

void VGA::clear_buffer() {
    for (int x = 0; x < 160; x++) {
        for (int y = 0; y < 25; y++) {
            VGA::set_char({ .width=x, .height=y }, '\0');
        }
    }
}