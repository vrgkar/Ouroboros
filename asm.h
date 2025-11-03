#ifndef __ASM_H__
#define __ASM_H__

#include "stdint.h"

static inline void cli(void)
{
    asm volatile("cli" ::: "memory");
}

static inline void sti(void)
{
    asm volatile("sti" ::: "memory");
}

static inline void hlt(void)
{
    asm volatile("hlt");
}

static inline void nop(void)
{
    asm volatile("nop");
}

static inline void inb(uint16_t port, uint8_t* value)
{
    asm volatile("inb %1, %0" : "=a"(*value) : "Nd"(port));
}

static inline void outb(uint16_t port, uint8_t value)
{
    asm volatile("outb %0, %1" : : "a"(value), "Nd"(port));
}

#endif /* __ASM_H__ */