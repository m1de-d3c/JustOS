#include <graphics/vga.h>

#include "util.h"

extern "C" void entry(uint32_t);

// Entry point of the kernel
void entry(uint32_t ptr) {
    // CLI;
    
    // init_vga(VGAMODE_W320_H200_C256);
    uint8_t* VMEM = (uint8_t*) 0xB8000;
}