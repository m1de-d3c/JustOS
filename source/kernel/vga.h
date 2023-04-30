#ifndef __JOS_VGA_H__
#define __JOS_VGA_H__

#include "util.h"

#define VGAMODE_W320_H200_C256 (1<<1)
#define VGAMODE_W720_H480_C16 (1<<2)
#define VGAMODE_TEXT_W80_H25 (1<<3)

void init_vga(uint32_t options);

#endif