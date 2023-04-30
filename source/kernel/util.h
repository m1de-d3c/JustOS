#ifndef __JOS_UTIL_H__
#define __JOS_UTIL_H__

#include <stdint.h>

#define high16(val) ((uint16_t) (val >> 16) & 0xFFFF)
#define low16(val) ((uint16_t) val & 0xFFFF)
#define high8(val) ((uint8_t) (val >> 8) & 0xFF)
#define low8(val) ((uint8_t) val & 0xFF)

// ==== Assembly instruction shortcuts ====

#define CLI __asm__("cli")
#define STI __asm__("sti")

// ==== Working with CPU ports ====

/// @brief Sends value of 1 byte into the port
/// @param port port to send in
/// @param val value
void outb(uint16_t port, uint8_t val);
/// @brief Gets value of 1 byte from the port
/// @param port port the get value from
/// @return value stored in the port
uint8_t inb(uint16_t port);
/// @brief Sends value of 1 word into the port
/// @param port port to send in
/// @param val value
void outw(uint16_t port, uint16_t val);
/// @brief Gets value of 1 word from the port
/// @param port port the get value from
/// @return value stored in the port
uint16_t inw(uint16_t port);

#endif