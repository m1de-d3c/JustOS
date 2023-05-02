#ifndef __JOS_IDT_H__
#define __JOS_IDT_H__

#include "util.h"

void set_idt_gate(int index, uint32_t handler);

#endif