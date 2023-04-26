#ifndef __JOS_VGA_H__
#define __JOS_VGA_H__

#include <stdint.h>

#define VMEMCHR(w, h) *((char*) 0xB8000 + (2 * (h * 80 + w)))
#define VMEMCOLOR(w, h) *((char*) 0xB8000 + (2 * (h * 80 + w + 1)))

namespace VGA {
    struct Rect {
        int width, height;
    };

    void set_char(VGA::Rect pos, char chr);
    uint16_t get_char(VGA::Rect pos);

    void clear_buffer();
}

#endif