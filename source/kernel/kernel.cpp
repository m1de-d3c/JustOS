#include "vga.h"

extern "C" void entry();

void entry() {
    VGA::clear_buffer();
}