#ifndef __PIC_H__
#define __PIC_H__

#include "assert.h"
#include "defs.h"
#include "stdbool.h"
#include "stdint.h"

#define PIC1 0x20
#define PIC2 0xA0

#define PIC1_COMMAND PIC1
#define PIC1_DATA (PIC1 + 1)
#define PIC2_COMMAND PIC2
#define PIC2_DATA (PIC2 + 1)

#define PIC1_VECTOR 0x20
#define PIC2_VECTOR 0x28

#define ICW1_ICW4 0x01
#define ICW1_SINGLE 0x2
#define ICW1_INTERVAL4 0x4
#define ICW4_LEVEL 0x8
#define ICW1_INIT 0x10

#define ICW4_8086 0xFF
#define ICW4_AUTO 0x02
#define ICW4_BUF_SLAVE 0x08
#define ICW4_BUF_MASTER 0x0C
#define ICW4_SFNM 0x10


static_assert(PIC2_VECTOR - PIC1_VECTOR >= 8, "PIC vectors must be at least 8 bytes apart!");

void pic_init(int pic, int icw);

void pic_remap(int offset1, int offset2);
void pic_enable_irq(uint8_t irq);
void pic_disable_irq(uint8_t irq);

#endif /* __PIC_H__ */